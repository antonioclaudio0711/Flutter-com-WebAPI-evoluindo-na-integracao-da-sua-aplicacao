import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout_function.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/screens/exceptions/token_not_valid_exception.dart';
import 'package:flutter_webapi_first_course/screens/pages/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();

  JournalService service = JournalService();

  int? userId;

  String? userToken;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título baseado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
            onPressed: () => refresh(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              onTap: () {
                logoutFunction(context: context);
              },
              title: const Text("Sair"),
            )
          ],
        ),
      ),
      body: (userId != null && userToken != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                userId: userId!,
                refreshFunction: refresh,
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                token: userToken!,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void refresh() {
    SharedPreferences.getInstance().then(
      (preferences) {
        String? token = preferences.getString("accessToken");
        String? email = preferences.getString("email");
        int? id = preferences.getInt("id");

        if (token != null && email != null && id != null) {
          setState(() {
            userId = id;
            userToken = token;
          });

          service
              .getAll(
            id: id.toString(),
            token: token,
          )
              .then(
            (List<Journal> listJournal) {
              setState(
                () {
                  database = {};
                  for (Journal journal in listJournal) {
                    database[journal.id] = journal;
                  }
                },
              );
            },
          );
        } else {
          Navigator.pushReplacementNamed(context, "login-screen");
        }
      },
    ).catchError(
      test: (error) => error is TokenNotValidException,
      (error) {
        logoutFunction(context: context);
      },
    ).catchError(
      test: (error) => error is HttpException,
      (error) {
        var innerError = error as HttpException;
        showExceptionDialog(context: context, content: innerError.message);
      },
    );
  }
}
