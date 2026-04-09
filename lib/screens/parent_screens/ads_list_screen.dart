import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = Provider.of<ParentProvider>(context, listen: false);
      data.getAdsData();
    });
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
                        future: data.getAds,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator(),);
                          }else{
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.adsList.length,
                              itemBuilder: (context, index){
                                return GestureDetector(
                                  onTap: () {
                                    data.selectedKidName = data.adsList[index].name;
                                    data.selectedKidEmail = data.adsList[index].kidEmail;
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                        const AddAdsScreen()));
                                  },
                                  child: Container(
                                    width: size.width,
                                    height: size.height * 0.2,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(18)),
                                      border: Border.all(color: kGrey, width: 1),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              color: kBlue.withValues(alpha: 0.3),
                                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                                            ),
                                            child: Image.network(data.adsList[index].imageUrl,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(Icons.warning, color: kOrange,),
                                                  );
                                                }),
                                          ),
                                        ),
                                        Positioned(
                                            top: 12,
                                            left: 12,
                                            child: SizedBox(
                                              width: size.width * 0.6,
                                              child: Text(data.adsList[index].title,
                                                style: kBigTextStyle.copyWith(fontSize: 44.sp),),
                                            )
                                        ),
                                        Positioned(
                                            top: size.height * 0.1,
                                            left: 12,
                                            child: SizedBox(
                                              width: size.width * 0.6,
                                              child: Text(data.adsList[index].description,
                                                style: kTextStyleNormal,),
                                            )
                                        ),
                                        Positioned(
                                            top: 12,
                                            right: 12,
                                            child: Container(
                                              color: kRed,
                                              width: size.width * 0.3,
                                              child: Text(data.adsList[index].name,
                                                style: kTextStyleNormal,),
                                            )
                                        )
                                      ],
                                    ),
                                  ),
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





