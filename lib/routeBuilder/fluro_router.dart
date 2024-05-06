import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_appllication/Authentication/admin/login_register.dart';
import 'package:web_appllication/action_screen/closure_report_action.dart';
import 'package:web_appllication/action_screen/daily_project_action.dart';
import 'package:web_appllication/action_screen/dashboard_action.dart';
import 'package:web_appllication/action_screen/depot_insights_action.dart';
import 'package:web_appllication/action_screen/depot_overview_action.dart';
import 'package:web_appllication/action_screen/detail_eng_action.dart';
import 'package:web_appllication/action_screen/energy_management_action.dart';
import 'package:web_appllication/action_screen/jmr_screen_action.dart';
import 'package:web_appllication/action_screen/key_events_action.dart';
import 'package:web_appllication/action_screen/material_procurement_action.dart';
import 'package:web_appllication/action_screen/monthly_report_action.dart';
import 'package:web_appllication/action_screen/quality_checklist_action.dart';
import 'package:web_appllication/action_screen/safety_report_action.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/overview.dart';
import 'package:web_appllication/cities.dart';
import 'package:web_appllication/pmis_oAndm_split_screen.dart.dart';
import 'package:web_appllication/screen_admin/MenuPage/role.dart';
import 'package:web_appllication/screen_user/Splash/splash_screen.dart';
import '../depot.dart';

class FluroRouting {
  static final FluroRouter router = FluroRouter();

  static Handler loginHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const LoginRegister());

  static Handler splashScreen = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const SplashScreen(),
  );

  static Handler pmisOandMhandle = Handler(
    handlerFunc: (context, Map<String, dynamic> params) {
      ModalRoute? modalRoute = ModalRoute.of(context!);

      print("params - ${params}");

      if (modalRoute != null) {
        Map<String, dynamic>? modelRoute =
            modalRoute.settings.arguments as Map<String, dynamic>?;

        if (modelRoute != null) {
          final userId = modelRoute['userId'];
          final role = modelRoute['role'];
          final roleCentre = modelRoute['roleCentre'];

          return PmisAndOAndMScreen(
            roleCentre: roleCentre,
            userId: userId,
            role: role,
          );
        } else {
          return FutureBuilder<Map<String, dynamic>?>(
              future: _getCityDataFromSharedPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Do something with userId
                  Map<String, dynamic>? cityData = snapshot.data;

                  String userId = cityData?['userId'] ?? 'null';
                  String role = cityData?['role'] ?? 'N/A';
                  String roleCentre = cityData?['roleCentre'] ?? 'N/A';

                  if (userId != 'null') {
                    // User is logged in, return your widget
                    return PmisAndOAndMScreen(
                      roleCentre: roleCentre,
                      userId: userId,
                      role: role,
                    );
                  } else {
                    // User is not logged in, navigate to login screen
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginRegister()));
                    // Return an empty container or loading widget since you're navigating
                  }
                }
                return LoadingPage();
              });
        }
      }
      return null;
    },
  );

  static Handler navPagedHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) {
      ModalRoute? modalRoute = ModalRoute.of(context!);

      if (modalRoute != null) {
        Map<String, dynamic>? modelRoute =
            modalRoute.settings.arguments as Map<String, dynamic>?;

        if (modelRoute != null) {
          final userId = modelRoute['userId'];
          final role = modelRoute['role'];

          return DashboardAction(
            userId: userId,
            role: role,
          );
        } else {
          return FutureBuilder<Map<String, dynamic>?>(
              future: _getCityDataFromSharedPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Do something with userId
                  Map<String, dynamic>? cityData = snapshot.data;

                  String userId = cityData?['userId'] ?? 'null';
                  String role = cityData?['role'] ?? 'N/A';

                  if (userId != 'null') {
                    // User is logged in, return your widget
                    return DashboardAction(
                      userId: userId,
                      role: role,
                    );
                  } else {
                    // User is not logged in, navigate to login screen
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginRegister()));
                    // Return an empty container or loading widget since you're navigating
                  }
                }
                return LoadingPage();
              });
        }
      }
      return null;
    },
  );

  // Handle the case where modalRoute or modelRoute is null
  // or return some default widget

  static Handler evBusDepotHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => Container());

  static Handler citiesHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => CitiesPage());

  static Handler userHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const RoleScreen());

  static Handler depotHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final cityName = modelRoute['cityName'];
        final role = modelRoute["role"];
        final userId = modelRoute['userId'];

        return Mydepots(
          cityName: cityName,
          userId: userId,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String role = cityData?["role"] ?? "N/A";

                // Return your widget here using userId
                if (userId != 'null') {
                  return Mydepots(
                    cityName: cityName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler overviewPageHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final depoName = modelRoute['depoName'];
        final cityName = modelRoute['cityName'];
        final role = modelRoute['role'];
        final userId = modelRoute['userId'];

        return MyOverview(
          depoName: depoName,
          cityName: cityName,
          role: role,
          userId: userId,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depoName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? "N/A";

                if (userId != 'null') {
                  return MyOverview(
                    depoName: depoName,
                    cityName: cityName,
                    role: role,
                    userId: userId,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                }
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler depotOverviewhandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return DepotOverviewAction(
            role: role,
            userId: userId,
            cityName: cityName,
            depotName: depoName);
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? "N/A";

                print('CityName: $cityName, DepotName: $depotName');
                if (userId != 'null') {
                  return DepotOverviewAction(
                      role: role,
                      userId: userId,
                      cityName: cityName,
                      depotName: depotName);
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
              }

              // Return your widget here using userId

              return LoadingPage();
            });
      }
    }
  });

  static Handler projectPlanninghandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return PlanningActionScreen(
          depotName: depoName,
          userId: userId,
          cityName: cityName,
          role: role,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? 'N/A';

                // Return your widget here using userId
                return PlanningActionScreen(
                  depotName: depotName,
                  userId: userId,
                  cityName: cityName,
                  role: role,
                );
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler materialProcurementhandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return MaterialProcurementAction(
          role: role,
          userId: userId,
          cityName: cityName,
          depotName: depoName,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? 'N/A';

                print('CityName: $cityName, DepotName: $depotName');

                if (userId != 'null') {
                  // Return your widget here using userId
                  return MaterialProcurementAction(
                    role: role,
                    userId: userId,
                    cityName: cityName,
                    depotName: depotName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler dailyProgressthandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return DailyProjectAction(
          userId: userId,
          role: role,
          cityName: cityName,
          depotName: depoName,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? 'N/A';

                print('CityName: $cityName, DepotName: $depotName');
                if (userId != 'null') {
                  return DailyProjectAction(
                    userId: userId,
                    role: role,
                    cityName: cityName,
                    depotName: depotName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
                // Return your widget here using userId
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler monthlyProgressthandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return MonthlyReportAction(
          depotName: depoName,
          role: role,
          userId: userId,
          cityName: cityName,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? 'N/A';

                if (userId != null) {
                  return MonthlyReportAction(
                    depotName: depotName,
                    role: role,
                    userId: userId,
                    cityName: cityName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
                // Return your widget here using userId
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler detailEngthandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return DetailEngineeringAction(
          cityName: cityName,
          depotName: depoName,
          userId: userId,
          role: role,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? 'N/A';

                print('CityName: $cityName, DepotName: $depotName');
                if (userId != 'null') {
                  // Return your widget here using userId
                  return DetailEngineeringAction(
                    cityName: cityName,
                    role: role,
                    userId: userId,
                    depotName: depotName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler jmrhandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return JmrScreenAction(
          role: role,
          userId: userId,
          cityName: cityName,
          depotName: depoName,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? "N/A";

                if (userId != 'null') {
                  return JmrScreenAction(
                    role: role,
                    userId: userId,
                    cityName: cityName,
                    depotName: depotName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
                // Return your widget here using userId
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler safetyChecklisthandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return SafetyReportAction(
          role: role,
          userId: userId,
          depotName: depoName,
          cityName: cityName,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? "N/A";

                print('CityName: $cityName, DepotName: $depotName');
                if (userId != 'null') {
                  return SafetyReportAction(
                    role: role,
                    userId: userId,
                    depotName: depotName,
                    cityName: cityName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }

                // Return your widget here using userId
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler qualityChecklisthandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return QualityChecklistAction(
          depotName: depoName,
          role: role,
          cityName: cityName,
          userId: userId,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? "N/A";

                print('CityName: $cityName, DepotName: $depotName');
                if (userId != 'null') {
                  return QualityChecklistAction(
                    depotName: depotName,
                    role: role,
                    cityName: cityName,
                    userId: userId,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
                // Return your widget here using userId
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler depotinsighteshandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final userId = modelRoute['userId'];
        final role = modelRoute['role'];

        return DepotInsightsAction(
            role: role,
            depotName: depoName,
            userId: userId,
            title: 'Overview Page',
            cityName: cityName,
            docId: '');
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String docId = cityData?['docId'];
                String title = cityData?['title'];
                String role = cityData?['role'];

                print('CityName: $cityName, DepotName: $depotName');
                if (userId != 'null') {
                  return DepotInsightsAction(
                      role: role,
                      depotName: depotName,
                      userId: userId,
                      title: title,
                      cityName: cityName,
                      docId: docId);
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
                // Return your widget here using userId
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler closureReporthandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return ClosureReportAction(
          depotName: depoName,
          role: role,
          userId: userId,
          // userId: widget.userid,
          cityName: cityName,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? 'user';

                if (userId != 'null') {
                  // Return your widget here using userId
                  return ClosureReportAction(
                    depotName: depotName,
                    role: role,
                    userId: userId,
                    // userId: widget.userid,
                    cityName: cityName,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Return an empty container or loading widget since you're navigating
                }
              }
              return LoadingPage();
            });
      }
    }
  });

  static Handler demandEnergyhandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    ModalRoute? modalRoute = ModalRoute.of(context!);

    if (modalRoute != null) {
      Map<String, dynamic>? modelRoute =
          modalRoute.settings.arguments as Map<String, dynamic>?;

      if (modelRoute != null) {
        final userId = modelRoute['userId'];
        final cityName = modelRoute['cityName'];
        final depoName = modelRoute['depoName'];
        final role = modelRoute['role'];

        return EnergyManagementAction(
          // userId: widget.userId,
          cityName: cityName,
          depotName: depoName,
          role: role, userId: userId,
        );
      } else {
        return FutureBuilder<Map<String, dynamic>?>(
            future: _getCityDataFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Do something with userId
                Map<String, dynamic>? cityData = snapshot.data;
                String userId = cityData?['userId'] ?? 'null';
                String cityName = cityData?['cityName'] ?? 'defaultCityName';
                String depotName = cityData?['depotName'] ?? 'defaultDepotName';
                String role = cityData?['role'] ?? 'N/A';

                if (userId != 'null') {
                  // Return your widget here using userId
                  return EnergyManagementAction(
                    // userId: widget.userId,
                    cityName: cityName,
                    depotName: depotName,
                    role: role, userId: userId,
                  );
                } else {
                  // User is not logged in, navigate to login screen
                  return const LoginRegister();
                  // Future.microtask(() {
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (context) => const LoginRegister(),
                  //   ));
                  // });
                  // Return an empty container or loading widget since you're navigating
                }
              }
              return LoadingPage();
            });
      }
    }
  });

  static void setupRouter() {
    router.define('splashScreen', handler: splashScreen);
    router.define(
      'login',
      handler: loginHandler,
    );
    router.define(
      '/pmis_oAndm',
      handler: pmisOandMhandle,
    );
    router.define('login/EVDashboard/', handler: navPagedHandler);
    router.define('login/EVDashboard/Cities/', handler: citiesHandler);
    router.define('login/EVDashboard/Cities/EVBusDepot/',
        handler: depotHandler);
    router.define('login/EVDashboard/Cities/EVBusDepot/OverviewPage/',
        handler: overviewPageHandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DepotOverview/',
        handler: depotOverviewhandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/ProjectPlanning/',
        handler: projectPlanninghandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/MaterialProcurement/',
        handler: materialProcurementhandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DailyProgress/',
        handler: dailyProgressthandler);

    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/MonthlyProgress/',
        handler: monthlyProgressthandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DetailedEngineering/',
        handler: detailEngthandler);
    router.define('login/EVDashboard/Cities/EVBusDepot/OverviewPage/Jmr/',
        handler: jmrhandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/SafetyChecklist/',
        handler: safetyChecklisthandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/QualityChecklist/',
        handler: qualityChecklisthandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DepotInsightes/',
        handler: depotinsighteshandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/ClosureReport/',
        handler: closureReporthandler);
    router.define(
        'login/EVDashboard/Cities/EVBusDepot/OverviewPage/DemandEnergy/',
        handler: demandEnergyhandler);
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const SplashScreen();
    });
  }

  // static Future<String?> _getUserIdFromSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userId = prefs.getString('employeeId');
  //   return userId;
  // }

  static Future<Map<String, dynamic>?>?
      _getCityDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('employeeId');
    String? cityName = prefs.getString('cityName');
    String? depotName = prefs.getString('depotName');
    String? role = prefs.getString('role');

    return {
      'userId': userId,
      'cityName': cityName,
      'depotName': depotName,
      'role': role
    };
  }

  // FutureBuilder<Map<String, dynamic>?> _yourCustomMethod(Widget pageName) {
  //   return FutureBuilder<Map<String, dynamic>?>(
  //     future: _getCityDataFromSharedPreferences(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         // Do something with userId
  //         Map<String, dynamic>? cityData = snapshot.data;

  //         String cityName = cityData?['cityName'] ?? 'defaultCityName';
  //         String depotName = cityData?['depotName'] ?? 'defaultDepotName';

  //         print('CityName: $cityName, DepotName: $depotName');

  //         // Return your widget here using userId
  //         return MyOverview(
  //           depoName: depotName,
  //           cityName: cityName,
  //         );
  //       }
  //       return LoadingPage();
  //     },
  //   );
  // }
}
