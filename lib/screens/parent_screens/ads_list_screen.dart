import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_ads_screen.dart';
import 'package:provider/provider.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';

class AdsListScreen extends StatefulWidget {
  const AdsListScreen({super.key});

  @override
  State<AdsListScreen> createState() => _AdsListScreenState();
}

class _AdsListScreenState extends State<AdsListScreen> {

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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 18,
                    children: [
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
                      FutureBuilder(
                        future: data.getKid,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator(),);
                          }else{
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.kidsList.length,
                              itemBuilder: (context, index){
                                return data.kidsList[index].accept == true
                                    ? GestureDetector(
                                        onTap: () {
                                          data.selectedKidName = data.kidsList[index].name;
                                          data.selectedKidEmail = data.kidsList[index].email;
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) =>
                                              const AddAdsScreen()));
                                  },
                                  child: Container(
                                    width: size.width * 0.8,
                                    height: 100,
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: kDarkWhite,
                                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        border: Border.all(
                                            width: 2,
                                            color: kDarkGrey)
                                    ),
                                    child: Center(
                                        child: Text(data.kidsList[index].name, style: kTextStyle,)),
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
                                      child: Text('notConfirmed'.tr(args: [data.kidsList[index].name]), style: kTextStyle,)),
                                );
                              },
                            );
                          }
                        },
                      ),
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





