import 'dart:convert';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:decodelms/models/meetings.dart';
import 'package:clipboard/clipboard.dart';

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
      Uri.parse('https://decode-mnjh.onrender.com/API/admin/getRoomId'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Thetext(
              thetext: "Live lessons",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.black))),
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
                            16.0), // Adjust the padding as needed
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meeting.courseName,
                                  style: TextStyle(
                                    fontWeight: FontWeight
                                        .bold, // Add styling as needed
                                    fontSize: 18, // Add your desired font size
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    'By: ${meeting.instructor}',
                                    style: TextStyle(
                                      fontSize:
                                          14, // Add your desired font size
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    Text(
                                      '  ${meeting.date} ${meeting.time}',
                                      style: TextStyle(
                                        fontSize:
                                            14, // Add your desired font size
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
    );
  }
}
