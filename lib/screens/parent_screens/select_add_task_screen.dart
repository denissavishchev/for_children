import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
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
                    TaskSelectWidget(
                        text: 'multiTask',
                        description: 'multiTaskDescription',
                        route: AddMultiTaskScreen()),
                    TaskSelectWidget(
                        text: 'singleTask',
                        description: 'singleTaskDescription',
                        route: AddSingleTaskScreen()),
                  ],
                )
            );
          }
      )
    );
  }
}

class TaskSelectWidget extends StatelessWidget {
  const TaskSelectWidget({
    super.key,
    required this.text,
    required this.description,
    required this.route,
  });

  final String text;
  final String description;
  final Widget route;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: (){
              data.isEdit = false;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => route));
            },
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.2,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kGrey.withValues(alpha: 0.7),
                      kGrey,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                      width: 3,
                      color: kGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 6)
                    ),
                    BoxShadow(
                      color: kGrey.withValues(alpha: 0.2),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ]
              ),
              child: Column(
                spacing: 12,
                children: [
                  Text(text.tr(),
                    style: kBigTextStyle.copyWith(color: kBlue),),
                  Text(description.tr(),
                      style: kTextStyle.copyWith(color: kBlue,),
                    textAlign: TextAlign.justify,),
                ],
              ),
            ),
          );
        }
    );
  }
}
