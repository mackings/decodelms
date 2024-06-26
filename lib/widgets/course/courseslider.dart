import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/models/firstmodel.dart';
import 'package:decodelms/views/course/stream.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursecard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CourseCarouselSlider extends StatefulWidget {
  @override
  State<CourseCarouselSlider> createState() => _CourseCarouselSliderState();
}

class _CourseCarouselSliderState extends State<CourseCarouselSlider> {
  dynamic Token;
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

  @override
  void initState() {
    GetToken();
    super.initState();
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('https://server-eight-beige.vercel.app/api/student/studentGet'),
      headers: {
        'Authorization': 'Bearer $Token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final List<dynamic> courseDataList =
          responseData['studentRegisteredCourses'];

      List<Course> courses = courseDataList
          .map((courseData) => Course.fromJson(courseData))
          .toList();

      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AllCourseCardShimmer();
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return AllCourseCardShimmer();
        } else {
          final courses = snapshot.data;

          if (courses != null && courses.isNotEmpty) {
            // Courses are found, display them in the carousel
            return CarouselSlider(
              items: courses.map((course) {
                return CourseCard(course: course);
              }).toList(),
              options: CarouselOptions(
                height: 140.0,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          } else {
            // No courses found, display a message
            return Center(
                child: Thetext(
                    thetext: "You have not Enrolled for a Course",
                    style: GoogleFonts.poppins()));
          }
        }
      },
    );
  }
}

class AllCourseCarouselSlider extends StatefulWidget {
  @override
  State<AllCourseCarouselSlider> createState() =>
      _AllCourseCarouselSliderState();
}

class _AllCourseCarouselSliderState extends State<AllCourseCarouselSlider> {
  dynamic Token;
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

  @override
  void initState() {
    GetToken();
    super.initState();
  }

  Future<List<Coursem>?> fetchAllCourses() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://server-eight-beige.vercel.app/api/course/viewAllCourses'),
        headers: {
          'Authorization': 'Bearer $Token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData != null &&
            responseData is Map<String, dynamic> &&
            responseData.containsKey('courses')) {
          final coursesData = responseData['courses'];

          if (coursesData is List) {
            List<Coursem>? allCourses =
                (coursesData as List?)?.map<Coursem>((courseData) {
              if (courseData is Map<String, dynamic>) {
                return Coursem.fromJson(courseData);
              } else {
                return Coursem(
                  id: 'Invalid Course Data',
                  userId: '',
                  courseTitle: '',
                  courseDescription: '',
                  courseLanguage: '',
                  reviews: [],
                  courseImage: [],
                  isPaidCourse: '',
                  isPriceCourse: 0,
                  modules: [],
                  totalRegisteredByStudent: 0,
                  createdAt: '',
                  updatedAt: '',
                  isUploadedCompleted: false,
                );
              }
            }).toList();

            print("All Courses $allCourses");
            return allCourses;
          } else {
            throw Exception('Invalid data format for courses');
          }
        } else {
          throw Exception('No courses data found in the response');
        }
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching courses: ${e}');
      return null; // Return null on error
    }
  }

//AllCourse

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coursem>?>(
      future: fetchAllCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CarouselSlider(
                items: List.generate(5, (index) {
                  return AllCourseCardShimmer(); // Create a shimmer placeholder widget
                }),
                options: CarouselOptions(
                  height: 190.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 1),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print('Snapshot has error');
          return AllCourseCardShimmer();
        } else if (snapshot.hasData) {
          final allCourses = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarouselSlider(
              items: allCourses!.map((allCourse) {
                return AllCourseCard(allCourse: allCourse);
              }).toList(),
              options: CarouselOptions(
                height: 250.0, // Adjust height as needed
                aspectRatio: 16 / 9,
                viewportFraction: 0.9, // Ensure full visibility of the card
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
        } else {
          // Handle the case when there are no courses...
          return Text('No courses available.');
        }
      },
    );
  }
}

///////Enrolled Slide

class CourseCarouselSlider2 extends StatefulWidget {
  @override
  State<CourseCarouselSlider2> createState() => _CourseCarouselSlider2State();
}

class _CourseCarouselSlider2State extends State<CourseCarouselSlider2> {
  dynamic Token;

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

  @override
  void initState() {
    GetToken();
    super.initState();
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('https://server-eight-beige.vercel.app/api/student/studentGet'),
      headers: {
        'Authorization': 'Bearer $Token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> courseDataList =
          responseData['studentRegisteredCourses'];

      List<Course> courses = courseDataList
          .map((courseData) => Course.fromJson(courseData))
          .toList();
     // print(courseDataList);

      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final courses = snapshot.data;

          if (courses != null && courses.isNotEmpty) {
            // Courses are found, display them in a ListView
            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20), // Adjust this spacing
                    child: CourseEnrolledCard2(
                      course: course,
                      onTapFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StreamPage(courseId: course.id)));
                      },
                    ),
                    // child: AllCourseCard(allCourse: null),
                  );
                },
              ),
            );
          } else {
            // No courses found, display a message
            return Center(
              child: Thetext(
                thetext: "You have not Enrolled for a Course",
                style: GoogleFonts.poppins(),
              ),
            );
          }
        }
      },
    );
  }
}

//Shimmer
class AllCourseCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[200]!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white, // Placeholder color
            width: double.infinity,
            height: 150.0, // Adjust the height as needed
          ),
        ),
      ),
    );
  }
}
