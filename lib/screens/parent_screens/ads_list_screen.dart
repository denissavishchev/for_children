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
                                      color: kWhite,
                                      borderRadius: BorderRadius.all(Radius.circular(18)),
                                      border: Border.all(color: kGrey, width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kGrey.withValues(alpha: 0.4),
                                          spreadRadius: 1.5,
                                          blurRadius: 3,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                            child: Column(
                                              spacing: 12,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(data.adsList[index].title,
                                                  style: kBigTextStyle.copyWith(fontSize: 44.sp),),
                                                Text(data.adsList[index].description,
                                                  style: kTextStyleNormal, softWrap: true,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Container(
                                              clipBehavior: Clip.hardEdge,
                                              margin: const EdgeInsets.only(left: 12),
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
                                            Container(
                                              margin: const EdgeInsets.only(top: 12),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: kDarkWhite,
                                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                                border: Border.all(color: kOrange.withValues(alpha: 0.7), width: 1),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: kWhite.withValues(alpha: 0.7),
                                                    spreadRadius: 3,
                                                    blurRadius: 3,
                                                    offset: const Offset(0, -1),
                                                  ),
                                                  BoxShadow(
                                                    color: kOrange.withValues(alpha: 0.4),
                                                    spreadRadius: 1,
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 4),
                                                  )
                                                ]
                                              ),
                                              child: Text(data.adsList[index].name,
                                                style: kTextStyleNormal,),
                                            )
                                          ],
                                        ),
                                      
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





