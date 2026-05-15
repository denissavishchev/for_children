import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/widgets/parents_widget/parent_bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/history_tiles_list_widget.dart';

class ParentHistoryScreen extends StatelessWidget {
  const ParentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kWhite,
      body: SafeArea(
          child: Consumer<ParentProvider>(
            builder: (context, data, _){
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  StreamBuilder<List<Map<String, dynamic>>>(
                      stream: Supabase.instance.client
                          .from('history')
                          .stream(primaryKey: ['id'])
                          .order('time', ascending: false),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return Column(
                            children: [
                              const SizedBox(height: 12,),
                              SizedBox(
                                  height: size.height * 0.8,
                                  child: HistoryTilesListWidget(snapshot: snapshot.data!,)),
                            ],
                          );
                        }else{
                          return const Center(child: SpinKitSpinningLines(
                            color: kBlue,
                            size: 40,
                          ),);
                        }
                      }
                  ),
                  ParentBottomNavigationBarWidget()
                ],
              );
            },
          )
      ),
    );
  }
}


