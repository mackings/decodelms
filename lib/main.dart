import 'dart:math';

import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/views/auth/signin.dart';
import 'package:decodelms/views/auth/signup.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:appinio_video_player/appinio_video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    final cameraStatus = await Permission.camera.request();
   final microphoneStatus =  await Permission.microphone.request();

if (cameraStatus.isGranted && microphoneStatus.isGranted) {
  // Proceed with media device access
} else {
  print('Camera permission status: $cameraStatus');
  print('Microphone permission status: $microphoneStatus');
  // Handle permissions not granted
}
  if (WebRTC.platformIsAndroid) {
   startForegroundService();
  } else {}
  runApp(const ProviderScope(child: MyApp())); 
}

Future<bool> startForegroundService() async {
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: 'Title of the notification',
    notificationText: 'Text of the notification',
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), 
  );
  await FlutterBackground.initialize(androidConfig: androidConfig);
  return FlutterBackground.enableBackgroundExecution();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  final api = Api();
  @override
  Widget build(BuildContext context) {
    final thetheme = ref.watch(api.themeprovider.notifier);
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            title: 'Flutter Demos',
            theme: thetheme.state == 0 ? ThemeData.light() : ThemeData.dark(),
            home: Signup()
            );
      },
    );
  }
}
