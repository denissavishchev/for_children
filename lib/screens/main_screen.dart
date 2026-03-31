import 'package:flutter/material.dart';
import 'package:for_children/screens/kid_screens/main_kid_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:provider/provider.dart';
import '../providers/parent_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    data.getRole(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ParentProvider>(
        builder: (context, data, _){
          if(data.role == 'parent'){
            return const MainParentScreen();
          }else if(data.role == 'child'){
            return const MainKidScreen();
          }else{
            return SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Image.asset('assets/images/bg.png', fit: BoxFit.cover,));
          }
        },
      )
    );
  }
}