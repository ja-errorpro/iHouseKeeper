import 'package:flutter/material.dart';
import 'package:ihousekeeper/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ihousekeeper/buttons.dart';
import 'package:ihousekeeper/button_tap_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    print("Firebase initialize error: $e");
  }
  await FirebaseAnalytics.instance.logAppOpen();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataBaseProvider db = DataBaseProvider();

    // in first time, insert all type with 0 count
    // get if database is empty
    db.queryAll().then((value) {
      if (value.isEmpty) {
        // insert all type with 0 count
        db.insertAllType();
      }
    });

    return const MaterialApp(
      title: 'i管家',
      home: MainScreen(),
    ); // MaterialApp
  } // build()
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var permission_manager = PermissionManager();
    // p.getPermission(context, Permission.storage);
    permission_manager.message = '地圖功能需要定位權限，請同意權限以繼續使用';
    permission_manager.getPermission(context, Permission.location);
    // p.getPermission(context, Permission.photos);
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      if (orientation == Orientation.portrait) {
        // vertical layout
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 252, 252, 132),
            appBar: AppBar(title: const Text('i 管家')),
            body: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Buttons.getButton(
                      '水電維修',
                      'assets/images/水電.png',
                      () =>
                          Events.openMap(context, map_type.water_electricity)),
                  Buttons.getButton('房屋裝修', 'assets/images/房屋裝修.png',
                      () => Events.openMap(context, map_type.house_decoration)),
                  Buttons.getButton(
                      '搬家清運',
                      'assets/images/搬家.png',
                      () => Events.openMap(
                          context, map_type.movingNtransportation)),
                ]), // Row
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Buttons.getButton('家事清潔', 'assets/images/清潔.png',
                      () => Events.openMap(context, map_type.house_cleaning)),
                  Buttons.getButton('交通接送', 'assets/images/接送.png',
                      () => Events.openMap(context, map_type.transportation)),
                  Buttons.getButton('緊急救援', 'assets/images/急救.png',
                      () => Events.openMap(context, map_type.emergency)),
                ]), // Row
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Buttons.getButton('身體照顧', 'assets/images/身體照顧.png',
                      () => Events.openMap(context, map_type.body_care)),
                  Buttons.getButton('藥局找', 'assets/images/藥局找.png',
                      () => Events.openMap(context, map_type.pharmacy)),
                  Buttons.getButton('團購找', 'assets/images/團購找.png',
                      () => Events.openMap(context, map_type.group_buying)),
                ]), // Row
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Buttons.getButton('成長課程', 'assets/images/活動課程.png',
                      () => Events.openMap(context, map_type.group_course)),
                  Buttons.getButton('結伴郊遊', 'assets/images/郊遊.png',
                      () => Events.openMap(context, map_type.outings)),
                  Buttons.getButton('我的最愛', 'assets/images/我的最愛.png',
                      () => Events.openMyFavorite(context)),
                ])
              ],
            ));
      } else {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 252, 252, 132),
            appBar: AppBar(title: const Text('i 管家')),
            body: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Buttons.getButton(
                      '水電維修',
                      'assets/images/水電.png',
                      () =>
                          Events.openMap(context, map_type.water_electricity)),
                  Buttons.getButton('房屋裝修', 'assets/images/房屋裝修.png',
                      () => Events.openMap(context, map_type.house_decoration)),
                  Buttons.getButton(
                      '搬家清運',
                      'assets/images/搬家.png',
                      () => Events.openMap(
                          context, map_type.movingNtransportation)),
                  Buttons.getButton('家事清潔', 'assets/images/清潔.png',
                      () => Events.openMap(context, map_type.house_cleaning)),
                ]), // Row
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Buttons.getButton('交通接送', 'assets/images/接送.png',
                      () => Events.openMap(context, map_type.transportation)),
                  Buttons.getButton('緊急救援', 'assets/images/急救.png',
                      () => Events.openMap(context, map_type.emergency)),
                  Buttons.getButton('身體照顧', 'assets/images/身體照顧.png',
                      () => Events.openMap(context, map_type.body_care)),
                  Buttons.getButton('藥局找', 'assets/images/藥局找.png',
                      () => Events.openMap(context, map_type.pharmacy)),
                ]), // Row
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Buttons.getButton('團購找', 'assets/images/團購找.png',
                      () => Events.openMap(context, map_type.group_buying)),
                  Buttons.getButton('成長課程', 'assets/images/活動課程.png',
                      () => Events.openMap(context, map_type.group_course)),
                  Buttons.getButton('結伴郊遊', 'assets/images/郊遊.png',
                      () => Events.openMap(context, map_type.outings)),
                  Buttons.getButton('我的最愛', 'assets/images/我的最愛.png',
                      () => Events.openMyFavorite(context)),
                ]) // Row
              ],
            ));
      }
    });

    //return ; // Scaffold
  } // build()
}
