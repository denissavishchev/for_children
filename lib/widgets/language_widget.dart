import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/widgets/language.dart';
import 'package:provider/provider.dart';

import 'flag_widget.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
        builder: (context, data, _){
          return PopupMenuButton(
            child: FlagWidget(
                country:
                    context.locale.toString() == 'en_US'
                    ? 'GB'
                    : context.locale.toString() == 'pl_PL'
                    ? 'PL'
                    : 'RU'
            ),
            onSelected: (value){
              data.setLanguage(value, context);
              if(value.language == 'English - UK'){
                context.setLocale(const Locale('en', 'US'));
              }else if(value.language == 'Polski - PL'){
                context.setLocale(const Locale('pl', 'PL'));
              }else if(value.language == 'Russian - Ru'){
                context.setLocale(const Locale('ru', 'RU'));
              }
            },
              itemBuilder: (context){
                return languageList.map<PopupMenuEntry<Language>>((valueLanguage){
                  return PopupMenuItem<Language>(
                    value: valueLanguage,
                    child: Text(valueLanguage.language, style: kTextStyle,));
                }).toList();
              });
        });
  }
}
