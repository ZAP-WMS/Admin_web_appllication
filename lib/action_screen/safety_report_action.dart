import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/safety_summary.dart';
import 'package:web_appllication/screen_user/Planning_Pages/safety_checklist.dart';

class SafetyReportAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  SafetyReportAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<SafetyReportAction> createState() => _SafetyReportActionState();
}

class _SafetyReportActionState extends State<SafetyReportAction> {
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
        selectedUi = SafetyChecklistUser(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
        );

        break;
      case 'admin':
        selectedUi = SafetySummary(
          cityName: widget.cityName,
          role: widget.role,
          depoName: widget.depotName,
          userId: widget.userId,
        );
        break;
      
      case 'projectManager':
        selectedUi = SafetySummary(
          cityName: widget.cityName,
          role: widget.role,
          depoName: widget.depotName,
          userId: widget.userId,
        );
        break;
    }

    return selectedUi;
  }
}
