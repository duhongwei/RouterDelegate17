

RouterDelegate17 is a subclass of RouterDelegate. Implemented push,pop,replace methods with Navgator2.0. Different from Navgator 1.0, it can easily jump to any page in the page stack, as well as the function of page status monitoring. Support android, ios.

[中文](https://github.com/duhongwei/RouterDelegate17/blob/main/README_CN.md)

## Demo
The animation shows the running effect of main.dart in the example file.

<img src="https://raw.githubusercontent.com/duhongwei/RouterDelegate17/main/img/demo.gif"/>

## Introduction
1. `Future<T?> push<T>(Page<T> page)` The page is pushed onto the stack. If the page to be pushed into the stack already exists, all the above pages will be popped up. That is to say, you can jump to any page in the stack.
2. `bool pop<T extends Object>` The page at the top of the stack is popped.
3. `Future<T?> replace<T, TO>(Page<T> page, {TO? result})` page replacement. If the new page already exists in the stack, all the pages at the top of the stack are popped.
4. Page status monitoring.
5. Exit program monitoring. Whenever you want to exit the home page (such as pressing the physical exit button on the home page), it will be recorded and the number of times will be reported.
6. openDialog. Wrapping showDialog, in order to allow the page below dialog to modify `PageStatus` in time, if showDialog is called directly, the page below dialog will not change the state.
7. openModalBottomSheet. Wrapping showModalBottomSheet, so that the page under ModalBottomSheet can modify `PageStatus` in time. If you call showModalBottomSheet directly, the page below ModalBottomSheet will not change state.

## Usage

Full example, here: [https://github.com/duhongwei/RouterDelegate17/tree/main/example](https://github.com/duhongwei/RouterDelegate17/tree/main/example).

