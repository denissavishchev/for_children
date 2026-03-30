import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/parent_provider.dart';
import '../../screens/kid_screens/kids_description_screen.dart';
import 'kid_single_basic_container_widget.dart';

class KidSingleTaskListWidget extends StatefulWidget {
  const KidSingleTaskListWidget({
    super.key, required this.snapshot,
  });

  final List<Map<String, dynamic>> snapshot;

  @override
  State<KidSingleTaskListWidget> createState() => _KidSingleTaskListWidgetState();
}

class _KidSingleTaskListWidgetState extends State<KidSingleTaskListWidget> {

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
            alignment: Alignment.bottomRight,
            children: [
              ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80, top: 2),
                  itemCount: widget.snapshot.length,
                  itemBuilder: (context, index){
                    final taskData = widget.snapshot[index];
                    if(taskData['kidEmail'].toLowerCase() == data.email){
                      return GestureDetector(
                        onTap: () {
                          data.priceController.text = taskData['price'];
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                                  KidsDescriptionScreen(index: index, snapshot: taskData)));
                        },
                        child: KidSingleBasicContainerWidget(
                          snapshot: taskData,
                          index: index,
                          nameOf: 'parentName',
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