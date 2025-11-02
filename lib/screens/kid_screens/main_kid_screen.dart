import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/day_duration_widget.dart';
import '../../widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import '../../widgets/kids_widgets/kid_single_task_list_widget.dart';
import '../../widgets/kids_widgets/kids_multitask_list_widget.dart';

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
      body: Consumer2<KidProvider, ParentProvider>(
        builder: (context, data, parent, _){
          return Container(
            height: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover
                )
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        parent.email == ''
                            ? CircularProgressIndicator()
                            : DayDurationWidget(
                          email: parent.email ?? '',
                          userStartTime: data.startDayTime,
                          userEndTime: data.endDateTime,),
                        const SizedBox(height: 4,),
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
                              return Consumer<ParentProvider>(
                                  builder: (context, data, _){
                                    return SizedBox(
                                      height: size.height * 0.8,
                                      child: PageView.builder(
                                          controller: parent.taskPageController,
                                          itemCount: 2,
                                          itemBuilder: (context, index){
                                            return index == 0
                                                ? KidSingleTaskListWidget(snapshot: snapshot.data![0])
                                                : KidsMultiTaskListWidget(snapshot: snapshot.data![1]);
                                          }
                                      ),
                                    );
                                  }
                              );
                            }
                        ),
                      ],
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
              ),
            ),
          );
        },
      ),
    );
  }
}



