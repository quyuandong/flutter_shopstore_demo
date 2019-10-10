import 'package:flutter/material.dart';

import './routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',


      initialRoute: "/",
      onGenerateRoute: onGenerateRoute,
      // home: Tabs(title: 'shopStore'),
    );
  }
}


