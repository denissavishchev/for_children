import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';
import '../widgets/flag_widget.dart';
import 'parent_screens/main_parent_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer<ParentProvider>(
            builder: (context, data, _){
              return Padding(
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
                              IconButton(
                                  onPressed: () => Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                      const MainScreen())),
                                  icon: const Icon(
                                    Icons.backspace_outlined,
                                    color: kBlue,
                                    size: 32,
                                  )),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 18,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('language'.tr(),style: kTextStyle,),
                              GestureDetector(
                                onTap: () => context.setLocale(const Locale('en', 'US')),
                                  child: const FlagWidget(country: 'GB')),
                              GestureDetector(
                                onTap:  () => context.setLocale(const Locale('pl', 'PL')),
                                  child: const FlagWidget(country: 'PL')),
                              GestureDetector(
                                onTap: () => context.setLocale(const Locale('ru', 'RU')),
                                  child: const FlagWidget(country: 'RU')),
                            ],
                          ),
                          const SizedBox(height: 50,),
                          FutureBuilder(
                              future: data.getKids(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  return Column(
                                    children: [
                                      Text(
                                        'yourKids'.tr(), style: kTextStyle,),
                                      SizedBox(
                                        height: 50,
                                        child: ListView.builder(
                                          itemCount: data.kidsNames.length,
                                            itemBuilder: (context, index){
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('${data.kidsNames[index]}', style: kTextStyle,),
                                                const Icon(Icons.check, color: kDarkGrey,)
                                              ],
                                            );
                                            }
                                        ),
                                      )
                                    ],
                                  );
                                }else{
                                  return Text('noAddedKids'.tr(),style: kTextStyle,);
                                }

                              }),
                          const SizedBox(height: 18,),
                          Row(
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
                          const SizedBox(height: 50,),
                          Consumer<LoginProvider>(
                              builder: (context, data, _){
                                return TextButton(
                                    onPressed: () => data.signOut(context),
                                    child: Text('LogOut',style: kTextStyle,));
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}


