import 'package:flutter/foundation.dart';

class AllDepoSelectProviderUser with ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  void setCheckedBool(bool value) {
    _isChecked = value;
    print('isChecked - ${value}');
    notifyListeners();
  }

  void reloadCheckbox() {
    notifyListeners();
  }
}
