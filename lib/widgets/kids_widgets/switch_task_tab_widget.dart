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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SwitchTaskButtonWidget(index: 0,),
          SwitchTaskButtonWidget(index: 1,)
        ],
      ),
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
          final bool isIndex = data.pageIndex == index;
          return GestureDetector(
            onTap: () => data.switchTaskScreen(index),
            child: Container(
              width: size.width * 0.45,
              height: 40,
              decoration: BoxDecoration(
                  gradient: isIndex
                  ? LinearGradient(
                      colors: [
                        kWhite,
                        kWhite.withValues(alpha: 0.01),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      stops: [0.1, 1]
                  )
                  : LinearGradient(
                      colors: [
                          kWhite,
                          kLightGrey.withValues(alpha: 0.4),
                          kGrey.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                    ),
                  border: Border.all(color: isIndex ? kWhite : kDarkWhite.withValues(alpha: 0.6), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(size.width * 0.45,)),
                  boxShadow: [
                    BoxShadow(
                      color: kGrey.withValues(alpha: !isIndex ? 0.5 : 0.3),
                      blurRadius: 5,
                      spreadRadius: 1.5,
                      offset: Offset(0, 2)
                    ),
                  ]
              ),
              child: Center(
                child: Text(index == 0 ? 'oneTime'.tr() : 'fewDays'.tr(),
                  style: isIndex ? kBigTextKidStyle : kBigTextStyle,),
              ),
            ),
          );
        }
    );
  }
}