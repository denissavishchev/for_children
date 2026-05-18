import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import '../../widgets/kids_widgets/kid_history_tile_list_widget.dart';

class KidHistoryScreen extends StatelessWidget {
  const KidHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                              Expanded(
                                  child: KidHistoryTilesListWidget(snapshot: snapshot.data!,)),
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
                  KidBottomNavigationBarWidget()
                ],
              );
            },
          )
      ),
    );
  }
}


