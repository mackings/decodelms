import 'dart:async';
import 'dart:convert';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:decodelms/models/streammodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StreamPage extends StatefulWidget {
  final String courseId;

  StreamPage({required this.courseId});

  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  Future<CourseDetailResponse>? futureCourseDetail;
  String? token;
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null) {
      setState(() {
        token = savedToken;
      });
      print("Token retrieved from shared preferences: $token");
    } else {
      print("Token not found in shared preferences.");
    }
  }

  Future<CourseDetailResponse> fetchCourseDetailById(
      String courseId, String? token) async {
    final baseUrl =
        "https://decode-mnjh.onrender.com/api/student/studentViewCourse/$courseId";

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] is List) {
        final result = data['result'] as List;
        if (result.isNotEmpty) {
          final modules = result.map((moduleData) {
            return CourseModuleResponse.fromJson(moduleData);
          }).toList();
          return CourseDetailResponse(
              message: "Course details fetched successfully", result: modules);
        }
      }
      throw Exception(
          'Course details not found or data structure is incorrect.');
    }
    throw Exception('Failed to load course details: ${response.body}');
  }

  dynamic vidurl;

  @override
  void initState() {
    super.initState();
    getToken();

    Timer(Duration(seconds: 2), () {
      futureCourseDetail = fetchCourseDetailById(widget.courseId, token);

      futureCourseDetail!.then((courseDetail) {
        if (courseDetail.result.isNotEmpty) {
          final firstModule = courseDetail.result.first;
          if (firstModule.video.isNotEmpty) {
            vidurl = firstModule.video.first.path;

            // Now you can use vidurl to create the videoPlayerController
            videoPlayerController =
                VideoPlayerController.networkUrl(Uri.parse(vidurl))
                  ..initialize().then((value) => setState(() {}));
            _customVideoPlayerController = CustomVideoPlayerController(
              context: context,
              videoPlayerController: videoPlayerController,
            );
          }
        }
      });

      print(widget.courseId);
      print(token);
    });
  }

  List<VideoPlayerController> videoControllers = [];

  @override
  void dispose() {
    super.dispose();
    _customVideoPlayerController.dispose();
    for (final controller in videoControllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Course Detail'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))),
      body: futureCourseDetail == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<CourseDetailResponse>(
              future: futureCourseDetail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No data available.'));
                } else {
                  final courseDetail = snapshot.data!;
                  final firstModule = courseDetail.result.first;
                  return ListView.builder(
                    itemCount: courseDetail.result.length,
                    itemBuilder: (context, index) {
                      final module = courseDetail.result[index];
                      return Column(
                        children: [
                          // Text('Module Title: ${firstModule.moduleTitle}'),
                          // Text(
                          //     'Module Description: ${firstModule.moduleDescription}'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SafeArea(
                              child: CustomVideoPlayer(
                                  customVideoPlayerController:
                                      _customVideoPlayerController),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
    );
  }

  // VideoPlayerController _createVideoPlayerController(String videoUrl) {
  //   final controller = VideoPlayerController.networkUrl(Uri.parse(
  //       "https://res.cloudinary.com/dcr62btte/video/upload/v1697493812/profile/aungmlok99o9jppvzdnk.mp4"));
  //   controller.initialize().then((_) {
  //     setState(() {});
  //   });

  //   videoControllers.add(controller);
  //   return controller;
  // }
}
