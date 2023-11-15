import 'package:decodelms/models/quizquestions.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class QuizPage extends StatefulWidget {
  final String quizId;

  QuizPage({required this.quizId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final String baseUrl = 'https://decode-mnjh.onrender.com/api/quizes/getQuiz';
  late String? token;
  List<Map<String, dynamic>> selectedAnswers = [];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchToken();
    //_loadQuiz();
  }

  Future<void> _fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null) {
      setState(() {
        token = savedToken;
      });
      print("Token retrieved from shared preferences: $token");

      _loadQuiz();
    } else {
      print("Token not found in shared preferences.");
    }
  }

  Quiz? _quiz;

  Future<Quiz?> _loadQuiz() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/${widget.quizId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final quizResponse = QuizResponse.fromJson(json);
        setState(() {
          _quiz = quizResponse.quiz;
        });
        return quizResponse.quiz;
      } else {
        print('Failed to load quiz: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error loading quiz: $e');
    }
  }

  dynamic QID;
  dynamic AID;

  Future SubmitQuiz() async {
    String errorMessage = '';

    try {
      final response = await http.post(
          Uri.parse(
              "https://decode-mnjh.onrender.com/api/quizes/submitAnswers/$QID"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(
            {
            "userAnswers": selectedAnswers
            }
            ));

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
              press2: () {},
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

        // setState(() {
        //   isEnrolling = false;
        // });

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

  dynamic res;
  bool isLastQuestion(int index) {
    return index == _quiz!.questions.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: GestureDetector(
            onTap: () {
              SubmitQuiz();
            },
            child: Text('Quiz')),
      ),
      body: _quiz == null
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: PageController(initialPage: currentPage),
              itemCount: _quiz!.questions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QuizQuestionView(
                    question: _quiz!.questions[index],
selectedAnswer: selectedAnswers.length > index
    ? selectedAnswers[index]['correctAnswerIndexes']
    : null,

                    onAnswerSelected: (int? answerIndex) {
                      setState(() {
                        QID = _quiz!.id;
                        if (answerIndex != null) {
                          if (selectedAnswers.length <= index) {
                            int? parsedAnswerIndex =
                                int.tryParse(answerIndex.toString());
                            if (parsedAnswerIndex != null) {
                             
                              String questionId = _quiz!.questions[index].id;

                             
                              Map<String, dynamic> answerMap = {
                                'correctAnswerIndexes': parsedAnswerIndex,
                                '_id': questionId,
                              };

                          
                              selectedAnswers.add(answerMap);

                              print(selectedAnswers);
                              print("Quiz ID $QID");
                            } else {
                          
                            }
                          } else {
                            
                            selectedAnswers[index] = {
                              'correctAnswerIndexes': answerIndex,
                              '_id': _quiz!.questions[index].id,
                            };
                          }
                        } else {
                          
                          selectedAnswers[index] = {
                            'correctAnswerIndexes': null,
                            '_id': _quiz!.questions[index].id,
                          };
                        }
                      });
                    },
                    isLastQuestion: isLastQuestion(index),
                  ),
                );
              },
            ),
    );
  }
}

class QuizQuestionView extends StatefulWidget {
  final Question question;
  final int? selectedAnswer;
  final Function(int?) onAnswerSelected;
  final bool isLastQuestion; // Define isLastQuestion property

  QuizQuestionView({
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
    required this.isLastQuestion, // Include isLastQuestion in the constructor
  });

  @override
  _QuizQuestionViewState createState() => _QuizQuestionViewState();
}

class _QuizQuestionViewState extends State<QuizQuestionView> {
  bool isAnswerSelected = false; // Track whether an answer has been selected

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Thetext(
              thetext: widget.question.description,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
          Column(
            children: widget.question.answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isSelected = widget.selectedAnswer == index;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CheckboxListTile(
                      title: Thetext(
                          thetext: answer, style: GoogleFonts.poppins()),
                      value: isSelected,
                      onChanged: isAnswerSelected // Disable onChanged if an answer is already selected
                          ? null
                          : (value) {
                              if (value != null && value) {
                                setState(() {
                                  isAnswerSelected = true;
                                });
                                widget.onAnswerSelected(index);
                              } else {
                                setState(() {
                                  isAnswerSelected = false;
                                });
                                widget.onAnswerSelected(null);
                              }
                            },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 7.h,
            width: MediaQuery.of(context).size.width - 12.w,
            decoration: BoxDecoration(
              color: widget.isLastQuestion
                  ? Colors.blue
                  : Colors.grey, // Change button color if the last question
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Thetext(
                thetext: widget.isLastQuestion
                    ? "Submit Quiz"
                    : "Swipe left to Continue",
                style: GoogleFonts.poppins(
                    color: widget.isLastQuestion ? Colors.white : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

