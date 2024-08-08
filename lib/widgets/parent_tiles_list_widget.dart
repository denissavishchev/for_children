import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/parent_screens/description_screen.dart';
import 'package:provider/provider.dart';
import 'basic_container_widget.dart';

class ParentTilesListWidget extends StatefulWidget {
  const ParentTilesListWidget({
    super.key,
  });

  @override
  State<ParentTilesListWidget> createState() => _ParentTilesListWidgetState();
}

class _ParentTilesListWidgetState extends State<ParentTilesListWidget> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    data.getEmailData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return SizedBox(
              height: size.height * 0.8,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index){
                          if(snapshot.data?.docs[index].get('parentEmail').toLowerCase() == data.email){
                            return GestureDetector(
                              onTap: () {
                                data.priceController.text = snapshot.data?.docs[index].get('price');
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                        DescriptionScreen(index: index, snapshot: snapshot)));
                              },
                              child: BasicContainerWidget(
                                snapshot: snapshot,
                                index: index,
                                nameOf: 'kidName',
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


