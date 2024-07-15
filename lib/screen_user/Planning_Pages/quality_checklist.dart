import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/screen_user/Planning_Pages/electrical_quality_checklist.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';
import 'civil_quality_checklist.dart';

class QualityChecklistUser extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String? currentDate;
  bool? isHeader;
  String role;

  QualityChecklistUser(
      {super.key,
      this.userId,
      required this.cityName,
      required this.depoName,
      this.currentDate,
      this.isHeader = true,
      required this.role});

  @override
  State<QualityChecklistUser> createState() => _QualityChecklistUserState();
}

TextEditingController ename = TextEditingController();
String selectedTabName = '';
String currentTabName = '';
String selectedDepot = '';
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
TextEditingController selectedDepoController = TextEditingController();

final AuthService authService = AuthService();
List<String> assignedCities = [];
bool isFieldEditable = false;
List<bool> listToSelectTab = [];
List<String> qualityFields = [
  'CivilChecklistField',
  'ElectricalChecklistField'
];

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
class _QualityChecklistUserState extends State<QualityChecklistUser> {
  @override
  void initState() {
    getAssignedCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.currentDate = DateFormat.yMMMMd().format(DateTime.now());

    final scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading:
                  widget.isHeader! ? widget.isHeader! : false,
              backgroundColor: blue,
              title: widget.isHeader!
                  ? const Text('Quality Checklist')
                  : const Text(''),
              actions: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                  width: 200,
                  height: 30,
                  child: TypeAheadField(
                      animationStart: BorderSide.strokeAlignCenter,
                      hideOnLoading: true,
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
                        selectedDepot = suggestion.toString();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QualityChecklistUser(
                                role: widget.role,
                                cityName: widget.cityName,
                                depoName: selectedDepot,
                              ),
                            ));
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.all(5.0),
                            hintText: 'Go To Depot'),
                        style: const TextStyle(fontSize: 15),
                        controller: selectedDepoController,
                      )),
                ),
                widget.isHeader!
                    ? Padding(
                        padding: const EdgeInsets.only(
                            right: 20, top: 10, bottom: 10),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: lightblue),
                          child: isFieldEditable
                              ? TextButton(
                                  onPressed: () {
                                    _selectedIndex == 0
                                        ? CivilstoreData(
                                            context,
                                            widget.depoName!,
                                            widget.currentDate!,
                                            listToSelectTab,
                                            selectedTabName,
                                            widget.userId!)
                                        : storeData(
                                            context,
                                            widget.depoName!,
                                            widget.currentDate!,
                                            listToSelectTab,
                                            widget.userId!);
                                  },
                                  child: Text(
                                    'Sync Data',
                                    style:
                                        TextStyle(color: white, fontSize: 20),
                                  ),
                                )
                              : Container(),
                        ),
                      )
                    : Container(),
              ],
              // leading:
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: Column(
                  children: [
                    TabBar(
                      labelColor: white,
                      labelStyle: buttonWhite,
                      unselectedLabelColor: Colors.black,
                      indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: white,
                          paintingStyle: PaintingStyle.fill),
                      tabs: const [
                        Tab(text: 'Civil Engineer'),
                        Tab(text: 'Electrical Engineer'),
                      ],
                      onTap: (value) {
                        _selectedIndex = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(children: [
              CivilQualityChecklistUser2(
                cityName: widget.cityName,
                depoName: widget.depoName,
                getBoolList: getBoolList,
                userId: widget.userId,
              ),
              ElectricalQualityChecklistUser(
                cityName: widget.cityName,
                depoName: widget.depoName,
                userId: widget.userId,
                getBoolList: getBoolList,
              ),
            ]),
          )),
    );
  }

  void getBoolList(List<bool> boolList, String tabName) {
    listToSelectTab = boolList;
    selectedTabName = tabName;
    print(listToSelectTab);
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(widget.cityName)
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

    return depoList;
  }

  Future getAssignedCities() async {
    assignedCities = await authService.getCityList();
    isFieldEditable =
        authService.verifyAssignedCities(widget.cityName!, assignedCities);
    print("Quality isFieldEditable: $isFieldEditable");
  }
  
}
