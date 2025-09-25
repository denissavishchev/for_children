import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpWidget extends StatelessWidget {
  const ExpWidget({super.key, required this.count});

  final double count;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Container(
            width: 40 * count,
            height: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: kDarkGrey
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