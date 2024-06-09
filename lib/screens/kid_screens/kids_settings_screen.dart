import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/flag_widget.dart';
import 'main_kid_screen.dart';


class KidsSettingsScreen extends StatelessWidget {
  const KidsSettingsScreen({super.key});

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
                                      const MainKidScreen())),
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


