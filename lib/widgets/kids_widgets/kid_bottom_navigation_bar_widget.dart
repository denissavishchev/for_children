import 'package:flutter/material.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class KidBottomNavigationBarWidget extends StatelessWidget {
  const KidBottomNavigationBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Positioned(
        bottom: 10,
        child: Container(
          width: size.width - 24,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(152)),
            border: Border.all(color: kWhite, width: 1),
            color: kGrey.withValues(alpha: 0.2),
            boxShadow: [
              BoxShadow(
                color: kGrey.withValues(alpha: 0.2),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(0, 3)
              ),
              const BoxShadow(
                color: kDarkWhite,
                spreadRadius: -12.0,
                blurRadius: 20,
              ),
            ]
          ),
          child: Consumer<KidProvider>(
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
        )
    );
  }
}
