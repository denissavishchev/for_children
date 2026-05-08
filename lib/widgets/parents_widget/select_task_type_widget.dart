import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class SelectTaskTypeWidget extends StatelessWidget {
  const SelectTaskTypeWidget({
    super.key, required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: () => selectType(context, data),
            child: Container(
              width: width,
                padding: const EdgeInsets.fromLTRB(12, 2, 4, 2),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(width: 0.8, color: kBlue),
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                          color: kBlue.withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(0, 2)
                      )
                    ]
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('taskType'.tr(), style: kTextStyle,),
                          Text(data.selectedTypeStatus, style: kBigTextStyle,),
                        ],
                      ),
                      Icon(Icons.arrow_drop_down, color: kBlue)
                    ],
                  ),
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
                    margin: EdgeInsets.fromLTRB(12, 0, 12, size.height * 0.2),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(width: 0.8, color: kBlue),
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                              color: kBlue.withValues(alpha: 0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2)
                          )
                        ]
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
                              onTap: (){
                                setState(() => data.changeTypeStatus(data.taskTypes.keys.elementAt(index)));
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(width: 0.8, color: kBlue),
                                    color: kWhite,
                                    boxShadow: [
                                      BoxShadow(
                                          color: kBlue.withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2)
                                      )
                                    ]
                                ),
                                child: Center(child: Text(data.taskTypes.keys.elementAt(index), style: kTextStyle,)),
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