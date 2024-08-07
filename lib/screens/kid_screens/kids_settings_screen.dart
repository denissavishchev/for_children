import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/flag_widget.dart';
import '../../widgets/info_widget.dart';
import 'main_kid_screen.dart';


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
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer2<KidProvider, ParentProvider>(
            builder: (context, data, parent, _){
              return Stack(
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
                                  Text('${parent.email}', style: kTextStyle,),
                                  const Spacer(),
                                  const SizedBox(width: 32,)
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
                              Column(
                                children: [
                                  Text(
                                    'yourParents'.tr(), style: kTextStyle,),
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
                              const SizedBox(height: 18,),
                              Consumer<LoginProvider>(
                                  builder: (context, data, _){
                                    return TextButton(
                                        onPressed: () => data.logOut(context),
                                        child: Text('LogOut',style: kTextStyle,));
                                  })
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
                ],
              );
            },
          )
      ),
    );
  }
}


