import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/history_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/kid_screens/main_kid_screen.dart';
import '../widgets/toasts.dart';

class ParentProvider with ChangeNotifier {

  GlobalKey<FormState> taskKey = GlobalKey<FormState>();

  TextEditingController addTaskNameController = TextEditingController();
  TextEditingController addTaskDescriptionController = TextEditingController();
  TextEditingController addTaskPriceController = TextEditingController();
  TextEditingController kidSearchController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedKidName = '';
  String selectedKidEmail = '';

  DateTime taskDeadline = DateTime.now();
  bool isDeadline = false;

  bool isLoading = false;

  List<String> status = ['price', 'inProgress', 'done', 'checked', 'paid'];

  String imageUrl = '';
  String fileName = '';
  late Reference imageToUpload;
  late XFile? file;
  late Future<void> getKid;
  late Future<void> getEmailVoid;
  Map<String, String> kidsList = {};
  List<bool> kidsListAccept = [];
  Map<String, String> wishList = {};

  String? email = '';
  String? role = '';

  double stars = 0.0;

  bool mainParentInfo = false;
  bool addTaskInfo = false;
  bool settingsParentInfo = false;
  bool isEdit = false;
  String editDocId = '';

  void switchParentInfo(){
    mainParentInfo = !mainParentInfo;
    notifyListeners();
  }

  void switchAddTaskInfo(){
    addTaskInfo = !addTaskInfo;
    notifyListeners();
  }

  void switchSettingsParentInfo(){
    settingsParentInfo = !settingsParentInfo;
    notifyListeners();
  }

  Future<void> getEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    notifyListeners();
  }

  void getKidsData(){
    getKid = getKids();
  }

  void getEmailData(){
    getEmailVoid = getEmail();
  }

  Future getRole(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.
    instance.collection('users').doc(prefs.getString('email')?.toLowerCase()).get();
    prefs.setString('role', doc.data()?['role'] ?? '');
    role = prefs.getString('role');
    notifyListeners();
  }

  Future<void> deleteTask(AsyncSnapshot snapshot, int index, context)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.3,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Text('deleteThisTask'.tr(), style: kTextStyle,),
                  ButtonWidget(
                      onTap: () => FirebaseFirestore.instance.collection('history').doc(
                          snapshot.data?.docs[index].id).delete(),
                      text: 'delete')
                ],
              )
          );
        });
  }

  Future addKidToParent(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('email');
    DocumentSnapshot<Map<String, dynamic>> docP = await FirebaseFirestore.
    instance.collection('users').doc(prefs.getString('email')?.toLowerCase()).get();
    if(docP.data()?['kid4'] == ''){
      for(var k = 0; k < 5; k++){
        if(docP.data()?['kid$k'] != kidSearchController.text.trim()){
          if(docP.data()?['kid$k'] == ''){
            await FirebaseFirestore.instance.collection('users').doc(prefs.getString('email')).update({
              'kid$k': kidSearchController.text.trim(),});
            break;
          }
        }else{
          sadToast('kidAlreadyInList');
          break;
        }
      }
    }else{
      sadToast('onlyFiveKids');
    }
    DocumentSnapshot<Map<String, dynamic>> docK = await FirebaseFirestore.
    instance.collection('users').doc(kidSearchController.text.trim().toLowerCase()).get();
    if(docK.data()?['kid4'] == ''){
      for(var k = 0; k < 5; k++){
        if(docK.data()?['kid$k'] != prefs.getString('email')){
          if(docK.data()?['kid$k'] == ''){
            await FirebaseFirestore.instance.collection('users').doc(kidSearchController.text.trim()).update({
              'kid$k': prefs.getString('email'),});
            break;
          }
        }else{
          break;
        }
      }
    }else{
      sadToast('kidHasFiveParent');
    }
    kidSearchController.clear();
    Navigator.of(context).pop();
    getKidsData();
    notifyListeners();
  }

  Future kidSearch(context) async{
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.
      instance.collection('users').doc(kidSearchController.text.trim().toLowerCase()).get();
      if(doc.exists && doc.data()?['role'] == 'child'){
        Map<String, dynamic>? data = doc.data();
        showKidSearchInfo(context, data?['name'], data?['surName'], kidSearchController.text.trim());
        }else{
        sadToast('noEmail');
      }
  }

  Future<void> getKids() async{
    kidsList.clear();
    kidsListAccept.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('email');
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.
    instance.collection('users').doc(prefs.getString('email')?.toLowerCase()).get();
    for(int k = 0; k < 6; k++){
        DocumentSnapshot<Map<String, dynamic>> docEmail = await FirebaseFirestore.
        instance.collection('users').doc(doc.data()?['kid$k']?.toLowerCase()).get();
        kidsList.addAll({'${docEmail.data()?['name']}': '${doc.data()?['kid$k']}'});
        kidsListAccept.add(doc.data()?['kid${k}Accept']);
        notifyListeners();
      // }
    }
  }

  Future showKidSearchInfo(context, String name, String surname, String email) {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.3,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Text('addKidSure'.tr(args: ['$name $surname']), style: kTextStyle,),
                  Text('email: $email', style: kTextStyle,),
                  ButtonWidget(
                      onTap: () => addKidToParent(context),
                      text: 'add')
                ],
              )
          );
        });
  }

  Future showWishList(context, ParentProvider data) {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.6,
              width: size.width,
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: wishList.isNotEmpty
              ? ListView.builder(
                  itemCount: wishList.length,
                  itemBuilder: (context, index){
                    String wish = wishList.keys.elementAt(index);
                    String image = wishList.values.elementAt(index);
                    return GestureDetector(
                      onTap: () => addWishToField(context, wish),
                      child: Container(
                        width: size.width,
                        height: image == 'false'
                            ? 50 : 100,
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                            color: kDarkGrey,
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(wish, style: kTextStyle,),
                            image == 'false'
                                ? const SizedBox.shrink()
                                : Image.network(image),
                          ],
                        ),
                      ),
                    );
                  })
              : Center(child: Text('kidHasNoWishes'.tr(), style: kBigTextStyle,)),
          );
        });
  }

  void addWishToField(context, String wish){
    addTaskPriceController.text = wish;
    notifyListeners();
    Navigator.of(context).pop();
  }

  Future pickAnImage()async{
    ImagePicker image = ImagePicker();
    file = await image.pickImage(source: ImageSource.camera);
    if(file == null) return;
    fileName = DateTime.now().millisecondsSinceEpoch.toString();
    imageToUpload = FirebaseStorage.instance.ref().child('images').child(fileName);
    notifyListeners();
  }

  Future changePriceStatus(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index, String? role)async{
    FirebaseFirestore.instance.collection('tasks').doc(snapshot.data?.docs[index].id).update({
      'price': priceController.text.trim(),
      'priceStatus': role == 'parent' ? 'set' : 'changed'
    });
  }

  Future changeToInProgress(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index, context)async{
    FirebaseFirestore.instance.collection('tasks').doc(snapshot.data?.docs[index].id).update({
      'status': 'inProgress'
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        role == 'parent'
            ? const MainParentScreen()
            : const MainKidScreen()));
  }

  Future changeToDone(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index, context)async{
    FirebaseFirestore.instance.collection('tasks').doc(snapshot.data?.docs[index].id).update({
      'status': 'done'
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        role == 'parent'
            ? const MainParentScreen()
            : const MainKidScreen()));
  }

  Future changeToChecked(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index, context)async{
    FirebaseFirestore.instance.collection('tasks').doc(snapshot.data?.docs[index].id).update({
      'status': 'checked',
      'stars': stars.toString()
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        role == 'parent'
            ? const MainParentScreen()
            : const MainKidScreen()));
  }

  Future changeToPaid(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index, context)async{
    FirebaseFirestore.instance.collection('tasks').doc(snapshot.data?.docs[index].id).update({
      'status': 'paid',
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        role == 'parent'
            ? const MainParentScreen()
            : const MainKidScreen()));
  }

  void selectKid(String key, String value){
    selectedKidName = key;
    selectedKidEmail = value;
    wishList.clear();
    notifyListeners();
  }

  Future addTaskToBase(context)async{
    isLoading = true;
    notifyListeners();
    if(selectedKidName != ''){
    if(fileName != ''){
      try{
        await imageToUpload.putFile(File(file!.path));
        imageUrl = await imageToUpload.getDownloadURL();
      }catch(e){
        return;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('email');
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.
    instance.collection('users').doc(prefs.getString('email')?.toLowerCase()).get();
    String parentName = doc.data()?['name'];
      await FirebaseFirestore.instance.collection('tasks').add({
        'priceStatus': 'set',
        'parentName': parentName,
        'parentEmail': prefs.getString('email'),
        'kidName': selectedKidName,
        'kidEmail': selectedKidEmail,
        'taskName': addTaskNameController.text,
        'description': addTaskDescriptionController.text,
        'status': 'price',
        'price': addTaskPriceController.text,
        'deadline': isDeadline ? taskDeadline.toString() : 'false',
        'stars' : '0',
        'imageUrl' : fileName == '' ? 'false' : imageUrl,
        'time' : DateTime.now().toString()
      });
      addTaskNameController.clear();
      addTaskDescriptionController.clear();
      addTaskPriceController.clear();
      taskDeadline = DateTime.now();
      isDeadline = false;
      imageUrl = '';
      fileName = '';
      selectedKidName = '';
      selectedKidEmail = '';
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
          const MainParentScreen()));
    }else{
      sadToast('selectKid');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void>editTaskInBase(context, String docId)async{
    await FirebaseFirestore.instance.collection('tasks').doc(docId).update({
      'kidName': selectedKidName,
      'kidEmail': selectedKidEmail,
      'taskName': addTaskNameController.text,
      'description': addTaskDescriptionController.text,
      'price': addTaskPriceController.text,
      'deadline': isDeadline ? taskDeadline.toString() : 'false',
      'time' : DateTime.now().toString()
    });
    addTaskNameController.clear();
    addTaskDescriptionController.clear();
    addTaskPriceController.clear();
    taskDeadline = DateTime.now();
    isDeadline = false;
    imageUrl = '';
    fileName = '';
    selectedKidName = '';
    selectedKidEmail = '';
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const MainParentScreen()));
  }

  Future<void>saveTaskToHistory(String parentName, String parentEmail, String kidName, String kidEmail,
      String taskName, String description, String price, String stars)async {
    await FirebaseFirestore.instance.collection('history').add({
      'parentName': parentName,
      'parentEmail': parentEmail,
      'kidName': kidName,
      'kidEmail': kidEmail,
      'taskName': taskName,
      'description': description,
      'price': price,
      'stars' : stars,
      'time' : DateTime.now().toString()
    });
  }

  Future<void>addTaskToHistory(context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      int index, String parentName, String parentEmail, String kidName, String kidEmail,
      String taskName, String description, String price, String stars, String url)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.3,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Text('addToHistoryQuestion'.tr(), style: kTextStyle,),
                  ButtonWidget(
                      onTap: () {
                        saveTaskToHistory(parentName, parentEmail, kidName, kidEmail,
                            taskName, description, price, stars).then((v) =>
                          FirebaseFirestore.instance.collection('tasks').doc(
                              snapshot.data?.docs[index].id).delete());
                        if(url != 'false'){
                          FirebaseStorage.instance.refFromURL(url).delete();
                        }
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                            role == 'parent'
                                ? const MainParentScreen()
                                : const MainKidScreen()));
                        },
                      text: 'add')
                ],
              )
          );
        });
  }

  Future<void>historyDescription(context, String price, String description,
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index,) async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.5,
              width: size.width,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Container(
                    height: 60,
                    width: size.width,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kBlue.withOpacity(0.1),
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(4)
                      ),
                    ),
                    child: Text(snapshot.data?.docs[index].get('taskName'),
                      style: kBigTextStyle,),
                  ),
                  Container(
                    height: 200,
                    width: size.width,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: kBlue.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Text(snapshot.data?.docs[index].get('description'), style: kTextStyle),
                  ),
                  ButtonWidget(
                      onTap: () => deleteFromHistory(context, snapshot, index),
                      text: 'deleteFromHistory')
                ],
              )
          );
        });
  }

  Future<void>deleteFromHistory(context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.15,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Center(child: Text('areYouSure'.tr(), style: kTextStyle,)),
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection('history').doc(
                            snapshot.data?.docs[index].id).delete();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                            const HistoryScreen()));
                      },
                      child: Text('yes'.tr(), style: kTextStyle,)
                  )
                ],
              )
          );
        });
  }

  Future searchForEditing(String docId) async{
    isEdit = true;
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.
    instance.collection('tasks').doc(docId).get();
    if(doc.exists){
      Map<String, dynamic>? data = doc.data();
      selectedKidName = data?['kidName'];
      addTaskNameController.text = data?['taskName'];
      selectedKidEmail = data?['kidEmail'];
      addTaskDescriptionController.text = data?['description'];
      addTaskPriceController.text = data?['price'];
      taskDeadline = data?['deadline'] == 'false' ? DateTime.now() : DateTime.parse(data?['deadline']);
      isDeadline = data?['deadline'] == 'false' ? false : true;
      fileName = data?['imageUrl'];
      editDocId = docId;
    }
  }

  Widget image(){
    if(isEdit){
      if(fileName == 'false'){
        return const SizedBox.shrink();
      }else if(fileName.contains('https://firebasestorage')){
        return Image.network(fileName);
      }
    }else{
      if(fileName == ''){
        return const Icon(Icons.camera_alt);
      }else{
        return Image.file(File(file!.path), fit: BoxFit.cover,);
      }
    }
    return const Center(child: CircularProgressIndicator());

  }

  void updateRating(double rating){
    stars = rating;
    notifyListeners();
  }

  void setTaskTime(DateTime time){
    taskDeadline = time;
    notifyListeners();
  }

  void setIsDeadline(bool value){
    isDeadline = value;
    notifyListeners();
  }

  void setLanguage(context, Locale locale){
    context.setLocale(locale);
    notifyListeners();
  }

}