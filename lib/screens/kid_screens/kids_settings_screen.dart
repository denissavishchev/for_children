import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/flag_widget.dart';
import '../../widgets/info_widget.dart';

class KidsSettingsScreen extends StatefulWidget {
  const KidsSettingsScreen({super.key});

  @override
  State<KidsSettingsScreen> createState() => _KidsSettingsScreenState();
}

class _KidsSettingsScreenState extends State<KidsSettingsScreen> {

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
          child: Consumer2<KidProvider, ParentProvider>(
            builder: (context, data, parent, _){
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset('assets/icons/settings.svg',
                        width: size.width * 0.8,
                        colorFilter: ColorFilter.mode(kDarkWhite, BlendMode.srcIn),
                      )),
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: size.width,
                          minHeight: size.height),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 12,12, 0),
                              child: Row(
                                spacing: 12,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: kDarkWhite),
                                        boxShadow: [
                                          BoxShadow(
                                              color: kGrey.withValues(alpha: 0.3),
                                              blurRadius: 3,
                                              spreadRadius: 3,
                                              offset: Offset(2, 2)
                                          )
                                        ]
                                    ),
                                    child: Image.asset('assets/images/catAvatar.png'),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${parent.name}', style: kBigTextStyle,),
                                      Text('${parent.email}',
                                        style: kTextStyle.copyWith(color: kBlue.withValues(alpha: 0.6)),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 18,),
                            Container(
                              width: size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kWhite.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                                border: Border.all(color: kDarkWhite),
                                boxShadow: [
                                  BoxShadow(
                                    color: kGrey.withValues(alpha: 0.3),
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    offset: Offset(0, 2)
                                  )
                                ]
                              ),
                              child: Column(
                                spacing: 12,
                                children: [
                                  Row(
                                    spacing: 8,
                                    children: [
                                      Image.asset('assets/images/languages.png', width: 20),
                                      Text('language'.tr(), style: kBigTextStyle,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: List.generate(parent.locales.length, ((i){
                                      return GestureDetector(
                                          onTap: () => context.setLocale(parent.locales.values.elementAt(i)),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: context.locale == parent.locales.values.elementAt(i)
                                                        ? kDarkBlue : Colors.transparent,
                                                    blurRadius: 3,
                                                    spreadRadius: 2,
                                                  )
                                                ]
                                              ),
                                              child: FlagWidget(country: parent.locales.keys.elementAt(i))));
                                    })),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              width: size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: kWhite.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                  border: Border.all(color: kDarkWhite),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kGrey.withValues(alpha: 0.3),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2)
                                    )
                                  ]
                              ),
                              child: Column(
                                spacing: 8,
                                children: [
                                  Row(
                                    spacing: 8,
                                    children: [
                                      Image.asset('assets/images/family.png', width: 20),
                                      Text('yourParents'.tr(), style: kBigTextStyle,),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 32.0 * data.parentsList.length,
                                    child: FutureBuilder(
                                      future: data.getParent,
                                      builder: (context, snapshot){
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return const Center(child: SpinKitSpinningLines(
                                            color: kBlue,
                                            size: 40,
                                          ),);
                                        }else{
                                          return ListView.separated(
                                              itemCount: data.parentsList.length,
                                              itemBuilder: (context, index){
                                                String key = data.parentsList.keys.elementAt(index);
                                                bool isAccepted = data.parentsListAccept[index];
                                                return data.parentsList[key] !=''
                                                    ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(key, style: kBigTextStyle,),
                                                        GestureDetector(
                                                          onTap: () => !isAccepted ? data.acceptParent(index) : null,
                                                          child: Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                                            decoration: BoxDecoration(
                                                                color: !isAccepted
                                                                    ? kRed.withValues(alpha: 0.6)
                                                                    : Colors.transparent,
                                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: !isAccepted ? kDarkWhite.withValues(alpha: 0.8) : Colors.transparent,
                                                                    blurRadius: 3,
                                                                    spreadRadius: 1.5,
                                                                  )
                                                                ]
                                                            ),
                                                            child: Row(
                                                              spacing: 4,
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Text(!isAccepted ? 'clickToAccept'.tr() : 'accepted'.tr(),
                                                                  style: kBigTextStyle.copyWith(fontWeight: FontWeight.normal),),
                                                                Container(
                                                                    width: 16,
                                                                    height: 16,
                                                                    decoration: BoxDecoration(
                                                                        color: !isAccepted ? kRed : kGreen,
                                                                        shape: BoxShape.circle,
                                                                        border: Border.all(width: 0.5 ,color: kWhite),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color: kWhite,
                                                                            blurRadius: 0.5,
                                                                            spreadRadius: 0.5,
                                                                          )
                                                                        ]
                                                                    ),
                                                                    child: Icon(!isAccepted ? Icons.close : Icons.check, color: kWhite, size: 14,)),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                    : const SizedBox.shrink();
                                              },
                                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.2,),
                            LogoutButtonWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 24,
                      right: 20,
                      child: InfoWidget(
                        info: data.settingsKidInfo,
                        onTap: () => data.switchSettingsKidInfo(),
                        text: 'settingsKidInfo',
                        height: 0.2,)),
                  KidBottomNavigationBarWidget()
                ],
              );
            },
          )
      ),
    );
  }
}

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<LoginProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: () => data.logOut(context),
            child: Container(
              height: 38,
              width: size.height * 0.2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kWhite,
                        kWhite.withValues(alpha: 0.01),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      stops: [0.1, 1]
                  ),
                  border: Border.all(color: kWhite, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(size.width * 0.45,)),
                  boxShadow: [
                    BoxShadow(
                        color: kGrey.withValues(alpha: 0.3),
                        blurRadius: 3,
                        spreadRadius: 1.5,
                        offset: Offset(0, 2)
                    ),
                  ]
              ),
              child: Center(
                child: Text('logout'.tr(),
                  style: kBigTextStyle.copyWith(
                    color: kBlue,
                  ),),
              ),
            ),
          );
        }
    );
  }
}


