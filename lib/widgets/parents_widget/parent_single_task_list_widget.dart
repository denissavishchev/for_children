import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/task_description_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'parent_single_basic_container_widget.dart';

class ParentSingleTaskListWidget extends StatefulWidget {
  const ParentSingleTaskListWidget({
    super.key, required this.snapshot,
  });

  final List<Map<String, dynamic>> snapshot;

  @override
  State<ParentSingleTaskListWidget> createState() => _ParentSingleTaskListWidgetState();
}

class _ParentSingleTaskListWidgetState extends State<ParentSingleTaskListWidget> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    data.getEmailData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          if (widget.snapshot.isEmpty) {
            return Center(
              child: SizedBox(
                width: 200,
                child: Column(
                  spacing: 12,
                  children: [
                    Text('noTasksParent'.tr(),
                      style: kBigTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Image.asset('assets/images/emptyList.png', width: 140,)
                  ],
                ),
              ),
            );
          }
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: widget.snapshot.length,
                  itemBuilder: (context, index){
                    final taskData = widget.snapshot[index];
                    return GestureDetector(
                      onTap: () {
                        data.priceController.text = taskData['price'];
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                                TaskDescriptionScreen(index: index, snapshot: taskData)));
                      },
                      child: ParentSingleBasicContainerWidget(
                        snapshot: taskData,
                        index: index,
                        nameOf: 'kidName',
                      ),
                    );
                  }),
            ],
          );
        });
  }
}