import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/add_single_task_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../kid_screens/main_kid_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DescriptionScreen extends StatelessWidget {
  const DescriptionScreen({super.key,
    required this.index,
    required this.snapshot
  });

  final int index;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kGrey,
      resizeToAvoidBottomInset: true,
      body: Consumer<ParentProvider>(
          builder: (context, data, _){
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60,),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(snapshot.data?.docs[index].get(data.role == 'parent'
                            ? 'kidName' : 'parentName'),
                          style: kBigTextStyle,),
                        IconButton(
                          onPressed: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              data.role == 'parent'
                                 ? const MainParentScreen()
                                 : const MainKidScreen())),
                          icon: const Icon(Icons.close, size: 40,), color: kBlue,)
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
                                  color: kBlue.withValues(alpha: 0.1),
                                  borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(4)
                                  ),
                                ),
                                child: Text(snapshot.data?.docs[index].get('taskName'),
                                  style: kBigTextStyle,),
                              ),
                              Divider(color: kBlue.withValues(alpha: 0.2), height: 0.1,),
                              Container(
                                width: size.width,
                                padding: const EdgeInsets.only(left: 12),
                                color: kBlue.withValues(alpha: 0.1),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('taskPrice'.tr(),
                                          style: kTextStyle.copyWith(
                                              color: kBlue.withValues(alpha: 0.6)),),
                                        Text(snapshot.data?.docs[index].get('price'),
                                          style: kTextStyle,),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(snapshot.data?.docs[index].get('deadline') != 'false'
                                            ? 'taskDeadline'.tr()
                                            : '',
                                          style: kTextStyle.copyWith(
                                              color: kBlue.withValues(alpha: 0.6)),),
                                        Text(snapshot.data?.docs[index].get('deadline') == 'false'
                                            ? 'withoutDeadline'.tr()
                                            : snapshot.data?.docs[index].get('deadline') != null
                                            ? DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(snapshot.data!.docs[index].get('deadline')))
                                            : snapshot.data?.docs[index].get('deadline'),
                                          style: kTextStyle,),
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
                              snapshot.data?.docs[index].get('imageUrl') == 'false' ? 12 : 3, 0),
                          decoration: BoxDecoration(
                              color: kBlue.withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Text(snapshot.data?.docs[index].get('description'), style: kTextStyle),
                        ),
                      ),
                      snapshot.data?.docs[index].get('imageUrl') == 'false'
                          ? const SizedBox.shrink()
                          : Expanded(
                        child: Container(
                          height: 300,
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.fromLTRB(3, 12, 12, 0),
                          decoration: BoxDecoration(
                            color: kBlue.withValues(alpha: 0.3),
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Image.network(snapshot.data?.docs[index].get('imageUrl'), fit: BoxFit.cover),
                        ),)
                    ],
                  ),
                  snapshot.data?.docs[index].get('status') == 'price'
                  ? _buildPrice(snapshot, data, context, size)
                  : snapshot.data?.docs[index].get('status') == 'inProgress'
                  ? _buildInProgress(snapshot, data, context, size)
                  : snapshot.data?.docs[index].get('status') == 'done'
                  ? _buildDone(snapshot, data, context, size)
                  : snapshot.data?.docs[index].get('status') == 'checked'
                  ? _buildChecked(snapshot, data, context, size)
                  : _buildComplete(snapshot),
                  const SizedBox(height: 20,),
                  data.role == 'parent' && snapshot.data?.docs[index].get('status') == 'paid'
                  ? IconButton(
                      onPressed: () => data.addTaskToHistory(context, snapshot, index,
                          snapshot.data?.docs[index].get('parentName'),
                          snapshot.data?.docs[index].get('parentEmail'),
                          snapshot.data?.docs[index].get('kidName'),
                          snapshot.data?.docs[index].get('kidEmail'),
                          snapshot.data?.docs[index].get('taskName'),
                          snapshot.data?.docs[index].get('description'),
                          snapshot.data?.docs[index].get('price'),
                          snapshot.data?.docs[index].get('stars'),
                          snapshot.data?.docs[index].get('imageUrl'),),
                      icon: const Icon(Icons.history, size: 32, color: kBlue,))
                  : data.role == 'parent'
                      && snapshot.data?.docs[index].get('status') == 'price'
                      && snapshot.data?.docs[index].get('priceStatus') == 'set'
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(child: Text('editTaskDescription'.tr(), style: kTextStyle,)),
                        IconButton(
                            onPressed: () {
                              data.searchForEditing(snapshot.data!.docs[index].id.toString());
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
            );
          }),
    );
  }

  _buildComplete(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
    return Padding(
        padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 8,),
          Center(
            child: RatingBar(
              initialRating: double.parse(snapshot.data?.docs[index].get('stars')),
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
                  color: snapshot.data?.docs[index].get('status') == 'paid'
                      ? kGreen : kRed),
              borderRadius: const BorderRadius.all(Radius.circular(12))
            ),
            child: Center(child: Text(
              'paid'.tr(),
              style: snapshot.data?.docs[index].get('status') == 'paid'
                  ? kGreenTextStyle : kRedTextStyle,)),
          )
        ],
      ),
    );
  }

  _buildChecked(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: data.role == 'child'
          ? Column(
        children: [
          Center(
            child: RatingBar(
              initialRating: double.parse(snapshot.data?.docs[index].get('stars')),
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
          Text('ifPaid'.tr(), style: kTextStyle,),
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

  _buildDone(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, ParentProvider data, context, Size size) {
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
          : Text('waitingForPay'.tr(args: [snapshot.data?.docs[index].get(
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      )]), style: kTextStyle,),
    );
  }

  _buildInProgress(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, ParentProvider data, context, Size size) {
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
          : Text('waitingForDone'.tr(args: [snapshot.data?.docs[index].get(
          data.role == 'parent'
              ? 'kidName'
              : 'parentName'
      )]), style: kTextStyle,),
    );
  }

  _buildPrice(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, ParentProvider data, context, Size size) {
    return Padding(
            padding: const EdgeInsets.all(12.0),
             child:  (snapshot.data?.docs[index].get('priceStatus') == 'set' && data.role == 'child') ||
                 (snapshot.data?.docs[index].get('priceStatus') == 'changed' && data.role == 'parent')
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
            : Text('waitingForPrice'.tr(args: [snapshot.data?.docs[index].get(
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
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
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
