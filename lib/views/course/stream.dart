import 'dart:async';
import 'dart:convert';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/models/streammodel.dart';
import 'package:decodelms/widgets/course/courseslider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

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
  int currentModuleIndex = 0;

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
              message: "Course details fetched successfully",
              result: modules,
              comments: []);
        }
      }
      throw Exception(
          'Course details not found or data structure is incorrect.');
    }
    throw Exception('Failed to load course details: ${response.body}');
  }

  Future<CommentResponse> fetchCommentById(String commentId) async {
    final baseUrl = "https://decode-mnjh.onrender.com/api/comments/$commentId";

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('comment Data $data');

      if (data['message'] == "success") {
        final commentData = data['comment']; // Extract the comment data
        final comment = CommentResponse.fromJson(commentData);
        return comment;
      } else {
        throw Exception('Failed to load comment: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load comment: ${response.body}');
    }
  }

  // Function to post a comment to the module
  Future<void> postComment(String moduleId, String comment) async {
    final apiUrl =
        "https://decode-mnjh.onrender.com/api/comments/module/$moduleId";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"commentBody": comment}),
    );

    if (response.statusCode == 200) {
      print("Comment posted successfully");
    } else {
      throw Exception('Failed to post comment: ${response.body}');
    }
  }

  void _showCommentModal(String moduleId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        String newComment = "";

        return Column(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                newComment = value;
              },
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (newComment.isNotEmpty) {
                  postComment(moduleId, newComment);
                }
                Navigator.pop(context);
              },
              child: Text('Post Comment'),
            ),
          ],
        );
      },
    );
  }

  dynamic vidurl;

  @override
  void initState() {
    super.initState();
    getToken();
    setState(() {});

    Timer(Duration(seconds: 2), () {
      futureCourseDetail = fetchCourseDetailById(widget.courseId, token);

      futureCourseDetail!.then((courseDetail) {
        if (courseDetail.result.isNotEmpty) {
          final firstModule = courseDetail.result.first;
          if (firstModule.video.isNotEmpty) {
            loadVideo(firstModule.video.first.path);
            // vidurl = firstModule.video.first.path;
            // videoPlayerController =
            //     VideoPlayerController.networkUrl(Uri.parse(vidurl))
            //       ..initialize().then((value) => setState(() {}));
            // _customVideoPlayerController = CustomVideoPlayerController(
            //   context: context,
            //   videoPlayerController: videoPlayerController,
            // );
          }
        }
      });


      print(widget.courseId);
      print(token);
    });
  }


    void loadVideo(String videoUrl) {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        // Initialize and play the video
        videoPlayerController.play();
        setState(() {});
      });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

void loadNextVideo() async {
  final courseDetail = await futureCourseDetail;

  if (courseDetail != null && currentModuleIndex < courseDetail.result.length - 1) {
    currentModuleIndex++;
    final nextModule = courseDetail.result[currentModuleIndex];
    if (nextModule.video.isNotEmpty) {
      loadVideo(nextModule.video.first.path);
    }
  }
}


  List<VideoPlayerController> videoControllers = [];
  dynamic MID;

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
          ),
        ),
      ),
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
                  final module = courseDetail.result[currentModuleIndex];

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SafeArea(
                          child: CustomVideoPlayer(
                            customVideoPlayerController: _customVideoPlayerController,
                          ),
                        ),
                      ),
                      // You can add controls to navigate to the next module here
                      ElevatedButton(
                        onPressed: loadNextVideo,
                        child: Text('Next Module'),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}
    
