import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursenav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CourseDetailsPage extends StatefulWidget {
  final AllCourse allCourses; // Corrected variable name

  CourseDetailsPage({required this.allCourses});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonRow(
                    title: "About Course",
                    leftButtonCallback: () {
                      Navigator.pop(context);
                    },
                    rightButtonCallback: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        Container(
                          height: 25.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.allCourses.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Thetext(
                          thetext: widget.allCourses.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(minWidth: 30.w),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.allCourses.imageUrl),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Thetext(
                                    thetext: "Decode Analytical",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TabBar(
                    tabs: [
                      Tab(
                          child: Thetext(
                              thetext: "About",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ))),
                      Tab(
                          child: Thetext(
                              thetext: "Lessons",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ))),
                      Tab(
                          child: Thetext(
                              thetext: "Reviews",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ))),
                    ],
                  ),
                ),
                Container(
                  height: 30.h,
                  child: TabBarView(
                    children: [
                      // Description tab content
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 30),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Text(widget.allCourses.description),

                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 25.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Thetext(
                                                thetext: "30",
                                                style: GoogleFonts.poppins()),
                                            Thetext(
                                                thetext: "Lessons",
                                                style: GoogleFonts.poppins()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 25.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Thetext(
                                                thetext: "30",
                                                style: GoogleFonts.poppins()),
                                            Thetext(
                                                thetext: "Lessons",
                                                style: GoogleFonts.poppins()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 25.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Thetext(
                                                thetext: widget
                                                    .allCourses.enrolled
                                                    .toString(),
                                                style: GoogleFonts.poppins()),
                                            Thetext(
                                                thetext: "Enrolled",
                                                style: GoogleFonts.poppins()),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )


                            ],
                          ),
                        ),
                      ),

                      // Modules tab content
                      ListView.builder(
                        itemCount: widget.allCourses.modules.length,
                        itemBuilder: (context, index) {
                          final module = widget.allCourses.modules[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: GestureDetector(
                              onTap: () {
                                print(module.videoUrl);
                              },
                              child: Container(
                                height: 10.h,
                                width: 5.w,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      title: Thetext(
                                          thetext: module.title,
                                          style: GoogleFonts.poppins()),
                                          leading: Icon(Icons.play_circle),
                                      subtitle: Thetext(
                                          thetext: module.description,
                                          style: GoogleFonts.poppins()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );

                        },
                      ),

                      // Reviews tab content
                      Center(
                        child: Text('Reviews will be displayed here'),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print(widget.allCourses.enrolled);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Container(
                      height: 7.h,
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Thetext(
                          thetext: "Enroll Course ",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
