import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/Authentication/admin/login_register.dart';
import 'package:web_appllication/depot.dart';
import 'package:web_appllication/overview.dart';
import 'package:web_appllication/provider/provider_admin/key_provider.dart';
import 'package:web_appllication/provider/provider_user/key_provider.dart';
import 'package:web_appllication/screen_admin/KeyEvents/key_events.dart';
import 'package:web_appllication/screen_admin/overview_page/Jmr_screen/jmr.dart';
import 'package:web_appllication/screen_admin/overview_page/closure_summary_table.dart';
import 'package:web_appllication/screen_admin/overview_page/daily_project.dart';
import 'package:web_appllication/screen_admin/overview_page/depot_overview.dart';
import 'package:web_appllication/screen_admin/overview_page/detailed_Eng.dart';
import 'package:web_appllication/screen_admin/overview_page/material_vendor.dart';
import 'package:web_appllication/screen_admin/overview_page/monthly_summary.dart';
import 'package:web_appllication/screen_admin/overview_page/quality_checklist.dart';
import 'package:web_appllication/screen_admin/overview_page/safety_summary.dart';
import 'package:web_appllication/screen_admin/overview_page/testing_report.dart';
import 'package:web_appllication/screen_user/overview_pages/closure_report.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';

class CustomAppBar extends StatefulWidget {
  final String? text;
  String? userId;
  bool toDepots;
  bool isDepoPage;
  bool isCitiesPage;
  VoidCallback? donwloadFun;
  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? onTap;
  bool havebottom;
  bool isdetailedTab;
  bool isdownload;
  TabBar? tabBar;
  String? cityName;
  String? depoName;
  bool showDepoBar;
  bool toMainOverview;
  bool toOverview;
  bool toPlanning;
  bool toMaterial;
  bool toSubmission;
  bool toMonthly;
  bool toDetailEngineering;
  bool toJmr;
  bool toSafety;
  bool toChecklist;
  bool toTesting;
  bool toClosure;
  bool toEasyMonitoring;
  bool toDaily;
  bool isprogress;
  bool isCityBar;
  String? role;
  bool? isProjectManager;
  Widget? makeAnEntryPage;

  CustomAppBar(
      {super.key,
      this.toDepots = false,
      this.text,
      this.userId,
      this.haveSynced = false,
      this.haveSummary = false,
      this.store,
      this.onTap,
      this.donwloadFun,
      this.havebottom = false,
      this.isdownload = false,
      this.isdetailedTab = false,
      this.tabBar,
      required this.cityName,
      this.showDepoBar = false,
      this.toOverview = false,
      this.toPlanning = false,
      this.toMaterial = false,
      this.toSubmission = false,
      this.toMonthly = false,
      this.toDetailEngineering = false,
      this.toJmr = false,
      this.toSafety = false,
      this.toChecklist = false,
      this.toTesting = false,
      this.toClosure = false,
      this.toEasyMonitoring = false,
      this.toDaily = false,
      this.isprogress = false,
      this.toMainOverview = false,
      this.depoName,
      this.isCityBar = true,
      this.isDepoPage = false,
      this.isCitiesPage = false,
      this.role,
      this.isProjectManager,
      this.makeAnEntryPage});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController selectedDepoController = TextEditingController();
  TextEditingController selectedCityController = TextEditingController();
  KeyProviderAdmin? _keyProvider;
  String? companyName;
  bool isLoading = true;

  @override
  void initState() {
    getcompany();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: blue,
            title: widget.isCitiesPage
                ? const Text(
                    'Cities',
                    style: TextStyle(fontSize: 20),
                  )
                : widget.isDepoPage
                    ? Text(
                        widget.cityName ?? "",
                        style: TextStyle(fontSize: 15),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              widget.text.toString(),
                              style: appFontSize,
                            ),
                          ),
                          Text(
                            'City - ${widget.cityName}     Depot - ${widget.depoName}',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
            actions: [
              widget.isCityBar
                  ? Container(
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

                            widget.toDepots
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Mydepots(
                                        userId: widget.userId,
                                        cityName: selectedCityController.text,
                                      ),
                                    ))
                                : Container();
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
                    )
                  : Container(),
              widget.showDepoBar
                  ? Container(
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

                            if (selectedCityController.text.isNotEmpty) {
                              widget.toDepots
                                  ? Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Mydepots(
                                          userId: widget.userId,
                                          cityName: selectedCityController.text,
                                        ),
                                      ))
                                  : widget.toMainOverview
                                      ? Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyOverview(
                                              role: widget.role!,
                                              userId: widget.userId,
                                              depoName: suggestion.toString(),
                                              cityName:
                                                  selectedCityController.text,
                                            ),
                                          ))
                                      : widget.toDaily
                                          ? Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DailyProjectAdmin(
                                                  role: widget.role!,
                                                  userId: widget.userId,
                                                  depoName:
                                                      suggestion.toString(),
                                                  cityName:
                                                      selectedCityController
                                                          .text,
                                                ),
                                              ))
                                          : widget.toOverview
                                              ? Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DepotOverviewAdmin(
                                                      role: widget.role!,
                                                      userId: widget.userId!,
                                                      cityName:
                                                          selectedCityController
                                                              .text,
                                                      depoName:
                                                          suggestion.toString(),
                                                    ),
                                                  ))
                                              : widget.toMaterial
                                                  ? Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MaterialProcurementAdmin(
                                                          role: widget.role!,
                                                          userId: widget.userId,
                                                          depoName: suggestion
                                                              .toString(),
                                                          cityName:
                                                              selectedCityController
                                                                  .text,
                                                        ),
                                                      ))
                                                  : widget.toSubmission
                                                      ? Navigator
                                                          .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DailyProjectAdmin(
                                                                  role: widget
                                                                      .role!,
                                                                  userId: widget
                                                                      .userId,
                                                                  depoName:
                                                                      suggestion
                                                                          .toString(),
                                                                  cityName:
                                                                      selectedCityController
                                                                          .text,
                                                                ),
                                                              ))
                                                      : widget.toMonthly
                                                          ? Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            MonthlySummary(
                                                                      role: widget
                                                                          .role!,
                                                                      userId: widget
                                                                          .userId,
                                                                      depoName:
                                                                          suggestion
                                                                              .toString(),
                                                                      cityName:
                                                                          selectedCityController
                                                                              .text,
                                                                      id: 'Monthly Summary',
                                                                    ),
                                                                  ))
                                                          : widget
                                                                  .toDetailEngineering
                                                              ? Navigator
                                                                  .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                DetailedEngAdmin(
                                                                          userId:
                                                                              widget.userId,
                                                                          cityName:
                                                                              selectedCityController.text,
                                                                          depoName:
                                                                              suggestion.toString(),
                                                                        ),
                                                                      ))
                                                              : widget.toJmr
                                                                  ? Navigator
                                                                      .pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                JmrAdmin(
                                                                              role: widget.role!,
                                                                              userId: widget.userId,
                                                                              cityName: selectedCityController.text,
                                                                              depoName: suggestion.toString(),
                                                                            ),
                                                                          ))
                                                                  : widget.toSafety
                                                                      ? Navigator.pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SafetySummary(
                                                                              userId: widget.userId,
                                                                              role: widget.role!,
                                                                              cityName: selectedCityController.text,
                                                                              depoName: suggestion.toString(),
                                                                            ),
                                                                          ))
                                                                      : widget.toChecklist
                                                                          ? Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => QualityChecklistAdmin(
                                                                                  role: widget.role!,
                                                                                  userId: widget.userId,
                                                                                  cityName: selectedCityController.text,
                                                                                  depoName: suggestion.toString(),
                                                                                ),
                                                                              ))
                                                                          : widget.toTesting
                                                                              ? Navigator.pushReplacement(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => TestingReportAdmin(
                                                                                      userId: widget.userId,
                                                                                      cityName: selectedCityController.text,
                                                                                      depoName: suggestion.toString(),
                                                                                    ),
                                                                                  ))
                                                                              : widget.toClosure
                                                                                  ? Navigator.pushReplacement(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => ClosureSummaryTable(
                                                                                          userId: widget.userId,
                                                                                          role: widget.role!,
                                                                                          depoName: suggestion.toString(),
                                                                                          cityName: selectedCityController.text,
                                                                                          id: 'Closure Report',
                                                                                        ),
                                                                                      ))
                                                                                  : widget.toEasyMonitoring
                                                                                      ? Navigator.pushReplacement(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                            builder: (context) => KeyEventsAdmin(
                                                                                              userId: widget.userId,
                                                                                              depoName: suggestion.toString(),
                                                                                              cityName: selectedCityController.text,
                                                                                            ),
                                                                                          ))
                                                                                      : ' ';
                            }
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'Go To Depot',
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            controller: selectedDepoController,
                          )),
                    )
                  : Container(),
              widget.isprogress
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 230,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                legends(yellow, 'Base Line', blue),
                                legends(green, 'On Time', black),
                                legends(red, 'Delay', white),
                              ],
                            )),
                        Consumer<KeyProviderAdmin>(
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, right: 10, left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 150,
                                    color: green,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          'Project Duration \n ${durationParse(value.startdate, value.endDate)} Days',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: black)),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 150,
                                    color: red,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          'Project Delay \n ${durationParse(value.actualDate, value.endDate)} Days ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: white)),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    '% Of Progress is ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                    width: 40.0,
                                    child: CircularPercentIndicator(
                                      radius: 20.0,
                                      lineWidth: 5.0,
                                      percent:
                                          (value.perProgress.roundToDouble()) /
                                              100,
                                      center: Text(
                                        // value.getName.toString(),
                                        "${(value.perProgress.roundToDouble())}% ",

                                        textAlign: TextAlign.center,
                                        style: captionWhite,
                                      ),
                                      progressColor: green,
                                      backgroundColor: red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Container(),
              widget.isdownload
                  ? Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ElevatedButton(
                          onPressed: widget.donwloadFun,
                          child: const Icon(
                            Icons.download,
                            color: Colors.white,
                          )),
                    )
                  : widget.haveSummary
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 40, top: 10, bottom: 10),
                          child: Container(
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            child: TextButton(
                                onPressed: widget.onTap,
                                child: Text(
                                  'View Summary',
                                  style: TextStyle(color: white, fontSize: 20),
                                )),
                          ),
                        )
                      : Container(),
              widget.haveSynced
                  ? companyName == 'TATA POWER'
                      ? Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.blue),
                          child: TextButton(
                              onPressed: () {
                                widget.store!();
                              },
                              child: Text(
                                'Sync Data',
                                style: TextStyle(color: white, fontSize: 14),
                              )),
                        )
                      : Container()
                  : Container(),
              widget.isProjectManager!
                  ? Tooltip(
                      message: "Insert data as a user",
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          widget.makeAnEntryPage!));
                            },
                            child: const Text("Make An Entry")),
                      ),
                    )
                  : Container(),
              Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: GestureDetector(
                      onTap: () async {
                        onWillPop(context);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('employeeId');
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
                          ),
                        ],
                      ))),
            ],
            bottom: widget.havebottom
                ? TabBar(
                    labelColor: Colors.yellow,
                    labelStyle: buttonWhite,
                    unselectedLabelColor: white,

                    //indicatorSize: TabBarIndicatorSize.label,
                    indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: almostblack,
                      paintingStyle: PaintingStyle.fill,
                    ),

                    tabs: const [
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                    ],
                  )
                : widget.isdetailedTab
                    ? TabBar(
                        labelColor: Colors.yellow,
                        labelStyle: buttonWhite,
                        unselectedLabelColor: white,

                        //indicatorSize: TabBarIndicatorSize.label,
                        indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: almostblack,
                          paintingStyle: PaintingStyle.fill,
                        ),

                        tabs: const [
                          Tab(text: "RFC Drawings of Civil Activities"),
                          Tab(
                              text:
                                  "EV Layout Drawings of Electrical Activities"),
                          Tab(text: "Shed Lighting Drawings & Specification"),
                        ],
                      )
                    : widget.tabBar));
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Close TATA POWER?",
                      style: subtitle1White,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "No",
                              style: button.copyWith(color: blue),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            a = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegister(),
                                ));
                            // exit(0);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: button,
                            )),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ));
    return a;
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

  Future<void> getcompany() async {
    await AuthService().getCurrentCompanyName().then((value) {
      companyName = value;
      setState(() {
        isLoading = false;
      });
    });
  }
}

legends(Color color, String title, Color textColor) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 75,
            height: 28,
            color: color,
            padding: const EdgeInsets.all(5),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
            )),
      ],
    ),
  );
}

int durationParse(String fromtime, String todate) {
  DateTime startdate = DateFormat('dd-MM-yyyy').parse(fromtime);
  DateTime enddate = DateFormat('dd-MM-yyyy').parse(todate);
  return enddate.add(Duration(days: 1)).difference(startdate).inDays;
}
