import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class KidStatusWidget extends StatelessWidget {
  const KidStatusWidget({
    super.key,
    required this.snapshot,
  });

  final Map<String, dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('${snapshot['status']}'.tr(),
          style: snapshot['status'] == 'price' &&
              snapshot['priceStatus'] == 'changed'
              ? kTextStyleOrange
              : kBigTextStyle.copyWith(fontSize: 26.sp)),
        snapshot['status'] == 'price'
                ? Image.asset('assets/images/negotiation.png', width: 48,)
                : snapshot['status'] == 'inProgress'
                ? Image.asset('assets/images/progress.png', width: 48,)
                : Image.asset('assets/images/done.png', width: 42,),
        snapshot['status'] == 'price'
              ? snapshot['priceStatus'] == 'set'
              ? Text('parentProposition'.tr(args: [snapshot['parentName']]), style: kTextStyleOrange)
              : Text('youOffer'.tr(), style: kTextStyle)
              : SizedBox.shrink()
      ],
    );
  }
}