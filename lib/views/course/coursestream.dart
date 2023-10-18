import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursenav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Videostream extends ConsumerStatefulWidget {
  const Videostream({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideostreamState();
}

class _VideostreamState extends ConsumerState<Videostream> {
  String videoUrl =
      "https://res.cloudinary.com/dcr62btte/video/upload/v1697493812/profile/aungmlok99o9jppvzdnk.mp4";

  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  @override
  void initState() {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TheBars(
        callback: () {},
        thebody: Column(
          children: [
            SafeArea(
              child: CustomVideoPlayer(
                  customVideoPlayerController: _customVideoPlayerController),
            ),
          ],
        ));
  }
}
