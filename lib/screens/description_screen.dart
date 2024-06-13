import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';

class DescriptionScreen extends StatelessWidget {
  const DescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Container();
        });
  }
}
