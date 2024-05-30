import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:for_children/widgets/status_widget.dart';
import 'package:image_picker/image_picker.dart';

class ParentProvider with ChangeNotifier {

  GlobalKey taskKey = GlobalKey<FormState>();

  TextEditingController addChildTaskNameController = TextEditingController();
  TextEditingController addTaskNameController = TextEditingController();
  TextEditingController addTaskDescriptionController = TextEditingController();
  TextEditingController addTaskPriceController = TextEditingController();

  DateTime taskDeadline = DateTime.now();
  bool isDeadline = false;

  List<String> status = ['price', 'inProgress', 'done', 'checked', 'paid'];

  String imageUrl = '';
  String fileName = '';
  late Reference imageToUpload;
  late XFile? file;

  Future pickAnImage()async{
    ImagePicker image = ImagePicker();
    file = await image.pickImage(source: ImageSource.camera);
    if(file == null) return;
    fileName = DateTime.now().millisecondsSinceEpoch.toString();
    imageToUpload = FirebaseStorage.instance.ref().child('images').child(fileName);
    notifyListeners();
  }

  Future showTaskDescription(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index, context) {
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(snapshot.data?.docs[index].get('kidName'),
                          style: kBigTextStyle,),
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.clear), color: kBlue,)
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 104,
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 60,
                                width: size.width * 0.7,
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
                              Divider(color: kBlue.withOpacity(0.2), height: 0.1,),
                              Container(
                                width: size.width * 0.7,
                                padding: const EdgeInsets.only(left: 12),
                                color: kBlue.withOpacity(0.1),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('taskPrice'.tr(),
                                          style: kTextStyle.copyWith(
                                              color: kBlue.withOpacity(0.6)),),
                                        Text(snapshot.data?.docs[index].get('price'),
                                          style: kTextStyle,),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(snapshot.data?.docs[index].get('deadline') != 'false'
                                            ? 'taskDeadline'.tr()
                                            : '',
                                          style: kTextStyle.copyWith(
                                              color: kBlue.withOpacity(0.6)),),
                                        Text(snapshot.data?.docs[index].get('deadline') == 'false'
                                            ? 'withoutDeadline'.tr()
                                            : snapshot.data?.docs[index].get('deadline') != null
                                            ? DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(snapshot.data!.docs[index].get('deadline')))
                                            : snapshot.data?.docs[index].get('deadline'),
                                          style: kTextStyle,),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusWidget(
                                snapshot: snapshot,
                                index: index,
                                border: false,
                                name: snapshot.data?.docs[index].get('status'),),
                              GestureDetector(
                                onTap: (){},
                                child: Container(
                                  width: size.width * 0.2,
                                  height: 60,
                                  margin: const EdgeInsets.fromLTRB(12, 0, 0, 4),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      border: Border.all(width: 1, color: kBlue.withOpacity(0.8)),
                                      gradient: LinearGradient(
                                          colors: [
                                            kBlue.withOpacity(0.4),
                                            kBlue.withOpacity(0.6)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 1)
                                        ),
                                        BoxShadow(
                                          color: kGrey.withOpacity(0.2),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                  ),
                                  child: const Center(child: Text('change')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 300,
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.fromLTRB(12, 12,
                              snapshot.data?.docs[index].get('imageUrl') == 'false' ? 12 : 3, 0),
                          decoration: BoxDecoration(
                            color: kBlue.withOpacity(0.1),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Text(snapshot.data?.docs[index].get('description'), style: kTextStyle),
                        ),
                      ),
                      snapshot.data?.docs[index].get('imageUrl') == 'false'
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: Container(
                            height: 300,
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.fromLTRB(3, 12, 12, 0),
                            decoration: BoxDecoration(
                              color: kBlue.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Image.network(snapshot.data?.docs[index].get('imageUrl'), fit: BoxFit.cover),
                          ),)
                    ],
                  )
                ],
              )
          );
        });
  }

  Future addTaskToBase(context)async{
    if(fileName != ''){
      try{
        await imageToUpload.putFile(File(file!.path));
        imageUrl = await imageToUpload.getDownloadURL();
      }catch(e){
        return;
      }
    }
    await FirebaseFirestore.instance.collection('tasks').add({
      'elderName': '',
      'kidName': addChildTaskNameController.text,
      'taskName': addTaskNameController.text,
      'description': addTaskDescriptionController.text,
      'status': 'paid',
      'price': addTaskPriceController.text,
      'deadline': isDeadline ? taskDeadline.toString() : 'false',
      'stars' : '2',
      'imageUrl' : fileName == '' ? 'false' : imageUrl
    });
    addChildTaskNameController.clear();
    addTaskNameController.clear();
    addTaskDescriptionController.clear();
    addTaskPriceController.clear();
    taskDeadline = DateTime.now();
    isDeadline = false;
    imageUrl = '';
    fileName = '';
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