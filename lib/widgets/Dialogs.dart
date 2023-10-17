import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Apidialog extends StatefulWidget {
  Widget? dialog;
  var message;

  Apidialog({this.message, this.dialog});

  @override
  State<Apidialog> createState() => _ApidialogState();
}

class _ApidialogState extends State<Apidialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue,
      child: Container(
        height: 10.h,
        width: 20.w,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        ),
      ),
      
    );
  } 
}
