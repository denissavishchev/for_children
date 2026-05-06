import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_single_task_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../widgets/parents_widget/parent_round_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'add_multi_task_screen.dart';

class TaskDescriptionScreen extends StatelessWidget {
  const TaskDescriptionScreen({super.key,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    spacing: 12,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  border: Border.all(color: kBlue, width: 0.5),
                                  borderRadius: const BorderRadius.all(Radius.circular(8)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kBlue.withValues(alpha: 0.2),
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
                                  Text(snapshot['kidName'],
                                    style: kBigTextStyle,),
                                ],
                              ),
                            ),
                          ),
                          ParentRoundButton(
                            icon: Icons.close,
                            onTap: () {
                              data.pageIndex = 0;
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                  const MainParentScreen()));
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 120,
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 66,
                                width: size.width,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  border: Border.all(color: kBlue, width: 0.5),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8)
                                  ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: kBlue.withValues(alpha: 0.2),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                          offset: const Offset(2, 4)
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
                                        style: kBigTextStyle,
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
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  border: Border.all(color: kBlue, width: 0.5),
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(8)
                                  ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: kBlue.withValues(alpha: 0.2),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                          offset: const Offset(2, 4)
                                      )
                                    ]
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/medal.png', width: 18,),
                                        const SizedBox(width: 4),
                                        Text(snapshot['price'], style: kBigTextStyle,),
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
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 250,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: kBlue, width: 0.5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kBlue.withValues(alpha: 0.2),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                        offset: const Offset(2, 4)
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
                                      Text('details'.tr(), style: kTextStyle),
                                    ],
                                  ),
                                  const Divider(color: kBlue,),
                                  Text(snapshot['description'], style: kTextStyle),
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
                              margin: const EdgeInsets.only(left: 3),
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kBlue.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                        offset: const Offset(2, 4)
                                    )
                                  ]
                              ),
                              child: Image.network(snapshot['imageUrl'], fit: BoxFit.cover),
                            ),)
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: kBlue, width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                  color: kBlue.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: const Offset(2, 4)
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            snapshot['status'] == 'price'
                                ? _buildPrice(snapshot, data, context)
                                : snapshot['status'] == 'inProgress'
                                ? _buildInProgress(snapshot, data, context)
                                : snapshot['status'] == 'done'
                                ? _buildDone(snapshot, data, context, size)
                                : snapshot['status'] == 'checked'
                                ? _buildChecked(snapshot, data, context, size)
                                : _buildComplete(snapshot),
                            const SizedBox(height: 20,),
                            snapshot['status'] == 'paid'
                                ? Padding(
                                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      Expanded(child: Text('addToHistoryDescription'.tr(), style: kTextStyle,)),
                                      ParentRoundButton(
                                      onTap: () => data.addTaskToHistory(context, snapshot, index,
                                        snapshot['parentName'],
                                        snapshot['parentEmail'],
                                        snapshot['kidName'],
                                        snapshot['kidEmail'],
                                        snapshot['taskName'],
                                        snapshot['description'],
                                        snapshot['price'],
                                        snapshot['stars'],
                                        snapshot['imageUrl'],
                                        snapshot.containsKey('type') ? snapshot['type'] : 'home',
                                        snapshot.containsKey('expQty') ? snapshot['expQty'] : '1',
                                      ),
                                      icon: Icons.history),
                                    ],
                                  ),
                                )
                                : snapshot['status'] == 'price' && snapshot['priceStatus'] == 'set'
                                ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(child: Text('editTaskDescription'.tr(), style: kTextStyle,)),
                                  ParentRoundButton(
                                      onTap: (){
                                        if(data.pageIndex == 0){
                                          data.searchSingleTaskForEditing(snapshot['id'].toString());
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) =>
                                              const AddSingleTaskScreen()));
                                        }else{
                                          data.searchMultiTaskForEditing(snapshot['id'].toString());
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) =>
                                              const AddMultiTaskScreen()));
                                        }
                                      },
                                      icon: Icons.edit
                                  )
                                ],
                              ),
                            )
                                : const SizedBox.shrink()
                          ],
                        ),
                      )
                    ],
                  ),
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
          snapshot['status'] == 'paid'
              ? Text('taskCompletedParentDescription'.tr(), style: kTextStyle,)
              : Text('payForIt'.tr(), style: kTextStyle,),
          Center(
            child: RatingBar(
              initialRating: double.parse(snapshot['stars']),
              ignoreGestures: true,
              allowHalfRating: false,
              itemCount: 3,
              itemSize: 60,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star,
                    color: kBlue,
                    shadows: [
                      BoxShadow(
                          color: kBlue,
                          blurRadius: 9,
                          spreadRadius: 6,
                          offset: Offset(0.5, 0.5)
                      )
                    ]),
                empty: const Icon(Icons.star_border,
                    color: kBlue,
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
          Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: snapshot['status'] == 'paid'
                      ? kGreen : kRed),
              borderRadius: const BorderRadius.all(Radius.circular(12))
            ),
            child: Center(
                child: Text(snapshot['status'] == 'paid'
                  ? 'paid'.tr()
                  : 'unpaid'.tr(),
                style: snapshot['status'] == 'paid'
                    ? kTextStyle : kRedTextStyle,)),
          )
        ],
      ),
    );
  }

  _buildChecked(Map<String, dynamic> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: _buildComplete(snapshot),
    );
  }

  _buildDone(Map<String, dynamic> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
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
                    color: kBlue,
                    shadows: [
                      BoxShadow(
                          color: kBlue,
                          blurRadius: 9,
                          spreadRadius: 6,
                          offset: Offset(0.5, 0.5)
                      )
                    ]),
                empty: const Icon(Icons.star_border,
                    color: kBlue,
                    shadows: [
                      BoxShadow(
                          color: kGrey,
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
      ),
    );
  }

  _buildInProgress(Map<String, dynamic> snapshot, ParentProvider data, context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          spacing: 12,
          children: [
            Text('waitingForDone'.tr(args: [snapshot['kidName']]), style: kTextStyle,),
            Text('parentInProgressStatusDescription'.tr(), style: kTextStyle,),
          ],
        ),
      ),
    );
  }

  _buildPrice(Map<String, dynamic> snapshot, ParentProvider data, context) {
    return Padding(
            padding: const EdgeInsets.all(12.0),
             child:  (snapshot['priceStatus'] == 'set' && data.role == 'child') ||
                 (snapshot['priceStatus'] == 'changed' && data.role == 'parent')
            ? Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text('parentPriceStatusDescription'.tr(), style: kTextStyle,),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: data.priceController,
                        cursorColor: kDarkGrey,
                        style: kTextStyle,
                        decoration: textFieldDecoration.copyWith(
                            label: Text('price'.tr(),)),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          data.changePriceStatus(context, snapshot, index, data.role, data.pageIndex == 0);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const MainParentScreen()));
                        },
                        icon: const Icon(Icons.autorenew, color: kBlue,)
                    )
                  ],
                ),
                const SizedBox(height: 4,),
                ChangeButtonWidget(
                  index: index,
                  snapshot: snapshot,
                  onTap: () => data.changeToInProgress(snapshot, index, context, data.pageIndex == 0),
                  text: 'acceptPriceChangeStatus',),
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
                  border: Border.all(width: 0.8, color: kBlue),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                        color: kBlue.withValues(alpha: 0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: const Offset(2, 4)
                    )
                  ]
              ),
              child: Center(
                child: Text(text.tr(),
                  style: kBigTextStyle,
                  textAlign: TextAlign.center,),
              ),
            ),
          );
        });
  }
}
