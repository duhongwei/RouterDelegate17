RouterDelegate17 是 RouterDelegate 的子类。用 Navgator2.0 实现的了 push,pop,replace 的方法。与 Navgator1.0不同的是，可以方便的跳转到页面栈中的任意页面。 

## 演示
动图为 example 文件中的 main.dart的运行效果。

<img src="https://github.com/duhongwei/RouterDelegate17/main/image/sample.gif"/>

## 功能
1. `Future<T?> push<T>(Page<T> page)` 页面入栈。如果待入栈的页面已经存在，上面的页面全部弹出。也就是说可以跳转到栈中任意页面。
2. `bool pop<T extends Object>` 栈顶的页面出栈。
3. `Future<T?> replace<T, TO>(Page<T> page, {TO? result})` 页面替换。如果新页面在栈中已经存在，则栈顶的页面全部弹出。
4. 页面状态监控。比如 A,B，二个页面。栈中有 A 页面， B 入栈，A 页面响应 `PageStatus.leave`，因为此时 A 页面被 B 页面覆盖了。B 页面 弹出 A 页面响应 `PageStatus.enter` 方法，因为 此时 A 页面又重新显示了。如果页面是首次入栈，页面的状态是 `PageStatus.none`
5. 退出程序监控。每当要退出首页（比如在首页按物理退出键）都会记录下来，并报告次数。
一般2秒（默认）内连按两次就需要退出程序。按一次可以 toast 通知。
6. openDialog。 对 showDialog 的包装，为了让 dialog下面的页面可以及时修改`PageStatus`，如果直接调用 showDialog，dialog下面的页面不会改变状态。
7. openModalBottomSheet 对 showModalBottomSheet 的包装，为了让 ModalBottomSheet 下面的页面可以及时修改`PageStatus`。如果直接调用  showModalBottomSheet，ModalBottomSheet 下面的页面不会改变状态。
## 使用

1. 安装
`flutte pub get router_delegate17`
2. 为了方便说明，生成一个全局变量 `routerDelegate = RouterDelegate17()`，一个页面 PageA,一个页面PageB，一个页面 C
在 main.dart 中，初始化首页，引用 routerDelegate
```dart
void main() async {
  await app.init(pages: [MaterialPage(child: PageA())]);
  runApp(const MyApp());
}
Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Router(
        routerDelegate: routerDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
然后就可以使用 `routerDelegate.push` 等方法进行页面跳转了。
```
3. 页面 A 中 PageA 跳转 PageB `routerDelegate.push(PageB())`,在页面B中 PageB跳PageC `routerDelegate.push(PageC())`
4. 在页面 C 中可以直接回到 页面A `routerDelegate.push(PageA())`
5. 在跳转的时候页面上会显示页面当前的状态。

其它的演示效果直接看完整示例吧，在这里 https://github.com/duhongwei/RouterDelegate17/tree/main/example 。

## 补充

RouterDelegate17 是 RouterDelegate 的子类。就是帮你实现的必要的方法，方便使用。

为了简化逻辑，方便使用，RouterDelegate17 暂时并不支持 web 开发。

