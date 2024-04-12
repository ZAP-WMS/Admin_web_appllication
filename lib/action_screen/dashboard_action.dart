import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/sidebar_nav/nav_screen.dart';
import 'package:web_appllication/screen_admin/split_dashboard/split_dashboard.dart';
import 'package:web_appllication/screen_user/screen/split_dashboard/split_dashboard.dart';

class DashboardAction extends StatefulWidget {
  String role;
  String userId;

  DashboardAction({super.key, required this.role, required this.userId});

  @override
  State<DashboardAction> createState() => _DashboardActionState();
}

class _DashboardActionState extends State<DashboardAction> {
  Widget selectedUi = Container();

  @override
  void initState() {
    print('role - ${widget.role}');
    selectWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return selectedUi;
  }

  Widget selectWidget() {
    switch (widget.role) {
      case 'user':
        selectedUi = SplitDashboard(
          userId: widget.userId,
          role: widget.role,
        );

        break;
      case 'admin':
        selectedUi = NavigationPage(
          userId: widget.userId,
          role: widget.role,
        );
        break;

      case 'projectManager':
        selectedUi = NavigationPage(
          userId: widget.userId,
          role: widget.role,
        );
        break;
    }

    return selectedUi;
  }
}
