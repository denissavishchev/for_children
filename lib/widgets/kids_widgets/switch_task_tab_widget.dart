import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class SwitchTaskTabWidget extends StatelessWidget {
  const SwitchTaskTabWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SwitchTaskButtonWidget(index: 0,),
        SwitchTaskButtonWidget(index: 1,)
      ],
    );
  }
}

class SwitchTaskButtonWidget extends StatelessWidget {
  const SwitchTaskButtonWidget({
    super.key, required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: () => data.switchTaskScreen(index),
            child: Container(
              width: size.width * 0.45,
              height: 40,
              decoration: BoxDecoration(
                  color: data.pageIndex == index ? kBlue.withValues(alpha: 0.7) : kWhite,
                  border: Border.all(color: kBlue, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              child: Center(
                child: Text(index == 0 ? 'oneTime'.tr() : 'fewDays'.tr(),
                  style: data.pageIndex == index ? kBigTextKidStyle : kBigTextStyle,),
              ),
            ),
          );
        }
    );
  }
}