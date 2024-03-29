import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../KeyEvents/Grid_DataTable.dart';
import 'electrical_quality_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../authentication/auth_service.dart';
import 'package:web_appllication/style.dart';
import 'civil_quality_checklist.dart';

class QualityChecklist extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String? currentDate;
  bool? isHeader;

  QualityChecklist(
      {super.key,
      this.userId,
      required this.cityName,
      required this.depoName,
      this.currentDate,
      this.isHeader = true});

  @override
  State<QualityChecklist> createState() => _QualityChecklistState();
}

TextEditingController ename = TextEditingController();
dynamic empName,
    distev,
    vendorname,
    date,
    olano,
    panel,
    serialno,
    depotname,
    customername;

dynamic alldata;
int? _selectedIndex = 0;

dynamic userId;
TextEditingController selectedCityController = TextEditingController();

TextEditingController selectedDepoController = TextEditingController();
List<String> title = [
  'CHECKLIST FOR INSTALLATION OF PSS',
  'CHECKLIST FOR INSTALLATION OF RMU',
  'CHECKLIST FOR INSTALLATION OF  COVENTIONAL TRANSFORMER',
  'CHECKLIST FOR INSTALLATION OF CTPT METERING UNIT',
  'CHECKLIST FOR INSTALLATION OF ACDB',
  'CHECKLIST FOR  CABLE INSTALLATION ',
  'CHECKLIST FOR  CABLE DRUM / ROLL INSPECTION',
  'CHECKLIST FOR MCCB PANEL',
  'CHECKLIST FOR CHARGER PANEL',
  'CHECKLIST FOR INSTALLATION OF  EARTH PIT',
];
// ignore: non_constant_identifier_names
List<String> civil_title = [
  'CHECKLIST FOR INSTALLATION OF EXCAVATION WORK',
  'CHECKLIST FOR INSTALLATION OF EARTH WORK - BACKFILLING',
  'CHECKLIST FOR INSTALLATION OF BRICK & BLOCK MASSONARY',
  'CHECKLIST FOR INSTALLATION OF BLDG DOORS, WINDOWS, HARDWARE, GLAZING',
  'CHECKLIST FOR INSTALLATION OF FALSE CEILING',
  'CHECKLIST FOR FLOORING & TILING',
  'CHECKLIST FOR GROUT INSPECTION',
  'CHECKLIST FOR INRONITE FLOORING CHECK',
  'CHECKLIST FOR PAINTING',
  'CHECKLIST FOR PAVING WORK',
  'CHECKLIST FOR WALL CLADDING & ROOFING',
  'CHECKLIST FOR WALL WATER PROOFING',
];

// Main
class _QualityChecklistState extends State<QualityChecklist> {
  int currentIndex = 0;
  @override
  void initState() {
    // _tabController.index = _selectedIndex!.toInt();
    getUserId().whenComplete(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.currentDate =
        widget.currentDate ?? DateFormat.yMMMMd().format(DateTime.now());

    final scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading:
                  widget.isHeader! ? widget.isHeader! : false,
              backgroundColor: white,

              flexibleSpace: Container(
                height: 55,
                color: blue,
              ),

              actions: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: 200,
                  height: 30,
                  child: TypeAheadField(
                      animationStart: BorderSide.strokeAlignCenter,
                      suggestionsCallback: (pattern) async {
                        return await getCityList(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        selectedCityController.text = suggestion.toString();
                        selectedDepoController.clear();
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.all(5.0),
                          hintText: widget.cityName,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        controller: selectedCityController,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: 200,
                  height: 30,
                  child: TypeAheadField(
                      animationStart: BorderSide.strokeAlignCenter,
                      suggestionsCallback: (pattern) async {
                        return await getDepoList(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        selectedDepoController.text = suggestion.toString();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QualityChecklist(
                                depoName: suggestion.toString(),
                                cityName: widget.cityName,
                                userId: widget.userId,
                              ),
                            ));
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: 'Go To Depot',
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        controller: selectedDepoController,
                      )),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: GestureDetector(
                        onTap: () {
                          onWillPop(context);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/logout.png',
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.userId ?? '',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ))),
              ],
              title: Text(
                '${widget.cityName}/${widget.depoName}/Quality Checklist',
                style: appFontSize,
              ),
              // leading:
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: Column(
                  children: [
                    TabBar(
                      labelColor: currentIndex == _selectedIndex ? white : blue,
                      labelStyle: buttonWhite,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        color:
                            blue, // Set the background color of the selected tab label
                      ),
                      // MaterialIndicator(
                      //     horizontalPadding: 24,
                      //     bottomLeftRadius: 8,
                      //     bottomRightRadius: 8,
                      //     color: white,
                      //     paintingStyle: PaintingStyle.fill),
                      tabs: const [
                        Tab(text: 'Civil Engineer'),
                        Tab(text: 'Electrical Engineer'),
                      ],
                      onTap: (value) {
                        _selectedIndex = value;
                        currentIndex = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(children: [
              CivilQualityChecklist(
                cityName: widget.cityName,
                depoName: widget.depoName,
                currentDate: widget.currentDate,
              ),
              ElectricalQualityChecklist(
                cityName: widget.cityName,
                depoName: widget.depoName,
                currentDate: widget.currentDate,
              )
            ]),
          )),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];

    if (selectedCityController.text.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DepoName')
          .doc(selectedCityController.text)
          .collection('AllDepots')
          .get();

      depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

      if (pattern.isNotEmpty) {
        depoList = depoList
            .where((element) => element
                .toString()
                .toUpperCase()
                .startsWith(pattern.toUpperCase()))
            .toList();
      }
    } else {
      depoList.add('Please Select a City');
    }

    return depoList;
  }

  Future<List<dynamic>> getCityList(String pattern) async {
    List<dynamic> cityList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('DepoName').get();

    cityList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      cityList = cityList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return cityList;
  }
}
