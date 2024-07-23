import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../screens/kid_screens/main_kid_screen.dart';
import '../widgets/toasts.dart';

class KidProvider with ChangeNotifier {

  late Future<void> getParent;
  Map<String, String> parentsList = {};
  List<bool> parentsListAccept = [];
  List<String> parentsEmailsList = [];
  String imageUrl = '';
  String fileName = '';
  late Reference imageToUpload;
  late XFile? file;
  bool isLoading = false;

  Map<String, bool> selectedParentsEmail = {};

  GlobalKey<FormState> wishKey = GlobalKey<FormState>();

  TextEditingController addWishNameController = TextEditingController();

  bool mainKidInfo = false;
  bool wishInfo = false;
  bool settingsKidInfo = false;

  void switchMainKidInfo(){
    mainKidInfo = !mainKidInfo;
    notifyListeners();
  }

  void switchWishInfo(){
    wishInfo = !wishInfo;
    notifyListeners();
  }

  void switchSettingsKidInfo(){
    settingsKidInfo = !settingsKidInfo;
    notifyListeners();
  }

  void getParentsData(){
    getParent = getParents();
  }

  Future<void> getParents() async{
    parentsList.clear();
    parentsListAccept.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('email');
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.
    instance.collection('users').doc(prefs.getString('email')?.toLowerCase()).get();
    for(int k = 0; k < 6; k++){
      DocumentSnapshot<Map<String, dynamic>> docEmail = await FirebaseFirestore.
      instance.collection('users').doc(doc.data()?['kid$k']?.toLowerCase()).get();
      selectedParentsEmail.addAll({'${doc.data()?['kid$k']}': true});
      parentsList.addAll({'${docEmail.data()?['name']}': '${doc.data()?['kid$k']}'});
      parentsListAccept.add(doc.data()?['kid${k}Accept']);
      parentsEmailsList.add(doc.data()?['kid$k']);
      notifyListeners();
    }
  }

  Future acceptParent(int index) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot<Map<String, dynamic>> docK = await FirebaseFirestore.
    instance.collection('users').doc(prefs.getString('email')?.toLowerCase()).get();
    for(int k = 0; k < 6; k++){
      if(docK.data()?['kid$k'] == parentsEmailsList[index]){
        await FirebaseFirestore.instance.collection('users').doc(prefs.getString('email')).update({
          'kid${k}Accept': true,});
      }
    }
    DocumentSnapshot<Map<String, dynamic>> docP = await FirebaseFirestore.
    instance.collection('users').doc(parentsEmailsList[index].toLowerCase()).get();
    for(int k = 0; k < 6; k++){
      if(docP.data()?['kid$k'] == prefs.getString('email')){
        await FirebaseFirestore.instance.collection('users').doc(parentsEmailsList[index]).update({
          'kid${k}Accept': true,});
      }
    }
    getParentsData();
  }

  Future pickAnImage()async{
    ImagePicker image = ImagePicker();
    file = await image.pickImage(source: ImageSource.camera);
    if(file == null) return;
    fileName = DateTime.now().millisecondsSinceEpoch.toString();
    imageToUpload = FirebaseStorage.instance.ref().child('wishes').child(fileName);
    notifyListeners();
  }

  Future addWishToBase(context)async{
    isLoading = true;
    notifyListeners();
      List parents = [];
      for(var p in selectedParentsEmail.entries) {
        if (p.value == true) {
          parents.add(p.key);
        }
      }
    if(parents.isNotEmpty){
    if(fileName != ''){
      try{
        await imageToUpload.putFile(File(file!.path));
        imageUrl = await imageToUpload.getDownloadURL();
      }catch(e){
        return;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.
    instance.collection('users').doc(prefs.getString('email')?.toLowerCase()).get();
    String name = doc.data()?['name'];
        await FirebaseFirestore.instance.collection('wishes').add({
          'wish': addWishNameController.text,
          'kidEmail': prefs.getString('email'),
          'kidName' : name,
          'parent0Name': parents.isNotEmpty ? parents[0] : '',
          'parent1Name': parents.length > 1 ? parents[1] : '',
          'parent2Name': parents.length > 2 ? parents[2] : '',
          'parent3Name': parents.length > 3 ? parents[3] : '',
          'parent4Name': parents.length > 4 ? parents[4] : '',
          'imageUrl' : fileName == '' ? 'false' : imageUrl,
          'time' : DateTime.now().toString()
        });
        addWishNameController.clear();
        imageUrl = '';
        fileName = '';
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>
            const MainKidScreen()));
      }else{
        sadToast('selectParent');
      }
    isLoading = false;
    notifyListeners();
  }

  void selectParent(String key, bool value){
    selectedParentsEmail.update(key,(value) => value = !value);
    notifyListeners();
  }

  Future showWishDescription(context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index) {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: size.height,
              width: size.width,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
             child: Image.network(snapshot.data?.docs[index].get('imageUrl'), fit: BoxFit.cover),
            ),
          );
        });
  }

}