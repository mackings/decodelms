import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursecard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CourseCarouselSlider extends StatelessWidget {
  Future<List<Course>> fetchCourses(String bearerToken) async {
    final response = await http.get(
      Uri.parse('https://decode-mnjh.onrender.com/api/student/studentGet'),
      headers: {
        'Authorization':
            'Bearer $bearerToken',
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
      future: fetchCourses("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTJkYzYyZjExMjZmZjExMzJiNWUwYjYiLCJpYXQiOjE2OTc0OTg5NjcsImV4cCI6MTY5NzU4NTM2N30.VFVaFBJv1G64jOGA6IaDxj1maU99Fa_iCOS2mYC8ZQk"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final courses = snapshot.data;

          if (courses != null && courses.isNotEmpty) {
            // Courses are found, display them in the carousel
            return CarouselSlider(
              items: courses.map((course) {
                return CourseCard(course: course);
              }).toList(),
              options: CarouselOptions(
                height: 180.0,
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
              child: Thetext(thetext: "You have not Enrolled Yet\nCheck out our free courses today", style: GoogleFonts.poppins())
            );
          }
        }
      },
    );
  }
}



class AllCourseCarouselSlider extends StatelessWidget {
  Future<List<AllCourse>> fetchAllCourses(String bearerToken) async {
    final response = await http.get(
      Uri.parse('https://decode-mnjh.onrender.com/api/course/viewAllCourses'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
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
  Widget build(BuildContext context) {
    return FutureBuilder<List<AllCourse>>(
      future: fetchAllCourses(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTJkYzYyZjExMjZmZjExMzJiNWUwYjYiLCJpYXQiOjE2OTc0OTg5NjcsImV4cCI6MTY5NzU4NTM2N30.VFVaFBJv1G64jOGA6IaDxj1maU99Fa_iCOS2mYC8ZQk"), // Pass the bearer token
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final allCourses = snapshot.data;
          return CarouselSlider(
            items: allCourses!.map((allCourse) {
              return AllCourseCard(allCourse: allCourse,);
            }).toList(),
            options: CarouselOptions(
              height: 180.0,
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
          // Handle the case when there are no courses...
          return Text('No courses available.');
        }
      },
    );
  }
}
