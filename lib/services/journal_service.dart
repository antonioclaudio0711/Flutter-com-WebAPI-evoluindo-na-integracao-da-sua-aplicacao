import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/helpers/constants.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/exceptions/token_not_valid_exception.dart';
import 'package:http/http.dart' as http;

class JournalService {
  static const String url = Constants.url;
  static const String resource = "journals/";
  http.Client client = Constants().client;

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.post(
      Uri.parse(getUrl()),
      body: jsonJournal,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt-expired") {
        throw TokenNotValidException();
      } else {
        throw HttpException(response.body);
      }
    } else {
      return true;
    }
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      body: jsonJournal,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt-expired") {
        throw TokenNotValidException();
      } else {
        throw HttpException(response.body);
      }
    } else {
      return true;
    }
  }

  Future<List<Journal>> getAll({
    required String id,
    required String token,
  }) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/$resource"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt-expired") {
        throw TokenNotValidException();
      } else {
        throw HttpException(response.body);
      }
    } else {
      List<Journal> list = [];

      List<dynamic> listDynamic = json.decode(response.body);

      for (var jsonMap in listDynamic) {
        list.add(
          Journal.fromMap(jsonMap),
        );
      }

      return list;
    }
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(
      Uri.parse("${getUrl()}$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt-expired") {
        throw TokenNotValidException();
      } else {
        throw HttpException(response.body);
      }
    } else {
      return true;
    }
  }
}
