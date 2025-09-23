import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpWidget extends StatelessWidget {
  const ExpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          // data.setExp(index)
          return Container(
            width: 140,
            height: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: kDarkGrey
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, ((i){
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