import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import '../../widgets/button_widget.dart';

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
            return Padding(
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
                                const MainScreen())),
                            icon: const Icon(
                              Icons.backspace_outlined,
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
                                  return GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: data.kidsList.length,
                                    itemBuilder: (context, index){
                                      String key = data.kidsList.keys.elementAt(index);
                                      return Container(
                                        width: size.width * 0.4,
                                        margin: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                            color: kDarkGrey,
                                            borderRadius: BorderRadius.all(Radius.circular(12))
                                        ),
                                        child: Center(
                                            child: Text(key, style: kTextStyle,)),
                                      );
                                    },
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 40),);
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
                            TextFormField(
                              controller: data.addTaskPriceController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.multiline,
                              cursorColor: kDarkGrey,
                              decoration: textFieldDecoration.copyWith(
                                  label: Text('price'.tr(),)),
                              maxLength: 64,
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
                      height: MediaQuery.viewInsetsOf(context).bottom == 0
                          ? size.height * 0.05 : size.height * 0.4,),
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }
}



