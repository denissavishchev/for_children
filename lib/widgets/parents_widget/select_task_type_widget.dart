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
          return Column(
            children: [
              Container(
                color: kDarkGrey,
                width: 196,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(data.taskTypes.length, (index){
                    return Container(
                      width: 40,
                      height: 40,
                      color: kRed,
                    );
                  }),
                ),
              ),
              Text(data.selectedTypeStatus, style: kTextStyle,),
            ],
          );
        }
    );
  }
}