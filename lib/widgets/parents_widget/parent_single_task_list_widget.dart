import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/task_description_screen.dart';
import 'package:provider/provider.dart';
import '../basic_single_container_widget.dart';

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
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              SizedBox(
                  height: size.height * 0.8,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 50),
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
                            child: BasicSingleContainerWidget(
                              snapshot: taskData,
                              index: index,
                              nameOf: 'kidName',
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      })
              ),
            ],
          );
        });
  }
}


