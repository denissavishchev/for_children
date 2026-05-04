import 'package:flutter/material.dart';
import 'package:for_children/widgets/parents_widget/parent_bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/history_bar_widget.dart';
import '../../widgets/history_tiles_list_widget.dart';

class ParentHistoryScreen extends StatefulWidget {
  const ParentHistoryScreen({super.key});

  @override
  State<ParentHistoryScreen> createState() => _ParentHistoryScreenState();
}

class _ParentHistoryScreenState extends State<ParentHistoryScreen> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    data.getKidsData();
    super.initState();
  }

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
                                  height: size.height * 0.4,
                                  child: HistoryTilesListWidget(snapshot: snapshot.data!,)),
                              FutureBuilder(
                                  future: data.getKid,
                                  builder: (context, snapShot){
                                    if(snapShot.connectionState == ConnectionState.waiting){
                                      return const Center(child: CircularProgressIndicator(),);
                                    }else{
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate(data.kidsList.length, ((i){
                                            return HistoryBarWidget(
                                                snapshot: snapshot.data!,
                                                kidName:  data.kidsList[i].name);
                                          })),
                                        ),
                                      );
                                    }}),
                            ],
                          );
                        }else{
                          return const Center(child: CircularProgressIndicator());
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


