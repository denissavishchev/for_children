import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import 'add_multi_task_screen.dart';
import 'add_single_task_screen.dart';
import 'main_parent_screen.dart';

class SelectAddTaskScreen extends StatelessWidget {
  const SelectAddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: Consumer<ParentProvider>(
          builder: (context, data, _){
            return SafeArea(
                child: Column(
                  spacing: 18,
                  children: [
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
                      ],
                    ),
                    ButtonWidget(
                        onTap: (){
                          data.isEdit = false;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const AddMultiTaskScreen()));
                        },
                        text: 'multitask'
                    ),
                    ButtonWidget(
                        onTap: (){
                          data.isEdit = false;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const AddSingleTaskScreen()));
                        },
                        text: 'single task'
                    ),
                  ],
                )
            );
          }
      )
    );
  }
}
