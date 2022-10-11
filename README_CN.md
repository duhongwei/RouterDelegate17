RouterDelegate17 是 RouterDelegate 的子类。用 Navgator2.0 实现了 push,pop,replace 方法。与 Navgator1.0不同的是，可以方便的跳转到页面栈中的任意页面,还有页面状态监听的功能。 支持 android ,ios。
## 演示
动图为 example 文件中的 main.dart的运行效果。

<img src="https://raw.githubusercontent.com/duhongwei/RouterDelegate17/main/img/demo.gif"/>

## 简介
1. `Future<T?> push<T>(Page<T> page)` 页面入栈。如果待入栈的页面已经存在，上面的页面全部弹出。也就是说可以跳转到栈中任意页面。
2. `bool pop<T extends Object>` 栈顶的页面出栈。
3. `Future<T?> replace<T, TO>(Page<T> page, {TO? result})` 页面替换。如果新页面在栈中已经存在，则栈顶的页面全部弹出。
4. 页面状态监控。
5. 退出程序监控。每当要退出首页（比如在首页按物理退出键）都会记录下来，并报告次数。
6. openDialog。 对 showDialog 的包装，为了让 dialog下面的页面可以及时修改`PageStatus`，如果直接调用 showDialog，dialog下面的页面不会改变状态。
7. openModalBottomSheet 对 showModalBottomSheet 的包装，为了让 ModalBottomSheet 下面的页面可以及时修改`PageStatus`。如果直接调用  showModalBottomSheet，ModalBottomSheet 下面的页面不会改变状态。

## 使用
完整示例，在这里 [https://github.com/duhongwei/RouterDelegate17/tree/main/example](https://github.com/duhongwei/RouterDelegate17/tree/main/example)。


