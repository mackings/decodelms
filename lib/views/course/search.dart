// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:decodelms/models/searchcourse.dart';
// import 'package:decodelms/widgets/course/coursecard.dart';

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController _searchController = TextEditingController();
//   SearchResponse? searchResponse;

//   Future<SearchResponse> searchCourses(String courseTitle) async {
//     final baseUrl = "https://decode-mnjh.onrender.com/api/course/search?course_title=$courseTitle";

//     final Uri uri = Uri.parse(baseUrl);

//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return SearchResponse.fromJson(data);
//     } else {
//       throw Exception('Failed to load courses. Status code: ${response.statusCode}');
//     }
//   }

//   Widget buildSearchResults() {
//     if (searchResponse == null) return Container();

//     return Expanded(
//       child: ListView.builder(
//         itemCount: searchResponse!.courses.length,
//         itemBuilder: (context, index) {
//           final searchCourse = searchResponse!.courses[index];
//           return AllCourseCard(
//             allCourse: SearCou(
//               id: searchCourse.id,
//               title: searchCourse.title,
//               description: searchCourse.description,
//               imageUrl: searchCourse.imageUrl,
//               enrolled: 1,
//               modules: [],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Course Search'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Enter course title',
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final courseTitle = _searchController.text;
//               final response = await searchCourses(courseTitle);
//               setState(() {
//                 searchResponse = response;
//               });
//             },
//             child: Text('Search'),
//           ),
//           buildSearchResults(),
//         ],
//       ),
//     );
//   }
// }
