import 'package:flutter/material.dart';
import 'package:ihousekeeper/permission.dart';
import 'package:permission_handler/permission_handler.dart';

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
        appBar: AppBar(title: const Text('iHouseKeeper')),
        body: Center(
            child: Row(children: [
          InkWell(
            child: const Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/images/water_electricity.png'),
                    width: 100,
                  ),
                ),
                Text('水電維修')
              ],
            ), // Column
            onTap: () {},
          ),
          InkWell(
            child: const Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/images/house_decoration.jpg'),
                    width: 100,
                  ),
                ),
                Text('房屋裝修')
              ],
            ), // Column
            onTap: () {},
          ), // InkWell// InkWell
        ]))); // Scaffold
  } // build()
}
