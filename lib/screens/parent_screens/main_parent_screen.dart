import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/history_screen.dart';
import 'package:for_children/widgets/info_widget.dart';
import 'package:provider/provider.dart';
import 'add_multi_task_screen.dart';
import 'add_single_task_screen.dart';
import 'parent_settings_screen.dart';
import '../../widgets/parents_widget/parent_single_task_list_widget.dart';
import '../../widgets/parents_widget/parent_multi_task_list_widget.dart';
import 'package:rxdart/rxdart.dart';

class MainParentScreen extends StatelessWidget {
  const MainParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kGrey,
      body: SafeArea(
        child: Consumer<ParentProvider>(
          builder: (context, data, _){
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Row(
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
                                IconButton(
                                    onPressed: () => Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                        const HistoryScreen())),
                                    icon: const Icon(
                                      Icons.history,
                                      color: kBlue,
                                      size: 32,
                                    )),
                              ],
                            ),
                            SelectTaskButtonWidget()
                          ],
                        ),
                      ),
                      StreamBuilder(
                          stream: CombineLatestStream.list([
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .orderBy('time', descending: true)
                                .snapshots(),
                            FirebaseFirestore.instance
                                .collection('multiTasks')
                                .orderBy('time', descending: true)
                                .snapshots(),
                          ]),
                          builder: (context, snapshot){
                            if (!snapshot.hasData) return CircularProgressIndicator();
                            return SizedBox(
                              height: size.height * 0.8,
                              child: PageView.builder(
                                  controller: data.taskPageController,
                                  itemCount: 2,
                                  itemBuilder: (context, index){
                                    return index == 0
                                      ? ParentSingleTaskListWidget(snapshot: snapshot.data![0])
                                      : ParentMultiTaskListWidget(snapshot: snapshot.data![1]);
                                  }
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                  Positioned(
                    top: 30,
                      left: 150,
                      child: InfoWidget(
                        info: data.mainParentInfo,
                        onTap: () => data.switchParentInfo(),
                        text: 'mainParentInfo',
                        height: 0.2,)),
                ],
              ),
            );
          },
        )
      ),
    );
  }
}

class SelectTaskButtonWidget extends StatelessWidget {
  const SelectTaskButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
      builder: (context, data, _){
        return AnimatedContainer(
          width: data.isSelectButtonOpen ? 180 : 120,
          height: size.height * 0.06,
          decoration: BoxDecoration(
            color: data.isSelectButtonOpen ? kBlue : kGrey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8)),
          ),
          duration: Duration(milliseconds: 300),
          child: Row(
            mainAxisAlignment: data.isSelectButtonOpen
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => data.openSelectButton(),
                child: Icon(
                      data.isSelectButtonOpen ? Icons.close : Icons.add_circle_outline,
                      color: data.isSelectButtonOpen ? kRed : kBlue,
                      size: 32,
                    ),
              ),
              Visibility(
                visible: data.isSelectButtonOpen,
                child: Row(
                  spacing: 20,
                  children: [
                    GestureDetector(
                      onTap: () {
                        data.isSelectButtonOpen = false;
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                            const AddSingleTaskScreen()));
                      },
                      child: Icon(
                        Icons.task_alt_outlined,
                        color: kWhite,
                        size: 32,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        data.isSelectButtonOpen = false;
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const AddMultiTaskScreen()));
                        },
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: kWhite,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}


