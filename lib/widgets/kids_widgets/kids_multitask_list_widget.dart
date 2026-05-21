import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../screens/kid_screens/kids_description_screen.dart';
import 'kids_multi_basic_container_widget.dart';

class KidsMultiTaskListWidget extends StatelessWidget {
  const KidsMultiTaskListWidget({
    super.key, required this.snapshot,
  });

  final List<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return snapshot.isEmpty
              ? Center(
                child: SizedBox(
                  width: 200,
                  child: Column(
                    spacing: 12,
                    children: [
                      Text('noTasksKids'.tr(),
                        style: kBigTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Image.asset('assets/images/emptyList.png', width: 140,)
                    ],
                  ),
                ),
              )
          : Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80, top: 2),
                  itemCount: snapshot.length,
                  itemBuilder: (context, index){
                    final taskData = snapshot[index];
                    return GestureDetector(
                      onTap: () {
                        data.priceController.text = taskData['price'];
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                                KidsDescriptionScreen(index: index, snapshot: taskData)));
                      },
                      child: KidsMultiBasicContainerWidget(
                        snapshot: taskData,
                        index: index,
                        nameOf: 'parentName',
                      ),
                    );
                  }),
            ],
          );
        });
  }
}