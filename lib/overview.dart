import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';

import 'widgets/widgets_admin/custom_appbar.dart';

String userId = '';

class MyOverview extends StatefulWidget {
  final String? userId;
  final String depoName;
  final String cityName;
  final String role;
  
  const MyOverview({
      super.key,
      required this.depoName,
      required this.cityName,
      this.userId,
      required this.role
      });

  @override
  State<MyOverview> createState() => _MyOverviewState();

}

class _MyOverviewState extends State<MyOverview> {
  List<String> assignedDepots = [];
  final AuthService authService = AuthService();

  List<String> pages = [];
  late SharedPreferences _sharedPreferences;
  // List<void Function(BuildContext)> pages = [];

  List<IconData> icondata = [
    Icons.search_off_outlined,
    Icons.play_lesson_rounded,
    Icons.chat_bubble_outline_outlined,
    Icons.book_online_rounded,
    Icons.notes,
    Icons.track_changes_outlined,
    Icons.domain_verification,
    Icons.list_alt_outlined,
    Icons.electric_bike_rounded,
    Icons.text_snippet_outlined,
    // Icons.monitor_outlined,
  ];

  List imagedata = [
    'assets/overview_image/overview.png',
    'assets/overview_image/project_planning.png',
    'assets/overview_image/resource.png',
    'assets/overview_image/daily_progress.png',
    'assets/overview_image/monthly.png',
    'assets/overview_image/detailed_engineering.png',
    'assets/overview_image/jmr.png',
    // 'assets/overview_image/safety.png',
    'assets/overview_image/safety.png',
    'assets/overview_image/quality.png',
    // 'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/closure_report.png',
    'assets/overview_image/easy_monitoring.jpg',
    // 'assets/overview_image/overview.png',
    // 'assets/overview_image/project_planning.png',
    // 'assets/overview_image/resource.png',
    // 'assets/overview_image/monitor.png',
    // 'assets/overview_image/detailed_engineering.png',
    // 'assets/overview_image/daily_progress.png',
    // 'assets/overview_image/jmr.png',
    // 'assets/overview_image/safety.png',
    // 'assets/overview_image/safety_checklist.jpeg',
    // 'assets/overview_image/checklist_civil.png',
    // 'assets/overview_image/testing_commissioning.png',
    // 'assets/overview_image/closure_report.png',
  ];

  @override
  void initState() {
    getAssignedDepots();
    getUserId();
    setSharePrefence();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    List<String> desription = [
      'Overview of Project Progress Status of ${widget.depoName} EV Bus Charging Infra',
      'Project Planning & Scheduling Bus Depot Wise [Gant Chart] ',
      'Material Procurement & Vendor Finalization Status',
      'Submission of Daily Progress Report for Individual Project',
      'Monthly Project Monitoring & Review',
      'Detailed Engineering Of Project Documents like GTP, GA Drawing',
      'Online JMR verification for projects',
      'Safety check list & observation',
      'FQP Checklist for Civil,Electrical work & Quality Checklist',
      'Depot Insightes',
      'Closure Report',
      'Depot Demand Energy Management',
    ];
    pages = [
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DepotOverview/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/ProjectPlanning/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/MaterialProcurement/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DailyProgress/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/MonthlyProgress/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DetailedEngineering/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/Jmr/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/SafetyChecklist/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/QualityChecklist/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DepotInsightes/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/ClosureReport/',
      'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DemandEnergy/',
    ];

    return Scaffold(
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBar(
            isProjectManager: false,
            role: widget.role,
            showDepoBar: true,
            toMainOverview: true,
            cityName: widget.cityName,
            userId: widget.userId,
            text: 'Overview Page',
            depoName: widget.depoName,
            // userid: widget.userid,
          ),
          preferredSize: const Size.fromHeight(50)),
      body: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.9,
        children: List.generate(desription.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: cards(desription[index], imagedata[index], index),
          );
        }),
      ),
    );
  }

  Widget cards(String desc, String img, int index) {
    return GestureDetector(
      onTap: (() {
        Navigator.pushNamed(context, pages[index], arguments: {
          'depoName': widget.depoName,
          'cityName': widget.cityName,
          'userId': widget.userId,
          "role": widget.role,
        });
      }),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(
            5.0,
          ),
          width: MediaQuery.of(context).size.width / 5,
          height: MediaQuery.of(context).size.height / 4,
          child: Card(
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    3.0,
                  ),
                  child: Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setSharePrefence() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('depotName', widget.depoName);
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    print("AssignedDepots - $assignedDepots");
  }

  
}
