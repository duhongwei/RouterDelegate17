import 'package:example/app.dart';
import 'package:example/pages/b.dart';

import 'package:example/widgets/status_text.dart';
import 'package:flutter/material.dart';

class PageA extends StatefulWidget {
  const PageA({Key? key}) : super(key: key);

  @override
  State<PageA> createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  dynamic resultB;
  int exitCount = 0;
  @override
  void initState() {
    //如果是 android 按物理返回键
    routerDelegate.exitCount.addListener(() {
      setState(() {
        exitCount = routerDelegate.exitCount.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('page A')),
      body: Column(children: [
        ValueListenableBuilder(
            valueListenable: routerDelegate.currentNavSettings.status,
            builder: (context, value, child) {
              return StatusText(text: value.toString());
            }),
        ElevatedButton(
            onPressed: () async {
              resultB = await routerDelegate.push(const MaterialPage(child: PageB()));
              setState(() {});
            },
            child:const Text('goto pageB')),
        StatusText(text: resultB ?? 'no return value'),
        StatusText(text: exitCount.toString())
      ]),
    );
  }
}
