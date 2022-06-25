import 'package:example/app.dart';
import 'package:example/pages/a.dart';
import 'package:flutter/material.dart';

void main() async {
  await routerDelegate.setInitialPages([MaterialPage(child: PageA())]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter RouteDelegate17 demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Router(
          routerDelegate: routerDelegate,
          backButtonDispatcher: RootBackButtonDispatcher()),
    );
  }
}
