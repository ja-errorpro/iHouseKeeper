import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

enum map_type {
  water_electricity('水電維修'),
  house_decoration('房屋裝修'),
  movingNtransportation('搬家清運'),
  house_cleaning('家事清潔'),
  transportation('交通接送'),
  emergency('緊急救援'),
  body_care('身體照顧'),
  pharmacy('藥局找'),
  group_buying('團購找'),
  group_course('成長課程'),
  outings('結伴郊遊');

  const map_type(this.name);
  final String name;
}

extension map_type_extension on Map<map_type, int> {
  Map<String, int> get toMapString {
    Map<String, int> map = {};
    forEach((key, value) {
      map[key.name] = value;
    });
    return map;
  }
}

class CreateMapWidget extends StatefulWidget {
  Uri? url;
  CreateMapWidget(Uri url) {
    this.url = url;
  }

  @override
  MapState createState() => MapState(url!);
}

class MapState extends State<CreateMapWidget> {
  Uri? url;
  MapState(Uri url) {
    // super.initState();
    this.url = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("搜尋結果"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(this.url!)),
        initialSettings: InAppWebViewSettings(
          clearCache: true,
          cacheEnabled: false,
          transparentBackground: true,
        ),
        gestureRecognizers: {
          Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
          ),
        },
        onGeolocationPermissionsShowPrompt: (controller, origin) async {
          return GeolocationPermissionShowPromptResponse(
            origin: origin,
            allow: true,
            retain: true,
          );
        },
      ),
    );
  }
}

class TypeTapCountsRecord {
  map_type type;
  int count;
  TypeTapCountsRecord({required this.type, required this.count});
}

extension TypeTapCountsRecordExtension on TypeTapCountsRecord {
  Map<String, int> get toMapString {
    Map<String, int> map = {};
    map[type.name] = count;
    return map;
  }

  set fromMapString(Map<String, int> map) {
    map.forEach((key, value) {
      type = map_type.values.firstWhere((element) => element.name == key);
      count = value;
    });
  }
}

class DataBaseProvider {
  static final DataBaseProvider _instance = DataBaseProvider._internal();
  static Database? _database;
  DataBaseProvider._internal();

  factory DataBaseProvider() {
    return _instance;
  }

  Future<Database> getDBConnect() async {
    if (_database != null) {
      return _database!;
    }
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return _database ??= await openDatabase(
      join(await getDatabasesPath(), 'tapdata.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tap_counts(type TEXT PRIMARY KEY, count INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future insert(TypeTapCountsRecord records) async {
    final db = await getDBConnect();
    await db.insert(
      'tap_counts',
      records.toMapString,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future insertAllType() async {
    final db = await getDBConnect();
    map_type.values.forEach((element) async {
      await db.insert(
        'tap_counts',
        {'type': element.name, 'count': 0},
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    });
  }

  Future<List<TypeTapCountsRecord>> queryAll() async {
    final db = await getDBConnect();
    final List<Map<String, dynamic>> maps = await db.query('tap_counts');
    return List.generate(maps.length, (i) {
      return TypeTapCountsRecord(
        type: map_type.values.firstWhere(
            (element) => element.name == maps[i]['type'].toString()),
        count: maps[i]['count'],
      );
    });
  }

  Future update(TypeTapCountsRecord records) async {
    final db = await getDBConnect();
    await db.update(
      'tap_counts',
      records.toMapString,
      where: 'type = ?',
      whereArgs: [records.type.name],
    );
  }

  Future delete(TypeTapCountsRecord records) async {
    final db = await getDBConnect();
    await db.delete(
      'tap_counts',
      where: 'type = ?',
      whereArgs: [records.type.name],
    );
  }

  Future close() async {
    final db = await getDBConnect();
    db.close();
  }

  Future<int> getCount(map_type type) async {
    final db = await getDBConnect();
    final List<Map<String, dynamic>> maps = await db.query('tap_counts',
        columns: ['count'], where: 'type = ?', whereArgs: [type.name]);
    if (maps.isNotEmpty) {
      return maps.first['count'];
    }
    print("get 0");
    return 0;
  }

  Future<int> updateCount(map_type type, int count) async {
    final db = await getDBConnect();
    print("updateCount: ${type.name}, $count");
    return await db.update('tap_counts', {'count': count},
        where: 'type = ?', whereArgs: [type.name]);
  }

  Future<int> insertCount(map_type type, int count) async {
    final db = await getDBConnect();
    return await db.insert('tap_counts', {'type': type.name, 'count': count},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteCount(map_type type) async {
    final db = await getDBConnect();
    return await db.delete('tap_counts', where: 'type = ?', whereArgs: [type]);
  }

  Future<int> increment1(map_type type) async {
    int count = await getCount(type);
    return await updateCount(type, count + 1);
  }
}

class Events {
  static Map<map_type, Uri> map_urls = {
    map_type.water_electricity: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E6%B0%B4%E9%9B%BB%E7%B6%AD%E4%BF%AE'),
    map_type.house_decoration: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E6%88%BF%E5%B1%8B%E8%A3%9D%E4%BF%AE'),
    map_type.movingNtransportation: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E6%90%AC%E5%AE%B6%E6%B8%85%E9%81%8B'),
    map_type.house_cleaning: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E5%AE%B6%E4%BA%8B%E6%B8%85%E6%BD%94'),
    map_type.transportation: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E4%BA%A4%E9%80%9A%E6%8E%A5%E9%80%81'),
    map_type.emergency: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E7%B7%8A%E6%80%A5%E6%95%91%E6%8F%B4'),
    map_type.body_care: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E8%BA%AB%E9%AB%94%E7%85%A7%E9%A1%A7'),
    map_type.pharmacy: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E8%97%A5%E5%B1%80%E6%89%BE'),
    map_type.group_buying: Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=%E5%9C%98%E8%B3%BC%E6%89%BE'),
    map_type.group_course: Uri.parse(''),
  };

  static Map<map_type, String> map_names = {
    map_type.water_electricity: '水電維修',
    map_type.house_decoration: '房屋裝修',
    map_type.movingNtransportation: '搬家清運',
    map_type.house_cleaning: '家事清潔',
    map_type.transportation: '交通接送',
    map_type.emergency: '緊急救援',
    map_type.body_care: '身體照顧',
    map_type.pharmacy: '藥局找',
    map_type.group_buying: '團購找',
    map_type.group_course: '成長課程',
    map_type.outings: '旅行社',
  };

  static openMap(BuildContext context, map_type? type) {
    if (type == null) {
      print('Warn: openMap() type is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Warn: openMap() type is null'),
        ),
      );
      return;
    }

    DataBaseProvider db = DataBaseProvider();
    db.increment1(type).then((t) {
      FirebaseAnalytics.instance.logEvent(name: 'openMap', parameters: {
        'type': type.name,
      });
      MapsLauncher.launchQuery(map_names[type]!);
    });

    // debug
    /*
    db.queryAll().then((value) {
      value.forEach((element) {
        print('${element.type.name}: ${element.count}');
      });
    });*/
  }

  static openMyFavorite(BuildContext context) {
    List<TypeTapCountsRecord> records = [];

    // query from database and get records
    DataBaseProvider db = DataBaseProvider();
    db.queryAll().then((value) {
      records = value;
      value.forEach((element) {
        print('value: ${element.type.name}: ${element.count}');
      });
      records.sort((a, b) => b.count.compareTo(a.count));
      records.forEach((element) {
        print('list: ${element.type.name}: ${element.count}');
      });

      // show dialog with sorted list
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('我的最愛'),
            content: SizedBox(
              height: 300,
              width: 300,
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(records[index].type.name),
                    onTap: () {
                      Navigator.of(context).pop();
                      openMap(context, records[index].type);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('關閉'),
              ),
            ],
          );
        },
      );
    });
  }
}
