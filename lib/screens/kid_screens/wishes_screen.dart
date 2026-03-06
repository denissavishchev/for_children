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
      body: SizedBox(
        height: size.height,
        child: SafeArea(
            child: Consumer<KidProvider>(
              builder: (context, data, _){
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 12,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const AddWishScreen())),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: kDarkGrey, width: 2),
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Text('addNewWish'.tr(), style: kTextStyle),
                              ),
                            ),
                            const WishesTilesListWidget()
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 4,
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
      ),
    );
  }
}
