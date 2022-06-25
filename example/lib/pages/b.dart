import 'package:example/widgets/status_text.dart';
import 'package:flutter/material.dart';
import 'package:example/app.dart';

class PageB extends StatefulWidget {
  const PageB({Key? key}) : super(key: key);

  @override
  State<PageB> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('page B')),
      body: Column(children: [
        ValueListenableBuilder(
            valueListenable: routerDelegate.currentNavSettings.status,
            builder: (context, value, child) {
              return StatusText(text: value.toString());
            }),
        ElevatedButton(
            onPressed: () async {
              var result = await routerDelegate.openDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                        child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      child: ElevatedButton(
                        child: const Text(
                          '关闭',
                          style: buttonTextStyle,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop('dialog value');
                        },
                      ),
                    ));
                  });
              devPrint('dialog 返回值是  $result');
            },
            child: const Text(
              '显示对话框',
              style: buttonTextStyle,
            )),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
            onPressed: () async {
              routerDelegate.pop(DateTime.now().second.toString());
            },
            child: const Text(
              '弹出页面B',
              style: buttonTextStyle,
            ))
      ]),
    );
  }
}
