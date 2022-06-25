// Copyright 2022 duhongwei. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file

library router_delegate17;

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 路由管理
///
/// 在使用其它方法之前，必须首先调用 [setInitialPages] 设置初始页面。初始页面可以有多个。
///
/// 跳转到页面调用  [push] 方法
///
/// 弹出页面调用 [pop] 方法。 也可以用 [Navigator] 直接弹出页面，两种方法都可以带返回值
/// ```dart
/// Navigator.of(context)pop()`
/// ```
/// [replace] 方法 替换当前页面。
///
/// 在页面中可以获取页面的状态 [PageStatus]。所有页面是用栈管理的。新页面入栈状态为 [PageStatus.none]。
/// 新页面下面的页面的状态变为 [PageStatus.leave]。上面的页面弹出后，下面的页面的状态为 [Page.enter]。
///
/// 有两种方法可以显示对话框 [showDialog],[openDialog]。[openDialog] 是 [showDialog]的包装。
/// 使用 [openDialog] 可以改变下面页面的状态。弹出对话框用 [Navigator.pop]
///
/// 有两种方法可以显示 bottomSheet [showModalBottomSheet],[openModalBottomSheet]。[openModalBottomSheet] 是 [showModalBottomSheet]的包装。
/// 使用 [openModalBottomSheet] 可以改变下面页面的状态。 弹出 bottomSheet 用 [Navigator.pop]
///
/// 混入 [PopNavigatorRouterDelegateMixin] 增加物理返回键的处理
class RouterDelegate17 extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  /// 取消退出程序延时时间
  final Duration exitDelay;

  /// 退出程序请求次数
  final ExitCount exitCount;

  /// 创建RouterDelegate17实例
  ///
  /// 取消退出程序延时时间默认为 2秒
  RouterDelegate17({this.exitDelay = const Duration(seconds: 2)})
      : exitCount = ExitCount(delay: exitDelay);

  /// 当前路由的配置信息
  NavSettings get currentNavSettings => _settingsList.last;

  /// 打开对话框
  ///
  /// [showModalBottomSheet]的包装。包装的目的是为了让下面的页面可以随着对话框的打开和状态而改变状态
  Future<T?> openDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) async {
    currentNavSettings.status.value = PageStatus.leave;
    var result = await showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings);
    currentNavSettings.status.value = PageStatus.enter;
    return result;
  }

  /// 打开模态 bottomSheet
  ///
  ///  [showModalBottomSheet]的包装。包装的目的是为了让下面的页面可以随着对话框的打开和状态而改变状态
  Future<T?> openModalBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) async {
    currentNavSettings.status.value = PageStatus.leave;
    var result = await showModalBottomSheet(
        context: context,
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        barrierColor: barrierColor,
        isScrollControlled: isScrollControlled,
        useRootNavigator: true,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        routeSettings: routeSettings,
        transitionAnimationController: transitionAnimationController);
    currentNavSettings.status.value = PageStatus.enter;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var pages = _settingsList.map<Page>((settings) => settings.page);
    return Navigator(
      key: navigatorKey,
      onPopPage: (Route<dynamic> route, dynamic result) {
        if (pop(result)) {
          return route.didPop(result);
        } else {
          return false;
        }
      },
      pages: List.of(pages),
    );
  }

  @override
  Future<bool> popRoute() async {
    var done = await super.popRoute();
    if (done) {
      return done;
    } else {
      if (!pop()) {
        exitCount._tryAdd();
      }
      return true;
    }
  }

  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(RouteSettings configuration) async {}

  /// 设置初始页面
  ///
  /// 必须在其它方法之前调用。
  /// [pages]一般来说由 [MaterialPage] 或 [CupertinoPage] 实例组成。
  setInitialPages<T>(List<Page> pages) {
    for (var page in pages) {
      _settingsList.add(NavSettings.fromPage(page));
    }
  }

  _ensureOne<T>(Page<T> page) {
    var setttings = NavSettings.fromPage(page);
    var index = _settingsList.indexOf(setttings);

    if (index > -1) {
      _settingsList.removeRange(index + 1, _settingsList.length);
      currentNavSettings.status.value = PageStatus.enter;
    } else {
      currentNavSettings.status.value = PageStatus.leave;
      _settingsList.add(setttings);
    }
  }

  /// 跳转到[page]
  ///
  /// [page]是新页面，新页面的状态为 [PageStatus.none]
  /// [page]老页面,在栈中已经存在。[page]上面的所有页面出栈。[page]的状态为 [PageStatus.enter]
  Future<T?> push<T>(Page<T> page) {
    //如果已存在，那么 上面的全弹出。
    assert(_settingsList.isNotEmpty);
    _ensureOne<T>(page);
    notifyListeners();
    return currentNavSettings.completer.future as Future<T?>;
  }

  /// 页面出栈
  ///
  /// 如果是调用
  /// ```dart
  /// Navigator.of(context)pop()`
  /// ```
  /// [Navigator.onPopPage] 会响应这个请求，然后调用 [pop]来处理。殊途同归。
  /// [result] 是可选的返回值，页面弹出的时候返回给调用者。
  bool pop<T extends Object>([T? result]) {
    if (_settingsList.length < 2) {
      return false;
    }
    var last = _settingsList.removeLast();
    notifyListeners();
    last.completer.complete(result);

    currentNavSettings.status.value = PageStatus.enter;

    return true;
  }

  /// 用[page]替换当前页面
  ///
  /// 当前页面出栈。把 [result] 返回给调用者。
  /// 执行 [push] 方法 [page] 入栈
  Future<T?> replace<T, TO>(Page<T> page, {TO? result}) {
    assert(_settingsList.isNotEmpty);
    var last = _settingsList.removeLast();
    last.completer.complete(result);

    return push(page);
  }

  //--------- private

  final List<NavSettings> _settingsList = [];
}

/// 页面状态
enum PageStatus {
  /// 新入栈
  none,

  /// 不再是顶层页面，被新页面（对话框）遮挡。
  leave,

  /// 重新成为顶层页面。
  enter
}

/// 退出程序请求计次
///
/// 和普通的计次不同，每次增加次数后 [delay] 时间后都会被减掉。
/// 应用程序可以监听 [value] 的变化来决定是否要退出程序。
/// ```dart
/// var exitCount = ExitCount()
/// exitCount.addListener(() {
///   print(exitCount.value);
/// });
/// ```
class ExitCount extends ChangeNotifier {
  int _value = 0;

  /// 增加的次数在 [delay] 时间后会被减掉。
  final Duration delay;

  ExitCount({required this.delay});

  int get value => _value;

  _tryAdd() {
    _value++;
    notifyListeners();
    Timer(delay, () {
      _value--;
    });
  }
}

/// 路由配置
///
/// 虽然没有设置为私有，这个类基本上是专为 [RouterDelegate17] 准备的。
class NavSettings<T> {
  /// 页面
  ///
  /// 一般来说 page 是 [MaterialPage] 或 [CupertinoPage] 实例。
  final dynamic page;

  /// 每个页面都会有一个 completer
  final Completer<T> completer;

  /// 页面状态
  final status = ValueNotifier<PageStatus>(PageStatus.none);
  NavSettings({required this.page, required this.completer});

  /// 以 page 为基础创建 NavSettings 实例
  factory NavSettings.fromPage(Page<T> page) {
    return NavSettings<T>(page: page, completer: Completer<T>());
  }
  @override
  int get hashCode => page.child.runtimeType.hashCode;

  @override
  bool operator ==(Object other) {
    return other is NavSettings && other.hashCode == hashCode;
  }
}
