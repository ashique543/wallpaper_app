import 'package:permission_handler/permission_handler.dart';

void requestPermission() async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Permission is granted, you can proceed with file operations.
  } else {
    // Permission denied.
  }
}