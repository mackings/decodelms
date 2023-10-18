import 'package:decodelms/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:decodelms/widgets/course/courseslider.dart';

class Enrolledcourses extends StatefulWidget {
  @override
  State<Enrolledcourses> createState() => _EnrolledcoursesState();
}

class _EnrolledcoursesState extends State<Enrolledcourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CourseCarouselSlider2()
    );
  }
}
