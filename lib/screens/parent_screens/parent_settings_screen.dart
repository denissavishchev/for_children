import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/widgets/parents_widget/parent_button_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/flag_widget.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/parents_widget/parent_bottom_navigation_bar_widget.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {

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
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: size.width,
                          minHeight: size.height),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const SizedBox(height: 18,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                      Text('${data.name}', style: kBigTextStyle,),
                                      Text('${data.email}',
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
                                    children: List.generate(data.locales.length, ((i){
                                      return GestureDetector(
                                          onTap: () => context.setLocale(data.locales.values.elementAt(i)),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: context.locale == data.locales.values.elementAt(i)
                                                          ? kDarkBlue : Colors.transparent,
                                                      blurRadius: 3,
                                                      spreadRadius: 2,
                                                    )
                                                  ]
                                              ),
                                              child: FlagWidget(country: data.locales.keys.elementAt(i))));
                                    })),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
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
                              child: Column(
                                spacing: 8,
                                children: [
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Image.asset('assets/images/family.png', width: 20),
                                      Text('yourKids'.tr(), style: kTextStyle,),
                                    ],
                                  ),
                                  Text('yourKidsDescription'.tr(), style: kTextStyle,),
                                  SizedBox(
                                    height: 72.0 * data.kidsList.length,
                                    child: FutureBuilder(
                                      future: data.getKid,
                                      builder: (context, snapshot){
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return const Center(child: SpinKitSpinningLines(
                                            color: kBlue,
                                            size: 40,
                                          ),);
                                        }else{
                                          return ListView.builder(
                                              itemCount: data.kidsList.length,
                                              itemBuilder: (context, index){
                                                return data.kidsList[index].name != ''
                                                    ? Padding(
                                                  padding: const EdgeInsets.only(bottom: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if(data.kidsList[index].accept){
                                                        data.changeDayDuration(
                                                            context,
                                                            data.kidsList[index].name,
                                                            data.kidsList[index].startDay,
                                                            data.kidsList[index].endDay,
                                                            data.kidsList[index].email);
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                          color: kWhite,
                                                          border: Border.all(color: kBlue, width: 0.5),
                                                          borderRadius: const BorderRadius.all(Radius.circular(8)
                                                          ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(data.kidsList[index].name, style: kBigTextStyle,),
                                                              Row(
                                                                spacing: 4,
                                                                children: [
                                                                  Text(!data.kidsList[index].accept ? 'notAccepted'.tr() : 'accepted'.tr(),
                                                                    style: kBigTextStyle.copyWith(fontWeight: FontWeight.normal),),
                                                                  Container(
                                                                      width: 16,
                                                                      height: 16,
                                                                      decoration: BoxDecoration(
                                                                          color: !data.kidsList[index].accept ? kRed : kGreen,
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
                                                                      child: Icon(!data.kidsList[index].accept
                                                                          ? Icons.close : Icons.check,
                                                                        color: kWhite, size: 14,)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('dayDurationTime'.tr(), style: kBigTextStyle.copyWith(fontWeight: FontWeight.normal),),
                                                              Text('${data.kidsList[index].startDay.substring(0, 5)} - ${data.kidsList[index].endDay.substring(0, 5)}',
                                                                style: kBigTextStyle.copyWith(fontWeight: FontWeight.normal),),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
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
                            ),
                            const SizedBox(height: 18,),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12.0),
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
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
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      controller: data.kidSearchController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      cursorColor: kDarkGrey,
                                      decoration: textFieldDecoration.copyWith(
                                          label: Text('kidsEmail'.tr(),)),
                                      onTapOutside: (e) => FocusManager.instance.primaryFocus?.unfocus(),
                                      validator: (value){
                                        if(value == null || value.isEmpty) {
                                          return 'thisFieldCannotBeEmpty'.tr();
                                        }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)){
                                          return 'wrongEmail'.tr();
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () => data.kidSearch(context),
                                        icon: const Icon(Icons.search, size: 44,))
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 50,),
                            Consumer<LoginProvider>(
                                builder: (context, data, _){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: ParentButtonWidget(
                                        onTap: () => data.logOut(context),
                                        text: 'logout'),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 24,
                      right: 20,
                      child: InfoWidget(
                        info: data.settingsParentInfo,
                        onTap: () => data.switchSettingsParentInfo(),
                        text: 'settingsParentInfo',
                        height: 0.2,)),
                  ParentBottomNavigationBarWidget()
                ],
              );
            },
          )
      ),
    );
  }
}


