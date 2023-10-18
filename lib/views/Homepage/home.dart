import 'package:decodelms/views/course/enrolledcourses.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/courseslider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
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

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return TheBar(
          callback: () {},
          thebody: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Thetext(
                          thetext: "Hello Macs", style: GoogleFonts.poppins()),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Icon(Icons.notifications)
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Thetext(
                          thetext: "Let's learn\ntogether",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 20.sp)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                child: Container(
                  height: 40.sp,
                  width: MediaQuery.of(context).size.width - 1.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 211, 218, 224),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            print(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintStyle: GoogleFonts.poppins(color: Colors.black),
                          hintText: "Search Course",
                          suffixIcon: Container(
                            height: 40.sp, // Same height as the TextFormField
                            width: 40.sp, // Custom width for the container
                            child: IconButton(
                              icon: Icon(Icons.search, color: Colors.black),
                              onPressed: () {
                                // Handle the search icon tap here
                              },
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Thetext(
                        thetext: "Continue to course",
                        style: GoogleFonts.poppins()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Enrolledcourses()));
                      },
                      child: Thetext(
                          thetext: "See all",
                          style: GoogleFonts.poppins(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CourseCarouselSlider(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Thetext(
                        thetext: "Most browsed through",
                        style: GoogleFonts.poppins()),
                    Thetext(
                        thetext: "See more",
                        style: GoogleFonts.poppins(color: Colors.blue)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AllCourseCarouselSlider(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Thetext(
                        thetext: "Most browsed through",
                        style: GoogleFonts.poppins()),
                    Thetext(
                        thetext: "See more",
                        style: GoogleFonts.poppins(color: Colors.blue)),
                  ],
                ),
              ),
              Container(
                height: 10.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Fvector-art%2F2779579-man-working-on-a-computer-people-on-computer-screen-speaking-with-colleague-or-friends-illustrations-concept-video-conference-online-meeting-or-work-from-home-vector-illustration&psig=AOvVaw3w2QAc3QXj6k4HErFMN7HP&ust=1697682559696000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNj4v8LG_oEDFQAAAAAdAAAAABAJ"))),
              )
            ],
          ));
    }));
  }
}
