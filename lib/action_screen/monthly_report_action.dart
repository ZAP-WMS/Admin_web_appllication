import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/monthly_summary.dart';
import 'package:web_appllication/screen_user/overview_pages/monthly_project.dart';

class MonthlyReportAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  MonthlyReportAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<MonthlyReportAction> createState() => _MonthlyReportActionState();
}

class _MonthlyReportActionState extends State<MonthlyReportAction> {
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
        selectedUi = MonthlyProjectUser(
          role: widget.role,
          depoName: widget.depotName,
          cityName: widget.cityName,
          userId: widget.userId,
        );

        break;
      case 'admin':
        selectedUi = MonthlySummary(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
          id:'Monthly Summary' ,
        );
        break;
      
      case 'projectManager':
        selectedUi = MonthlySummary(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
          id:'Monthly Summary' ,
        );
        break;

    }

    return selectedUi;
  }
}
