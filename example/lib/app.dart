import 'package:example/pages/a.dart';
import 'package:flutter/material.dart';
import 'package:router_delegate17/router_delegate17.dart';

import 'package:flutter/foundation.dart';

final routerDelegate = RouterDelegate17([const MaterialPage(child: PageA())]);
devPrint(object) {
  if (kDebugMode) {
    print(object);
  }
}

const buttonTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
