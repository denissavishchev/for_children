import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/kid_screens/single_save_money_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import 'add_single_save_money_screen.dart';

class SaveMoneyScreen extends StatelessWidget {
  const SaveMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer<KidProvider>(
        builder: (context, data, _){
          return Container(
            height: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_money.png'),
                    fit: BoxFit.cover
                )
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('saveMoney')
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (context, snapshot){
                              if (!snapshot.hasData) return CircularProgressIndicator();
                              return SizedBox(
                                height: size.height * 0.6,
                                child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 124),
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index){
                                      final total = List.from(snapshot.data?.docs[index].get('money') ?? [])
                                          .fold<int>(0, (s, m) => s + (int.tryParse(m.split('/')[0]) ?? 0));
                                      final percent = (total / (int.tryParse(snapshot.data!.docs[index].get('price').toString()) ?? 0)) * 100;
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(builder: (context) =>
                                                SingleSaveMoneyScreen(documentId: snapshot.data!.docs.elementAt(index).id,)));
                                          },
                                          child: Container(
                                            height: 120,
                                            margin: const EdgeInsets.fromLTRB(12, 3, 12, 12),
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                                color: kWhite.withValues(alpha: 0.2),
                                                border: Border.all(width: 1, color: kOrange.withValues(alpha: 0.5)),
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        width: size.width * 0.6,
                                                        height: 60,
                                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(width: 1, color: kOrange.withValues(alpha: 0.5)),
                                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            LayoutBuilder(
                                                                builder: (context, constraints){
                                                                  return Container(
                                                                    width: constraints.maxWidth * percent / 100,
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                          colors: [
                                                                            kOrange.withValues(alpha: 0.5),
                                                                            Colors.transparent
                                                                          ],
                                                                        begin: Alignment.bottomCenter,
                                                                        end: Alignment.topCenter
                                                                      ),
                                                                      borderRadius: const BorderRadius.horizontal(
                                                                          left: Radius.circular(8),
                                                                        right: Radius.circular(0)
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(snapshot.data?.docs[index].get('whatIsIt'), style: kBigTextStyleWhite,),
                                                            ),
                                                          ],
                                                        )),
                                                    SizedBox(
                                                      width: size.width * 0.6,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('$total'
                                                              '/ ${snapshot.data?.docs[index].get('price')} ${snapshot.data?.docs[index].get('currency')}',
                                                            style: kBigTextStyleWhite,),
                                                          Text('${percent.toStringAsFixed(0)}%',
                                                            style: kBigTextStyleWhite,),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 120,
                                                  constraints: BoxConstraints(
                                                    maxWidth: size.width * 0.2
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  margin: const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: kBlue.withValues(alpha: 0.3),
                                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: kDarkBlue.withValues(alpha: 0.9),
                                                        blurRadius: 1,
                                                        spreadRadius: 1,
                                                        offset: Offset(-2, 2)
                                                      )
                                                    ]
                                                  ),
                                                  child: snapshot.data?.docs[index].get('imageUrl') == 'false'
                                                      ? Image.asset('assets/images/cat.png', fit: BoxFit.contain)
                                                      : Image.network(snapshot.data?.docs[index].get('imageUrl'), fit: BoxFit.contain),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                    }),
                              );
                            }
                        ),
                        const Spacer(),
                        ButtonWidget(
                          onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const AddSingleSaveMoneyScreen())),
                          text: 'add',
                        ),
                        const SizedBox(height: 80,),
                      ],
                    ),
                  ),
                  KidBottomNavigationBarWidget()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

