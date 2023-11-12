import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> getPermissions() async {
  PermissionStatus pmstatus = PermissionStatus.granted;
  Map<Permission, PermissionStatus> status = await [
    Permission.storage,
    Permission.location,
  ].request();
  List<PermissionStatus> statusList = [];
  if (status[Permission.storage] != null) {
    statusList.add(status[Permission.storage]!);
  } // if
  if (status[Permission.location] != null) {
    statusList.add(status[Permission.location]!);
  } // if

  statusList.forEach((element) {
    if (element.isGranted) {
    } // if
    else if (element.isPermanentlyDenied) {
      pmstatus = PermissionStatus.permanentlyDenied;
    } // else if
    else {
      if (pmstatus == PermissionStatus.granted) {
        pmstatus = PermissionStatus.denied;
      } // if
    } // else
  }); // statusList.forEach

  return pmstatus;
} // getPermissions()
