import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
  outings('結伴郊遊'),
  my_favorite('我的最愛');

  const map_type(this.name);
  final String name;
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
    map_type.my_favorite: '我的最愛',
  };

  static openMap(BuildContext context, map_type? type) {
    if (type == null) {
      print('openMap: type is null');
      return;
    }
    // Uri url = map_urls[type];
    //Navigator.push(
    //    context, MaterialPageRoute(builder: (context) => CreateMapWidget(url)));
    MapsLauncher.launchQuery(map_names[type]!);
  }

  static openMyFavorite(BuildContext context) {
    print('openMyFavorite');
  }
}
