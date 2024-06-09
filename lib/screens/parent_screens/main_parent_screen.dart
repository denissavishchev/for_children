import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'parent_settings_screen.dart';
import '../../widgets/parent_tiles_list_widget.dart';

class MainParentScreen extends StatelessWidget {
  const MainParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kGrey,
      body: SafeArea(
        child: Consumer<ParentProvider>(
          builder: (context, data, _){
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
                                const ParentSettingsScreen())),
                          icon: const Icon(
                            Icons.settings,
                            color: kBlue,
                            size: 32,
                          )),
                      const Spacer(),
                      Text('${data.email}', style: kTextStyle,),
                      const Spacer(),
                      IconButton(
                          onPressed: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const AddTaskScreen())),
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: kBlue,
                            size: 32,
                          ))
                    ],
                  ),
                ),
                const ParentTilesListWidget()
              ],
            );
          },
        )
      ),
    );
  }
}


