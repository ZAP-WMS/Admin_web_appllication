import 'package:flutter/foundation.dart';

class RequestNotificationProvider extends ChangeNotifier {
  bool _newUserAdded = false;
  bool get newUserAdded => _newUserAdded;

  void showHideButton(bool value) {
    _newUserAdded = value;
  }
  
}
