import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

logoutFunction({required BuildContext context}) {
  SharedPreferences.getInstance().then(
    (preferences) {
      preferences.clear();
    },
  );

  Navigator.pushReplacementNamed(context, 'login-screen');
}
