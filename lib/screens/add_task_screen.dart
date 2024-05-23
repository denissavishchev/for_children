import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Text(
                'Daniel', style: kTextStyle,
              ),
              TextField(
                cursorColor: kDarkGrey,
                decoration: textFieldDecoration.copyWith(hintText: 'Task',),
                maxLength: 64,
              ),
              TextField(
                cursorColor: kDarkGrey,
                decoration: textFieldDecoration.copyWith(hintText: 'Description',),
                maxLength: 256,
              ),
              TextField(
                cursorColor: kDarkGrey,
                decoration: textFieldDecoration.copyWith(hintText: 'Date',),
              ),
              TextField(
                cursorColor: kDarkGrey,
                decoration: textFieldDecoration.copyWith(hintText: 'Price',),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
