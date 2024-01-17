import 'package:decodelms/widgets/colors.dart';
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

  TheFormfield({
    this.controller,
    this.prefix,
    this.suffix,
    this.value,
    this.input,
    required this.vis,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TheFormfieldState();
}

class _TheFormfieldState extends ConsumerState<TheFormfield> {
  String? validateInput(String? value) {
    // You can add your own validation logic here
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    // Additional validation checks can be added as needed
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 8.h,
        width: MediaQuery.of(context).size.width - 10.w,
        decoration: BoxDecoration(
          color: formfieldcolor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.vis,
              onChanged: (value) {
                setState(() {
                  widget.input = value;
                  print(value);
                });
              },
              validator: validateInput, // Validation function
              decoration: InputDecoration(
                hintStyle: GoogleFonts.poppins(color: hintcolor),
                hintText: widget.value,
                prefixIcon: widget.prefix,
                suffixIcon: widget.suffix,
                suffixIconColor: hintcolor,
                prefixIconColor: hintcolor,
                border: InputBorder.none,
                prefixStyle: GoogleFonts.poppins(color: hintcolor),
              ),
              style: GoogleFonts.poppins(color: hintcolor),
            ),
          ),
        ),
      ),
    );
  }
}
