import 'dart:async';
import 'dart:convert';
import 'package:decodelms/models/quizanswer.dart';
import 'package:decodelms/models/quizquestions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  final String quizId;

  QuizPage({required this.quizId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final String baseUrl = 'https://decode-mnjh.onrender.com/api/quizes';
  late String? token;
  late Quiz _quiz;
  List<int?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    // Fetch the token when the widget initializes
    _fetchToken();
    // Load the quiz after a delay
    Timer(Duration(seconds: 2), () {
     // _loadQuiz();
    });
  }

  Future<void> _fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null) {
      setState(() {
        token = savedToken;
      });
      print("Token retrieved from shared preferences: $token");
      // Load the quiz after the token is fetched
      //_loadQuiz();
    } else {
      print("Token not found in shared preferences.");
    }
  }

  // Future<Quiz?> _loadQuiz() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/${widget.quizId}'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       final quiz = Quiz.fromJson(json); // Parse the entire response

  //       // Initialize selectedAnswers with the correct size and default values
  //       selectedAnswers =
  //           List<int?>.generate(quiz.questions.length, (index) => -1);

  //       setState(() {
  //         _quiz = quiz;
  //       });

  //       return quiz;
  //     } else {
  //       // Handle the case when the quiz is not loaded
  //       print('Failed to load quiz: ${response.statusCode}');
  //       return null; // Return null to indicate that the quiz wasn't loaded
  //     }
  //   } catch (e) {
  //     // Handle network errors here
  //     print('Error loading quiz: $e');
  //     return null; // Return null in case of errors
  //   }
  // }

  Future<int> _submitQuiz(
      String quizId, QuizSubmission submission, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$quizId/submit'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(submission.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['score'];
      } else {
        throw Exception('Failed to submit quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to submit quiz: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      // body: FutureBuilder<Quiz>(
      //   future: _loadQuiz(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       print(snapshot.error);
      //       return Center(child: Text('Error loading quiz'));
      //     } else if (snapshot.hasData) {
      //       return Column(
      //         children: [
      //           Expanded(
      //             child: ListView.builder(
      //               itemCount: snapshot.data!.questions.length,
      //               itemBuilder: (context, index) {
      //                 final question = snapshot.data!.questions[index];
      //                 return ListTile(
      //                   title: Text(question.questionDescription),
      //                   // ... rest of your code for rendering questions
      //                 );
      //               },
      //             ),
      //           ),
      //           // Add any other widgets you need, like the "Submit Quiz" button
      //         ],
      //       );
      //     } else {
      //       // Handle other states, if needed
      //       return Center(child: Text('No quiz data available'));
      //     }
      //   },
      // ),
    );
  }
}
