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
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              color: kWhite.withValues(alpha: 0.3)
                          ),
                          child: StreamBuilder(
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
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(builder: (context) =>
                                                  SingleSaveMoneyScreen(documentId: snapshot.data!.docs.elementAt(index).id,)));
                                            },
                                            child: Container(
                                              height: 60,
                                              margin: const EdgeInsets.fromLTRB(12, 3, 12, 12),
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        kLightBlue.withValues(alpha: 0.8),
                                                        kDarkBlue.withValues(alpha: 0.8),
                                                        kPurple.withValues(alpha: 0.8),
                                                      ],
                                                      stops: const [0, 0.5, 1]
                                                  ),
                                                  border: Border.all(width: 1, color: kOrange.withValues(alpha: 0.3)),
                                                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: kRed.withValues(alpha: 0.6),
                                                        blurRadius: 6,
                                                        spreadRadius: 2,
                                                        offset: const Offset(-4, 6)
                                                    ),
                                                    BoxShadow(
                                                        color: Colors.black.withValues(alpha: 0.3),
                                                        blurRadius: 1,
                                                        spreadRadius: 0.5,
                                                        offset: const Offset(-0.5, 0.5)
                                                    ),
                                                  ]
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(snapshot.data?.docs[index].get('whatIsIt'), style: kBigTextStyleWhite,),
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
                                      }),
                                );
                              }
                          ),
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

