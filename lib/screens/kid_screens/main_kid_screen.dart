import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kid_tiles_list_widget.dart';
import 'kids_settings_screen.dart';

class MainKidScreen extends StatelessWidget {
  const MainKidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer2<KidProvider, ParentProvider>(
            builder: (context, data, parent, _){
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    height: size.height * 0.1,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () =>
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                    const KidsSettingsScreen())),
                            icon: const Icon(
                              Icons.settings,
                              color: kBlue,
                              size: 32,
                            )),
                        const Spacer(),
                        Text('${parent.email}', style: kTextStyle,),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
              // Navigator.pushReplacement(context,
              //                   MaterialPageRoute(builder: (context) =>
              //                   const AddTaskScreen())),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: kBlue,
                              size: 32,
                            ))
                      ],
                    ),
                  ),
                  const KidTilesListWidget()
                ],
              );
            },
          )
      ),
    );
  }
}
