import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_appllication/model/user_model/daily_projectModel.dart';
import 'package:web_appllication/model/user_model/energy_management.dart';
import 'package:web_appllication/screen_user/overview_pages/daily_project.dart';

List<int> globalRowIndex = [];

class SummaryProviderUser extends ChangeNotifier {
  List<DailyProjectModelUser> _dailydata = [];
  List<EnergyManagementModelUser> _energydata = [];

  List<dynamic> intervalListData = [];
  List<dynamic> energyListData = [];

  List<dynamic> get intervalData => intervalListData;
  List<dynamic> get energyConsumedData => energyListData;

  List<DailyProjectModelUser> get dailydata {
    return _dailydata;
  }

  List<EnergyManagementModelUser> get energyData {
    return _energydata;
  }

  fetchdailydata(
      String depoName, String userId, DateTime date, DateTime endDate) async {
    globalItemLengthList.clear();
    isShowPinIcon.clear();

    final List<DailyProjectModelUser> loadeddata = [];
    _dailydata.clear();
    for (DateTime initialdate = endDate;
        initialdate.isAfter(date.subtract(const Duration(days: 1)));
        initialdate = initialdate.subtract(const Duration(days: 1))) {
      print(date.add(const Duration(days: 1)));
      print(DateFormat.yMMMMd().format(initialdate));
      FirebaseFirestore.instance
          .collection('DailyProject3')
          .doc(depoName)
          .collection(DateFormat.yMMMMd().format(initialdate))
          .doc(userId)
          .get()
          .then((value) {
        if (value.data() != null) {
          print('swswssw${value.data()!['data'].length}');
          for (int i = 0; i < value.data()!['data'].length; i++) {
            globalItemLengthList.add(0);
            isShowPinIcon.add(false);
            var _data = value.data()!['data'][i];
            loadeddata.add(DailyProjectModelUser.fromjson(_data));
            globalRowIndex.add(i + 1);
          }
          _dailydata = loadeddata;
          notifyListeners();
        }
      });
    }
  }

  fetchEnergyData(String cityName, String depoName, String userId,
      DateTime date, DateTime endDate) async {
    globalRowIndex.clear();
    final List<dynamic> timeIntervalList = [];
    final List<dynamic> energyConsumedList = [];
    int currentMonth = DateTime.now().month;
    String monthName = DateFormat('MMMM').format(DateTime.now());
    final List<EnergyManagementModelUser> fetchedData = [];
    _energydata.clear();
    timeIntervalList.clear();
    energyConsumedList.clear();
    for (DateTime initialdate = endDate;
        initialdate.isAfter(date.subtract(const Duration(days: 1)));
        initialdate = initialdate.subtract(const Duration(days: 1))) {
      // print(date.add(const Duration(days: 1)));
      // print(DateFormat.yMMMMd().format(initialdate));

      FirebaseFirestore.instance
          .collection('EnergyManagementTable')
          .doc(cityName)
          .collection('Depots')
          .doc(depoName)
          .collection('Year')
          .doc(DateTime.now().year.toString())
          .collection('Months')
          .doc(monthName)
          .collection('Date')
          .doc(DateFormat.yMMMMd().format(initialdate))
          .collection('UserId')
          .doc(userId)
          .get()
          .then((value) {
        if (value.data() != null) {
          for (int i = 0; i < value.data()!['data'].length; i++) {
            var data = value.data()!['data'][i];
            fetchedData.add(EnergyManagementModelUser.fromJson(data));
            timeIntervalList.add(value.data()!['data'][i]['timeInterval']);
            energyConsumedList.add(value.data()!['data'][i]['energyConsumed']);
          }
          _energydata = fetchedData;
          intervalListData = timeIntervalList;
          energyListData = energyConsumedList;
          notifyListeners();
        } else {
          intervalListData = timeIntervalList;
          energyListData = energyConsumedList;

          notifyListeners();
        }
      });
    }
  }
}