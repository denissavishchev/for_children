import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/screens/login_screens/pre_screen.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../widgets/info_widget.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kGrey,
      body: SafeArea(
        child: Consumer<LoginProvider>(
          builder: (context, data, _){
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: size.height * 0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => data.selectRole('parent'),
                          child: Container(
                            width: size.width * 0.45,
                            height: size.height * 0.64,
                            margin: const EdgeInsets.fromLTRB(12, 0, 6, 0),
                            decoration: BoxDecoration(
                                color: kBlue.withValues(alpha: data.role == 'parent' ? 0.8 : 0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Image.asset('assets/images/selectParents.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => data.selectRole('child'),
                          child: Container(
                            width: size.width * 0.45,
                            height: size.height * 0.64,
                            margin: const EdgeInsets.fromLTRB(6, 0, 12, 0),
                            decoration: BoxDecoration(
                                color: kBlue.withValues(alpha: data.role == 'child' ? 0.8 : 0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Image.asset('assets/images/selectKids.png'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    SingleChildScrollView(
                      child: Container(
                        width: size.width,
                        margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: kBlue.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text('selectDescription'.tr(),
                            style: kTextStyle,
                            textAlign: TextAlign.justify),
                      ),
                    ),
                    const Spacer(),
                    ButtonWidget(
                        onTap: () {
                          if(data.role != ''){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>
                                const PreScreen()));
                          }
                        },
                        text: data.role == 'parent'
                            ? 'ImTheParent'
                            : data.role == 'child'
                            ? 'ImTheKid'
                            : 'selectYourRole'),
                    const SizedBox(height: 40,),
                  ],
                ),
                Visibility(
                  visible: data.role == 'parent',
                  child: Positioned(
                      top: 24,
                      left: 20,
                      child: InfoWidget(
                        info: data.selectLeftInfo,
                        onTap: () => data.switchSelectLeftInfo(),
                        text: 'selectInfoParent',
                        height: 0.4,)),
                ),
                Visibility(
                  visible: data.role == 'child',
                  child: Positioned(
                      top: 24,
                      right: 20,
                      child: InfoWidget(
                        info: data.selectRightInfo,
                        onTap: () => data.switchSelectRightInfo(),
                        text: 'selectInfoKid',
                        height: 0.4,)),
                ),
              ],
            );
          },
        )
      ),
    );
  }
}
