import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KidProvider with ChangeNotifier {

  late Future<void> getParent;
  Map<String, String> parentsList = {};
  List<bool> parentsListAccept = [];
  List<String> parentsEmailsList = [];

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

}