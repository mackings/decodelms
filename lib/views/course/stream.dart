import 'dart:async';
import 'dart:convert';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/models/quizquestions.dart';
import 'package:decodelms/models/streammodel.dart';
import 'package:decodelms/views/quiz/quiz.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/buttons.dart';
import 'package:decodelms/widgets/colors.dart';
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
  List<CourseModule> allModules = [];
  ScrollController _scrollController = ScrollController();

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
  String? moduleID;
  List<Map<String, dynamic>> selectedAnswers = [];
  dynamic QID;
  dynamic AID;
  dynamic res;

  Future SubmitQuiz() async {
    String errorMessage = '';

    try {
      final response = await http.post(
          Uri.parse(
              "https://server-eight-beige.vercel.app/api/quizes/submitAnswers/$QID"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"userAnswers": selectedAnswers}));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        print(selectedAnswers);

        setState(() {
          res = data['score'];
          print('Results is $res');
          // isEnrolling = false;
        });

        // Show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                Navigator.pop(context);
              },
              press2: () {
                // Navigator.pop(context, res);
                Complete();
              },
              theicon: Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 60,
              ),
              title: "Quiz Attempted",
              message: "You Scored $res",
              message2: 'Continue',
            );
          },
        );
      } else if (response.statusCode == 409) {
        var data = jsonDecode(response.body);
        print(data);
        print(selectedAnswers);

        setState(() {
          errorMessage = data['message'];
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                Navigator.pop(context);
              },
              press2: () {
                Navigator.pop(context);
              },
              theicon: Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              title: "Enrollment Failed",
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : "Enrollment failed. Please try again later.",
              message2: "Take me Home",
            );
          },
        );

        // throw Exception(response.body);
      } else {
        print(selectedAnswers);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                Navigator.pop(context);
              },
              press2: () {
                Navigator.pop(context);
              },
              theicon: Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              title: "Enrollment Failed",
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : "Enrollment failed. Please try again later.",
              message2: "Take me Home",
            );
          },
        );
        print(response.body);
      }
    } catch (error) {
      print('Error is $error');
      setState(() {
        // isEnrolling = false;
      });

      print(res);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EnrollmentDialog(
            press1: () {
              Navigator.pop(context);
            },
            press2: () {
              Navigator.pop(context);
            },
            theicon: Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            title: "Enrollment Failed",
            message: errorMessage.isNotEmpty
                ? errorMessage
                : "Enrollment failed. Please try again later.",
            message2: "Take me Home",
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();

    setState(() {});

    Timer(Duration(seconds: 2), () {
      futureCourseDetail = fetchCourseDetailById(widget.courseId, token);

      futureCourseDetail!.then((courseDetail) {
        if (courseDetail.result.isNotEmpty) {
          allModules = courseDetail.result.first.modules;
          loadModule(courseDetail, courseDetail.result.first.modules.first);
        }
      });
    });
  }

  void loadModule(ApiResponse courseDetail, CourseModule module) {
    // Check if the current module is completed
    if (courseDetail.result.first.modules.first.isCompleted == true) {
      print("Current module is already completed. Loading next module.");

      loadNextModule(courseDetail);
    } else if (module.video.isNotEmpty) {
      // Load video for the current module
      loadVideo(module.video.first.path);
    } else {
      print("All caught up! You have completed all modules.");
    }
  }

  void loadNextModule(ApiResponse courseDetail) {
    if (currentModuleIndex < courseDetail.result.first.modules.length - 1) {
      currentModuleIndex++;
      final nextModule = courseDetail.result.first.modules[currentModuleIndex];

      if (nextModule.isCompleted) {
        print("Next module is already completed. Loading the next one.");
        loadNextModule(courseDetail);
      } else if (nextModule.video.isNotEmpty) {
        // Load video for the next module
        loadVideo(nextModule.video.first.path);
      } else if (nextModule.quizzes.isNotEmpty) {
        // Check if the next module has a quiz
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
                quizId: nextModule.quizzes.first,
                courseId: widget.courseId,
                moduleId: nextModule.id),
          ),
        ).then((_) {
          // After the quiz page is closed, load the video for the next module
          loadNextVideo();
        });
      } else {
        // Handle the case where the next module has neither a video nor a quiz
        print('All caught up! You have completed all modules.');
      }
    } else {
      // All modules are completed
      print("All caught up! You have completed all modules.");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EnrollmentDialog(
            title: "Congratulations",
            message: "You just completed this Course",
            message2: "Certify Me",
            press1: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            press2: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            theicon: Icon(
              Icons.check_circle,
              color: Colors.blue,
              size: 50,
            ),
          );
        },
      );
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
                          moduleId: currentModule.id),
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
        currentModuleIndex < courseDetail.result.first.modules.length - 1) {
      currentModuleIndex++;
      final nextModule = courseDetail.result.first.modules[currentModuleIndex];

      if (nextModule.video.isNotEmpty) {
        loadVideo(nextModule.video.first.path);
      } else {
        // Handle the case where the next module has no video
        print('No video available for the next module');
      }
    }
  }

  Future Complete() async {
    String errorMessage = '';

    try {
      final response = await http.put(
        Uri.parse(
            "https://server-eight-beige.vercel.app/api/student/markcomplete/${widget.courseId}/${moduleID}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                // Navigator.pop(context);
              },
              press2: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              theicon: Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 60,
              ),
              title: "Module Marked",
              message: "Completed",
              message2: 'Continue',
            );
          },
        );
      } else if (response.statusCode == 409) {
        var data = jsonDecode(response.body);
        print(data);

        setState(() {
          errorMessage = data['message'];
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                Navigator.pop(context);
              },
              press2: () {
                Navigator.pop(context);
              },
              theicon: Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              title: "Enrollment Failed",
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : "Enrollment failed. Please try again later.",
              message2: "Take me Home",
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                Navigator.pop(context);
              },
              press2: () {
                Navigator.pop(context);
              },
              theicon: Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              title: "Enrollment Failed",
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : "Enrollment failed. Please try again later.",
              message2: "Take me Home",
            );
          },
        );
        print(response.body);
      }
    } catch (error) {
      print('Error is $error');
      setState(() {
        // isEnrolling = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EnrollmentDialog(
            press1: () {
              Navigator.pop(context);
            },
            press2: () {
              Navigator.pop(context);
            },
            theicon: Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            title: "Enrollment Failed",
            message: errorMessage.isNotEmpty
                ? errorMessage
                : "Enrollment failed. Please try again later.",
            message2: "Take me Home",
          );
        },
      );
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
        backgroundColor: appcolor,
        appBar: AppBar(
          backgroundColor: appcolor,
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
                        apiResponse.result.first.modules[currentModuleIndex];
                    final courseID = apiResponse.result;

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
                          padding: const EdgeInsets.all(5.0),
                          child: SafeArea(
                            child: CustomVideoPlayer(
                              customVideoPlayerController:
                                  _customVideoPlayerController,
                                
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (futureCourseDetail != null) {
                              final courseDetail = await futureCourseDetail;
                              setState(() {
                                moduleID = module.id;
                              });

                              if (courseDetail != null) {
                                final currentModule = courseDetail
                                    .result.first.modules[currentModuleIndex];
                                if (currentModule.quizzes.isNotEmpty == true) {
                                  videoPlayerController.pause();
                                  if (courseDetail
                                          .result
                                          .first
                                          .modules[currentModuleIndex]
                                          .isCompleted ==
                                      false) {
                                    print("Uncompleted");
                                  } else {
                                    print("True");
                                  }

                                  final quizScore = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                        quizId:
                                            currentModule?.quizzes.first ?? '',
                                        courseId: widget.courseId,
                                        moduleId: currentModule.id,
                                        //  onSubmitQuiz: SubmitQuiz,
                                      ),
                                    ),
                                  );
                                  // print("Passed Course ID ${widget.courseId}");

                                  print('Quiz Score: $quizScore');
                                  if (quizScore >= 3) {
                                    if (courseDetail
                                            .result
                                            .first
                                            .modules[currentModuleIndex]
                                            .isCompleted ==
                                        false) {
                                      loadNextVideo(); // Proceed to the next module
                                    }
                                  }
                                } else if (currentModuleIndex <
                                    courseDetail.result.length - 1) {
                                  final nextModule = courseDetail
                                      .result[currentModuleIndex].modules.first;

                                  if (nextModule.quizzes.isNotEmpty == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(
                                          quizId:
                                              nextModule?.quizzes.first ?? '',
                                          courseId: nextModule?.id ?? '',
                                          moduleId: currentModule.id,
                                        ),
                                      ),
                                    );
                                  } else if (nextModule.video.isNotEmpty ==
                                      true) {
                                    videoPlayerController.pause();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Complete Module'),
                                          content: Text(
                                              'Do you want to mark this module as completed?'),
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
                                                loadVideo(nextModule
                                                        ?.video.first?.path ??
                                                    '');
                                              },
                                              child: Text('Complete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    final currentModule = courseDetail.result
                                        .first.modules[currentModuleIndex];
                                  } else if (currentModule.quizzes.isEmpty &&
                                      currentModule.video.isNotEmpty) {
                                    print("No quiz in the next module");
                                  }
                                } else {
                                  videoPlayerController.pause();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EnrollmentDialog(
                                          title: "Done?",
                                          message: "Proceed to the next module",
                                          message2: "Continue",
                                          press1: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          press2: () {
                                            Complete();
                                            // Navigator.pop(context);
                                          },
                                          theicon: Icon(
                                            Icons.check_circle,
                                            color: Colors.blue,
                                            size: 50,
                                          ));
                                    },
                                  );
                                  //Last Action
                                }
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
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: allModules.length,
                            itemBuilder: (context, index) {
                              CourseModule module = allModules[index];

                              return GestureDetector(
                                onTap: () {
                                  //loadVideo(module.video.first.path);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Thetext(
                                      thetext: module.moduleTitle,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Thetext(
                                        thetext:
                                            "${module.isCompleted == false ? "Not Completed" : "Module Completed"}",
                                        style: GoogleFonts.poppins()),
                                    leading: Thetext(
                                      thetext:
                                          '${index + 1}', // Display module number
                                      style: GoogleFonts.poppins(),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        if (module.isCompleted == true) {
showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 300,
        child: CompletedVideoPlayer(
          videoPath: module.video.first.path.toString(),
        ),
      ),
    );
  },
);

                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return EnrollmentDialog(
                                                title: "Error Playing Video",
                                                message:
                                                    "Complete Previous Modules",
                                                message2: "Close",
                                                press1: () {},
                                                press2: () {
                                                  Navigator.pop(context);
                                                },
                                                theicon: Icon(
                                                  Icons.play_disabled_rounded,
                                                  size: 50,
                                                  color: Colors.blue,
                                                ),
                                              );
                                            }),
                                          );
                                        }
                                      },
                                      child: Icon(
                                        Icons.play_circle,
                                        color: Colors.blue,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ));
  }
}

class CompletedVideoPlayer extends StatefulWidget {
  final String videoPath;

  CompletedVideoPlayer({required this.videoPath});

  @override
  _CompletedVideoPlayerState createState() => _CompletedVideoPlayerState();
}

class _CompletedVideoPlayerState extends State<CompletedVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        // Initialize and play the video
        _videoPlayerController.play();
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _videoPlayerController,
        );
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _customVideoPlayerController != null
        ? CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController!,
          )
        : Center(child: CircularProgressIndicator()); // You can replace Container() with any other loading indicator or placeholder
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
