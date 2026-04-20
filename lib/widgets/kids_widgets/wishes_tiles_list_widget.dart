import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class WishesTilesListWidget extends StatefulWidget {
  const WishesTilesListWidget({
    super.key,
  });

  @override
  State<WishesTilesListWidget> createState() => _WishesTilesListWidgetState();
}

class _WishesTilesListWidgetState extends State<WishesTilesListWidget> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    data.getEmailData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer2<ParentProvider, KidProvider>(
        builder: (context, data, kidData, _){
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('wishes')
                .stream(primaryKey: ['id'])
                .order('time', ascending: false),
            builder: (context, snapshot){
              if(snapshot.hasData){
                final wishes = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 40),
                    itemCount: wishes.length,
                    itemBuilder: (context, index){
                      if(wishes[index]['kidEmail'].toLowerCase() == data.email){
                        return GestureDetector(
                          onTap: () {
                            wishes[index]['imageUrl'] != 'false'
                                ? kidData.showWishDescription(context, wishes[index], index)
                                : null;
                          },
                          child: Container(
                            height: 120,
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.only(right: 6, left: 12),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      kBlue.withValues(alpha: 0.2),
                                      kWhite,
                                    ]
                                ),
                                border: Border.all(width: 1, color: kDarkWhite),
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                      color: kDarkGrey.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                      offset: Offset(4, 4)
                                  )
                                ]
                            ),
                            child: Row(
                              spacing: 12,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(wishes[index]['wish'],
                                              style: kBigTextStyleWhite.copyWith(fontSize: 44.sp),),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      kOrange.withValues(alpha: 0.6),
                                                      kOrange.withValues(alpha: 0.5),
                                                      kOrange.withValues(alpha: 0.4),
                                                    ]
                                                ),
                                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                                border: Border.all(width: 0.5, color: kOrange.withValues(alpha: 0.5)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: kOrange,
                                                    size: 16,
                                                    shadows: [
                                                      Shadow(
                                                        color: kWhite,
                                                        blurRadius: 3,
                                                        offset: const Offset(0.2, 0.2),
                                                      )
                                                    ],
                                                  ),
                                                  Text('dreamItem'.tr(),
                                                    style: kTextStyleWhite.copyWith(fontSize: 18.sp),
                                                    textAlign: TextAlign.center,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(wishes[index]['whyNeed'],
                                          style: kTextStyleWhite.copyWith(fontSize: 18.sp),),
                                      ],
                                    ),
                                  ),
                                ),
                                   wishes[index]['imageUrl'] == 'false'
                                    ? Container(
                                  width: size.width * 0.2,
                                  height: 100,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            kLightBlue.withValues(alpha: 0.2),
                                            kBlue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(width: 0.5, color: kWhite),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kGrey,
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                          offset: const Offset(1, 1),
                                        ),
                                        BoxShadow(
                                          color: kWhite.withValues(alpha: 0.5),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                          offset: const Offset(-2, -2),
                                        ),
                                      ]
                                  ),
                                  child: Icon(Icons.no_photography, color: kDarkBlue, size: 84.sp,),
                                )
                                    : Container(
                                      width: size.width * 0.2,
                                      height: 100,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              kLightBlue.withValues(alpha: 0.2),
                                              kBlue,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        border: Border.all(width: 0.5, color: kWhite),
                                        boxShadow: [
                                          BoxShadow(
                                            color: kGrey,
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(1, 1),
                                          ),
                                          BoxShadow(
                                            color: kWhite.withValues(alpha: 0.5),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(-2, -2),
                                          ),
                                        ]
                                      ),
                                      child: Image.network(wishes[index]['imageUrl'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Image.asset('assets/images/headphones.png'),
                                          );
                                        },),
                                    )
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    });
              }else{
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        });
  }
}