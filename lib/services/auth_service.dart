import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/helpers/constants.dart';
import 'package:flutter_webapi_first_course/screens/exceptions/user_not_find_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String url = Constants.url;
  http.Client client = Constants().client;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    http.Response response = await client.post(
      Uri.parse("${url}login"),
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case 'Cannot find user':
          throw UserNotFindException();
      }

      throw HttpException(response.body);
    } else {
      saveUserInfos(response.body);
      return true;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    http.Response response = await client.post(
      Uri.parse("${url}register"),
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    } else {
      saveUserInfos(response.body);
      return true;
    }
  }

  Future<void> saveUserInfos(String body) async {
    Map<String, dynamic> map = json.decode(body);

    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("accessToken", token);
    preferences.setString("email", email);
    preferences.setInt("id", id);
  }
}
