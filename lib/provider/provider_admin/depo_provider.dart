import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DepoProviderAdmin extends ChangeNotifier {
  List<String>? depolist;
  List<String> depodata = [];

  fetchData(String cityname) {
    FirebaseFirestore.instance.collection(cityname).get().then((value) {
      value.docs.forEach((element) {
        var data = element['DepoName'];
        depodata.add(data);
      });
    });

    depolist = depodata;
    print(depolist);
    notifyListeners();
  }
}
