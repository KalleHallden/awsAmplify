import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '/ui_elements/waveform_widget.dart'; // Assuming the waveform widget is in this file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request microphone permission before starting the app
  await _askPermission();

  runApp(const MyApp());
}

Future<void> _askPermission() async {
  final PermissionStatus permissionStatus = await _getPermission();
  if (permissionStatus == PermissionStatus.granted) {
    print("Microphone permission granted");
  } else if (permissionStatus == PermissionStatus.denied) {
    print("Microphone permission denied. You may need to enable it in system settings.");
  } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
    print("Microphone permission permanently denied. Redirecting to app settings...");
    await openAppSettings();
  } else if (permissionStatus == PermissionStatus.restricted) {
    print("Microphone permission is restricted and cannot be granted.");
  }
}

Future<PermissionStatus> _getPermission() async {
  final PermissionStatus permission = await Permission.microphone.status;

  if (permission.isDenied || permission.isRestricted) {
    // Request the microphone permission if not already granted
    final PermissionStatus newPermission = await Permission.microphone.request();
    return newPermission;
  } else {
    // Return the current permission status
    return permission;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Waveform'),
        ),
        body: Center(
          child: WaveformWidget(),
        ),
      ),
    );
  }
}
