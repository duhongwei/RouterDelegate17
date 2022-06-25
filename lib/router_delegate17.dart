library router_delegate17;

import 'dart:async';
import 'package:flutter/material.dart';

class RouterDelegate17 extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  //RouterDelegate17._();
  //static final RouterDelegate17 _router = RouterDelegate17._();

  /* factory RouterDelegate17() {
    return _router;
  } */

  final Duration exitDelay;
  final ExitCount exitCount;
  RouterDelegate17({this.exitDelay = const Duration(seconds: 2)})
      : exitCount = ExitCount(delay: exitDelay);

  NavSettings get currentNavSettings => _settingsList.last;
  NavSettings? get previousNavSettings {
    var len = _settingsList.length;
    if (len < 2) return null;
    return _settingsList[len - 2];
  }

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

  Future<T?> push<T>(Page<T> page) {
    //如果已存在，那么 上面的全弹出。
    assert(_settingsList.isNotEmpty);
    _ensureOne<T>(page);
    notifyListeners();
    return currentNavSettings.completer.future as Future<T?>;
  }

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

  Future<T?> replace<T, TO>(Page<T> page, {TO? result}) {
    assert(_settingsList.isNotEmpty);
    var last = _settingsList.removeLast();
    last.completer.complete(result);

    _ensureOne<T>(page);
    notifyListeners();
    return currentNavSettings.completer.future as Future<T?>;
  }

  //--------- private

  final List<NavSettings> _settingsList = [];
}

enum PageStatus {
  none,
  // hide by other page
  leave,
  // is top most page
  enter
}

class ExitCount extends ChangeNotifier {
  int _value = 0;
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

class NavSettings<T> {
  final dynamic page;
  final Completer<T> completer;

  final status = ValueNotifier<PageStatus>(PageStatus.none);
  NavSettings({required this.page, required this.completer});
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
