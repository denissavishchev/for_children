import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';

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
              height: size.height * 0.4,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('wishes')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
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
                                height: 60,
                                margin: const EdgeInsets.fromLTRB(12, 3, 12, 12),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: kGrey,
                                    border: Border.all(width: 1, color: kBlue.withOpacity(0.2)),
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 6)
                                      ),
                                      BoxShadow(
                                        color: kGrey.withOpacity(0.2),
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data?.docs[index].get('wish'), style: kBigTextStyle,),
                                    snapshot.data?.docs[index].get('imageUrl') == 'false'
                                        ? const SizedBox.shrink()
                                        : Container(

                                          clipBehavior: Clip.hardEdge,
                                          margin: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: kBlue.withOpacity(0.3),
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