import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/parents_widget/parent_button_widget.dart';
import 'package:for_children/widgets/parents_widget/parent_round_button.dart';
import 'package:provider/provider.dart';
import '../../widgets/parents_widget/exp_widget.dart';
import '../../widgets/parents_widget/select_task_type_widget.dart';

class AddSingleTaskScreen extends StatefulWidget {
  const AddSingleTaskScreen({super.key});

  @override
  State<AddSingleTaskScreen> createState() => _AddSingleTaskScreenState();
}

class _AddSingleTaskScreenState extends State<AddSingleTaskScreen> {

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
      backgroundColor: kWhite,
      body: SafeArea(
        child: Consumer<ParentProvider>(
          builder: (context, data, _){
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    spacing: 18,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParentRoundButton(
                                onTap: () => data.showExitAddTaskDialog(context),
                                icon: Icons.arrow_back_ios_new
                            ),
                            Expanded(child: Text('addTaskInfo'.tr(), style: kTextStyle,))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Form(
                          key: data.taskKey,
                          child: Column(
                            spacing: 12,
                            children: [
                              SizedBox(
                                  width: size.width,
                                  height: data.kidsList.isEmpty ? null : 40.0 * (data.kidsList.length / 2).round(),
                                  child: FutureBuilder(
                                    future: data.getKid,
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const Center(child: SpinKitSpinningLines(
                                          color: kBlue,
                                          size: 40,
                                        ),);
                                      }else{
                                        return data.kidsList.isEmpty
                                            ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: kBlue, width: 0.5),
                                                  borderRadius: BorderRadius.all(Radius.circular(8))
                                              ),
                                              child: Text('noAddedKids'.tr(), style: kTextStyle, textAlign: TextAlign.center,),
                                            )
                                        : GridView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: data.kidsList.length,
                                          itemBuilder: (context, index){
                                            final isSelected = data.selectedKidName == data.kidsList[index].name;
                                            return data.kidsList[index].accept == true
                                                ? GestureDetector(
                                              onTap: () => data.selectKid(data.kidsList[index].name, data.kidsList[index].email),
                                              child: Container(
                                                width: size.width * 0.4,
                                                margin: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: isSelected ? kDarkWhite : Colors.transparent,
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    border: Border.all(
                                                        width: isSelected ? 1 : 0.5,
                                                        color: isSelected ? kBlue : kDarkGrey),
                                                    boxShadow: [
                                                      BoxShadow(
                                                      color: kDarkGrey.withValues(alpha: 0.6),
                                                    ),
                                                      isSelected
                                                          ? BoxShadow(
                                                              color: kBlue.withValues(alpha: 0.1),
                                                              blurRadius: 1,
                                                              spreadRadius: 2,
                                                              offset: const Offset(1, 1))
                                                          : BoxShadow(
                                                              color: kWhite,
                                                              blurRadius: 2,
                                                              spreadRadius: -1,
                                                              offset: const Offset(0, 1)
                                                      )
                                                  ]
                                                ),
                                                child: Center(
                                                    child: Text(
                                                      data.kidsList[index].name,
                                                      style: isSelected ? kTextStyle : kTextStyleGrey,)),
                                              ),
                                            )
                                                : Container(
                                                    width: size.width * 0.4,
                                                    margin: const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: kDarkGrey.withValues(alpha: 0.3),
                                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    ),
                                              child: Center(
                                                  child: Text('notConfirmed'.tr(args: [data.kidsList[index].name]), style: kTextStyleGrey,)),
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
                              Column(
                                spacing: 8,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    spacing: 8,
                                    children: [
                                      SelectTaskTypeWidget(width: 120,),
                                      Expanded(child: Text('taskTypeDescription'.tr(), style: kSmallTextStyle))
                                    ],
                                  ),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      ExpWidget(count: 3,),
                                      Expanded(child: Text('taskExpDescription'.tr(), style: kSmallTextStyle))
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 2,),
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
                                        onTap: () => data.showWishList(context, data),
                                        child: Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              border: Border.all(width: 0.8, color: kBlue),
                                              color: kWhite,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: kBlue.withValues(alpha: 0.3),
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                    offset: const Offset(0, 2)
                                                )
                                              ]
                                          ),
                                          child: const Icon(Icons.favorite_border_outlined, color: kBlue, size: 32,),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          spacing: 8,
                          children: [
                            Text('deadline'.tr(), style: kTextStyle,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width * 0.8,
                                  height: 80,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(width: 0.8, color: data.isDeadline ? kBlue : kGrey.withValues(alpha: 0.5)),
                                      color: kWhite,
                                      boxShadow: [
                                        BoxShadow(
                                            color: kBlue.withValues(alpha: data.isDeadline ? 0.3 : 0),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2)
                                        )
                                      ]
                                  ),
                                  child: Opacity(
                                    opacity: data.isDeadline ? 1 : 0.35,
                                    child: AbsorbPointer(
                                      absorbing: !data.isDeadline,
                                      child: CupertinoTheme(
                                          data: CupertinoThemeData(
                                            barBackgroundColor: Colors.transparent,
                                            textTheme: CupertinoTextThemeData(
                                              dateTimePickerTextStyle: kTextStyle,
                                              pickerTextStyle: kTextStyle,
                                            )
                                          ),
                                          child: CupertinoDatePicker(
                                            backgroundColor: Colors.transparent,
                                            initialDateTime: DateTime.now(),
                                            minimumDate: DateTime.now().subtract(const Duration(minutes: 1)),
                                            use24hFormat: true,
                                            mode: CupertinoDatePickerMode.date,
                                            onDateTimeChanged: (DateTime time) => data.setTaskTime(time),
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: Switch(
                                    activeThumbColor: kBlue,
                                    activeTrackColor: kGrey.withValues(alpha: 0.2),
                                    inactiveThumbColor: kGrey,
                                    inactiveTrackColor: kWhite,
                                      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                        if (states.contains(WidgetState.selected)) {
                                          return kBlue;
                                        }
                                        return kGrey;
                                      }),
                                    value: data.isDeadline,
                                    onChanged: (value) => data.setIsDeadline(value)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          spacing: 12,
                          children: [
                            GestureDetector(
                              onTap: () => data.isEdit ? null : data.pickAnImage(),
                              child: Container(
                                width: size.width * 0.4,
                                height: size.width * 0.5,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  border: Border.all(color: kBlue, width: data.fileName == '' ? 2 : 0),
                                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                                ),
                                child: data.fileName == ''
                                    ? Icon(Icons.camera_alt, size: 80, color: kBlue.withValues(alpha: 0.8),)
                                    : ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    child: Image.file(File(data.file!.path), fit: BoxFit.cover,)),
                              ),
                            ),
                            Expanded(child: Text('addPhotoDescription'.tr(), style: kTextStyle))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ParentButtonWidget(
                            onTap: () => data.isEdit
                                ? data.editSingleTaskInBase(context, data.editDocId)
                                : data.addSingleTaskToBase(context),
                            text: data.isEdit ? 'edit' : 'add'
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.viewInsetsOf(context).bottom == 0
                            ? size.height * 0.01 : size.height * 0.4,),
                    ],
                  ),
                ),
                data.isLoading
                    ? Container(
                  width: size.width,
                  height: size.height,
                  color: kGrey.withValues(alpha: 0.3),
                  child: const Center(child: SpinKitSpinningLines(
                    color: kBlue,
                    size: 40,
                  ),),
                ) : const SizedBox.shrink()
              ],
            );
          },
        )
      ),
    );
  }
}





