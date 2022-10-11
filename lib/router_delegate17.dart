// Copyright 2022 duhongwei. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library router_delegate17;

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// route management
///
/// Jump to the page to call the [push] method.
/// To popup page call the [pop] method. You can also use [Navigator] to pop up the page directly, both methods can take return values.
///
/// [replace] method replace the current page.
///
/// In the page you can get the status of the page [PageStatus]. All pages are managed with stacks. The new page status is [PageStatus.none].
/// The status of the page below the new page changes to [PageStatus.leave]. After the upper page pops up, the status of the lower page is [Page.enter].
///
/// There are two ways to show the dialog [showDialog], [openDialog]. [openDialog] is a wrapper for [showDialog].
/// Use [openDialog] to change the state of the following page. Popup dialog with [Navigator.pop].
///
/// There are two ways to show bottomSheet [showModalBottomSheet],[openModalBottomSheet]. [openModalBottomSheet] is a wrapper for [showModalBottomSheet].
/// Use [openModalBottomSheet] to change the state of the following page. Pop the bottomSheet with [Navigator.pop]
///
/// Mix in [PopNavigatorRouterDelegateMixin] to increase the handling of physical return keys
class RouterDelegate17 extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {

  /// Cancel Exit Program duration
  final Duration exitDelay;

  /// Number of requests to quit the program
  final ExitCount exitCount;

  /// Create RouterDelegate17 instance
  ///
  /// Cancel exit program duration defaults to 2 seconds
  /// `initialPages` is the initial page list and cannot be empty. Typically consists of [MaterialPage] or [CupertinoPage] instances.
  RouterDelegate17(List<Page> initialPages,
      {this.exitDelay = const Duration(seconds: 2)})
      : exitCount = ExitCount(delay: exitDelay) {
    assert(initialPages.isNotEmpty,'The initial page cannot be empty!');
    for (var page in initialPages) {
      _settingsList.add(NavSettings.fromPage(page));
    }
  }
  /// Configuration information of the current route
  NavSettings get currentNavSettings => _settingsList.last;

  /// Open dialog
  ///
  /// Wrapper for [showModalBottomSheet]. The purpose of the wrapper is to allow the following page to change state as the dialog opens and states.
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

  /// open modal bottomSheet
  ///
  /// Wrapper for [showModalBottomSheet]. The purpose of the wrapper is to allow the following page to change state as the dialog opens and states. 
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


  _ensureOne<T>(Page<T> page) {
    var setttings = NavSettings.fromPage(page);
    var index = _settingsList.indexOf(setttings);

    if (index > -1) {
      var length = _settingsList.length;
      while (--length > index) {
        _settingsList.removeLast().completer.complete();
      }
      currentNavSettings.status.value = PageStatus.enter;
    } else {
      currentNavSettings.status.value = PageStatus.leave;
      _settingsList.add(setttings);
    }
  }

  /// Jump to `Page`
  ///
  /// If `page` is a new page, the status of the new page is [PageStatus.none].
  /// if `page` is an old page, which already exists on the stack. All pages above `page` are popped. The status of `page` is [PageStatus.enter].
  Future<T?> push<T>(Page<T> page) {
    assert(_settingsList.isNotEmpty);
    // If `page` already exists, then the full above `page` pops up.
    _ensureOne<T>(page);
    notifyListeners();
    return currentNavSettings.completer.future as Future<T?>;
  }

  /// page pop
  ///
  /// You can also use the navigator to pop up the page
  /// ```dart
  /// Navigator.of(context)pop()`
  /// ```
  /// [Navigator.onPopPage] will respond to this request and then call [pop] to handle it. Same way.
  /// `result` is an optional return value, which is returned to the caller when the page pops up.
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

  /// Replace current page with `page`
  ///
  /// The current page is popped from the stack. Return [result] to the caller. Call [push] method  push `page` to the stack.
  Future<T?> replace<T, TO>(Page<T> page, {TO? result}) {
    assert(_settingsList.isNotEmpty);
    var last = _settingsList.removeLast();
    last.completer.complete(result);

    return push(page);
  }

  //--------- private

  final List<NavSettings> _settingsList = [];
}


enum PageStatus {
  /// new page
  none,

  /// No longer a top-level page, obscured by a new page or a dialog.
  leave,

  /// Re-become top-level page
  enter
}

/// Exit program request count.
///
/// Different from the normal count, the [delay] will be subtracted after each increase of the count.
/// The application can listen for changes in [value] to decide whether to exit the program.
/// ```dart
/// var exitCount = ExitCount()
/// exitCount.addListener(() {
///   print(exitCount.value);
/// });
/// ```
class ExitCount extends ChangeNotifier {
  int _value = 0;

  /// The added times will be subtracted after the [delay].
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

/// routing configuration
class NavSettings<T> {
  /// page
  ///
  /// Typically page is an instance of [MaterialPage] or [CupertinoPage].
  final dynamic page;

  /// Each page will have a completer
  final Completer<T> completer;

  /// page status
  final status = ValueNotifier<PageStatus>(PageStatus.none);
  NavSettings({required this.page, required this.completer});

  /// Create NavSettings instance based on page
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
