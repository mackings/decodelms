import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/views/course/coursedetails.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AllCourseCard extends StatefulWidget {
  final AllCourse allCourse;

  AllCourseCard({required this.allCourse});

  @override
  State<AllCourseCard> createState() => _AllCourseCardState();
}

class _AllCourseCardState extends State<AllCourseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(
                    allCourses: widget.allCourse,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                widget.allCourse.imageUrl.isNotEmpty
                    ? widget.allCourse.imageUrl
                    : '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150, // Adjust the height as needed
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Thetext(
                    thetext: widget.allCourse.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDetailsPage(allCourses: widget.allCourse),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Thetext(
                      thetext: widget.allCourse.description,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // Add the play button here
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.black,
                    size: 48.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseSearchPage extends StatefulWidget {
  @override
  State<CourseSearchPage> createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  dynamic Token;
  bool isEnrolling = false;

  Future GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      setState(() {
        Token = token;
      });
      print("Token retrieved from shared preferences: $Token");
    } else {
      print("Token not found in shared preferences.");
    }
  }

  final TextEditingController _searchController = TextEditingController();
  List<AllCourse> _courses = [];
  List<AllCourse> _filteredCourses = [];

  Future<List<AllCourse>> fetchAllCourses() async {
    final response = await http.get(
      Uri.parse('https://decode-mnjh.onrender.com/api/course/viewAllCourses'),
      headers: {
        'Authorization': 'Bearer $Token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['courses'];

      List<AllCourse> allCourses = responseData
          .map((courseData) => AllCourse.fromJson(courseData))
          .toList();

      return allCourses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  void initState() {
    GetToken();
    fetchAllCourses().then((courses) {
      setState(() {
        _courses = courses;
      });
    });
    super.initState();
  }

  void filterCourses(String query) {
    setState(() {
      _filteredCourses = _courses
          .where((course) =>
              course.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                filterCourses(query);
              },
              decoration: InputDecoration(
                labelText: 'Search for Courses',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
                    child: Text('No courses found'),
                  )
                : ListView.builder(
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return AllCourseCard(allCourse: course);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
