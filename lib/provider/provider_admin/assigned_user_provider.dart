import 'package:flutter/foundation.dart';

class AssignedUserProviderAdmin with ChangeNotifier {
  String _reportingManager = '';
  String get reportingManager => _reportingManager;

  void setReportingManager(String value) {
    _reportingManager = value;
    notifyListeners();
  }
}
