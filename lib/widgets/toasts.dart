import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:for_children/constants.dart';

void happyToast(String text){
  Fluttertoast.showToast(
      msg: text.tr(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: kGreen.withOpacity(0.3),
      textColor: kDarkGrey,
      fontSize: 20
  );
}

void sadToast(String text){
  Fluttertoast.showToast(
      msg: text.tr(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: kRed.withOpacity(0.3),
      textColor: kGrey,
      fontSize: 20
  );
}
