import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/add_task_screen.dart';
import 'package:for_children/screens/settings_screen.dart';

import '../widgets/basic_container_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * 0.1,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const SettingsScreen())),
                      icon: const Icon(
                        Icons.settings,
                        color: kPurple,
                        size: 32,
                      )),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const AddTaskScreen())),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: kPurple,
                        size: 32,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.8,
              child: ListView.builder(
                itemCount: 20,
                  itemBuilder: (context, index){
                    return BasicContainerWidget(
                      child: Text('Neo Capsule', style: kTextStyle,),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

