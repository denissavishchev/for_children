import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/kid_screens/add_wish_screen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/kid_info_widget.dart';
import '../../widgets/kids_widgets/kid_single_task_list_widget.dart';
import '../../widgets/kids_widgets/kids_multitask_list_widget.dart';
import 'kids_settings_screen.dart';

class MainKidScreen extends StatelessWidget {
  const MainKidScreen({super.key});

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
                                          const KidsSettingsScreen())),
                                  icon: const Icon(
                                    Icons.settings,
                                    color: kOrange,
                                    size: 32,
                                  )),
                              const Spacer(),
                              IconButton(
                                  onPressed: () =>
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) =>
                                          const AddWishScreen())),
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: kOrange,
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
                        ),
                        // const KidSingleTaskListWidget()
                      ],
                    ),
                    Positioned(
                        top: 24,
                        left: 60,
                        child: KidInfoWidget(
                          info: data.mainKidInfo,
                          onTap: () => data.switchMainKidInfo(),
                          text: 'mainKidInfo',
                          height: 0.2,)),
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
