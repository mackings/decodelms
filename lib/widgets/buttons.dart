import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Mybuttons extends StatefulWidget {
  final VoidCallback callback;
  var buttontxt;
  Color btncolor;

  Mybuttons({this.buttontxt, required this.callback, required this.btncolor});

  @override
  State<Mybuttons> createState() => _MybuttonsState();
}

class _MybuttonsState extends State<Mybuttons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.callback,
      child: Container(
        height: 7.h,
        width: MediaQuery.of(context).size.width - 13.w,
        child: Center(
            child: Text(
          "${widget.buttontxt}",
          style: GoogleFonts.poppins(color: Colors.white),
        )),
        decoration: BoxDecoration(
            color: widget.btncolor, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
