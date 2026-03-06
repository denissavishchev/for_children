import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/screens/kid_screens/wishes_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/button_widget.dart';

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 12,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 40,),
                              Text('whatDoYoWant'.tr(), style: kBigTextStyle),
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
                            ],
                          ),
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
                              width: 100,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: kOrange.withValues(alpha: 0.8),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                              ),
                              child: data.fileName == ''
                                  ? const Icon(Icons.camera_alt)
                                  : Image.file(File(data.file!.path), fit: BoxFit.cover,),
                            ),
                          ),
                          const SizedBox(height: 30,),
                          ButtonWidget(
                            onTap: () => data.addWishToBase(context),
                            text: 'add',
                          ),
                          SvgPicture.asset('assets/icons/wishStar.svg',
                            width: size.width * 0.8,
                            colorFilter: ColorFilter.mode(kDarkWhite, BlendMode.srcIn),
                          ),
                        ],
                      ),
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
