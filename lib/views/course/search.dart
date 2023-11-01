import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/models/searchcourse.dart';
import 'package:decodelms/views/course/coursedetails.dart';
import 'package:decodelms/views/course/detailssheet.dart';
import 'package:decodelms/views/course/results.dart';
import 'package:decodelms/views/course/searchresults.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  dynamic Token;
  var myindex;

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

  TextEditingController searchController = TextEditingController();
  List<Courseresults> searchResults = [];

  Future<void> searchCourses(String query) async {
    final response = await http.get(
        Uri.parse('https://decode-mnjh.onrender.com/api/course/search/$query'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Token',
        });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      CourseResponse courseResponse = CourseResponse.fromJson(jsonResponse);
      setState(() {
        searchResults = courseResponse.courses;
      });
      print("Search Results : $searchResults");
    } else {
      print('API request failed: ${response.body}');
    }
  }

  @override
  void initState() {
    GetToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 10, right: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
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
                          controller: searchController,
                          onTap: () {},
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
                                  searchCourses(searchController.text);
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
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5,color: Colors.black),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Thetext(thetext: searchResults[index].courseTitle, style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold
                              )),
                              trailing: Icon(Icons.check_circle,color: Colors.blue,),
                              subtitle: GestureDetector(
                                  onTap: () {
                                    print(searchResults[index].id);
                                    print(searchResults[index].modules.length);
                                    
                                    showMaterialModalBottomSheet(
                                      enableDrag: true,
                                      context: context,
                                      builder: (context) => CourseDetailsBottomSheet(
                                        courseImage: searchResults[index]
                                            .courseImages[index]
                                            .path,
                                        title: searchResults[index].courseTitle,
                                        description:
                                            searchResults[index].courseDescription,
                                        amount: searchResults[index]
                                            .isPriceCourse
                                            .toDouble(),
                                        themodules: searchResults[index].modules.length.toString(),
                                        theid:searchResults[index].id.toString(),
                                        theenrolled:searchResults[index].totalRegisteredByStudent.toString(),
                                        onEnrollPressed: () {},
                                      ),
                                    );
                                  },
                                  child:
                                      Thetext(thetext: searchResults[index].courseDescription, style: GoogleFonts.poppins())),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
