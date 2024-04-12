import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_appllication/model/admin_model/daily_projectModel.dart';

class SummaryProviderAdmin extends ChangeNotifier {
  List<DailyProjectModelAdmin> _dailydata = [];

  List<DailyProjectModelAdmin> get dailydata {
    return _dailydata;
  }

  fetchdailydata(
      String depoName, String userId, DateTime date, DateTime endDate) async {
    final List<DailyProjectModelAdmin> loadeddata = [];
    for (DateTime initialdate = date;
        initialdate.isBefore(endDate.add(const Duration(days: 1)));
        initialdate = initialdate.add(const Duration(days: 1))) {
      // print(DateFormat.yMMMMd().format(initialdate));

      FirebaseFirestore.instance
          .collection('DailyProjectReport2')
          .doc(depoName)
          .collection(userId)
          .doc(DateFormat.yMMMMd().format(initialdate))
          .get()
          .then((value) {
        if (value.data() != null) {
          // print('swswssw${value.data()!['data'].length}');
          for (int i = 0; i < value.data()!['data'].length; i++) {
            loadeddata
                .add(DailyProjectModelAdmin.fromjson(value.data()!['data'][i]));
          }
          _dailydata = loadeddata;
          notifyListeners();
        }
      });
    }
  }
}
