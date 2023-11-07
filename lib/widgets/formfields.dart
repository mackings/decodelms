import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TheFormfield extends ConsumerStatefulWidget {
  var prefix;
  var suffix;
  var controller;
  var value;
  var input;
  bool vis;

  TheFormfield(
      {this.controller, this.prefix, this.suffix, this.value, this.input,required this.vis});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TheFormfieldState();
}

class _TheFormfieldState extends ConsumerState<TheFormfield> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40.sp,
        width: MediaQuery.of(context).size.width - 10.w,
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
              controller: widget.controller,
              obscureText: widget.vis,
              onChanged: (value) {
                setState(() {
                  widget.input = value;
                  print(value);
                });
              },
              decoration: InputDecoration(
                hintStyle: GoogleFonts.poppins(color: Colors.black),
                hintText: widget.value,
                prefixIcon: widget.prefix,
                suffixIcon: widget.suffix,
                border: InputBorder.none,
              ),
              style: GoogleFonts.poppins(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
