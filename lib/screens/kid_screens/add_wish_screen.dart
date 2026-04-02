import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/screens/kid_screens/wishes_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';

class AddWishScreen extends StatefulWidget {
  const AddWishScreen({super.key});

  @override
  State<AddWishScreen> createState() => _AddWishScreenState();
}

class _AddWishScreenState extends State<AddWishScreen> {

  @override
  void initState() {
    final data = Provider.of<KidProvider>(context, listen: false);
    data.getParentsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
          child: Consumer<KidProvider>(
            builder: (context, data, _){
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      spacing: 12,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => const WishesScreen())),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kDarkGrey, width: 2),
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text('back'.tr(), style: kTextStyle),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Text('whatDoYoWant'.tr(), style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            color: kWhite,
                            border: Border.all(color: kDarkWhite, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: kGrey.withValues(alpha: 0.7),
                                spreadRadius: 10,
                                blurRadius: 20,
                                offset: const Offset(0, 10)
                              )
                            ]
                          ),
                          child: Column(
                            children: [
                              Form(
                                key: data.wishKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: size.width,
                                        height: 100,
                                        child: FutureBuilder(
                                          future: data.getParent,
                                          builder: (context, snapshot){
                                            if(snapshot.connectionState == ConnectionState.waiting){
                                              return const Center(child: CircularProgressIndicator(),);
                                            }else{
                                              return GridView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: data.selectedParentsEmail.length,
                                                itemBuilder: (context, index){
                                                  String key = data.selectedParentsEmail.keys.elementAt(index);
                                                  String name = data.parentsList.keys.elementAt(index);
                                                  bool value = data.selectedParentsEmail.values.elementAt(index);
                                                  return GestureDetector(
                                                    onTap: () => data.selectParent(key, value),
                                                    child: Container(
                                                      margin: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          color: value ? kWhite : Colors.transparent,
                                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: kDarkGrey.withValues(alpha: 0.8),
                                                                blurRadius: 0,
                                                                spreadRadius: 0,
                                                                offset: const Offset(0, 0)
                                                            ),
                                                            value
                                                                ? BoxShadow(
                                                                color: kGrey.withValues(alpha: 0.3),
                                                                blurRadius: 2,
                                                                spreadRadius: 3,
                                                                offset: const Offset(0, 2))
                                                                : BoxShadow(
                                                                color: kWhite,
                                                                blurRadius: 2,
                                                                spreadRadius: -1,
                                                                offset: const Offset(0, 1)
                                                            )
                                                          ]
                                                      ),
                                                      child: Center(
                                                          child: Text(name,
                                                            style: value ? kBigTextStyle : kBigTextStyle.copyWith(color: kGrey),)),
                                                    ),
                                                  );
                                                },
                                                gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 12,
                                                    mainAxisExtent: 40),);
                                            }
                                          },
                                        )
                                    ),
                                    Column(
                                      spacing: 12,
                                      children: [
                                        TextFormField(
                                          controller: data.addWishNameController,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          cursorColor: kDarkGrey,
                                          decoration: textFieldKidDecoration.copyWith(
                                              label: Text('wish'.tr(),)),
                                          maxLength: 64,
                                          validator: (value){
                                            if(value == null || value.isEmpty) {
                                              return 'thisFieldCannotBeEmpty'.tr();
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: data.addWishDescriptionController,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          cursorColor: kDarkGrey,
                                          maxLines: 2,
                                          decoration: textFieldKidDecoration.copyWith(
                                              label: Text('whyYouNeedThis'.tr(),)),
                                          maxLength: 256,
                                          validator: (value){
                                            if(value == null || value.isEmpty) {
                                              return 'thisFieldCannotBeEmpty'.tr();
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => data.pickAnImage(),
                                child: Container(
                                  width: size.width * 0.5,
                                  height: size.width * 0.6,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kDarkGrey, width: data.fileName == '' ? 2 : 0),
                                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                                  ),
                                  child: data.fileName == ''
                                      ? const Icon(Icons.camera_alt, size: 60, color: kDarkGrey,)
                                      : Image.file(File(data.file!.path), fit: BoxFit.cover,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30,),
                        GestureDetector(
                          onTap: () => data.addWishToBase(context),
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * 0.7,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    kOrange,
                                    kRed,
                                    kPurple,
                                    kBlue,
                                    kDarkBlue
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                stops: [
                                  0.1, 0.4, 0.6, 0.8, 0.9
                                  ]
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: kOrange.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(-4, 0)
                                ),
                                BoxShadow(
                                  color: kDarkBlue.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10)
                                )
                              ],
                              border: Border.all(color: kDarkWhite.withValues(alpha: 0.8), width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Text('add', style: kBigTextStyleWhite.copyWith(fontSize: 44.sp)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  data.isLoading
                      ? Container(
                    width: size.width,
                    height: size.height,
                    color: kGrey.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator(color: kBlue,),),
                  ) : const SizedBox.shrink(),
                ],
              );
            },
          )
      ),
    );
  }
}
