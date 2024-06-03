import 'package:flutter/material.dart';

class Language {
  Locale locale;
  String language;

  Language({
    required this.locale,
    required this.language
});
}

List<Language> languageList = [
  Language(
      locale: const Locale('en'),
      language: 'English - UK'
  ),
  Language(
      locale: const Locale('pl'),
      language: 'Polski - PL'
  ),
  Language(
      locale: const Locale('ru'),
      language: 'Russian - Ru'
  ),
];