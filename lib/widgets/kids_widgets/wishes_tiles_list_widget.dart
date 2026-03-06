import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:provider/provider.dart';
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
          return SizedBox(
              height: size.height * 0.8,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('wishes')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 40),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index){
                          if(snapshot.data?.docs[index].get('kidEmail').toLowerCase() == data.email){
                            return GestureDetector(
                              onTap: () {
                                snapshot.data?.docs[index].get('imageUrl') != 'false'
                                    ? kidData.showWishDescription(context, snapshot, index)
                                    : null;
                              },
                              child: Container(
                                height: 120,
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                padding: const EdgeInsets.only(left: 12),
                                decoration: BoxDecoration(
                                    color: kLightGrey.withValues(alpha: 0.5),
                                    border: Border.all(width: 1.5, color: kOrange),
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Row(
                                  spacing: 12,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(snapshot.data?.docs[index].get('wish'), style: kBigTextStyle,),
                                        Text(snapshot.data?.docs[index].get('whyNeed'), style: kBigTextStyle,),
                                      ],
                                    ),
                                    snapshot.data?.docs[index].get('imageUrl') == 'false'
                                        ? const SizedBox.shrink()
                                        : Container(
                                          clipBehavior: Clip.hardEdge,
                                          margin: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: kBlue.withValues(alpha: 0.3),
                                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child: Image.network(snapshot.data?.docs[index].get('imageUrl'), fit: BoxFit.cover),
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
              )
          );
        });
  }
}