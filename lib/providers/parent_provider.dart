import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/parent_screens/parent_history_screen.dart';
import 'package:for_children/screens/parent_screens/ads_list_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:for_children/widgets/parents_widget/day_duration_scroll_widget.dart';
import 'package:for_children/widgets/kids_widgets/kid_round_button.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ads_model.dart';
import '../models/kid_model.dart';
import '../screens/kid_screens/main_kid_screen.dart';
import '../screens/parent_screens/add_ads_screen.dart';
import '../screens/parent_screens/add_multi_task_screen.dart';
import '../screens/parent_screens/add_single_task_screen.dart';
import '../screens/parent_screens/parent_settings_screen.dart';
import '../widgets/toasts.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class ParentProvider with ChangeNotifier {

  GlobalKey<FormState> taskKey = GlobalKey<FormState>();
  GlobalKey<FormState> adsKey = GlobalKey<FormState>();

  TextEditingController addTaskNameController = TextEditingController();
  TextEditingController addTaskDescriptionController = TextEditingController();
  TextEditingController addTaskPriceController = TextEditingController();
  TextEditingController kidSearchController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  PageController taskPageController = PageController();
  String selectedKidName = '';
  String selectedKidEmail = '';
  double daySlider = 5;
  int pageIndex = 0;
  bool isSingleTask = true;
  bool isMultiTask = false;

  int startHour = 0;
  int startMinute = 0;
  int startSecund = 0;
  int endHour = 0;
  int endMinute = 0;
  int endSecund = 0;

  FixedExtentScrollController _startMinController = FixedExtentScrollController();
  FixedExtentScrollController _startHourController = FixedExtentScrollController();
  FixedExtentScrollController _endMinController = FixedExtentScrollController();
  FixedExtentScrollController _endHourController = FixedExtentScrollController();

  DateTime taskDeadline = DateTime.now();
  bool isDeadline = false;

  bool isLoading = false;

  final aiModel = GenerativeModel(
    model: 'gemini-2.5-flash-lite',
    apiKey: dotenv.env['GOOGLE_AI_STUDIO_KEY'].toString(),
  );

  List<String> status = ['price', 'inProgress', 'done', 'checked', 'paid'];

  Map<String, String> wishesParent = {
    'bear': 'toy',
    'gamepad': 'videoGame',
    'cupcake': 'sweet',
    'ticket': 'cinema',
    'dice': 'boardGame',
  };

  Map<String, String> wishesKid = {
    'gamepad': 'newGame',
    'bike': 'bicycle',
    'iceCream': 'iceCream',
    'toy': 'toyInf',
    'ticket': 'goingToTheCinema',
  };

  Map<String, Color> howItWorksParent = {
    'kidAddWish': kGreen,
    'parentChooseWish': kBlue,
    'kidDoTask': kOrange,
  };

  Map<String, Color> howItWorksKid = {
    'youAddYouWish': kGreen,
    'parentsCanSelectFromList': kOrange,
  };

  Map<String, Color> taskTypes = {
    'home': kRed,
    'study': kGreen,
    'sport': kBlue,
    'family': Colors.yellow,
    'art': kOrange,
    'health': kPurple,
    'ecology': Colors.pink,
    'hobby': kLightBlue};

  Map<IconData, String> hashtags = {
    Icons.tag_faces_rounded: 'Rozsmiesza',
    Icons.star: 'Wviatkowy',
    Icons.redeem: 'Idealny prezent',
  };

  String selectedTypeStatus = 'home';
  int selectedExp = 1;

  String imageUrl = '';
  String fileName = '';
  late Reference imageToUpload;
  XFile? file = XFile('');
  late Future<void> getKid;
  Future<void> getAds = Future.value(null);
  late Future<void> getEmailVoid;
  List<KidModel> kidsList = [];
  List<AdsModel> adsList = [];
  Map<String, String> wishList = {};

  String? email = '';
  String? name = '';
  String? adTitle = '';
  String? adDescription = '';
  String? adImageUrl = '';
  String adEndTime = '';
  String? role = '';

  double stars = 0.0;

  bool addTaskInfo = false;
  bool settingsParentInfo = false;
  bool isEdit = false;
  String editDocId = '';

  Map<String, Locale> locales = {
    'GB': const Locale('en', 'US'),
    'PL': const Locale('pl', 'PL'),
    'RU': const Locale('ru', 'RU'),
  };

  final Map<IconData, Widget> routes = {
    Icons.home: MainParentScreen(),
    Icons.settings: ParentSettingsScreen(),
    Icons.campaign: AdsListScreen(),
    Icons.history: ParentHistoryScreen(),
  };

  IconData selectedRoute = Icons.home;

  void switchAddTaskInfo(){
    addTaskInfo = !addTaskInfo;
    notifyListeners();
  }

  void switchSettingsParentInfo(){
    settingsParentInfo = !settingsParentInfo;
    notifyListeners();
  }

  void isSingleTaskSwitch(){
    isSingleTask = !isSingleTask;
  }

  Future<void> getEmailAndName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('users')
        .select('name, adTitle, adDescription, adImageUrl, adEndTime')
        .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '')
        .maybeSingle();
    if(doc != null){
      name = doc['name'];
      adTitle = doc['adTitle'];
      adDescription = doc['adDescription'];
      adImageUrl = doc['adImageUrl'];
      adEndTime = doc['adEndTime'] ?? '';
      if(adEndTime != ''){
        DateTime deadline = DateTime.parse(adEndTime);
        if (!deadline.isAfter(DateTime.now())) {
          await Supabase.instance.client
              .from('users')
              .update({
            'adTitle': '',
            'adDescription': '',
            'adImageUrl': '',
            'adEndTime': '',
          })
              .eq('email', email.toString());
          await Supabase.instance.client.storage
              .from('images')
              .remove([imageUrl.split('/').last]);
        }
      }
    }
    notifyListeners();
  }

  Future<void> getKidsData()async {
    getKid = getKids();
  }

  void getEmailData(){
    getEmailVoid = getEmailAndName();
  }

  Future getRole(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('users')
        .select('role')
        .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '')
        .maybeSingle();
    if (doc != null) {
      prefs.setString('role', doc['role']);
    } else {
      log('noUser');
    }
    role = prefs.getString('role');
    notifyListeners();
  }

  Future<void> deleteTask(Map<String, dynamic> snapshot, int index, context)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.3,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Text('deleteThisTask'.tr(), style: kTextStyle,),
                  ButtonWidget(
                      onTap: () async => await Supabase.instance.client
                        .from('history')
                        .delete()
                        .eq('id', snapshot['id']),
                      text: 'delete')
                ],
              )
          );
        });
  }

  Future addKidToParent(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic>? docP = await Supabase.instance.client
        .from('users')
        .select('kid0, kid1, kid2, kid3, kid4, kid5')
        .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '')
        .maybeSingle();
    if (docP != null) {
      if(docP['kid4'] == ''){
        for(var k = 0; k < 5; k++){
          if(docP['kid$k'] != kidSearchController.text.trim()){
            if(docP['kid$k'] == ''){
              await Supabase.instance.client
                  .from('users')
                  .update({'kid$k': kidSearchController.text.trim()})
                  .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '');
              break;
            }
          }else{
            sadToast('kidAlreadyInList');
            break;
          }
        }
      }else{
        sadToast('onlyFiveKids');
      }
    }
    else {
      log('noUser');
    }
    final Map<String, dynamic>? docK = await Supabase.instance.client
        .from('users')
        .select('kid0, kid1, kid2, kid3, kid4, kid5')
        .eq('email', kidSearchController.text.trim().toLowerCase())
        .maybeSingle();
    if(docK != null){
      if(docK['kid4'] == ''){
        for(var k = 0; k < 5; k++){
          if(docK['kid$k'] != prefs.getString('email')){
            if(docK['kid$k'] == ''){
              await Supabase.instance.client
                  .from('users')
                  .update({'kid$k': prefs.getString('email')})
                  .eq('email', kidSearchController.text.trim());
              break;
            }
          }else{
            break;
          }
        }
      }else{
        sadToast('kidHasFiveParent');
      }
    }
    kidSearchController.clear();
    Navigator.of(context).pop();
    getKidsData();
    notifyListeners();
  }

  Future kidSearch(context) async{
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('users')
        .select('role, name, surName')
        .eq('email', kidSearchController.text.toLowerCase().trim())
        .maybeSingle();
      if(doc != null && doc['role'] == 'child'){
        showKidSearchInfo(context, doc['name'], doc['surName'], kidSearchController.text.trim());
      }else{
        sadToast('noEmail');
      }
  }

  Future<void> getKids() async {
    kidsList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? parentEmail = prefs.getString('email')?.toLowerCase();

    if (parentEmail == null) return;

    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('users')
        .select('kid0, kid1, kid2, kid3, kid4, kid5')
        .eq('email', parentEmail)
        .maybeSingle();

    if (doc == null) return;
    for (int k = 0; k < 6; k++) {
      String? kidEmail = doc['kid$k']?.toLowerCase();
      if (kidEmail == null || kidEmail.isEmpty) continue;
      final Map<String, dynamic>? docEmail = await Supabase.instance.client
          .from('users')
          .select('*')
          .eq('email', kidEmail)
          .maybeSingle();
      if (docEmail == null) continue;
      bool isAcceptedByChild = false;
      for (int i = 0; i < 6; i++) {
        if (docEmail['kid$i']?.toLowerCase() == parentEmail) {
          if (docEmail['kid${i}Accept'] == true) {
            isAcceptedByChild = true;
          }
          break;
        }
      }
        final kid = KidModel(
            name: docEmail['name'] ?? '',
            email: kidEmail,
            accept: isAcceptedByChild,
            startDay: docEmail['dayStart'] ?? '',
            endDay: docEmail['dayEnd'] ?? '',
            adTitle: docEmail['adTitle'] ?? '',
            adDescription: docEmail['adDescription'] ?? '',
            adImageUrl: docEmail['adImageUrl'] ?? '',
            adEndTime: docEmail['adEndTime'] ?? ''
        );
        kidsList.add(kid);
    }
    notifyListeners();
  }

  Future showKidSearchInfo(context, String name, String surname, String email) {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.3,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Text('addKidSure'.tr(args: ['$name $surname']), style: kTextStyle,),
                  Text('email: $email', style: kTextStyle,),
                  ButtonWidget(
                      onTap: () => addKidToParent(context),
                      text: 'add')
                ],
              )
          );
        });
  }

  Future showWishList(context, ParentProvider data) {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.6,
              width: size.width,
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: wishList.isNotEmpty
              ? ListView.builder(
                  itemCount: wishList.length,
                  itemBuilder: (context, index){
                    String wish = wishList.keys.elementAt(index);
                    String image = wishList.values.elementAt(index);
                    return GestureDetector(
                      onTap: () => addWishToField(context, wish),
                      child: Container(
                        width: size.width,
                        height: image == ''
                            ? 50 : 100,
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                            color: kDarkGrey,
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(wish, style: kTextStyle,),
                            image == ''
                                ? const SizedBox.shrink()
                                : Image.network(image),
                          ],
                        ),
                      ),
                    );
                  })
              : Center(child: Text('kidHasNoWishes'.tr(), style: kBigTextStyle,)),
          );
        });
  }

  void addWishToField(context, String wish){
    addTaskPriceController.text = wish;
    notifyListeners();
    Navigator.of(context).pop();
  }

  Future<void> pickAnImage() async {
    ImagePicker imagePicker = ImagePicker();

    file = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
      maxWidth: 800,
    );

    if (file == null) {
      return;
    }
    final File fileToUpload = File(file!.path);
    fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final String bucketName = 'images';
      await Supabase.instance.client.storage
          .from(bucketName)
          .upload(
        fileName,
        fileToUpload,
      );
      imageUrl = Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(fileName);
    } catch (e) {
      log('❌ Błąd Supabase przy wgrywaniu zdjęcia: $e');
    }
    notifyListeners();
  }

  Future changePriceStatus(context, Map<String, dynamic> snapshot, int index, String? role, bool isSingle)async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.25,
              width: size.width,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('changePriceTo'.tr(), style: kBigTextStyle,),
                      Text('changePriceToDescription'.tr(args: [snapshot['price'], priceController.text.trim()]), style: kTextStyle,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                      KidRoundButton(
                        onTap: () async {
                          isSingle
                              ? await Supabase.instance.client
                              .from('tasks')
                              .update({'price': priceController.text.trim(), 'priceStatus': role == 'parent' ? 'set' : 'changed'})
                              .eq('id', snapshot['id'])
                              : await Supabase.instance.client
                              .from('multiTasks')
                              .update({'price': priceController.text.trim(), 'priceStatus': role == 'parent' ? 'set' : 'changed'})
                              .eq('id', snapshot['id']);
                          if (!context.mounted) return;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              role == 'parent'
                                  ? const MainParentScreen()
                                  : const MainKidScreen()));
                        },
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ],
              )
          );
        });
  }

  Future changeToInProgress(Map<String, dynamic> snapshot, int index, context, bool isSingle)async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.25,
              width: size.width,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('changeStatusToInProgress'.tr(), style: kBigTextStyle,),
                      Text('changeStatusToInProgressDescription'.tr(args: [snapshot['price'], snapshot['taskName']]), style: kTextStyle,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                      KidRoundButton(
                        onTap: () async {
                          isSingle
                          ? await Supabase.instance.client
                              .from('tasks')
                              .update({'status': 'inProgress', 'time' : DateTime.now().toString()})
                              .eq('id', snapshot['id'])
                          : await Supabase.instance.client
                              .from('multiTasks')
                              .update({'status': 'inProgress', 'time' : DateTime.now().toString()})
                              .eq('id', snapshot['id']);
                          if (!context.mounted) return;
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          role == 'parent'
                          ? const MainParentScreen()
                          : const MainKidScreen()));
                        },
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ],
              )
          );
        });
  }

  Future changeToDone(Map<String, dynamic> snapshot, int index, context, bool isSingle, bool changeScreen)async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.25,
              width: size.width,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('changeStatusToDone'.tr(), style: kBigTextStyle,),
                      Text('changeStatusToDoneDescription'.tr(args: [snapshot['taskName']]), style: kTextStyle,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                      KidRoundButton(
                        onTap: () async {
                          isSingle
                              ? await Supabase.instance.client
                              .from('tasks')
                              .update({'status': 'done'})
                              .eq('id', snapshot['id'])
                              : await Supabase.instance.client
                              .from('multiTasks')
                              .update({'status': 'done'})
                              .eq('id', snapshot['id']);
                          if(changeScreen){
                            if (!context.mounted) return;
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>
                                role == 'parent'
                                    ? const MainParentScreen()
                                    : const MainKidScreen()));
                          }
                        },
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ],
              )
          );
        });
  }

  Future changeToDoneWithoutDialog(context, Map<String, dynamic> snapshot)async{
    await Supabase.instance.client
        .from('multiTasks')
        .update({'status': 'done'})
        .eq('id', snapshot['id']);
  }

  Future changeToChecked(Map<String, dynamic> snapshot, int index, context, bool isSingle)async{
    isSingle
        ? await Supabase.instance.client
          .from('tasks')
          .update({'status': 'checked', 'stars' : stars.toStringAsFixed(0)})
          .eq('id', snapshot['id'])
        : await Supabase.instance.client
          .from('multiTasks')
          .update({'status': 'checked', 'stars' : stars.toStringAsFixed(0)})
          .eq('id', snapshot['id']);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        role == 'parent'
            ? const MainParentScreen()
            : const MainKidScreen()));
  }

  Future changeToPaid(Map<String, dynamic> snapshot, int index, context, bool isSingle)async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.25,
              width: size.width,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('changeStatusToPaid'.tr(), style: kBigTextStyle,),
                      Text('changeStatusToPaidDescription'.tr(args: [snapshot['taskName'], snapshot['stars'], snapshot['price']]),
                        style: kTextStyle,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                      KidRoundButton(
                        onTap: () async {
                          isSingle
                              ? await Supabase.instance.client
                              .from('tasks')
                              .update({'status': 'paid'})
                              .eq('id', snapshot['id'])
                              : await Supabase.instance.client
                              .from('multiTasks')
                              .update({'status': 'paid'})
                              .eq('id', snapshot['id']);
                          if(!context.mounted) return;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              role == 'parent'
                                  ? const MainParentScreen()
                                  : const MainKidScreen()));
                        },
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ],
              )
          );
        });
  }

  void selectKid(String key, String value){
    selectedKidName = key;
    selectedKidEmail = value;
    wishList.clear();
    notifyListeners();
  }

  Future addSingleTaskToBase(context)async{
    isLoading = true;
    notifyListeners();
    if(selectedKidName != ''){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic>? doc = await Supabase.instance.client
          .from('users')
          .select('name')
          .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '')
          .maybeSingle();
      String parentName = '';
      if(doc != null){
        parentName = doc['name'];
      }
    await Supabase.instance.client
        .from('tasks')
        .insert({
          'priceStatus': 'set',
          'parentName': parentName,
          'parentEmail': prefs.getString('email'),
          'kidName': selectedKidName,
          'kidEmail': selectedKidEmail,
          'taskName': addTaskNameController.text,
          'description': addTaskDescriptionController.text,
          'status': 'price',
          'price': addTaskPriceController.text,
          'deadline': isDeadline ? taskDeadline.toString() : 'false',
          'stars' : '0',
          'imageUrl' : fileName == '' ? 'false' : imageUrl,
          'time' : DateTime.now().toString(),
          'type' : selectedTypeStatus,
          'expQty' : selectedExp.toString(),
        });
      final Map<String, dynamic>? taskId = await Supabase.instance.client
          .from('tasks')
          .select('id')
          .eq('kidEmail', selectedKidEmail.toLowerCase())
          .eq('taskName', addTaskNameController.text)
          .eq('description', addTaskDescriptionController.text,)
          .maybeSingle();
      await Supabase.instance.client
          .from('wishes')
          .update({
        'assignedToTask': taskId?['id'],
        'isAssignedToMultitask': false,

      })
          .eq('wish', addTaskPriceController.text)
          .eq('kidEmail', selectedKidEmail.toLowerCase());
    final Map<String, dynamic>? kidDoc = await Supabase.instance.client
        .from('users')
        .select('fcmToken, notificationsNewTask')
        .eq('email', selectedKidEmail.toLowerCase())
        .maybeSingle();
    if(kidDoc != null){
      String? kidToken = kidDoc['fcmToken'];
      bool isNotification = kidDoc['notificationsNewTask'] ?? true;
      if (kidToken != null && isNotification) {
        sendNotificationToKid(kidToken, 'newTaskToDo'.tr(), parentName, addTaskNameController.text);
      }
    }
      addTaskNameController.clear();
      addTaskDescriptionController.clear();
      addTaskPriceController.clear();
      taskDeadline = DateTime.now();
      isDeadline = false;
      imageUrl = '';
      fileName = '';
      selectedKidName = '';
      selectedKidEmail = '';
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
          const MainParentScreen()));
    }else{
      sadToast('selectKid');
    }
    isLoading = false;
    notifyListeners();
  }

  Future addMultiTaskToBase(context)async{
    isLoading = true;
    notifyListeners();
    if(selectedKidName != ''){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic>? doc = await Supabase.instance.client
          .from('users')
          .select('name')
          .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '')
          .maybeSingle();
      String parentName = '';
      if(doc != null){
        parentName = doc['name'];
      }
      await Supabase.instance.client
          .from('multiTasks')
          .insert({
        'priceStatus': 'set',
        'parentName': parentName,
        'parentEmail': prefs.getString('email'),
        'kidName': selectedKidName,
        'kidEmail': selectedKidEmail,
        'taskName': addTaskNameController.text,
        'description': addTaskDescriptionController.text,
        'status': 'price',
        'price': addTaskPriceController.text,
        'stars' : '0',
        'imageUrl' : fileName == '' ? 'false' : imageUrl,
        'time' : DateTime.now().toString(),
        'type' : selectedTypeStatus,
        'expQty' : selectedExp.toString(),
        'daysNumber' : List.filled(daySlider.toInt(), 0),
      });
      final Map<String, dynamic>? taskId = await Supabase.instance.client
          .from('multiTasks')
          .select('id')
          .eq('kidEmail', selectedKidEmail.toLowerCase())
          .eq('taskName', addTaskNameController.text)
          .eq('description', addTaskDescriptionController.text,)
          .maybeSingle();
      await Supabase.instance.client
          .from('wishes')
          .update({
        'assignedToTask': taskId?['id'],
        'isAssignedToMultitask': true,

      })
          .eq('wish', addTaskPriceController.text)
          .eq('kidEmail', selectedKidEmail.toLowerCase());
      final Map<String, dynamic>? kidDoc = await Supabase.instance.client
          .from('users')
          .select('fcmToken, notificationsNewTask')
          .eq('email', selectedKidEmail.toLowerCase())
          .maybeSingle();
      if(kidDoc != null){
        String? kidToken = kidDoc['fcmToken'];
        bool isNotification = kidDoc['notificationsNewTask'] ?? true;
        if (kidToken != null && isNotification) {
          sendNotificationToKid(kidToken, 'newTaskToDo'.tr(), parentName, addTaskNameController.text);
        }
      }
      addTaskNameController.clear();
      addTaskDescriptionController.clear();
      addTaskPriceController.clear();
      isDeadline = false;
      imageUrl = '';
      fileName = '';
      selectedKidName = '';
      selectedKidEmail = '';
      daySlider = 5;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
          const MainParentScreen()));
    }else{
      sadToast('selectKid');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void>editSingleTaskInBase(context, String docId)async{
    await Supabase.instance.client
        .from('tasks')
        .update({
          'kidName': selectedKidName,
          'kidEmail': selectedKidEmail,
          'taskName': addTaskNameController.text,
          'description': addTaskDescriptionController.text,
          'price': addTaskPriceController.text,
          'deadline': isDeadline ? taskDeadline.toString() : 'false',
          'time' : DateTime.now().toString(),
          'type' : selectedTypeStatus,
          'expQty' : selectedExp.toString(),
        })
        .eq('id', docId);
    addTaskNameController.clear();
    addTaskDescriptionController.clear();
    addTaskPriceController.clear();
    taskDeadline = DateTime.now();
    isDeadline = false;
    imageUrl = '';
    fileName = '';
    selectedKidName = '';
    selectedKidEmail = '';
    selectedTypeStatus = 'home';
    selectedExp = 1;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const MainParentScreen()));
  }

  Future<void>editMultiTaskInBase(context, String docId)async{
    await Supabase.instance.client
        .from('multiTasks')
        .update({
          'kidName': selectedKidName,
          'kidEmail': selectedKidEmail,
          'taskName': addTaskNameController.text,
          'description': addTaskDescriptionController.text,
          'price': addTaskPriceController.text,
          'time': DateTime.now().toString(),
          'type': selectedTypeStatus,
          'expQty': selectedExp.toString(),
          'daysNumber': List.filled(daySlider.toInt(), 0)
        })
        .eq('id', docId);
    addTaskNameController.clear();
    addTaskDescriptionController.clear();
    addTaskPriceController.clear();
    taskDeadline = DateTime.now();
    imageUrl = '';
    fileName = '';
    selectedKidName = '';
    selectedKidEmail = '';
    selectedTypeStatus = 'home';
    selectedExp = 1;
    daySlider = 5;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const MainParentScreen()));
  }

  Future<void>saveTaskToHistory(String parentName, String parentEmail, String kidName, String kidEmail,
      String taskName, String description, String price, String stars, String type, String expQty)async {
    await Supabase.instance.client
        .from('history')
        .insert({
          'parentName': parentName,
          'parentEmail': parentEmail,
          'kidName': kidName,
          'kidEmail': kidEmail,
          'taskName': taskName,
          'description': description,
          'price': price,
          'stars' : stars,
          'time' : DateTime.now().toString(),
          'expQty' : expQty,
          'type' : type,
    });
  }

  Future<void>addTaskToHistory(context, Map<String, dynamic> snapshot,
      int index, String parentName, String parentEmail, String kidName, String kidEmail,
      String taskName, String description, String price, String stars, String url, String type, String expQty)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.3,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Text('addToHistoryQuestion'.tr(), style: kTextStyle,),
                  ButtonWidget(
                      onTap: () async {
                        saveTaskToHistory(parentName, parentEmail, kidName, kidEmail,
                            taskName, description, price, stars, type, expQty).then((v) async =>
                        await Supabase.instance.client
                            .from('tasks')
                            .delete()
                            .eq('id', snapshot['id']));
                        if(url != 'false'){
                        await Supabase.instance.client.storage
                            .from('images')
                            .remove([url]);
                        }
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                            role == 'parent'
                                ? const MainParentScreen()
                                : const MainKidScreen()));

                        },
                      text: 'add')
                ],
              )
          );
        });
  }

  Future<void>historyDescription(context, String price, String description,
  Map<String, dynamic> snapshot, int index,) async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.5,
              width: size.width,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Container(
                    height: 60,
                    width: size.width,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kBlue.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(4)
                      ),
                    ),
                    child: Text(snapshot['taskName'],
                      style: kBigTextStyle,),
                  ),
                  Container(
                    height: 200,
                    width: size.width,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: kBlue.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Text(snapshot['description'], style: kTextStyle),
                  ),
                  ButtonWidget(
                      onTap: () => deleteFromHistory(context, snapshot, index),
                      text: 'deleteFromHistory')
                ],
              )
          );
        });
  }

  Future<void>deleteFromHistory(context, Map<String, dynamic> snapshot, int index)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.15,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Center(child: Text('areYouSure'.tr(), style: kTextStyle,)),
                  TextButton(
                      onPressed: () async {
                        await Supabase.instance.client
                            .from('history')
                            .delete()
                            .eq('id', snapshot['id']);
                        if (!context.mounted) return;
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                            const ParentHistoryScreen()));
                      },
                      child: Text('yes'.tr(), style: kTextStyle,)
                  )
                ],
              )
          );
        });
  }

  Future searchSingleTaskForEditing(String docId) async{
    isEdit = true;
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('tasks')
        .select('kidName, taskName, kidEmail, description, price, deadline, imageUrl, type, expQty')
        .eq('id', docId)
        .maybeSingle();
    if(doc != null){
      selectedKidName = doc['kidName'];
      addTaskNameController.text = doc['taskName'];
      selectedKidEmail = doc['kidEmail'];
      addTaskDescriptionController.text = doc['description'];
      addTaskPriceController.text = doc['price'];
      taskDeadline = doc['deadline'] == 'false' ? DateTime.now() : DateTime.parse(doc['deadline']);
      isDeadline = doc['deadline'] == 'false' ? false : true;
      fileName = doc['imageUrl'];
      editDocId = docId;
      selectedTypeStatus = doc['type'] ?? 'home';
      selectedExp = int.tryParse(doc['expQty']) ?? 1;
      imageUrl = doc['imageUrl'];
    }
  }

  Future searchMultiTaskForEditing(String docId) async{
    isEdit = true;
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('multiTasks')
        .select('kidName, taskName, kidEmail, description, price, imageUrl, type, expQty, daysNumber')
        .eq('id', docId)
        .maybeSingle();
    if(doc != null){
      selectedKidName = doc['kidName'];
      addTaskNameController.text = doc['taskName'];
      selectedKidEmail = doc['kidEmail'];
      addTaskDescriptionController.text = doc['description'];
      addTaskPriceController.text = doc['price'];
      fileName = doc['imageUrl'];
      editDocId = docId;
      selectedTypeStatus = doc['type'] ?? 'home';
      selectedExp = int.tryParse(doc['expQty']) ?? 1;
      daySlider = double.parse(doc['daysNumber'].length.toString());
      imageUrl = doc['imageUrl'];
    }
  }

  Widget image(){
    if(isEdit){
      if(fileName == 'false'){
        return const SizedBox.shrink();
      }else if(fileName.contains('https://pwwvrdktfdzokxnovokf.supabase.co')){
        return Image.network(imageUrl);
      }
    }else{
      if(fileName == '' || file!.path == ''){
        return const Icon(Icons.camera_alt);
      }else{
        return Image.file(File(file!.path), fit: BoxFit.cover,);
      }
    }
    return const Center(child: SpinKitSpinningLines(
      color: kBlue,
      size: 40,
    ),);

  }

  void updateRating(double rating){
    stars = rating;
    notifyListeners();
  }

  void setTaskTime(DateTime time){
    taskDeadline = time;
    notifyListeners();
  }

  void setIsDeadline(bool value){
    isDeadline = value;
    notifyListeners();
  }

  void setLanguage(context, Locale locale){
    context.setLocale(locale);
    notifyListeners();
  }

  void setExp(int value){
    selectedExp = value;
    notifyListeners();
  }

  void changeTypeStatus(String type){
    selectedTypeStatus = type;
    notifyListeners();
    }

  void changeDaySlider(double v){
    daySlider = v;
    notifyListeners();
  }

  void switchTaskScreen(int index){
    taskPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut);
    pageIndex = index;
    notifyListeners();
  }

  Future<void> switchTodayTask(int index, String docId) async {
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('multiTasks')
        .select('daysNumber')
        .eq('id', docId)
        .maybeSingle();
    if(doc != null){
      List<dynamic> days = List.from(doc['daysNumber']);
      if (index >= 0 && index < days.length) {
        days[index] = days[index] == 0 ? 1 : 0;
      }
      await Supabase.instance.client
          .from('multiTasks')
          .update({'daysNumber': days})
          .eq('id', docId);
    }
  }

  int whatDayIs(String date) {
    DateTime dt = DateTime.parse(date);
    DateTime now = DateTime.now();
    DateTime newDay = DateTime(dt.year, dt.month, dt.day);
    DateTime today = DateTime(now.year, now.month, now.day);
    return today.difference(newDay).inDays;
  }

  int historyBoxSums(List<Map<String, dynamic>> snapshot, int index, String kidName) {
    Map<String, int> sums = {
      for (var t in taskTypes.keys.toList()) t: 0,
    };
    for (var doc in snapshot) {
      if (doc['parentEmail'].toLowerCase() == email && doc['kidName'] == kidName){
        String type = doc['type'];
        int qty = int.parse(doc['expQty']);
        if (sums.containsKey(type)) {
          sums[type] = sums[type]! + qty;
        }
      }
    }
    String typeKey = taskTypes.keys.toList()[index];
    return sums[typeKey] ?? 0;
  }


  Future changeDayDuration(context, String name, String start, String end, String email) async{
    Size size = MediaQuery.sizeOf(context);
    startHour = int.parse(start.split(':')[0]);
    startMinute = int.parse(start.split(':')[1]);
    startSecund = int.parse(start.split(':')[2]);
    endHour = int.parse(end.split(':')[0]);
    endMinute = int.parse(end.split(':')[1]);
    endSecund = int.parse(end.split(':')[2]);
    _startHourController = FixedExtentScrollController(initialItem: startHour - 4);
    _startMinController = FixedExtentScrollController(initialItem: startMinute);
    _endHourController = FixedExtentScrollController(initialItem: endHour - 18);
    _endMinController = FixedExtentScrollController(initialItem: endMinute);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.35,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Center(child: Text('setDayDurationFor'.tr(args: [name]), style: kTextStyle,)),
                  SizedBox(
                    height: size.height * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DayDurationScrollWidget(controller: _startHourController, timeValue: 'sh', from: 4, to: 10,),
                        Text(':', style: kTextStyle),
                        DayDurationScrollWidget(controller: _startMinController, timeValue: 'sm', from: 0, to: 59,),
                        Text('-', style: kTextStyle),
                        DayDurationScrollWidget(controller: _endHourController, timeValue: 'eh', from: 18, to: 23,),
                        Text(':', style: kTextStyle),
                        DayDurationScrollWidget(controller: _endMinController, timeValue: 'em', from: 0, to: 59,)
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        updateDayDuration(email);
                        Navigator.of(context).pop();
                      },
                      child: Text('ok'.tr(), style: kTextStyle,)
                  )
                ],
              )
          );
        });
  }

  void changeTimeValue(int value, String time){
  switch(time){
    case 'sh':
      startHour = value;
      break;
    case 'sm':
      startMinute = value;
      break;
    case 'eh':
      endHour = value;
      break;
    case 'em':
      endMinute = value;
      break;
  }
    notifyListeners();
  }

  Future<void> updateDayDuration(String email) async {
    await Supabase.instance.client
        .from('users')
        .update({
      'dayStart': '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}:00',
      'dayEnd': '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}:00',
         })
        .eq('email', email);
    getKids();
  }

  Future<void> sendNotificationToKid(String token, String title, String fromWho, String message) async {
    final dio = Dio();
    final serviceAccountJson = {
      "type": "service_account",
      "private_key_id": "any_random_id",
      "client_id": "123456789",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": dotenv.env['CLIENT_CERT_URL'].toString(),
      "project_id": dotenv.env['PROJECT_ID'].toString(),
      "private_key": dotenv.env['FIREBASE_PRIVATE_KEY']?.replaceAll(r'\n', '\n'),
      "client_email": dotenv.env['CLIENT_EMAIL'].toString(),
    };

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    try {
      final accountCredentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
      final client = await auth.clientViaServiceAccount(accountCredentials, scopes);
      final accessToken = client.credentials.accessToken.data;

      final response = await dio.post(
        'https://fcm.googleapis.com/v1/projects/${serviceAccountJson['project_id']}/messages:send',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          "message": {
            "token": token,
            "notification": {
              "title": '$title $fromWho',
              "body": message
            },
            "android": {
              "priority": "high",
              "notification": {
                "channel_id": "high_importance_channel",
                 "icon": "ic_launcher",
              }
            }
          }
        },
      );
      if (response.statusCode == 200) {
        log("Notification sent successfully");
      }
      client.close();
    } on DioException catch (e) {
      log("Error Dio: ${e.response?.data ?? e.message}");
    } catch (e) {
      log("error: $e");
    }
  }

  Future<void> getSmartAdDescription(context)async {
    isLoading = true;
    notifyListeners();
    Locale myLocale = Localizations.localeOf(context);
    String language = myLocale.languageCode;
    final prompt = [
      Content.multi([
        TextPart(
          "Jesteś profesjonalnym, kreatywnym asystentem copywritera reklamowego mówiącym po polsku. "
              "Twoim zadaniem jest stworzenie chwytliwego, sprzedażowego opisu reklamowego dla produktu, "
              "używając podanych słów kluczowych: '${addTaskDescriptionController.text.trim()}'. "
              "Opis musi mieć maksymalnie 128 symboli, zakładaj że spacja też symbol. Nie używaj hasztagów ani emotikonów."
              "Tylko opis, żadnych dodatkowych informacji"
              "Opis ma być w języku $language",
        ),
      ]),
    ];
    try {
      final response = await aiModel.generateContent(prompt);

      if (response.text != null) {
        addTaskDescriptionController.text = response.text ?? '';
      } else {
        throw Exception('empty response');
      }
    } catch (e) {
      log('Gemini error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future addAdToBase(context)async{
    isLoading = true;
    notifyListeners();
    if(selectedKidName != ''){
      await Supabase.instance.client
          .from('users')
          .update({
            'adTitle': addTaskNameController.text,
            'adDescription': addTaskDescriptionController.text,
            'adImageUrl': fileName == '' ? 'false' : imageUrl,
            'adEndTime': DateTime.now().add(Duration(days: daySlider.toInt())).toString(),
          })
          .eq('email', selectedKidEmail.toLowerCase().trim());
      addTaskNameController.clear();
      addTaskDescriptionController.clear();
      imageUrl = '';
      fileName = '';
      selectedKidName = '';
      selectedKidEmail = '';
      daySlider = 5;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
          const AdsListScreen()));
    }else{
      sadToast('selectKid');
    }
    isLoading = false;
    notifyListeners();
  }

  void changeAdTexts(String value, bool title){
    title
        ? addTaskNameController.text = value
        : addTaskDescriptionController.text = value;
    notifyListeners();
  }

  Future deleteAdDialog(context, String imageUrl, int index) async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.25,
              width: size.width,
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ],
                  ),
                  Column(
                    children: [
                      Text('beforeAddingNewAd'.tr(), style: kTextStyle,),
                      Text('timeLeft'.tr(args: [getTimeLeft(kidsList[index].adEndTime)]),
                        style: kBigTextStyle,),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: ButtonWidget(
                        onTap: () => deleteAd(context, imageUrl),
                        text: 'okIWantToAddNew',
                        width: 0.55,
                    ),
                  ),
                ],
              )
          );
        });
  }

  Future deleteAd(context, String imageUrl)async {
    await Supabase.instance.client
        .from('users')
        .update({
          'adTitle': '',
          'adDescription': '',
          'adImageUrl': '',
          'adEndTime': '',
        })
        .eq('email', selectedKidEmail.toLowerCase().trim());
    if(imageUrl != 'false'){
      await Supabase.instance.client.storage
          .from('images')
          .remove([imageUrl.split('/').last]);
    }
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const AddAdsScreen()));
  }

  String getTimeLeft(String adEndTime) {
    final DateTime end = DateTime.parse(adEndTime);
    final DateTime now = DateTime.now();
    final Duration difference = end.difference(now);

    if (difference.isNegative) {
      return 'expired'.tr();
    }
    final int days = difference.inDays;
    final int hours = difference.inHours % 24;
    final int minutes = difference.inMinutes % 60;
    if (days >= 1) {
      return '$days ${'days'.tr()} $hours ${'hours'.tr()}';
    } else if (hours >= 1) {
      return '$hours ${'hours'.tr()} $minutes ${'min'.tr()}';
    } else {
      return '$minutes ${'min'.tr()}';
    }
  }

  String getPriceFromDays(double value) {
    Map<int, String> values = {
      5: '3',
      10: '5',
      15: '7',
      20: '9',
      25: '11',
      30: '13',
    };
    return values[value] ?? value.toStringAsFixed(0);
  }

  Future<void> deleteWish(context, String id)async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.25,
              width: size.width,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 300),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('deleteThisWish'.tr(), style: kBigTextStyle,),
                      Text('deleteThisWishDescription'.tr(),
                        style: kTextStyle,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                      KidRoundButton(
                        onTap: () async {
                          final image = await Supabase.instance.client
                              .from('wishes')
                              .select('imageUrl')
                              .eq('id', id)
                              .maybeSingle();
                          await Supabase.instance.client
                              .from('wishes')
                              .delete()
                              .eq('id', id);
                          if(image?['imageUrl'] != null){
                            await Supabase.instance.client.storage
                                .from('images')
                                .remove([image?['imageUrl']]);
                          }
                        },
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ],
              )
          );
        });
  }

  Future<void> showSelectAddedTaskDialog(context)async{
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SafeArea(
            child: Container(
                height: size.height * 0.35,
                width: size.width,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                child: Column(
                  spacing: 18,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('whatTaskWillAdd'.tr(), style: kBigTextStyle,),
                    Column(
                      spacing: 12,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const AddSingleTaskScreen())),
                          child: Container(
                            width: size.width,
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kBlue.withValues(alpha: 0.1),
                              border: Border.all(color: kBlue, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text('singleTask'.tr(), style: kBigTextStyle),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const AddMultiTaskScreen())),
                          child: Container(
                            width: size.width,
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kBlue.withValues(alpha: 0.1),
                              border: Border.all(color: kBlue, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text('multiTask'.tr(), style: kBigTextStyle),
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Text('mainParentInfo'.tr(), style: kTextStyle,)),
                  ],
                )
            ),
          );
        });
  }


}