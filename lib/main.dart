import 'package:flutter/material.dart';

import 'views/pages/events_page.dart';
import 'views/pages/login_page.dart';
import 'views/themes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haleo',
      theme: CustomTheme.haleo,
      home: LoginPage(),
    );
  }
}