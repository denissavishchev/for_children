import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/info_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    data.getKidsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kGrey,
      body: SafeArea(
        child: Consumer<ParentProvider>(
          builder: (context, data, _){
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 18,),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                    const MainParentScreen())),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: kBlue,
                                  size: 32,
                                )),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 18,),
                        Form(
                          key: data.taskKey,
                          child: Column(
                            children: [
                              SizedBox(
                                  width: size.width,
                                  height: 40.0 * (data.kidsList.length / 2).round(),
                                  child: FutureBuilder(
                                    future: data.getKid,
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const Center(child: CircularProgressIndicator(),);
                                      }else{
                                        return GridView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: data.kidsList.length,
                                          itemBuilder: (context, index){
                                            String key = data.kidsList.keys.elementAt(index);
                                            String value = data.kidsList.values.elementAt(index);
                                            return data.kidsListAccept[index] == true
                                                ? GestureDetector(
                                              onTap: () => data.selectKid(key, value),
                                              child: Container(
                                                width: size.width * 0.4,
                                                margin: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: kDarkGrey,
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: data.selectedKidName == key
                                                            ? kBlue : kDarkGrey)
                                                ),
                                                child: Center(
                                                    child: Text(key, style: kTextStyle,)),
                                              ),
                                            )
                                                : Container(
                                              width: size.width * 0.4,
                                              margin: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: kDarkGrey.withOpacity(0.3),
                                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                              ),
                                              child: Center(
                                                  child: Text('notConfirmed'.tr(args: [key]), style: kTextStyle,)),
                                            );
                                          },
                                          gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisExtent: 40),);
                                      }
                                    },
                                  )
                              ),
                              const SizedBox(height: 18,),
                              TextFormField(
                                controller: data.addTaskNameController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                cursorColor: kDarkGrey,
                                decoration: textFieldDecoration.copyWith(
                                    label: Text('task'.tr(),)),
                                maxLength: 64,
                                validator: (value){
                                  if(value == null || value.isEmpty) {
                                    return 'thisFieldCannotBeEmpty'.tr();
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18,),
                              TextFormField(
                                controller: data.addTaskDescriptionController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 5,
                                cursorColor: kDarkGrey,
                                decoration: textFieldDecoration.copyWith(
                                    label: Text('description'.tr(),)),
                                maxLength: 256,
                              ),
                              const SizedBox(height: 18,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: data.addTaskPriceController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.multiline,
                                      cursorColor: kDarkGrey,
                                      decoration: textFieldDecoration.copyWith(
                                          label: Text('price'.tr(),)),
                                      maxLength: 64,
                                    ),
                                  ),
                                  Visibility(
                                    visible: data.selectedKidName != '',
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: GestureDetector(
                                        onTap: () =>
                                          data.showWishList(context, data),
                                        child: Container(
                                          width: 55,
                                          height: 55,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: kDarkGrey,
                                          ),
                                          child: const Icon(Icons.favorite, color: kBlue,),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.7,
                              height: size.height * 0.1,
                              child: Opacity(
                                opacity: data.isDeadline ? 1 : 0.1,
                                child: AbsorbPointer(
                                  absorbing: !data.isDeadline,
                                  child: CupertinoDatePicker(
                                    backgroundColor: kGrey,
                                    initialDateTime: DateTime.now(),
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (DateTime time) => data.setTaskTime(time),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text('deadline'.tr(), style: kTextStyle,),
                                Switch(
                                    value: data.isDeadline,
                                    onChanged: (value) => data.setIsDeadline(value)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30,),
                        GestureDetector(
                          onTap: () => data.pickAnImage(),
                          child: Container(
                            width: 100,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: kBlue.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: data.fileName == ''
                                ? const Icon(Icons.camera_alt)
                                : Image.file(File(data.file!.path), fit: BoxFit.cover,),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        ButtonWidget(
                          onTap: () => data.addTaskToBase(context),
                          text: 'add',
                        ),
                        SizedBox(
                          height: 10,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('wishes')
                                  .snapshots(),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return ListView.builder(
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index){
                                        for(int w = 0; w < snapshot.data!.docs.length;){
                                          if(snapshot.data?.docs[index].get('parent${w}Name').toLowerCase() == data.email
                                          && snapshot.data?.docs[index].get('kidName') == data.selectedKidName){
                                            data.wishList.addAll({'${snapshot.data?.docs[index].get('wish')}' : '${snapshot.data?.docs[index].get('imageUrl')}'});
                                            return const SizedBox.shrink();
                                          }else{
                                            return const SizedBox.shrink();
                                          }
                                }
                                        return null;
                                }
                                  );
                                }else{
                                  return const CircularProgressIndicator();
                                }
                              }
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.viewInsetsOf(context).bottom == 0
                              ? size.height * 0.05 : size.height * 0.4,),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 24,
                    right: 20,
                    child: InfoWidget(
                      info: data.addTaskInfo,
                      onTap: () => data.switchAddTaskInfo(),
                      text: 'addTaskInfo',
                      height: 0.2,)),
                data.isLoading
                    ? Container(
                  width: size.width,
                  height: size.height,
                  color: kGrey.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator(color: kBlue,),),
                ) : const SizedBox.shrink()
              ],
            );
          },
        )
      ),
    );
  }
}



