import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';

class FlagWidget extends StatelessWidget {
  const FlagWidget({
    super.key, required this.country,
  });

  final String country;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kDarkWhite),
        boxShadow: [
          BoxShadow(
            color: kDarkWhite,
            blurRadius: 0.5,
            spreadRadius: 0.5,
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: CountryFlag.fromCountryCode(
        country,
        theme: ImageTheme(
          height: 36,
          width: 46,
          shape: RoundedRectangle(8),
        ),
      ),
    );
  }
}