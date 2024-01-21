import 'package:flutter/material.dart';
import 'package:ihousekeeper/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ihousekeeper/buttons.dart';
import 'package:ihousekeeper/button_tap_events.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'iHouseKeeper',
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
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 252, 132),
        appBar: AppBar(title: const Text('iHouseKeeper')),
        body: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Buttons.getButton('水電維修', 'assets/images/water_electricity.png',
                  () => Events.openMap(context, map_type.water_electricity)),
              Buttons.getButton('房屋裝修', 'assets/images/house_decoration.jpg',
                  () => Events.openMap(context, map_type.house_decoration)),
              Buttons.getButton(
                  '搬家清運',
                  'assets/images/movingNtransportation.jpg',
                  () =>
                      Events.openMap(context, map_type.movingNtransportation)),
              Buttons.getButton('家事清潔', 'assets/images/house_cleaning.jpg',
                  () => Events.openMap(context, map_type.house_cleaning)),
            ]), // Row
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Buttons.getButton('交通接送', 'assets/images/transportation.jpg',
                  () => Events.openMap(context, map_type.transportation)),
              Buttons.getButton('緊急救援', 'assets/images/emergency.jpg',
                  () => Events.openMap(context, map_type.emergency)),
              Buttons.getButton('身體照顧', 'assets/images/body_care.jpg',
                  () => Events.openMap(context, map_type.body_care)),
              Buttons.getButton('藥局找', 'assets/images/pharmacy.jpg',
                  () => Events.openMap(context, map_type.pharmacy)),
            ]), // Row
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Buttons.getButton('團購找', 'assets/images/group_buying.jpg',
                  () => Events.openMap(context, map_type.group_buying)),
              Buttons.getButton('成長課程', 'assets/images/growth_course.jpg',
                  () => Events.openMap(context, map_type.group_course)),
              Buttons.getButton('結伴郊遊', 'assets/images/outing.jpg',
                  () => Events.openMap(context, map_type.outings)),
              Buttons.getButton('我的最愛', 'assets/images/my_favourite.jpg',
                  () => Events.openMyFavorite(context)),
            ]) // Row
          ],
        )); // Scaffold
  } // build()
}
