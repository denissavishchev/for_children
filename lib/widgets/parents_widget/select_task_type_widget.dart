import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class SelectTaskTypeWidget extends StatelessWidget {
  const SelectTaskTypeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: () => selectType(context, data),
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: kDarkGrey,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Center(child: Text(data.selectedTypeStatus)),
            ),
          );
        }
    );
  }

  Future<void> selectType(context, ParentProvider data)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState){
                return Container(
                    height: size.height * 0.6,
                    width: size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.fromLTRB(12, 0, 12, size.height * 0.2) ,
                    decoration: const BoxDecoration(
                      color: kGrey,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close, color: kBlue, size: 32,)),
                        ),
                        Column(
                          spacing: 12,
                          children: List.generate(data.taskTypes.length, (index){
                            return GestureDetector(
                              onTap: () => setState(() => data.changeTypeStatus(data.taskTypes.keys.elementAt(index))),
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: kDarkGrey,
                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(
                                        width: 2,
                                        color: data.selectedTypeStatus == data.taskTypes.keys.elementAt(index)
                                            ? kBlue : kDarkGrey)
                                ),
                                child: Center(child: Text(data.taskTypes.keys.elementAt(index))),
                              ),
                            );
                          }),
                        ),
                      ],
                    )
                );
              }
          );
        });
  }
}