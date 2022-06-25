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
    //如果是 android 按物理返回键
    routerDelegate.exitCount.addListener(() {
      setState(() {
        exitCount = routerDelegate.exitCount.value;
        //实际应用中这里给出警告。 2 秒后 exitCount= 恢复为 0
        if (exitCount == 1) {
          countText = '在首页按 back 键 $exitCount 次';
        }
        //实际应用中这里执行退出程序操作。 2 秒后 exitCount= 恢复为 1
        if (exitCount == 2) {
          countText = '在首页按 back 键 $exitCount 次';
        }
        //2 秒内如果一直按会一直增加。
        else{
          countText = '在首页按 back 键 $exitCount 次';
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('页面 A')),
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
              resultB = '页面B pop 后的返回值 $resultB';
              setState(() {});
            },
            child: const Text('显示页面B',style: buttonTextStyle,)),
        StatusText(text: resultB ?? '暂无上层页面返回值'),
        StatusText(text: countText)
      ]),
    );
  }
}
