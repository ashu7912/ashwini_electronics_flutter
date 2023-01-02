import 'package:flutter/foundation.dart';
import 'dart:collection';

class EventService extends ChangeNotifier {
  bool _isAscending = true;
  bool _isAlphabaticalSort = false;

  bool get isAscending {
    return _isAscending;
  }

  bool get isAlphabaticalSort {
    return _isAlphabaticalSort;
  }

  void toggleIsAscending () {
    _isAscending = !_isAscending;
    print(_isAscending);
    notifyListeners();
  }

  void toggleIsAlphabaticalSort () {
    _isAlphabaticalSort = !_isAlphabaticalSort;
    print(_isAlphabaticalSort);
    notifyListeners();
  }

}