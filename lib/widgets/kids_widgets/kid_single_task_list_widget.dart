import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../screens/kid_screens/kids_description_screen.dart';
import 'kid_single_basic_container_widget.dart';

class KidSingleTaskListWidget extends StatefulWidget {
  const KidSingleTaskListWidget({
    super.key, required this.snapshot,
  });

  final List<Map<String, dynamic>> snapshot;

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
          return Column(
            children: [
              Visibility(
                visible: data.adTitle != '' && data.adDescription != '',
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: kOrange),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${data.adTitle}',
                                  style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                              Text('${data.adDescription}',
                                style: kTextStyleNormal, softWrap: true,),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                          boxShadow: [
                            BoxShadow(
                              color: kGrey.withValues(alpha: 0.4),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(-2, 0),
                            )
                          ]
                        ),
                        child: Image.network('${data.adImageUrl}',
                            width: size.width * 0.3,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.warning, color: kOrange,),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 80, top: 2),
                itemCount: widget.snapshot.length,
                itemBuilder: (context, index){
                  final taskData = widget.snapshot[index];
                  if(taskData['kidEmail'].toLowerCase() == data.email){
                    return GestureDetector(
                      onTap: () {
                        data.priceController.text = taskData['price'];
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                                KidsDescriptionScreen(index: index, snapshot: taskData)));
                      },
                      child: KidSingleBasicContainerWidget(
                        snapshot: taskData,
                        index: index,
                        nameOf: 'parentName',
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
            ],
          );
        });
  }
}