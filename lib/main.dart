import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/views/auth/signin.dart';
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
            home: Signin(),
            );
      },
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String? myemail;
  //final user = User();

  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  String videoUrl =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mydemo = ref.watch(Api().demoprovider);
    final updates = ref.read(Api().demoprovider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              print("hello");
              print(mydemo);
            },
            child: Text(mydemo.toString())),
      ),
      body: SafeArea(
        child: Column(children: [
          SafeArea(
            child: CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                       // user.email = value;
                        print(value);
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              //updates.state = 200;
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 70,
              decoration: BoxDecoration(color: Colors.blue),
            ),
          )
        ]),
      ),
    );
  }
}
