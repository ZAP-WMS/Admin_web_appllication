import 'package:flutter/widgets.dart';

class textproviderAdmin with ChangeNotifier {
  String? _editdata;

  String? get changedata => _editdata;
  editname() {
    _editdata = changedata;
    notifyListeners();
  }
}
