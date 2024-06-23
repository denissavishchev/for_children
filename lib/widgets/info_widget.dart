import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key,
    required this.info,
    required this.onTap});

  final bool info;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: info ? 300 : 40,
              height: info ? 300 : 40,
              decoration: BoxDecoration(
                color: kGrey,
                  border: Border.all(width: info ? 1 : 0, color: kBlue.withOpacity(0.1)),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  boxShadow: info ? [
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
                  ] : null
              ),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 50),
                reverseDuration: const Duration(microseconds: 10),
                firstChild: const Center(child: Text('info')),
                secondChild: const Center(child: Icon(Icons.info_outlined, size: 32, color: kBlue,)),
                crossFadeState: info
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond
              ),
              // child: data.isInfo
              //     ? Text('info')
              //     : Center(child: Icon(Icons.info_outlined, size: 32, color: kBlue,)),
            ),
          );
        }
    );
  }
}