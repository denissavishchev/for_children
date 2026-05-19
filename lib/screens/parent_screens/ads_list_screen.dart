import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_ads_screen.dart';
import 'package:provider/provider.dart';
import '../../widgets/parents_widget/parent_bottom_navigation_bar_widget.dart';

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
              return Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      spacing: 18,
                      children: [
                        Text('adsListTitle'.tr(), style: kBigTextStyle, textAlign: TextAlign.center),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: kWhite,
                              border: Border.all(color: kBlue, width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(8)
                              ),
                          ),
                          child: Text('whyNeedAdDescription'.tr(), style: kTextStyle),
                        ),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kWhite,
                            border: Border.all(color: kBlue, width: 0.5),
                            borderRadius: const BorderRadius.all(Radius.circular(8)
                            ),
                          ),
                          child: Text('adDurationDescription'.tr(), style: kTextStyle),
                        ),
                        FutureBuilder(
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
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: data.kidsList.length,
                                    itemBuilder: (context, index){
                                      return data.kidsList[index].accept == true
                                          ? Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                              color: kWhite,
                                              border: Border.all(color: kBlue, width: 0.5),
                                              borderRadius: const BorderRadius.all(Radius.circular(8)
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: kBlue.withValues(alpha: 0.2),
                                                    blurRadius: 6,
                                                    spreadRadius: 1,
                                                    offset: const Offset(2, 4)
                                                )
                                              ]
                                          ),
                                          child: data.kidsList[index].adTitle != ''
                                              ? GestureDetector(
                                            onTap: () {
                                              data.selectedKidName = data.kidsList[index].name;
                                              data.selectedKidEmail = data.kidsList[index].email;
                                              data.deleteAdDialog(context, data.kidsList[index].adImageUrl, index);
                                            },
                                            child: ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                                                      child: Column(
                                                        spacing: 4,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(data.kidsList[index].adTitle,
                                                              style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                                                          Text(data.kidsList[index].adDescription,
                                                            style: kTextStyleNormal, softWrap: true,),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: kDarkWhite,
                                                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                                                              border: Border.all(color: kOrange.withValues(alpha: 0.7), width: 1),
                                                            ),
                                                            child: Text('timeLeft'.tr(args: [data.getTimeLeft(data.kidsList[index].adEndTime)]),
                                                              style: kTextStyleNormal,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        clipBehavior: Clip.hardEdge,
                                                        width: size.width * 0.3,
                                                        margin: const EdgeInsets.only(left: 12),
                                                        decoration: BoxDecoration(
                                                            color: kBlue.withValues(alpha: 0.3),
                                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: kGrey.withValues(alpha: 0.4),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset: Offset(0, 1),
                                                              )
                                                            ]
                                                        ),
                                                        child: Image.network(data.kidsList[index].adImageUrl,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (context, child, loadingProgress) {
                                                              if (loadingProgress == null) return child;
                                                              return const Center(child: SpinKitSpinningLines(
                                                                color: kBlue,
                                                                size: 40,
                                                              ),);
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
                                                        child: Text(data.kidsList[index].name,
                                                          style: kTextStyleNormal,),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                              : GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              data.selectedKidName = data.kidsList[index].name;
                                              data.selectedKidEmail = data.kidsList[index].email;
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(builder: (context) =>
                                                  const AddAdsScreen()));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                spacing: 8,
                                                children: [
                                                  Text(data.kidsList[index].name,
                                                    style: kTextStyle,),
                                                  Text('noAdAdded'.tr(), style: kTextStyle),
                                                  Icon(Icons.auto_awesome, color: kOrange,),
                                                  const Spacer(),
                                                  Text('clickToAdd'.tr(), style: kTextStyle),
                                                ],
                                              ),
                                            ),
                                          )
                                      )
                                          : Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: kDarkWhite,
                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            border: Border.all(
                                                width: 2,
                                                color: kDarkGrey),
                                            boxShadow: [
                                              BoxShadow(
                                                color: kGrey.withValues(alpha: 0.4),
                                                spreadRadius: 1.5,
                                                blurRadius: 3,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                        ),
                                        child: Center(
                                            child: Text('notConfirmed'.tr(args: [data.kidsList[index].name]),
                                              style: kTextStyle,)),
                                      );
                                    },
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  ParentBottomNavigationBarWidget()
                ],
              );
            },
          )
      ),
    );
  }
}





