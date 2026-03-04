import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: size.width,
                            minHeight: size.height),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 18,),
                              Row(
                                children: [
                                  SizedBox(height: 40, width: 40,),
                                  const Spacer(),
                                  Text('${parent.name}', style: kBigTextStyle,),
                                  const SizedBox(width: 12,),
                                  Text('${parent.email}', 
                                    style: kTextStyle.copyWith(color: kBlue.withValues(alpha: 0.6)),),
                                  const Spacer(),
                                  const SizedBox(width: 32,)
                                ],
                              ),
                              const SizedBox(height: 18,),
                              Container(
                                width: size.width * 0.7,
                                height: size.width * 0.45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(18))
                                ),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CountryFlag.fromCountryCode(
                                      context.locale.countryCode == 'US' ? 'GB' : context.locale.countryCode ?? 'GB',
                                      theme: ImageTheme(
                                      height: size.width * 0.45,
                                      width: size.width * 0.7,
                                      shape: RoundedRectangle(8),
                                    ),),
                                    Positioned(
                                      bottom: 12,
                                      child: Container(
                                        width: size.width * 0.7,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: kWhite.withValues(alpha: 0.7),
                                              blurRadius: 10,
                                              spreadRadius: 10,
                                            )
                                          ]
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: List.generate(parent.locales.length, ((i){
                                            return GestureDetector(
                                                onTap: () {
                                                  context.setLocale(parent.locales.values.elementAt(i));
                                                  },
                                                child: FlagWidget(country: parent.locales.keys.elementAt(i)));
                                          })),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 50,),
                              Column(
                                children: [
                                  Text('yourParents'.tr(), style: kTextStyle,),
                                  SizedBox(
                                    height: 24.0 * data.parentsList.length,
                                    child: FutureBuilder(
                                      future: data.getParent,
                                      builder: (context, snapshot){
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return const Center(child: CircularProgressIndicator(),);
                                        }else{
                                          return ListView.builder(
                                              itemCount: data.parentsList.length,
                                              itemBuilder: (context, index){
                                                String key = data.parentsList.keys.elementAt(index);
                                                return data.parentsList[key] !=''
                                                    ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(key, style: kTextStyle,),
                                                    data.parentsListAccept[index]
                                                        ? const Icon(Icons.check,
                                                        color: kGreen)
                                                        : GestureDetector(
                                                        onTap: () => data.acceptParent(index),
                                                        child: Text('accept'.tr()))
                                                  ],
                                                )
                                                    : const SizedBox.shrink();
                                              }
                                          );
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 38,),
                              LogoutButtonWidget(),
                            ],
                          ),
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
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset('assets/icons/settings.svg',
                          width: size.width * 0.8,
                          colorFilter: ColorFilter.mode(kDarkWhite, BlendMode.srcIn),
                          )),
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
                child: Text('LogOut',
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


