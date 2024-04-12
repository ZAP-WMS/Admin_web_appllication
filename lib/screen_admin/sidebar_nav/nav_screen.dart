import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/cities.dart';
import 'package:web_appllication/provider/provider_admin/demandEnergyProvider.dart';
import 'package:web_appllication/screen_admin/KeyEvents/Grid_DataTable.dart';
import 'package:web_appllication/screen_admin/MenuPage/role.dart';
import 'package:web_appllication/screen_admin/dashboard/demand%20energy%20management/demandScreen.dart';
import 'package:web_appllication/screen_admin/dashboard/ev_dashboard/ev_dashboard.dart';
import 'package:web_appllication/screen_admin/sidebar_nav/drawer_header.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

class NavigationPage extends StatefulWidget {
  String userId;
  String role;
  NavigationPage({super.key, required this.userId, required this.role});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final AuthService authService = AuthService();
  bool showStartEndDatePanel = false;
  var currentPage = DrawerSection.evDashboard;
  var container;
  String title = '';

  List<String> pageNames = [
    'EV Dashboard Project',
    'EV Bus Depot Management System',
    'Cities',
    'Role Management'
  ];

  List<IconData> screenIcons = [
    Icons.dashboard,
    Icons.home_max_outlined,
    Icons.person,
    Icons.location_city_outlined
  ];

  @override
  Widget build(BuildContext context) {
    // setState(() {});
    if (mounted) {
      setState(() {
        switch (currentPage) {
          case DrawerSection.evDashboard:
            showStartEndDatePanel = false;
            title = 'EV BUS Project Performance Analysis Dashboard';
            container = EVDashboardScreen(userId: widget.userId);
            //'login/EVDashboard';
            // Navigator.pushNamed(context, 'login/EVDashboard');
            break;
          case DrawerSection.demandEnergy:
            showStartEndDatePanel = true;
            title = 'EV Bus Depot Management System';
            container = DemandEnergyScreen(
              role: widget.role,
              userId: widget.userId,
            );
            break;
          case DrawerSection.cities:
            showStartEndDatePanel = false;

            title = 'Cities';
            container = CitiesPage();
            // Navigator.pushNamed(
            //     context, 'login/EVDashboard/EVBusDepot/Cities');
            break;
          case DrawerSection.users:
            showStartEndDatePanel = false;

            title = 'Role Management';
            container = const RoleScreen();
            break;
        }
      });
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: AppBar(
            actions: [
              showStartEndDatePanel
                  ? Consumer<DemandEnergyProviderAdmin>(
                      builder: (context, providerValue, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              width: 220,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Start Date - ',
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                      text: providerValue.startDate.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              height: 20,
                              width: 220,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'End Date - ',
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: providerValue.endDate.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Container(),
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20.0),
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
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    )),
              ),
            ],
            title: Text(
              title,
              style: TextStyle(color: white, fontSize: 15),
            ),
            backgroundColor: blue,
            // centerTitle: true,
          )),
      drawer: Drawer(
          width: 250,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                MyDrawerHeader(userId: widget.userId),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyDrawerList(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 120,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.circular(2.0)),
                        child: InkWell(
                          onTap: () async {
                            onWillPop(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('employeeId');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.power_settings_new_outlined,
                                color: white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(fontSize: 18, color: white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
      body: container,
    );
  }

  Widget MyDrawerList() {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          menuItems(1, pageNames[0], Icons.dashboard_outlined,
              currentPage == DrawerSection.evDashboard ? true : false),
          menuItems(2, pageNames[1], Icons.dashboard_sharp,
              currentPage == DrawerSection.demandEnergy ? true : false),
          menuItems(3, pageNames[2], Icons.house_outlined,
              currentPage == DrawerSection.cities ? true : false),
          widget.role == "admin"
              ? menuItems(4, pageNames[3], Icons.person_2_outlined,
                  currentPage == DrawerSection.users ? true : false)
              : Container(),
        ],
      ),
    );
  }

  Widget menuItems(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected
          ? const Color.fromARGB(255, 220, 236, 249)
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          if (mounted) {
            setState(() {
              switch (id) {
                case 1:
                  currentPage = DrawerSection.evDashboard;
                  break;
                case 2:
                  currentPage = DrawerSection.demandEnergy;
                  break;
                case 3:
                  currentPage = DrawerSection.cities;
                  break;
                case 4:
                  currentPage = DrawerSection.users;
                  break;
              }
            });
          }
        },
        onDoubleTap: () {
          Navigator.pop(context);
          if (mounted) {
            setState(() {
              switch (id) {
                case 1:
                  currentPage = DrawerSection.evDashboard;
                  break;
                case 2:
                  currentPage = DrawerSection.demandEnergy;
                  break;
                case 3:
                  currentPage = DrawerSection.cities;
                  break;
                case 4:
                  currentPage = DrawerSection.users;
                  break;
              }
            });
          }
        },
        child: Container(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Icon(
                icon,
                color: blue,
              )),
              Expanded(
                  flex: 4,
                  child: Text(
                    title,
                    style: TextStyle(color: blue),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSection { evDashboard, demandEnergy, cities, users }
