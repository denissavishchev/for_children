import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../screens/parent_screens/task_description_screen.dart';
import '../basic_multi_container_widget.dart';

class ParentMultiTaskListWidget extends StatefulWidget {
  const ParentMultiTaskListWidget({
    super.key, required this.snapshot,
  });

  final List<Map<String, dynamic>> snapshot;

  @override
  State<ParentMultiTaskListWidget> createState() => _ParentMultiTaskListWidgetState();
}

class _ParentMultiTaskListWidgetState extends State<ParentMultiTaskListWidget> {

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
          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  itemCount: widget.snapshot.length,
                  itemBuilder: (context, index){
                    final taskData = widget.snapshot[index];
                    if(taskData['parentEmail'].toLowerCase() == data.email){
                      return GestureDetector(
                        onTap: () {
                          data.priceController.text = taskData['price'];
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                                  TaskDescriptionScreen(index: index, snapshot: taskData)));
                        },
                        child: BasicMultiContainerWidget(
                          snapshot: taskData,
                          index: index,
                          nameOf: 'kidName',
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
            ],
          );
        });
  }
}