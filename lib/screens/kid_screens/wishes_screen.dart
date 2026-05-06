import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/wishes_tiles_list_widget.dart';
import '../../widgets/kids_widgets/kid_round_button.dart';
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
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Column(
                        spacing: 12,
                        children: [
                          Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/images/star.png', width: 24,),
                              Text('yourWishes'.tr(), style: kBigTextStyle.copyWith(fontSize: 44.sp),),
                              const Spacer(),
                              KidRoundButton(
                                icon: Icons.add_circle_outline,
                                onTap: () => Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const AddWishScreen())),),
                            ],
                          ),
                          Text('whyYouNeedDreams'.tr(), style: kTextStyle,),
                          Expanded(child: const WishesTilesListWidget())
                        ],
                      ),
                    ),
                  ),
                  data.isLoading
                      ? Container(
                        width: size.width,
                        height: size.height,
                        color: kGrey.withValues(alpha: 0.5),
                        child: const Center(child: SpinKitSpinningLines(
                          color: kBlue,
                          size: 40,
                        ),),
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


