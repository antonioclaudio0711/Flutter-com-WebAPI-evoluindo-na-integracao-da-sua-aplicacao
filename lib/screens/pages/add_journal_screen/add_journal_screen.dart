import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout_function.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/screens/exceptions/token_not_valid_exception.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/weekday.dart';
import '../../../models/journal.dart';

class AddJournalScreen extends StatelessWidget {
  final bool isEditing;
  final Journal journal;
  AddJournalScreen({
    super.key,
    required this.isEditing,
    required this.journal,
  });

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${WeekDay(journal.createdAt.weekday).long.toLowerCase()}, ${journal.createdAt.day}  |  ${journal.createdAt.month}  |  ${journal.createdAt.year}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              registerJournal(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) {
    SharedPreferences.getInstance().then(
      (preferences) {
        String? token = preferences.getString("accessToken");

        if (token != null) {
          String content = _contentController.text;

          journal.content = content;

          JournalService service = JournalService();
          if (isEditing) {
            service.edit(journal.id, journal, token).then(
                  (value) => Navigator.pop(context, value),
                );
          } else {
            service.register(journal, token).then(
                  (value) => Navigator.pop(context, value),
                );
          }
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
