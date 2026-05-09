import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpWidget extends StatelessWidget {
  const ExpWidget({
    super.key,
    required this.count,
    this.isSingle = true,
  });

  final double count;
  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Container(
            width: (isSingle ? 40 : 35) * count,
            height: 50,
            clipBehavior: Clip.hardEdge,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(count.toInt(), ((i){
                return GestureDetector(
                  onTap: () => data.setExp(i + 1),
                  child: SvgPicture.asset('assets/icons/pepper.svg',
                    width: 32,
                    colorFilter: ColorFilter.mode(i < data.selectedExp
                        ? kRed : kGrey, BlendMode.srcIn),
                  ),
                );
              })),
            ),
          );
        });
  }
}