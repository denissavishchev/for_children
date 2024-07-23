import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/wishes_tiles_list_widget.dart';
import 'main_kid_screen.dart';

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
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer<KidProvider>(
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
                                      const MainKidScreen())),
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
                                                  width: size.width * 0.4,
                                                  margin: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: kDarkGrey,
                                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: value ? kBlue : kDarkGrey)
                                                  ),
                                                  child: Center(
                                                      child: Text(name, style: kTextStyle,)),
                                                ),
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
                                TextFormField(
                                  controller: data.addWishNameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('wish'.tr(),)),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }
                                    return null;
                                  },
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
                            onTap: () => data.addWishToBase(context),
                            text: 'add',
                          ),
                          SizedBox(
                            height: size.height * 0.05,),
                          const WishesTilesListWidget()
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 24,
                      right: 20,
                      child: InfoWidget(
                        info: data.wishInfo,
                        onTap: () => data.switchWishInfo(),
                        text: 'wishInfo',
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
