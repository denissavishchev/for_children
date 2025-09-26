import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/history_screen.dart';
import 'package:for_children/screens/parent_screens/select_add_task_screen.dart';
import 'package:for_children/widgets/info_widget.dart';
import 'package:provider/provider.dart';
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
                            IconButton(
                                onPressed: () => Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                    const HistoryScreen())),
                                icon: const Icon(
                                  Icons.history,
                                  color: kBlue,
                                  size: 32,
                                )),
                            IconButton(
                                onPressed: () =>
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                      const SelectAddTaskScreen())),
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: kBlue,
                                  size: 32,
                                ))
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
                    top: 24,
                      left: 60,
                      child: InfoWidget(
                        info: data.mainParentInfo,
                        onTap: () => data.switchParentInfo(),
                        text: 'mainParentInfo',
                        height: 0.2,)),
                  Positioned(
                    bottom: 10,
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: kGrey,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => data.switchTaskScreen(0),
                              child: Text('Single task'),
                            ),
                            ElevatedButton(
                              onPressed: () => data.switchTaskScreen(1),
                              child: Text('Multitask'),
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            );
          },
        )
      ),
    );
  }
}


