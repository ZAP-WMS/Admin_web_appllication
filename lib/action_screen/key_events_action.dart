import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/KeyEvents/key_events2.dart';
import 'package:web_appllication/screen_user/overview_pages/key_events2.dart';

class PlanningActionScreen extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  PlanningActionScreen(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<PlanningActionScreen> createState() => _PlanningActionScreenState();
}

class _PlanningActionScreenState extends State<PlanningActionScreen> {
  Widget selectedUi = Container();

  @override
  void initState() {
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
        selectedUi = KeyEvents2User(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
        );

        break;
      case 'admin':
        selectedUi = KeyEvents2Admin(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          adminUserId: widget.userId,
        );
        break;
      
      case 'projectManager':
        selectedUi = KeyEvents2Admin(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          adminUserId: widget.userId,
        );
        break;

    }

    return selectedUi;
  }
}
