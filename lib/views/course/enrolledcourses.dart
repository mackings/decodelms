import 'package:carousel_slider/carousel_slider.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursenav.dart';
import 'package:flutter/material.dart';
import 'package:decodelms/widgets/course/courseslider.dart';
import 'package:google_fonts/google_fonts.dart';

class Enrolledcourses extends StatefulWidget {
  @override
  State<Enrolledcourses> createState() => _EnrolledcoursesState();
}

class _EnrolledcoursesState extends State<Enrolledcourses> {
  bool visi = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Specify the number of tabs here
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Thetext(
              thetext: "My Courses",
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Thetext(
                    thetext: "Ongoing",
                    style: GoogleFonts.poppins(color: Colors.black)),
              ),
              Tab(
                child: Thetext(
                    thetext: "Completed",
                    style: GoogleFonts.poppins(color: Colors.black)),
              ), // Add another tab
            ],
            indicatorColor: Colors.black,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                      child: GestureDetector(child: CourseCarouselSlider2()))
                ],
              ),
              Center(child: Text('Other Tab Content')),
            ],
          ),
        ),
      ),
    );
  }
}
