import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/flag_widget.dart';
import '../../widgets/info_widget.dart';
import 'main_parent_screen.dart';

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
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer<ParentProvider>(
            builder: (context, data, _){
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
                                          const MainParentScreen())),
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new,
                                        color: kBlue,
                                        size: 32,
                                      )),
                                  const Spacer(),
                                  Text('${data.email}', style: kTextStyle,),
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
                              Text('yourKids'.tr(), style: kTextStyle,),
                              SizedBox(
                                  height: 32.0 * data.kidsList.length,
                                  child: FutureBuilder(
                                    future: data.getKid,
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const Center(child: CircularProgressIndicator(),);
                                      }else{
                                        return ListView.builder(
                                            itemCount: data.kidsList.length,
                                            itemBuilder: (context, index){
                                              return data.kidsList[index].name != ''
                                                  ? Padding(
                                                    padding: const EdgeInsets.only(bottom: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(data.kidsList[index].name, style: kTextStyle,),
                                                        Icon(Icons.check,
                                                          color: data.kidsList[index].accept
                                                              ? kGreen : kDarkGrey,),
                                                        GestureDetector(
                                                          onTap: () => data.changeDayDuration(
                                                            context,
                                                            data.kidsList[index].name,
                                                            data.kidsList[index].startDay,
                                                            data.kidsList[index].endDay,
                                                            data.kidsList[index].email),
                                                            child: Text('${data.kidsList[index].startDay} - ${data.kidsList[index].endDay}',
                                                              style: kBigTextStyle,))
                                                      ],
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
                        info: data.settingsParentInfo,
                        onTap: () => data.switchSettingsParentInfo(),
                        text: 'settingsParentInfo',
                        height: 0.2,)),
                ],
              );
            },
          )
      ),
    );
  }
}


