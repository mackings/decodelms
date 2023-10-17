import 'dart:convert';

import 'package:decodelms/views/videocalls/videocall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:state_notifier/state_notifier.dart';

import '../models/user.dart';

class Dataclass {
  final Data = StateProvider((ref) {
    return 100;
  });

  final Color = StateProvider((ref) {
    return "red";
  });
}

final Apiprovider = Provider((ref) {
  return Api();
});

List? alldatas;

class Myfig extends StateNotifier {
  Myfig() : super(0);

  void increase() {
    state++;
    print(state);
  }

  decrease() {
    state--;
  }
}

class Api {
  dynamic alldata;

  Future signin(Login login) async {
    dynamic payload =
        jsonEncode({"email": login.email, "password": login.password});
    final response = await http.post(
        Uri.parse("https://decode-mnjh.onrender.com/api/user/login"),
        body: payload,
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print(data);
      return data; // You may want to return data or handle it as needed
    } else {
      print(payload);
      throw Exception(response.body);
    }
  }

  final thefigures = StateNotifierProvider((ref) => Myfig());

  Future getdata() async {
    final response = await http.get(
      Uri.parse("https://wordsdrip.onrender.com/allbooks/"),
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print(data["books"]);
      return data["books"];
    } else {
      throw Exception();
    }
  }

  final themeprovider = StateProvider((ref) => 0);

  final demoprovider = StateProvider((ref) {
    return "Yagory";
  });
}
