import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key, required this.onTap, required this.text,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: onTap,
            child: Container(
              width: size.width,
              height: size.height * 0.06,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(width: 1, color: kBlue.withOpacity(0.8)),
                  gradient: LinearGradient(
                      colors: [
                        kBlue.withOpacity(0.4),
                        kBlue.withOpacity(0.6)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 6)
                    ),
                    BoxShadow(
                      color: kGrey.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ]
              ),
              child: Center(child: Text(text.tr(), style: kBigTextStyleGrey,)),
            ),
          );
        }
    );
  }
}