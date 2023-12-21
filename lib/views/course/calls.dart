import 'dart:convert';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/buttombar.dart';
import 'package:decodelms/widgets/course/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:decodelms/models/meetings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:sizer/sizer.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  dynamic Token;
  late Future<List<Meeting>> futureMeetings;

  @override
  void initState() {
    super.initState();
    GetToken();
  }

  Future GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      setState(() {
        Token = token;
        futureMeetings = fetchMeetings(); // Reassign the future here
      });
      print("Token retrieved from shared preferences: $Token");
    } else {
      print("Token not found in shared preferences.");
    }
  }

  Future<List<Meeting>> fetchMeetings() async {
    final response = await http.get(
      Uri.parse('https://server-eight-beige.vercel.app/API/admin/getRoomId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $Token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData =
          json.decode(response.body)['meeting'] as List<dynamic>;
      List<Meeting> meetings = responseData
          .map((meetingData) => Meeting.fromJson(meetingData))
          .toList();

      print('Response data 2 $meetings');
      // print('All data 2 $alldata');

      return meetings; // Return the meetings data when successful
    } else {
      throw Exception('Failed to load meetings');
    }
  }
    void _onTabTapped(int index) {
    // setState(() {
    //   0 = index;
    // });
  }

  Future<void> scheduleMeeting() async {
    final url = Uri.parse(
        'https://server-eight-beige.vercel.app/api/admin/adminScheduleMeeting');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $Token',
    };

    final body = json.encode({
    "email": "ebisedi@yahoo.com",
    "description": "Introduction to Go",
    "date": "23/12/2023",
    "time": "1:30pm",
    "courseName": "Go",
    "isPaid": "free",
    "amount": 0
});

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
           print(response.body);
    } else {
      // Meeting scheduling failed
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
          padding: const EdgeInsets.only(top: 20,left: 15),
          child: Thetext(thetext: "Live Sessions", style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp
            
          )
          ),
        ),
          ),
      body: FutureBuilder<List<Meeting>>(
        future: futureMeetings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final alldatas = snapshot.data!;
            if (alldatas.isEmpty) {
              print('Meetings data is empty.');
              return Center(child: Text('No meetings found.'));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: alldatas.length,
                  itemBuilder: (context, index) {
                    final meeting = alldatas[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(width: 0.5, color: Colors.black)),
                        padding: EdgeInsets.all(
                            16.0), 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Thetext(
                                    thetext: meeting.courseName,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp
                                    )),

                                    Row(
                                      children: [
                                        Icon(Icons.access_time,color: Colors.blue,),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Thetext(thetext: meeting.time, style: GoogleFonts.poppins()),
                                              SizedBox(width: 2.w,),
                                              Thetext(thetext: meeting.date, style: GoogleFonts.poppins()),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),


                                         Row(
                                      children: [
                                        Icon(Icons.person,color: Colors.blue,),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              //Thetext(thetext: meeting.time, style: GoogleFonts.poppins()),
                                             // SizedBox(width: 2.w,),
                                              Thetext(thetext: meeting.instructor, style: GoogleFonts.poppins()),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                              ],
                            ),

                            
                            IconButton(
                              icon: Icon(Icons.copy),  
                              onPressed: () {
                                FlutterClipboard.copy(
                                        "https://decode-lms.netlify.app/lecture/${meeting.room}")
                                    .whenComplete((() {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return EnrollmentDialog(
                                            title: "Link Copied",
                                            message:
                                                "Attend via Desktop Browser",
                                            message2: "Close",
                                            press1: () {
                                              Navigator.pop(context);
                                            },
                                            press2: () {
                                              Navigator.pop(context);
                                            },
                                            theicon: Icon(
                                              Icons.check_circle,
                                              size: 50,
                                              color: Colors.blue,
                                            ));
                                      }));
                                }));
                                print(meeting.room);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(child: Text('No meetings found.'));
          }
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 0, onTabTapped:_onTabTapped ),
    );
  }
}
