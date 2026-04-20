import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Column(
            children: [
              Visibility(
                visible: data.adTitle != '' && data.adDescription != '',
                child: AdWidget(),
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

class AdWidget extends StatelessWidget {
  const AdWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                border: Border.all(color: kOrange),
                borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(2, 1, 4, 1),
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: kOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: kOrange, width: 0.5),
                          ),
                          child: Row(
                            spacing: 2,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: kOrange, size: 12),
                              Text('#maybe', style: kTextStyle),
                            ],
                          ),
                        ),
                        Text('${data.adTitle}',
                            style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                        Text('${data.adDescription}',
                          style: kTextStyleNormal, softWrap: true,),
                        Row(
                          spacing: 4,
                          children: List.generate(data.hashtags.length, ((i) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(2, 1, 4, 1),
                              decoration: BoxDecoration(
                                color: kOrange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                border: Border.all(color: kOrange, width: 0.5),
                              ),
                              child: Row(
                                spacing: 2,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(data.hashtags.keys.elementAt(i), color: kOrange, size: 8),
                                  Text(data.hashtags.values.elementAt(i), style: kSmallTextStyle.copyWith(fontSize: 14.sp)),
                                ],
                              ),
                            );
                          }))
                        )
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.only(left: size.width * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                          boxShadow: [
                            BoxShadow(
                              color: kGrey.withValues(alpha: 0.7),
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
                            return const Center(child: SpinKitSpinningLines(
                              color: kBlue,
                              size: 40,
                            ));
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.warning, color: kOrange,),
                            );
                          }),
                    ),
                    Positioned(
                      top: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kOrange, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: kBlue.withValues(alpha: 0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(-1, -1),
                              ),
                              BoxShadow(
                                color: kDarkWhite,
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(2, 2),
                              ),
                            ]
                          ),
                          child: Icon(
                            Icons.stars,
                            color: kOrange,
                            size: 24,
                            ),
                        )),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}