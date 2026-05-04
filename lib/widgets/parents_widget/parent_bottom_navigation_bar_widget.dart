import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class ParentBottomNavigationBarWidget extends StatelessWidget {
  const ParentBottomNavigationBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Positioned(
        bottom: 10,
        child: SizedBox(
          width: size.width - 24,
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(width: 0.6, color: kBlue.withValues(alpha: 0.7)),
                        borderRadius: const BorderRadius.all(Radius.circular(152)),
                        boxShadow: [
                          BoxShadow(
                              color: kDarkGrey.withValues(alpha: 0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 6)
                          ),
                          BoxShadow(
                            color: kBlue.withValues(alpha: 0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ]
                    ),
                    child: Consumer<ParentProvider>(
                        builder: (context, data, _){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(data.routes.length, ((i){
                              return GestureDetector(
                                onTap: () {
                                  data.selectedRoute = data.routes.keys.elementAt(i);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                          data.routes.values.elementAt(i)));
                                },
                                child: Icon(
                                  data.routes.keys.elementAt(i),
                                  color: data.selectedRoute == data.routes.keys.elementAt(i)
                                      ? kOrange.withValues(alpha: 0.8)
                                      : kDarkGrey.withValues(alpha: 0.5),
                                  size: 32,),
                              );
                            })),
                          );
                        }
                    )
                ),
              ),
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                    color: kWhite,
                    border: Border.all(width: 0.6, color: kBlue.withValues(alpha: 0.7)),
                    borderRadius: const BorderRadius.all(Radius.circular(152)),
                    boxShadow: [
                      BoxShadow(
                          color: kDarkGrey.withValues(alpha: 0.2),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(0, 6)
                      ),
                      BoxShadow(
                        color: kBlue.withValues(alpha: 0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                ),
                child: Consumer<ParentProvider>(
                    builder: (context, data, _){
                      return GestureDetector(
                        onTap: () => data.showSelectAddedTaskDialog(context),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: kBlue.withValues(alpha: 0.8),
                          size: 32,),
                      );
                    }
                ),
              )
            ],
          ),
        )
    );
  }
}
