import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../screens/kid_screens/kids_description_screen.dart';
import 'kid_single_basic_container_widget.dart';

class KidSingleTaskListWidget extends StatefulWidget {
  const KidSingleTaskListWidget({
    super.key, required this.snapshot,
  });

  final QuerySnapshot<Map<String, dynamic>> snapshot;

  @override
  State<KidSingleTaskListWidget> createState() => _KidSingleTaskListWidgetState();
}

class _KidSingleTaskListWidgetState extends State<KidSingleTaskListWidget> {

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
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              SizedBox(
                  height: size.height * 0.8,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 40),
                      itemCount: widget.snapshot.docs.length,
                      itemBuilder: (context, index){
                        if(widget.snapshot.docs[index].get('kidEmail').toLowerCase() == data.email){
                          return GestureDetector(
                            onTap: () {
                              data.priceController.text = widget.snapshot.docs[index].get('price');
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                      KidsDescriptionScreen(index: index, snapshot: widget.snapshot)));
                            },
                            child: KidSingleBasicContainerWidget(
                              snapshot: widget.snapshot,
                              index: index,
                              nameOf: 'parentName',
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      })
              ),
              GestureDetector(
                onTap: () => data.switchTaskScreen(1),
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: kWhite, size: 32,),
                ),
              )
            ],
          );
        });
  }
}