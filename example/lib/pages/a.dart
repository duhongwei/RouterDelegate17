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
  String countText = '';
  @override
  void initState() {
    
    routerDelegate.exitCount.addListener(() {
      setState(() {
        exitCount = routerDelegate.exitCount.value;
        // A warning is given here in practical applications. 
        // exitCount returns to 0 after 2 seconds.
        if (exitCount == 1) {
          countText = 'Press the back key $exitCount times on the home page';
        }
        // In practical applications, the exit program operation is performed here. 
        //exitCount returns to 1 after 2 seconds.
        if (exitCount == 2) {
          countText = 'Press the back key $exitCount times on the home page';
        }
        // If you keep pressing within 2 seconds, it will keep increasing.
        else {
          countText = 'Press the back key $exitCount times on the home page';
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page A')),
      body: Column(children: [
        ValueListenableBuilder(
            valueListenable: routerDelegate.currentNavSettings.status,
            builder: (context, value, child) {
              return StatusText(text: value.toString());
            }),
        ElevatedButton(
            onPressed: () async {
              resultB =
                  await routerDelegate.push(const MaterialPage(child: PageB()));
              resultB = 'Return value  $resultB after page B pop';
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text(
              'Show PageB',
              style: buttonTextStyle,
            )),
        StatusText(text: resultB ?? 'No upper page return value'),
        StatusText(text: countText)
      ]),
    );
  }
}
