import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_single_task_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
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
  final QuerySnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kGrey,
      resizeToAvoidBottomInset: true,
      body: Consumer<ParentProvider>(
          builder: (context, data, _){
            return Container(
              height: size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg_description.png'),
                      fit: BoxFit.cover
                  )
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.docs[index].get(data.role == 'parent'
                                ? 'kidName' : 'parentName'),
                              style: kBigTextStyleWhite,),
                            IconButton(
                              onPressed: () => Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                  data.role == 'parent'
                                      ? const MainParentScreen()
                                      : const MainKidScreen())),
                              icon: const Icon(Icons.close, size: 40,), color: kWhite,)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 104,
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    width: size.width,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: kOrange.withValues(alpha: 0.7),
                                      borderRadius: const BorderRadius.horizontal(
                                          right: Radius.circular(4)
                                      ),
                                    ),
                                    child: Text(snapshot.docs[index].get('taskName'),
                                      style: kBigTextStyleWhite,),
                                  ),
                                  Divider(color: kPurple.withValues(alpha: 0.7), height: 0.1,),
                                  Container(
                                    width: size.width,
                                    padding: const EdgeInsets.only(left: 12),
                                    color: kOrange.withValues(alpha: 0.7),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('taskPrice'.tr(),
                                              style: kTextStyle.copyWith(
                                                  color: kWhite.withValues(alpha: 0.6)),),
                                            Text(snapshot.docs[index].get('price'),
                                              style: kTextStyleWhite,),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(snapshot.docs[index].get('deadline') != 'false'
                                                ? 'taskDeadline'.tr()
                                                : '',
                                              style: kTextStyle.copyWith(
                                                  color: kWhite.withValues(alpha: 0.6)),),
                                            Text(snapshot.docs[index].get('deadline') == 'false'
                                                ? 'withoutDeadline'.tr()
                                                : snapshot.docs[index].get('deadline') != null
                                                ? DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(snapshot.docs[index].get('deadline')))
                                                : snapshot.docs[index].get('deadline'),
                                              style: kTextStyleWhite,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 300,
                              padding: const EdgeInsets.all(12),
                              margin: EdgeInsets.fromLTRB(12, 12,
                                  snapshot.docs[index].get('imageUrl') == 'false' ? 12 : 3, 0),
                              decoration: BoxDecoration(
                                  color: kOrange.withValues(alpha: 0.7),
                                  borderRadius: const BorderRadius.all(Radius.circular(4))
                              ),
                              child: Text(snapshot.docs[index].get('description'), style: kTextStyleWhite),
                            ),
                          ),
                          snapshot.docs[index].get('imageUrl') == 'false'
                              ? const SizedBox.shrink()
                              : Expanded(
                            child: Container(
                              height: 300,
                              clipBehavior: Clip.hardEdge,
                              margin: const EdgeInsets.fromLTRB(3, 12, 12, 0),
                              decoration: BoxDecoration(
                                color: kOrange.withValues(alpha: 0.7),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Image.network(snapshot.docs[index].get('imageUrl'), fit: BoxFit.cover),
                            ),)
                        ],
                      ),
                      snapshot.docs[index].get('status') == 'price'
                          ? _buildPrice(snapshot, data, context, size)
                          : snapshot.docs[index].get('status') == 'inProgress'
                          ? _buildInProgress(snapshot, data, context, size)
                          : snapshot.docs[index].get('status') == 'done'
                          ? _buildDone(snapshot, data, context, size)
                          : snapshot.docs[index].get('status') == 'checked'
                          ? _buildChecked(snapshot, data, context, size)
                          : _buildComplete(snapshot),
                      const SizedBox(height: 20,),
                      data.role == 'parent' && snapshot.docs[index].get('status') == 'paid'
                          ? IconButton(
                          onPressed: () => data.addTaskToHistory(context, snapshot, index,
                            snapshot.docs[index].get('parentName'),
                            snapshot.docs[index].get('parentEmail'),
                            snapshot.docs[index].get('kidName'),
                            snapshot.docs[index].get('kidEmail'),
                            snapshot.docs[index].get('taskName'),
                            snapshot.docs[index].get('description'),
                            snapshot.docs[index].get('price'),
                            snapshot.docs[index].get('stars'),
                            snapshot.docs[index].get('imageUrl'),),
                          icon: const Icon(Icons.history, size: 32, color: kOrange,))
                          : data.role == 'parent'
                          && snapshot.docs[index].get('status') == 'price'
                          && snapshot.docs[index].get('priceStatus') == 'set'
                          ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            Expanded(child: Text('editTaskDescription'.tr(), style: kTextStyleWhite,)),
                            IconButton(
                                onPressed: () {
                                  data.searchSingleTaskForEditing(snapshot.docs[index].id.toString());
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
              ),
            );
          }),
    );
  }

  _buildComplete(QuerySnapshot<Map<String, dynamic>> snapshot){
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 8,),
          Center(
            child: RatingBar(
              initialRating: double.parse(snapshot.docs[index].get('stars')),
              ignoreGestures: true,
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
                    color: snapshot.docs[index].get('status') == 'paid'
                        ? kGreen : kRed),
                borderRadius: const BorderRadius.all(Radius.circular(12))
            ),
            child: Center(child: Text(
              'paid'.tr(),
              style: snapshot.docs[index].get('status') == 'paid'
                  ? kGreenTextStyle : kRedTextStyle,)),
          )
        ],
      ),
    );
  }

  _buildChecked(QuerySnapshot<Map<String, dynamic>> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: data.role == 'child'
          ? Column(
        children: [
          Center(
            child: RatingBar(
              initialRating: double.parse(snapshot.docs[index].get('stars')),
              ignoreGestures: true,
              allowHalfRating: false,
              itemCount: 3,
              itemSize: 60,
              ratingWidget: RatingWidget(
                full: Icon(Icons.star,
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
                      ),

                    ]),
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
          const SizedBox(height: 8,),
          Text('ifPaid'.tr(), style: kTextStyleOrange,),
          const SizedBox(height: 8,),
          ChangeButtonWidget(
            index: index,
            snapshot: snapshot,
            onTap: () => data.changeToPaid(snapshot, index, context),
            text: 'paid',
          ),
        ],
      )
          : _buildComplete(snapshot),
    );
  }

  _buildDone(QuerySnapshot<Map<String, dynamic>> snapshot, ParentProvider data, context, Size size) {
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
            onTap: () => data.changeToChecked(snapshot, index, context),
            text: 'rate',
          )
        ],
      )
          : Text('waitingForPay'.tr(args: [snapshot.docs[index].get(
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      )]), style: kTextStyle,),
    );
  }

  _buildInProgress(QuerySnapshot<Map<String, dynamic>> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: data.role == 'child'
          ? Column(
        children: [
          ChangeButtonWidget(
            index: index,
            snapshot: snapshot,
            onTap: () => data.changeToDone(snapshot, index, context),
            text: 'imDoneStatus',
          )
        ],
      )
          : Text('waitingForDone'.tr(args: [snapshot.docs[index].get(
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      )]), style: kTextStyle,),
    );
  }

  _buildPrice(QuerySnapshot<Map<String, dynamic>> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:  (snapshot.docs[index].get('priceStatus') == 'set' && data.role == 'child') ||
          (snapshot.docs[index].get('priceStatus') == 'changed' && data.role == 'parent')
          ? Column(
        children: [
          const SizedBox(height: 18,),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: data.priceController,
                  cursorColor: kDarkGrey,
                  decoration: textFieldDecoration.copyWith(
                      label: Text('price'.tr(),)),
                ),
              ),
              IconButton(
                  onPressed: () {
                    data.changePriceStatus(snapshot, index, data.role);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>
                        data.role == 'parent'
                            ? const MainParentScreen()
                            : const MainKidScreen()));
                  },
                  icon: const Icon(Icons.change_circle_outlined)
              )
            ],
          ),
          const SizedBox(height: 12,),
          ChangeButtonWidget(
            index: index,
            snapshot: snapshot,
            onTap: () => data.changeToInProgress(snapshot, index, context),
            text: 'acceptPriceChangeStatus',),
        ],
      )
          : Text('waitingForPrice'.tr(args: [snapshot.docs[index].get(
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      )]), style: kTextStyle,),
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
  final QuerySnapshot<Map<String, dynamic>> snapshot;
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
              width: size.width * 0.6,
              height: 50,
              margin: const EdgeInsets.fromLTRB(12, 0, 0, 4),
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
                  style: kTextStyleGrey,
                  textAlign: TextAlign.center,),
              ),
            ),
          );
        });
  }
}
