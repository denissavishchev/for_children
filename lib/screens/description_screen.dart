import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/status_widget.dart';
import 'kid_screens/main_kid_screen.dart';

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
                  const SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(snapshot.data?.docs[index].get(data.role == 'parent' ? 'kidName' : 'parentName'),
                          style: kBigTextStyle,),
                        IconButton(
                          onPressed: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              data.role == 'parent'
                                 ? const MainParentScreen()
                                 : const MainKidScreen())),
                          icon: const Icon(Icons.clear), color: kBlue,)
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
                                width: size.width * 0.7,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: kBlue.withOpacity(0.1),
                                  borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(4)
                                  ),
                                ),
                                child: Text(snapshot.data?.docs[index].get('taskName'),
                                  style: kBigTextStyle,),
                              ),
                              Divider(color: kBlue.withOpacity(0.2), height: 0.1,),
                              Container(
                                width: size.width * 0.7,
                                padding: const EdgeInsets.only(left: 12),
                                color: kBlue.withOpacity(0.1),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('taskPrice'.tr(),
                                          style: kTextStyle.copyWith(
                                              color: kBlue.withOpacity(0.6)),),
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
                                              color: kBlue.withOpacity(0.6)),),
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
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusWidget(
                                snapshot: snapshot,
                                index: index,
                                border: false,
                                name: snapshot.data?.docs[index].get('status'),),
                            ],
                          ),
                        ),
                      )
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
                              color: kBlue.withOpacity(0.1),
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
                            color: kBlue.withOpacity(0.3),
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
                  : const Text('notPriceNotProgress')
                ],
              ),
            );
          }),
    );
  }

  _buildInProgress(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, ParentProvider data, context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:  (snapshot.data?.docs[index].get('priceStatus') == 'set' && data.role == 'child')
          ? Column(
        children: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.done_all)
          )
        ],
      )
          : const Text('Waiting for...'),
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
                GestureDetector(
                  onTap: () {
                    data.changeToInProgress(snapshot, index);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>
                        data.role == 'parent'
                            ? const MainParentScreen()
                            : const MainKidScreen()));
                  },
                  child: Container(
                    width: size.width * 0.6,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 4),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(width: 1, color: kBlue.withOpacity(0.8)),
                        gradient: LinearGradient(
                            colors: [
                              kBlue.withOpacity(0.4),
                              kBlue.withOpacity(0.6)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 2,
                              offset: const Offset(0, 1)
                          ),
                          BoxShadow(
                            color: kGrey.withOpacity(0.2),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ]
                    ),
                    child: Center(
                      child: Text('acceptPriceChangeStatus'.tr(),
                        style: kTextStyleGrey,
                        textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ],
            )
            : const Text('Waiting for...'),
          );
  }
}
