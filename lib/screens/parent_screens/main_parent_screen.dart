import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_task_screen.dart';
import 'package:provider/provider.dart';
import '../settings_screen.dart';
import '../../widgets/tiles_list_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
                                const SettingsScreen())),
                          icon: const Icon(
                            Icons.settings,
                            color: kBlue,
                            size: 32,
                          )),
                      const Spacer(),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () => data.kidsFilter('leonard'),
                              child: const Text('Leonard')
                          ),
                          TextButton(
                              onPressed: ()=> data.kidsFilter('daniel'),
                              child: const Text('Daniel')
                          ),
                          TextButton(
                              onPressed: ()=> data.kidsFilter(''),
                              child: const Text('All')
                          ),
                        ],
                      ),
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
                const TilesListWidget()
              ],
            );
          },
        )
      ),
    );
  }
}


