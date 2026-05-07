import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/parents_widget/parent_button_widget.dart';
import 'package:for_children/widgets/parents_widget/parent_round_button.dart';
import 'package:provider/provider.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 18,
                      children: [
                        Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParentRoundButton(
                                onTap: () => Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                    const MainParentScreen())),
                                icon: Icons.arrow_back_ios_new
                            ),
                            Expanded(child: Text('addTaskInfo'.tr(), style: kTextStyle,))
                          ],
                        ),
                        Form(
                          key: data.taskKey,
                          child: Column(
                            spacing: 18,
                            children: [
                              SizedBox(
                                  width: size.width,
                                  height: 40.0 * (data.kidsList.length / 2).round(),
                                  child: FutureBuilder(
                                    future: data.getKid,
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const Center(child: SpinKitSpinningLines(
                                          color: kBlue,
                                          size: 40,
                                        ),);
                                      }else{
                                        return GridView.builder(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SelectTaskTypeWidget(),
                                  ExpWidget(count: 3,)
                                ],
                              ),
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
                        GestureDetector(
                          onTap: () => data.isEdit ? null : data.pickAnImage(),
                          child: Container(
                            width: 100,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: kBlue.withValues(alpha: 0.3),
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: data.image(),
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
                          height: 10,
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                            stream: Supabase.instance.client
                                .from('wishes')
                                .stream(primaryKey: ['id']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final wishes = snapshot.data!;
                                data.wishList.clear();
                                for (var wish in wishes) {
                                  for (int w = 0; w < 10; w++) {
                                    String parentKey = 'parent${w}Name';
                                    if (wish.containsKey(parentKey) && wish[parentKey] != null) {
                                      if (wish[parentKey].toString().toLowerCase() == data.email?.toLowerCase() &&
                                          wish['kidName'] == data.selectedKidName) {
                                        data.wishList[wish['wish'].toString()] = wish['imageUrl'].toString();
                                        break;
                                      }
                                    }
                                  }
                                }
                                return const SizedBox.shrink();
                              } else {
                                return const Center(child: SpinKitSpinningLines(
                                  color: kBlue,
                                  size: 40,
                                ),);
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.viewInsetsOf(context).bottom == 0
                              ? size.height * 0.05 : size.height * 0.4,),
                      ],
                    ),
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





