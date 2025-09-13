import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/kid_screens/add_wish_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/kid_info_widget.dart';
import '../../widgets/kids_widgets/kid_tiles_list_widget.dart';
import 'kids_settings_screen.dart';

class MainKidScreen extends StatelessWidget {
  const MainKidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer2<KidProvider, ParentProvider>(
        builder: (context, data, parent, _){
          return Container(
            height: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover
                )
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          height: size.height * 0.1,
                          child: Row(
                            children: [
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
                              const Spacer(),
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
                        ),
                        const KidTilesListWidget()
                      ],
                    ),
                    Positioned(
                        top: 24,
                        left: 60,
                        child: KidInfoWidget(
                          info: data.mainKidInfo,
                          onTap: () => data.switchMainKidInfo(),
                          text: 'mainKidInfo',
                          height: 0.2,))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
