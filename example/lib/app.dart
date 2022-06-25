import 'package:flutter/material.dart';
import 'package:router_delegate17/router_delegate17.dart';
import 'package:flutter/foundation.dart';

final routerDelegate = RouterDelegate17();
devPrint(object) {
  if (kDebugMode) {
    print(object);
  }
}

const buttonTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
