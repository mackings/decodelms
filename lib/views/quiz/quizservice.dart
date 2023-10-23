// import 'dart:convert';
// import 'package:decodelms/models/quizanswer.dart';
// import 'package:decodelms/models/quizquestions.dart';
// import 'package:http/http.dart' as http;

// class QuizService {
//   // var quizId = '6528640d0d54e1fd2cab0950';
//   final String baseUrl = 'https://decode-mnjh.onrender.com/api/quizes';

//   Future<Quiz> getQuizById(String quizId, String token) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/$quizId'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);

//         print(Quiz.fromJson(json));
//         return Quiz.fromJson(json);
//       } else {
//         throw Exception('Failed to load quiz: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load quiz: $e');
//     }
//   }

//   Future<int> submitQuiz(
//       String quizId, QuizSubmission submission, String token) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/$quizId/submit'),
//       headers: {
//         'Authorization': 'Bearer $token', // Add the Bearer token here
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(submission.toJson()),
//     );
//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       return json['score'];
//     } else {
//       throw Exception('Failed to submit quiz: ${response.statusCode}');
//     }
//   }
// }




// // import 'dart:convert';
// // import 'package:decodelms/models/quizanswer.dart';
// // import 'package:decodelms/models/quizquestions.dart';
// // import 'package:http/http.dart' as http;



// // class QuizService {
// //   var quizId = '6528640d0d54e1fd2cab0950';
// //   final String baseUrl = 'https://decode-mnjh.onrender.com/api/quizes';

// //   Future<Quiz> getQuizById(String) async {
// //     final response = await http.get(Uri.parse('$baseUrl/$quizId'));
// //     if (response.statusCode == 200) {
// //       final json = jsonDecode(response.body);
// //       return Quiz.fromJson(json);
// //     } else {
// //       throw Exception('Failed to load quiz: ${response.statusCode}');
// //     }
// //   }

// //   Future<int> submitQuiz(String , QuizSubmission submission) async {
// //     final response = await http.post(
// //       Uri.parse('$baseUrl/$quizId/submit'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode(submission.toJson()),
// //     );
// //     if (response.statusCode == 200) {
// //       final json = jsonDecode(response.body);
// //       return json['score'];
// //     } else {
// //       throw Exception('Failed to submit quiz: ${response.statusCode}');
// //     }
// //   }
// // }
