import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/screens/kid_screens/save_money_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants.dart';
import '../models/durations_model.dart';
import '../screens/kid_screens/wishes_screen.dart';
import '../screens/kid_screens/kids_settings_screen.dart';
import '../screens/kid_screens/main_kid_screen.dart';
import '../widgets/kids_widgets/add_save_money_widget.dart';
import '../widgets/toasts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class KidProvider with ChangeNotifier {

  late Future<void> getParent;
  late Future<void> getDayDuration;
  Map<String, String> parentsList = {};
  List<bool> parentsListAccept = [];
  List<String> parentsEmailsList = [];
  String imageUrl = '';
  String fileName = '';
  late Reference imageToUpload;
  late XFile? file;
  bool isLoading = false;
  bool isDay = false;
  String startDayTime = '';
  String endDateTime = '';
  String dayDuration = '';
  List<DurationsModel> durationsList = [];

  final Map<IconData, Widget> routes = {
    Icons.home: MainKidScreen(),
    Icons.monetization_on_sharp: SaveMoneyScreen(),
    Icons.settings: KidsSettingsScreen(),
    Icons.favorite: WishesScreen(),
  };

  IconData selectedRoute = Icons.home;
  int totalBanknotesSum = 0;

  Map<String, bool> selectedParentsEmail = {};

  final GlobalKey<FormState> saveMoneyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> wishKey = GlobalKey<FormState>();

  TextEditingController addWishNameController = TextEditingController();
  TextEditingController addWishDescriptionController = TextEditingController();
  TextEditingController whatDoYoWantController = TextEditingController();
  TextEditingController whatDoYoWantPriceController = TextEditingController();
  TextEditingController whyYouNeedThisController = TextEditingController();
  TextEditingController addMoneyController = TextEditingController();

  bool settingsKidInfo = false;

  Map <String, int> savedMoney = {
    '1': 0,
    '2': 0,
    '5': 0,
    '10': 0,
    '20': 0,
    '50': 0,
    '100': 0,
  };

  void switchSettingsKidInfo(){
    settingsKidInfo = !settingsKidInfo;
    notifyListeners();
  }

  void getParentsData(){
    getParent = getParents();
  }

  void getDayDurationData(context){
    getDayDuration = getDurations(context);
  }

  Future<void> getParents() async{
    parentsList.clear();
    parentsListAccept.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('users')
        .select('kid0, kid0Accept, kid1, kid1Accept, kid2, kid2Accept, kid3, kid3Accept, kid4, kid4Accept, kid5, kid5Accept')
        .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '')
        .maybeSingle();
    for(int k = 0; k < 6; k++){
      if(doc != null){
        final Map<String, dynamic>? docEmail = await Supabase.instance.client
            .from('users')
            .select('kid0, kid0Accept, kid1, kid1Accept, kid2, kid2Accept, kid3, kid3Accept, kid4, kid4Accept, kid5, kid5Accept, name',)
            .eq('email', doc['kid$k'])
            .maybeSingle();
        if(docEmail != null){
          parentsList.addAll({'${docEmail['name']}': '${doc['kid$k']}'});
          selectedParentsEmail.addAll({'${doc['kid$k']}': true});
          parentsListAccept.add(doc['kid${k}Accept']);
          parentsEmailsList.add(doc['kid$k']);
        }
        notifyListeners();
      }
    }
  }

  Future acceptParent(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? myEmail = prefs.getString('email')?.toLowerCase();
    final String parentEmail = parentsEmailsList[index].toLowerCase();

    if (myEmail == null) return;

    final Map<String, dynamic>? docEmail = await Supabase.instance.client
        .from('users')
        .select('kid0, kid0Accept, kid1, kid1Accept, kid2, kid2Accept, kid3, kid3Accept, kid4, kid4Accept, kid5, kid5Accept, name',)
        .eq('email', myEmail)
        .maybeSingle();

    if (docEmail != null) {
      for (int k = 0; k < 6; k++) {
        if (docEmail['kid$k'] == parentEmail) {
          await Supabase.instance.client
              .from('users')
              .update({'kid${k}Accept': true,})
              .eq('email', myEmail);
          break;
        }
      }
    }
    final Map<String, dynamic>? parentDoc = await Supabase.instance.client
        .from('users')
        .select('kid0, kid0Accept, kid1, kid1Accept, kid2, kid2Accept, kid3, kid3Accept, kid4, kid4Accept, kid5, kid5Accept, name',)
        .eq('email', parentEmail)
        .maybeSingle();

    if (parentDoc != null) {
      for (int k = 0; k < 6; k++) {
        if (parentDoc['kid$k'] == myEmail) {
          await Supabase.instance.client
              .from('users')
              .update({'kid${k}Accept': true,})
              .eq('email', parentEmail);
          break;
        }
      }
    }
    getParentsData();
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

  Future addWishToBase(context)async{
    isLoading = true;
    notifyListeners();
      List parents = [];
      for(var p in selectedParentsEmail.entries) {
        if (p.value == true) {
          parents.add(p.key);
        }
      }
    if(parents.isNotEmpty){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('users')
        .select('name')
        .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '')
        .maybeSingle();

        String name = '';
        if(doc != null){
          name = doc['name'];
        }
    await Supabase.instance.client
        .from('wishes')
        .insert({
      'wish': addWishNameController.text,
      'whyNeed': addWishDescriptionController.text,
      'kidEmail': prefs.getString('email'),
      'kidName' : name,
      'parent0Name': parents.isNotEmpty ? parents[0] : '',
      'parent1Name': parents.length > 1 ? parents[1] : '',
      'parent2Name': parents.length > 2 ? parents[2] : '',
      'parent3Name': parents.length > 3 ? parents[3] : '',
      'parent4Name': parents.length > 4 ? parents[4] : '',
      'imageUrl' : fileName == '' ? 'false' : imageUrl,
      'time' : DateTime.now().toString(),
      'assignedToTask' : '',
      'isAssignedToMultitask' : false,
    });
        addWishNameController.clear();
        addWishDescriptionController.clear();
        imageUrl = '';
        fileName = '';
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>
            const WishesScreen()));
      }else{
        sadToast('selectParent');
      }
    isLoading = false;
    notifyListeners();
  }

  void selectParent(String key, bool value){
    selectedParentsEmail.update(key,(value) => value = !value);
    notifyListeners();
  }

  Future showWishDescription(context, Map<String, dynamic> snapshot, int index) {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: size.height,
              width: size.width,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
             child: Image.network(snapshot['imageUrl'],
                 fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) {
                   return const Center(
                     child: Icon(Icons.warning, color: kOrange,),
                   );
                 }),
            ),
          );
        });
  }

  void switchDay(context, String endTime) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = Provider.of<ParentProvider>(context, listen: false);
    isDay = !isDay;
    if(isDay){
      prefs.setString('endDateTime', endTime);
      prefs.setString('today', DateFormat('dd.MM.yyyy').format(DateTime.parse(DateTime.now().toString())));
      endDateTime = endTime;
      final Map<String, dynamic>? doc = await Supabase.instance.client
          .from('users')
          .select('dayStart, dayEnd')
          .eq('email', data.email.toString())
          .maybeSingle();
      if (doc != null){
        await Supabase.instance.client
            .from('daysDuration')
            .upsert({
          'email': data.email,
          'day': DateFormat('dd.MM.yyyy').format(DateTime.parse(DateTime.now().toString())),
          'start': DateTime.now().toString(),
          'end' : '',
          'parentStart': doc['dayStart'],
          'parentEnd': doc['dayEnd'],
        },
            onConflict: 'email, day');
      }
      startDayTime = DateFormat('HH:mm:ss').format(DateTime.parse(DateTime.now().toString()));
      prefs.setString('startDayTime', startDayTime);
    }else{
      final Map<String, dynamic>? time = await Supabase.instance.client
          .from('daysDuration')
          .select('start')
          .eq('email', data.email.toString())
          .eq('day', DateFormat('dd.MM.yyyy').format(DateTime.parse(DateTime.now().toString())),)
          .maybeSingle();
      if (time != null){
        await Supabase.instance.client
            .from('daysDuration')
            .update({
          'end' : DateTime.now().toString(),
          'duration' : DateTime.now().difference(DateTime.parse(time['start'])).toString(),
        })
            .eq('email', data.email.toString())
            .eq('day', prefs.getString('today').toString());
      }
      endDateTime = DateFormat('HH:mm:ss').format(
          DateTime.parse(DateTime.now().toString()));
      prefs.setString('endDateTime', endDateTime);

    }
    prefs.setBool('isDay', isDay);
    notifyListeners();
  }

  void initTimes(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = Provider.of<ParentProvider>(context, listen: false);
    isDay = prefs.getBool('isDay') ?? false;
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('daysDuration')
        .select('start, end')
        .eq('email', data.email.toString())
        .eq('day', DateFormat('dd.MM.yyyy').format(DateTime.parse(DateTime.now().toString())))
        .maybeSingle();
    if (doc != null){
      startDayTime = doc['start'] != null && doc['start'] != ''
          ? DateFormat('HH:mm:ss').format(DateTime.parse(doc['start']))
          : '06:00:00';
      endDateTime = doc['end'] != null && doc['end'] != ''
          ? DateFormat('HH:mm:ss').format(DateTime.parse(doc['end']))
          : '22:00:00';
    }else{
      startDayTime = '06:00:00';
      endDateTime = '22:00:00';
    }
    prefs.setString('startDayTime', startDayTime);
    prefs.setString('endDayTime', endDateTime);
    notifyListeners();
  }

  Future<void>saveSaveMoneyItem(context)async {
    isLoading = true;
    notifyListeners();
    await Supabase.instance.client
        .from('saveMoney')
        .insert({
      'whatIsIt': whatDoYoWantController.text,
      'price': whatDoYoWantPriceController.text,
      'whyNeed': whyYouNeedThisController.text,
      'currency': 'pln',
      'parentMoney': 0,
      'imageUrl': fileName == '' ? 'false' : imageUrl,
      'money': <int>[],
      'time': DateTime.now().toString(),
    });
    whatDoYoWantController.clear();
    whatDoYoWantPriceController.clear();
    whyYouNeedThisController.clear();
    imageUrl = '';
    fileName = '';
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const SaveMoneyScreen()));
    isLoading = false;
    notifyListeners();
  }

  Future showToAddMoney(context, String id) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SafeArea(
            child: AddSaveMoneyWidget(id: id)
          );
        });
  }

  Future<void> updateMoney(context, String id)async{
    final Map<String, dynamic>? doc = await Supabase.instance.client
        .from('saveMoney')
        .select('money')
        .eq('id', id)
        .maybeSingle();
    List<dynamic> moneyList = List.from(doc?['money']);
    moneyList.add('$totalBanknotesSum/${DateTime.now().toString()}');
    await Supabase.instance.client
        .from('saveMoney')
        .update({'money': moneyList})
        .eq('id', id);
    totalBanknotesSum = 0;
    savedMoney = {
      '1': 0,
      '2': 0,
      '5': 0,
      '10': 0,
      '20': 0,
      '50': 0,
      '100': 0,
    };
    Navigator.of(context).pop();
  }

  Future<void> setupKidNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();

      if (token != null) {
        await Supabase.instance.client
            .from('users')
            .update({'fcmToken': token})
            .eq('email', prefs.getString('email')?.toLowerCase().trim() ?? '');
      }
    } else {
      log('noPermission');
    }
  }

  Future<void> updateTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTime = prefs.getString('startDayTime');

    if (savedTime == null || !savedTime.contains(':')) {
      dayDuration = "00:00:00";
      notifyListeners();
      return;
    }
    final now = DateTime.now();
    final parts = savedTime.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    final int second = parts.length > 2 ? int.parse(parts[2]) : 0;
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      second,
    );
    Duration duration = now.difference(startDateTime);
    if (duration.isNegative) {
      duration += const Duration(hours: 24);
    }

    dayDuration = formatDuration(duration);
    notifyListeners();

  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  String get selectedParentsDisplay {
    final selectedNames = parentsList.entries
        .where((e) => selectedParentsEmail[e.value] == true)
        .map((e) => e.key);
    if (selectedNames.isEmpty) {
      return 'selectAtLeastOneParent'.tr();
    }
    return 'canSeeAndAddToTasks'.tr(args: [selectedNames.join(' and ')]);
  }

  void updateBanknote(String key, int value, bool increment) {
    increment
     ? savedMoney.update(key, (value) => value = value + 1)
     : value == 0
      ? null
      : savedMoney.update(key, (value) => value = value - 1);
    notifyListeners();
  }

  Future<String> getTaskName(String wishId, bool isMultitask) async {
    final supabase = Supabase.instance.client;
    final table = isMultitask ? 'multiTasks' : 'tasks';

    final id = await supabase
        .from('wishes')
        .select('assignedToTask')
        .eq('id', wishId)
        .maybeSingle();

    final data = await supabase
        .from(table)
        .select('taskName')
        .eq('id', id?['assignedToTask'])
        .maybeSingle();

    return data?['taskName'] ?? 'NoTask';
  }

  Future<void> getDurations(context) async{
    final data = Provider.of<ParentProvider>(context, listen: false);
    final PostgrestList durations = await Supabase.instance.client
        .from('daysDuration')
        .select('*')
        .eq('email', data.email.toString())
        .order('start', ascending: true);

    durationsList.clear();

    for (var d in durations) {
      final duration = DurationsModel(
          day: d['day'] ?? '',
          start: d['start'] ?? '',
          end: d['end'] ?? '',
          parentStart: d['parentStart'] ?? '',
          parentEnd: d['parentEnd'] ?? '',
          duration: d['duration'] ?? '',
      );
      durationsList.add(duration);
    }
    for(var d in durationsList) {
      log('day ${d.day} start ${d.start} end ${d.end} parentStart ${d.parentStart} parentEnd ${d.parentEnd} duration ${d.duration}');
    }
    notifyListeners();
  }

}