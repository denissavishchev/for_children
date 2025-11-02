import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../screens/kid_screens/add_wish_screen.dart';
import '../../screens/kid_screens/kids_settings_screen.dart';
import '../../screens/kid_screens/main_kid_screen.dart';
import '../../screens/kid_screens/save_money_screen.dart';

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
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: kWhite.withValues(alpha: 0.6)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () =>
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const MainKidScreen())),
                  icon: const Icon(
                    Icons.home,
                    color: kOrange,
                    size: 32,
                  )),
              IconButton(
                  onPressed: () =>
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const SaveMoneyScreen())),
                  icon: const Icon(
                    Icons.monetization_on_sharp,
                    color: kOrange,
                    size: 32,
                  )),
              IconButton(
                  onPressed: () =>
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const KidsSettingsScreen())),
                  icon: const Icon(
                    Icons.settings,
                    color: kOrange,
                    size: 32,
                  )),
              IconButton(
                  onPressed: () =>
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const AddWishScreen())),
                  icon: const Icon(
                    Icons.favorite,
                    color: kOrange,
                    size: 32,
                  ))
            ],
          ),
        )
    );
  }
}