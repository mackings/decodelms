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
  bool isVideoPlaying = false;
  late CourseModule currentModule;

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


    try {
      final message = data['message'];
      final resultData = data['result'] as List<dynamic>?;

      if (resultData != null) {
        final List<StudentCourse> result = resultData
            .map((courseData) =>
                StudentCourse.fromJson(courseData as Map<String, dynamic>))
            .toList();

        return ApiResponse(
          message: message,
          result: result,
        );
      } else {
        throw Exception('Failed to parse API response: Result is null');
      }
    } catch (e) {
      throw Exception('Failed to parse API response: $e');
    }
  } else {
    throw Exception('Failed to load course details: ${response.body}');
  }
}


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
          // Load the first module
          loadModule(courseDetail, courseDetail.result.first.modules.first);
        }
      });
    });
  }


void loadModule(ApiResponse courseDetail, CourseModule module) {
  // Check if the current module is completed
  if (courseDetail.result.first.isCompleted == true) {
    print("Current module is already completed. Loading next module.");

    loadNextModule(courseDetail);
  } else if (module.video.isNotEmpty) {
    // Load video for the current module
    loadVideo(module.video.first.path);
  }
}


  void loadNextModule(ApiResponse courseDetail) {
    if (currentModuleIndex < courseDetail.result.length - 1) {
      currentModuleIndex++;
      final nextModule = courseDetail.result[currentModuleIndex];
      if (nextModule.modules.first.video.isNotEmpty) {
        loadVideo(nextModule.modules.first.video.first.path);
      } else {
        // Handle the case where the video list is empty, e.g., show an error message or perform some other action.
        print('No video available for the next module');
      }
    }
  }

  bool isCurrentModuleAvailable() {
    return currentModule != null;
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
                // Video has ended
                void navigateToQuizPage(String quizId) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        quizId: quizId,
                        courseId: currentModule.id,
                      ),
                    ),
                  ).then((value) {
                    loadNextVideo();
                  });
                }

                if (isVideoPlaying) {
                  isVideoPlaying = false;
                  navigateToQuizPage(currentModule.quizzes.first);
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
      if (nextModule.modules.first.video.isNotEmpty) {
        loadVideo(nextModule.modules.first.video.first.path);
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
                    final module =
                        apiResponse.result[currentModuleIndex].modules;
                    final courseID = apiResponse.result;

                    // print("Current module Quiz ${module.quizzes.first}");

                    return Column(
                      children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Thetext(
                              thetext: module.first.moduleTitle,
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
                            width: MediaQuery.of(context).size.width - 10.w,
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
GestureDetector(
  onTap: () async {
    if (futureCourseDetail != null) {
      final courseDetail = await futureCourseDetail;

      if (courseDetail != null) {
        final currentModule = courseDetail.result[currentModuleIndex]?.modules?.first;

        if (currentModule?.quizzes.isNotEmpty == true) {
          videoPlayerController.pause();
if (courseDetail.result[currentModuleIndex].isCompleted == false) {
  print("Uncompleted");
} else {
  print("Completed");
}


          final quizScore = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                quizId: currentModule?.quizzes.first ?? '',
                courseId: widget.courseId,
              ),
            ),
          );
          print("Passed Course ID ${widget.courseId}");

          print('Quiz Score: $quizScore');
          if (quizScore >= 3) {
            // Check if the current module is completed
            if (courseDetail.result[currentModuleIndex].isCompleted == false) {
              loadNextVideo(); // Proceed to the next module
            }
          }
        } else if (currentModuleIndex < courseDetail.result.length - 1) {
          final nextModule = courseDetail.result[currentModuleIndex + 1]?.modules?.first;

          if (nextModule?.quizzes.isNotEmpty == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  quizId: nextModule?.quizzes.first ?? '',
                  courseId: nextModule?.id ?? '',
                ),
              ),
            );
          } else if (nextModule?.video.isNotEmpty == true) {
            videoPlayerController.pause();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Complete Module'),
                  content: Text('Do you want to mark this module as completed?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        currentModuleIndex++;
                        loadVideo(nextModule?.video.first?.path ?? '');
                      },
                      child: Text('Complete'),
                    ),
                  ],
                );
              },
            );
          } else {
            print("No video or quiz in the next module");
          }
        } else {}
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
                      ],
                    );
                  }
                },
              ));
  }
}
