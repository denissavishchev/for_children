import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/parents_widget/parent_bottom_navigation_bar_widget.dart';
import '../../widgets/parents_widget/parent_switch_task_tab_widget.dart';
import '../../widgets/parents_widget/parent_single_task_list_widget.dart';
import '../../widgets/parents_widget/parent_multi_task_list_widget.dart';
import 'package:rxdart/rxdart.dart';

class MainParentScreen extends StatefulWidget {
  const MainParentScreen({super.key});

  @override
  State<MainParentScreen> createState() => _MainParentScreenState();
}

class _MainParentScreenState extends State<MainParentScreen> {

  @override
  void initState() {
    final kidsData = Provider.of<KidProvider>(context, listen: false);
    final parentsData = Provider.of<ParentProvider>(context, listen: false);
    kidsData.setupKidNotification();
    parentsData.getKids();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kWhite,
      body: SafeArea(
        child: Consumer<ParentProvider>(
          builder: (context, data, _){
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  spacing: 12,
                  children: [
                    ParentsSwitchTaskTabWidget(),
                    Expanded(
                      child: StreamBuilder<List<List<Map<String, dynamic>>>>(
                          stream: CombineLatestStream.list([
                            Supabase.instance.client
                                .from('tasks')
                                .stream(primaryKey: ['id'])
                                .order('time', ascending: false),
                            Supabase.instance.client
                                .from('multiTasks')
                                .stream(primaryKey: ['id'])
                                .order('time', ascending: false),
                          ]),
                          builder: (context, snapshot){
                            if (!snapshot.hasData) {
                              return Center(child: SpinKitSpinningLines(
                              color: kBlue,
                              size: 40,
                            ));
                            }
                            return PageView.builder(
                                controller: data.taskPageController,
                                itemCount: 2,
                                itemBuilder: (context, index){
                                  return index == 0
                                    ? ParentSingleTaskListWidget(snapshot: snapshot.data![0])
                                    : ParentMultiTaskListWidget(snapshot: snapshot.data![1]);
                                }
                            );
                          }
                      ),
                    ),
                  ],
                ),
                ParentBottomNavigationBarWidget()
              ],
            );
          },
        )
      ),
    );
  }
}



