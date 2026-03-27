import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/kid_info_widget.dart';
import '../../widgets/kids_widgets/wishes_tiles_list_widget.dart';
import 'add_wish_screen.dart';

class WishesScreen extends StatelessWidget {
  const WishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
          child: Consumer<KidProvider>(
            builder: (context, data, _){
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: size.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        spacing: 12,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const AddWishScreen())),
                            child: Container(
                              height: 40,
                              width: size.width * 0.5,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      kDarkBlue,
                                      kPurple
                                    ]
                                ),
                                border: Border.all(color: kWhite.withValues(alpha: 0.5), width: 2),
                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                boxShadow: [
                                  BoxShadow(
                                    color: kPurple.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(-1, -3),
                                  ),
                                  BoxShadow(
                                    color: kBlue.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(1, 3),
                                  )
                                ]
                              ),
                              child: Row(
                                spacing: 4,
                                children: [
                                  Icon(Icons.add, color: kWhite),
                                  Text('addNewWish'.tr(), style: kTextStyleWhite),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: const WishesTilesListWidget())
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 8,
                      right: 20,
                      child: KidInfoWidget(
                        info: data.wishInfo,
                        onTap: () => data.switchWishInfo(),
                        text: 'wishInfo',
                        height: 0.2,)),
                  data.isLoading
                      ? Container(
                    width: size.width,
                    height: size.height,
                    color: kGrey.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator(color: kBlue,),),
                  ) : const SizedBox.shrink(),
                  KidBottomNavigationBarWidget()
                ],
              );
            },
          )
      ),
    );
  }
}
