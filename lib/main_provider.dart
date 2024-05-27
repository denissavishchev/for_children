import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/screens/main_screen.dart';

class MainProvider with ChangeNotifier {

  GlobalKey taskKey = GlobalKey<FormState>();

  TextEditingController addChildTaskNameController = TextEditingController();
  TextEditingController addTaskNameController = TextEditingController();
  TextEditingController addTaskDescriptionController = TextEditingController();
  TextEditingController addTaskPriceController = TextEditingController();

  DateTime taskDeadline = DateTime.now();
  bool isDeadline = false;

  List<String> status = ['price', 'inProgress', 'done', 'checked', 'paid'];

  Future addTaskToBase(context)async{
    await FirebaseFirestore.instance.collection('tasks').add({
      'elderName': '',
      'kidName': addChildTaskNameController.text,
      'taskName': addTaskNameController.text,
      'description': addTaskDescriptionController.text,
      'status': 'done',
      'price': addTaskPriceController.text,
      'deadline': isDeadline ? taskDeadline.toString() : 'false',
      'stars': '3',
    });
    addChildTaskNameController.clear();
    addTaskNameController.clear();
    addTaskDescriptionController.clear();
    addTaskPriceController.clear();
    taskDeadline = DateTime.now();
    isDeadline = false;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const MainScreen()));
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