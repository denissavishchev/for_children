import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_single_task_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:for_children/widgets/round_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../constants.dart';
import 'main_kid_screen.dart';

class KidsDescriptionScreen extends StatelessWidget {
  const KidsDescriptionScreen({super.key,
    required this.index,
    required this.snapshot
  });

  final int index;
  final Map<String, dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: true,
      body: Consumer<ParentProvider>(
          builder: (context, data, _){
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        kBlue.withValues(alpha: 0.4),
                                        kWhite.withValues(alpha: 0.7),
                                      ]
                                  ),
                                  border: Border.all(color: kWhite, width: 0.5),
                                  borderRadius: const BorderRadius.all(Radius.circular(8)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kBlue.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                        offset: const Offset(2, 4)
                                    )
                                  ]
                              ),
                              child: Row(
                                spacing: 4,
                                children: [
                                  Image.asset('assets/images/person.png', width: 12,),
                                  Text(snapshot[data.role == 'parent'
                                      ? 'kidName' : 'parentName'],
                                    style: kBigTextStyleWhite,)
                                ],
                              ),
                            ),
                          ),
                          RoundButton(
                            icon: Icons.close,
                            onTap: () {
                              data.pageIndex = 0;
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                  data.role == 'parent'
                                      ? const MainParentScreen()
                                      : const MainKidScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              kBlue.withValues(alpha: 0.7),
                              kBlue.withValues(alpha: 0.7),
                              kWhite.withValues(alpha: 0.7),
                          ]
                        ),
                        border: Border.all(color: kWhite, width: 0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18)
                        ),
                          boxShadow: [
                            BoxShadow(
                                color: kBlue.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(2, 2)
                            )
                          ]
                      ),
                      child: Row(
                        spacing: 4,
                        children: [
                          Image.asset('assets/images/todo.png', width: 18,),
                          Expanded(
                            child: Text(
                              snapshot['taskName'],
                              style: kBigTextStyleWhite,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                color: kDarkWhite.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                boxShadow: [
                                  BoxShadow(
                                      color: kBlue.withValues(alpha: 0.2),
                                      blurRadius: 1,
                                      spreadRadius: 0.5,
                                      offset: Offset(0.5, 0.5)
                                  )
                                ]
                            ),
                            child: Text((snapshot['type']),
                              style: kTextStyle,),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                kBlue.withValues(alpha: 0.7),
                                kBlue.withValues(alpha: 0.7),
                                kWhite.withValues(alpha: 0.7),
                              ]
                          ),
                        border: Border.all(color: kWhite, width: 0.5),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(18)
                        ),
                          boxShadow: [
                            BoxShadow(
                                color: kDarkGrey.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(2, 6)
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/medal.png', width: 18,),
                              const SizedBox(width: 4),
                              Text(snapshot['price'], style: kBigTextStyleWhite,),
                              const SizedBox(width: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(3, ((i){
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: (2 - i) < (snapshot.containsKey('expQty')
                                                  ? int.parse(snapshot['expQty'])
                                                  : 1)
                                                  ? kWhite.withValues(alpha: 0.2) : Colors.transparent,
                                              blurRadius: 2,
                                              spreadRadius: 2
                                          )
                                        ]
                                    ),
                                    child: SvgPicture.asset('assets/icons/pepper.svg',
                                      width: 16,
                                      colorFilter: ColorFilter.mode((2 - i) < int.parse(snapshot['expQty'])
                                          ? kRed : Colors.transparent, BlendMode.srcIn),
                                    ),
                                  );
                                })),
                              ),
                            ],
                          ),
                          snapshot.containsKey('deadline')
                              ? Row(
                                  children: [
                                    const Spacer(),
                                    snapshot['deadline'] != 'false'
                                        ? Image.asset('assets/images/deadline.png', width: 16,)
                                        : SizedBox.shrink(),
                                    Text(snapshot['deadline'] == 'false'
                                        ? 'withoutDeadline'.tr()
                                        : snapshot['deadline'] != null
                                        ? DateFormat('dd-MM-yyyy').format(
                                        DateTime.parse(snapshot['deadline']))
                                        : snapshot['deadline'],
                                      style: kTextStyle,),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 250,
                            padding: const EdgeInsets.all(8),
                            margin: EdgeInsets.fromLTRB(12, 12,
                                snapshot['imageUrl'] == 'false' ? 12 : 3, 0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      kBlue.withValues(alpha: 0.9),
                                      kWhite.withValues(alpha: 0.7)
                                    ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0.1, 0.9]
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                border: Border.all(color: kWhite, width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                      color: kDarkGrey.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                      offset: const Offset(2, 6)
                                  )
                                ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 4,
                                  children: [
                                    Image.asset('assets/images/bulb.png', width: 16,),
                                    Text('details'.tr(), style: kTextStyleWhite),
                                  ],
                                ),
                                const Divider(color: kDarkWhite,),
                                Text(snapshot['description'], style: kTextStyleWhite),
                              ],
                            ),
                          ),
                        ),
                        snapshot['imageUrl'] == 'false'
                            ? const SizedBox.shrink()
                            : Expanded(
                          child: Container(
                            height: 250,
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.fromLTRB(3, 12, 12, 0),
                            decoration: BoxDecoration(
                              color: kOrange.withValues(alpha: 0.7),
                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                                boxShadow: [
                                  BoxShadow(
                                      color: kDarkGrey.withValues(alpha: 0.6),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                      offset: const Offset(2, 6)
                                  )
                                ]
                            ),
                            child: Image.network(snapshot['imageUrl'], fit: BoxFit.cover),
                          ),)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      width: size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: kWhite,
                          border: Border.all(color: kBlue, width: 0.5),
                          borderRadius: const BorderRadius.all(Radius.circular(18)
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: kBlue.withValues(alpha: 0.1),
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(-2, -2)
                            ),
                            BoxShadow(
                                color: kGrey.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(4, 4)
                            )
                          ]
                      ),
                      child: snapshot['status'] == 'price'
                          ? _buildPrice(snapshot, data, context, size)
                          : snapshot['status'] == 'inProgress'
                          ? _buildInProgress(snapshot, data, context, size)
                          : snapshot['status'] == 'done'
                          ? _buildDone(snapshot, data, context, size)
                          : snapshot['status'] == 'checked'
                          ? _buildChecked(snapshot, data, context, size)
                          : _buildComplete(snapshot),
                    ),
                    const SizedBox(height: 20,),
                    data.role == 'parent' && snapshot['status'] == 'paid'
                        ? IconButton(
                        onPressed: () => data.addTaskToHistory(context, snapshot, index,
                          snapshot['parentName'],
                          snapshot['parentEmail'],
                          snapshot['kidName'],
                          snapshot['kidEmail'],
                          snapshot['taskName'],
                          snapshot['description'],
                          snapshot['price'],
                          snapshot['stars'],
                          snapshot['imageUrl'],
                          snapshot['type'],
                          snapshot['expQty'],
                        ),
                        icon: const Icon(Icons.history, size: 32, color: kOrange,))
                        : data.role == 'parent'
                        && snapshot['status'] == 'price'
                        && snapshot['priceStatus'] == 'set'
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Expanded(child: Text('editTaskDescription'.tr(), style: kTextStyleWhite,)),
                          IconButton(
                              onPressed: () {
                                data.searchSingleTaskForEditing(snapshot['id'].toString());
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                    const AddSingleTaskScreen()));
                              },
                              icon: const Icon(Icons.edit, size: 32, color: kBlue,))
                        ],
                      ),
                    )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            );
          }),
    );
  }

  _buildComplete(Map<String, dynamic> snapshot){
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 8,),
          Text('completeStatusDescription'.tr(), style: kTextStyle,),
          Center(
            child: RatingBar(
              initialRating: double.parse(snapshot['stars']),
              ignoreGestures: true,
              allowHalfRating: false,
              itemCount: 3,
              itemSize: 60,
              ratingWidget: RatingWidget(
                full: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [kDarkWhite, kBlue],
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Icon(Icons.star,
                        shadows: [
                          BoxShadow(
                              color: kBlue,
                              blurRadius: 9,
                              spreadRadius: 6,
                              offset: Offset(0.5, 0.5)
                          )
                        ]),
                  ),
                empty: const Icon(Icons.star_border,
                    color: kGrey,
                    shadows: [
                      BoxShadow(
                          color: kBlue,
                          blurRadius: 9,
                          spreadRadius: 6,
                          offset: Offset(0.5, 0.5)
                      )
                    ]), half: const SizedBox.shrink(),
              ),
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (r){},
            ),
          ),
          const SizedBox(height: 8,),
          snapshot['status'] == 'paid'
            ? SizedBox.shrink()
            : Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: kRed),
                  borderRadius: const BorderRadius.all(Radius.circular(12))
              ),
              child: Center(child: Text('paid'.tr(), style: kRedTextStyle,)),
          )
        ],
      ),
    );
  }

  _buildChecked(Map<String, dynamic> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: data.role == 'child'
          ? Column(
              spacing: 12,
              children: [
                int.parse(snapshot['stars']) == 3
                  ? Text('goodResult'.tr(), style: kTextStyle)
                  : int.parse(snapshot['stars']) == 2
                  ? Text('meddleResult'.tr(), style: kTextStyle)
                  : Text('weakResult'.tr(), style: kTextStyle),
                Center(
                  child: RatingBar(
                    initialRating: double.parse(snapshot['stars']),
                    ignoreGestures: true,
                    allowHalfRating: false,
                    itemCount: 3,
                    itemSize: 60,
                    ratingWidget: RatingWidget(
                      full: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [kDarkWhite, kBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Icon(Icons.star,
                            shadows: const [
                              BoxShadow(
                                  color: kRed,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  offset: Offset(0.5, 0.5)
                              ),
                              BoxShadow(
                                  color: kDarkBlue,
                                  blurRadius: 9,
                                  spreadRadius: 6,
                                  offset: Offset(1, 1)
                              ),

                            ]),
                      ),
                      empty: Icon(Icons.star_border,
                          color: kOrange.withValues(alpha: 0.9),
                          shadows: const [
                            BoxShadow(
                                color: kRed,
                                blurRadius: 4,
                                spreadRadius: 2,
                                offset: Offset(0.5, 0.5)
                            ),
                            BoxShadow(
                                color: kDarkBlue,
                                blurRadius: 9,
                                spreadRadius: 6,
                                offset: Offset(1, 1)
                            )
                          ]), half: const SizedBox.shrink(),
                    ),
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (r){},
                  ),
                ),
                Text('ifPaid'.tr(), style: kTextStyle,),
                ChangeButtonWidget(
                  index: index,
                  snapshot: snapshot,
                  onTap: () => data.changeToPaid(snapshot, index, context, data.pageIndex == 0),
                  text: 'paid',
                ),
                const SizedBox(height: 2,),
              ],
            )
          : _buildComplete(snapshot),
    );
  }

  _buildDone(Map<String, dynamic> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: data.role == 'parent'
          ? Column(
        children: [
          Text('checkCompletedWork'.tr(), style: kTextStyle,),
          const SizedBox(height: 8,),
          Center(
            child: RatingBar(
              initialRating: 0,
              allowHalfRating: false,
              itemCount: 3,
              itemSize: 60,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star,
                    color: kGrey,
                    shadows: [
                      BoxShadow(
                          color: kBlue,
                          blurRadius: 9,
                          spreadRadius: 6,
                          offset: Offset(0.5, 0.5)
                      )
                    ]),
                empty: const Icon(Icons.star_border,
                    color: kGrey,
                    shadows: [
                      BoxShadow(
                          color: kBlue,
                          blurRadius: 9,
                          spreadRadius: 6,
                          offset: Offset(0.5, 0.5)
                      )
                    ]), half: const SizedBox.shrink(),
              ),
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (rating) => data.updateRating(rating),
            ),
          ),
          const SizedBox(height: 8,),
          Text('notForgotToPay'.tr(), style: kTextStyle,),
          const SizedBox(height: 8,),
          ChangeButtonWidget(
            index: index,
            snapshot: snapshot,
            onTap: () => data.changeToChecked(snapshot, index, context, data.pageIndex == 0),
            text: 'rate',
          )
        ],
      )
          : Text('waitingForPay'.tr(args: [snapshot[
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      ]]), style: kTextStyle,),
    );
  }

  _buildInProgress(Map<String, dynamic> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: data.role == 'child'
          ? snapshot.containsKey('daysNumber')
          ? Column(
              children: [
                Text('daysLeft'.tr(args: [(snapshot['daysNumber'].length - data.whatDayIs(snapshot['time']) - 1).toString()]),
                  style: kTextStyle,),
              ],
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text('inProgressStatusDescription'.tr(), style: kTextStyle,),
              const SizedBox(height: 2,),
              ChangeButtonWidget(
                  index: index,
                  snapshot: snapshot,
                  onTap: () => data.changeToDone(snapshot, index, context, data.pageIndex == 0, true),
                  text: 'imDoneStatus',
                ),
              const SizedBox(height: 2,),
            ],
          )
          : Text('waitingForDone'.tr(args: [snapshot[
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      ]]), style: kTextStyle,),
    );
  }

  _buildPrice(Map<String, dynamic> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: (snapshot['priceStatus'] == 'set' && data.role == 'child') ||
          (snapshot['priceStatus'] == 'changed' && data.role == 'parent')
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text('priceStatusDescription'.tr(), style: kTextStyle,),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: TextField(
                      controller: data.priceController,
                      cursorColor: kDarkGrey,
                      style: kTextStyle,
                      decoration: textFieldDecoration.copyWith(
                          label: Text('price'.tr(), style: kTextStyle,),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                      data.changePriceStatus(context, snapshot, index, data.role, data.pageIndex == 0),
                      child: const Icon(Icons.autorenew, color: kOrange,))
                ],
              ),
              const SizedBox(height: 2,),
              ChangeButtonWidget(
                index: index,
                snapshot: snapshot,
                onTap: () => data.changeToInProgress(snapshot, index, context, data.pageIndex == 0),
                text: 'acceptPriceChangeStatus',),
              const SizedBox(height: 2,),
            ],
          )
          : Text('waitingForPrice'.tr(args: [snapshot[
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      ]]), style: kTextStyle,),
    );
  }
}

class ChangeButtonWidget extends StatelessWidget {
  const ChangeButtonWidget({
    super.key,
    required this.index,
    required this.snapshot,
    required this.onTap,
    required this.text,
  });

  final int index;
  final Map<String, dynamic> snapshot;
  final Function() onTap;
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
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(width: 1, color: kBlue.withValues(alpha: 0.8)),
                  gradient: LinearGradient(
                      colors: [
                        kBlue.withValues(alpha: 0.4),
                        kBlue.withValues(alpha: 0.6)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: const Offset(0, 1)
                    ),
                    BoxShadow(
                      color: kGrey.withValues(alpha: 0.2),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ]
              ),
              child: Center(
                child: Text(text.tr(),
                  style: kTextStyleWhite,
                  textAlign: TextAlign.center,),
              ),
            ),
          );
        });
  }
}
