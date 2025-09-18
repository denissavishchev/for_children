import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class ExpScrollWidget extends StatelessWidget {
  const ExpScrollWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Container(
            width: 70,
            height: 70,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: kDarkGrey
            ),
            child: ListWheelScrollView(
              controller: FixedExtentScrollController(
                  initialItem: int.parse(data.expQty)
              ),
              onSelectedItemChanged: (index) {
                data.setExp(index);
              },
              physics: const FixedExtentScrollPhysics(),
              itemExtent: 50,
              children: List.generate(5, (index){
                return Container(
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: kWhite
                    ),
                    child: Center(
                        child: Text('${index + 1}',
                          style: kTextStyle))
                );
              } ),
            ),
          );
        });
  }
}