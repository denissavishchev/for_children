import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/day_night_widget.dart';
import '../../widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import '../../widgets/kids_widgets/kid_single_task_list_widget.dart';
import '../../widgets/kids_widgets/kids_multitask_list_widget.dart';
import '../../widgets/kids_widgets/switch_task_tab_widget.dart';

class MainKidScreen extends StatefulWidget {
  const MainKidScreen({super.key});

  @override
  State<MainKidScreen> createState() => _MainKidScreenState();
}

class _MainKidScreenState extends State<MainKidScreen> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    final kidsData = Provider.of<KidProvider>(context, listen: false);
    data.getEmail();
    kidsData.initTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kWhite,
      body: Consumer<ParentProvider>(
        builder: (context, parent, _){
          return SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  child: parent.email == ''
                      ? CircularProgressIndicator()
                      : DayNightWidget(email: parent.email ?? '',),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                      boxShadow: [
                        BoxShadow(
                            color: kGrey.withValues(alpha: 0.5),
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: const Offset(0, -3)
                        ),
                      ],
                    ),
                    height: size.height * 0.82 - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
                    child: Column(
                      spacing: 12,
                      children: [
                        SwitchTaskTabWidget(),
                        Expanded(
                          child: StreamBuilder(
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
                                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                                return Consumer<ParentProvider>(
                                    builder: (context, data, _){
                                      return PageView.builder(
                                          controller: parent.taskPageController,
                                          onPageChanged: (index) => parent.switchTaskScreen(index),
                                          itemCount: 2,
                                          itemBuilder: (context, index){
                                            return index == 0
                                                ? KidSingleTaskListWidget(snapshot: snapshot.data![0])
                                                : KidsMultiTaskListWidget(snapshot: snapshot.data![1]);
                                          }
                                      );
                                    }
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                KidBottomNavigationBarWidget()
                // Positioned(
                //     top: 24,
                //     left: 55,
                //     child: KidInfoWidget(
                //       info: data.mainKidInfo,
                //       onTap: () => data.switchMainKidInfo(),
                //       text: 'mainKidInfo',
                //       height: 0.2,)),
              ],
            ),
          );
        },
      ),
    );
  }
}

