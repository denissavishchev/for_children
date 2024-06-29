import 'package:flutter/material.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';
import '../widgets/history_tiles_list_widget.dart';
import 'kid_screens/main_kid_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer<ParentProvider>(
            builder: (context, data, _){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: size.height * 0.1,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () =>
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                      data.role == 'parent'
                                          ? const MainParentScreen()
                                          : const MainKidScreen())),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: kBlue,
                                size: 32,
                              )),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const HistoryTilesListWidget()
                  ],
                ),
              );
            },
          )
      ),
    );
  }
}
