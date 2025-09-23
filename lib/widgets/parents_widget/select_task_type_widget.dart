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
              child: Text('add'),
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
          return GestureDetector(
            onTap: () {},
            child: Container(
                height: size.height * 0.2,
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(bottom: 300),
                decoration: const BoxDecoration(
                  color: kGrey,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Wrap(
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
                    Text(data.selectedTypeStatus, style: kTextStyle,),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close))
                  ],
                )
            ),
          );
        });
  }
}