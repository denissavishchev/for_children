import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants.dart';

class WaveButton extends StatelessWidget {
  const WaveButton({
    super.key, required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kDarkWhite.withValues(alpha: 0.8),
              spreadRadius: -12.0,
              blurRadius: 20,
            ),
          ]
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/wave.svg',
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(kBlue, BlendMode.srcIn),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kWhite,
                        kWhite.withValues(alpha: 0.01),
                        kWhite,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topLeft,
                      stops: [0.1, 0.8, 1]
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: kWhite, width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: kGrey.withValues(alpha: 0.5),
                        blurRadius: 3,
                        spreadRadius: 1.5,
                        offset: Offset(-0.5, 2)
                    ),
                  ]
              ),
              child: Center(
                child: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: kBlue.withValues(alpha: 0.7),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}