import 'dart:async';
import 'dart:convert';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/models/quizquestions.dart';
import 'package:decodelms/models/streammodel.dart';
import 'package:decodelms/views/quiz/quiz.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/buttons.dart';
import 'package:decodelms/widgets/course/courseslider.dart';
import 'package:decodelms/widgets/course/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Future<ApiResponse>? futureCourseDetail;

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

  Future<ApiResponse> fetchCourseDetailById(
      String courseId, String? token) async {
    final baseUrl =
        "https://server-eight-beige.vercel.app/api/student/studentViewCourse/$courseId";

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Course ID Is ${courseId}");
      try {
        final message = data['message'];
        final resultData =
            data['result'] as List<dynamic>; // Cast to List<dynamic>
        final List<CourseModule> result = resultData
            .map((moduleData) => CourseModule.fromJson(moduleData))
            .toList();

        return ApiResponse(
          message: message,
          result: result,
        );
      } catch (e) {
        throw Exception('Failed to parse API response: $e');
      }
    } else {
      throw Exception('Failed to load course details: ${response.body}');
    }
  }

  // Future<CommentResponse> fetchCommentById(String commentId) async {
  //   final baseUrl = "https://server-eight-beige.vercel.app/api/comments/$commentId";

  //   final response = await http.get(
  //     Uri.parse(baseUrl),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     print('comment Data $data');

  //     if (data['message'] == "success") {
  //       final commentData = data['comment']; // Extract the comment data
  //       final comment = CommentResponse.fromJson(commentData);
  //       return comment;
  //     } else {
  //       throw Exception('Failed to load comment: ${data['message']}');
  //     }
  //   } else {
  //     throw Exception('Failed to load comment: ${response.body}');
  //   }
  // }

  // Function to post a comment to the module

  Future<void> postComment(String moduleId, String comment) async {
    final apiUrl =
        "https://server-eight-beige.vercel.app/api/comments/module/$moduleId";

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

  var btntext = 'Next Module';
  var btntext2 = 'Finish Course';

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

  late Quiz _quiz;

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
          }
        }
      });

      print(widget.courseId);
      print(token);
    });
  }

  void loadVideo(String videoUrl) {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((_) {
            // Initialize and play the video
            videoPlayerController.play();
            Duration totalDuration = videoPlayerController.value.duration;
            String totalDurationString = formatDuration(totalDuration);

            print('Total Video Duration: $totalDurationString');

            videoPlayerController.addListener(() {
              if (videoPlayerController.value.isInitialized &&
                  videoPlayerController.value.isPlaying &&
                  videoPlayerController.value.position >= totalDuration) {
                void navigateToQuizPage(String quizId) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(quizId: quizId),
                    ),
                  ).then((value) {
                    loadNextVideo();
                  });
                }
              }
            });

            setState(() {});
          });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void loadNextVideo() async {
    final courseDetail = await futureCourseDetail;

    if (courseDetail != null &&
        currentModuleIndex < courseDetail.result.length - 1) {
      currentModuleIndex++;
      final nextModule = courseDetail.result[currentModuleIndex];
      if (nextModule.video.isNotEmpty) {
        loadVideo(nextModule.video.first.path);
      } else {
        // Handle the case where the video list is empty, e.g., show an error message or perform some other action.
        print('No video available for the next module');
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
            : FutureBuilder<ApiResponse>(
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
                    final apiResponse = snapshot.data!;
                    final module = apiResponse.result[currentModuleIndex];

                    return Column(
                      children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Thetext(
                              thetext: module.moduleTitle,
                              style: GoogleFonts.poppins()),
                        )),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SafeArea(
                            child: CustomVideoPlayer(
                              customVideoPlayerController:
                                  _customVideoPlayerController,
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 7.h,
                            width: MediaQuery.of(context).size.width -10.w,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),

                        // Initialize buttonText as "Next Module"

// ...

                        GestureDetector(
                          onTap: () async { 
                            final courseDetail = await futureCourseDetail;

                            if (courseDetail != null) {
                              if (currentModuleIndex <
                                  courseDetail.result.length - 1) {
                                // Not the last module, go to the next module's video
                                currentModuleIndex++;
                                final nextModule =
                                    courseDetail.result[currentModuleIndex];

                                if (nextModule.video.isNotEmpty) {
                                  loadVideo(nextModule.video.first.path);
                                }
                              } else {
                                // Last module, change the button text to "Finish Course" and show a dialog
                                setState(() {
                                  btntext = "Finish Course";
                                });

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return EnrollmentDialog(
                                        title: 'Congratulations',
                                        message:
                                            "Course Completed successfully",
                                        message2: "Get certified",
                                        press1: () {},
                                        press2: () {},
                                        theicon: Icon(Icons.check_circle,color: Colors.blue,size: 60,));
                                  },
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 7.h,
                            width: MediaQuery.of(context).size.width - 10.w,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Thetext(
                                thetext: btntext,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )

// GestureDetector(
//   onTap: () async {
//     print("Quiz ID is ${module.quizzes.first}");
//     print(module.id);
//     final courseDetail = await futureCourseDetail;

//     if (courseDetail != null) {
//       final currentModule =
//           courseDetail.result[currentModuleIndex];

//       if (currentModule.quizzes.isNotEmpty &&
//           videoPlayerController != null) {
//         videoPlayerController.pause();
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizPage(
//               quizId: currentModule.quizzes.first,
//             ),
//           ),
//         );
//       } else if (currentModuleIndex < courseDetail.result.length - 1) {
//         final nextModule =
//             courseDetail.result[currentModuleIndex + 1];

//         if (nextModule.quizzes.isNotEmpty) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => QuizPage(
//                 quizId: nextModule.quizzes.first,
//               ),
//             ),
//           );
//         } else {
//           print("Loaded ${module}");
//           loadNextVideo();
//         }
//       }
//     } else {
//       print("Course detail is null");
//     }
//   },
//   child: Container(
//     height: 7.h,
//     width: MediaQuery.of(context).size.width - 10.w,
//     decoration: BoxDecoration(
//       color: Colors.blue,
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Center(
//       child: Thetext(
//         thetext: "Next Module",
//         style: GoogleFonts.poppins(
//           color: Colors.white,
//         ),
//       ),
//     ),
//   ),
// )
                      ],
                    );
                  }
                },
              ));
  }
}
