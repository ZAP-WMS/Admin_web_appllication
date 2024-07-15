import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/closure_summary_table.dart';
import 'package:web_appllication/screen_user/overview_pages/closure_report.dart';

class ClosureReportAction extends StatefulWidget {
  final String role;
  final String cityName;
  final String depotName;
  final String userId;
  final String roleCentre;

  const ClosureReportAction(
      {super.key,
      required this.roleCentre,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId}
      );

  @override
  State<ClosureReportAction> createState() => _ClosureReportActionState();
}

class _ClosureReportActionState extends State<ClosureReportAction> {
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
        selectedUi = ClosureReportUser(
          role: widget.role,
          depoName: widget.depotName,
          cityName: widget.cityName,
          userId: widget.userId,
        );

        break;
      case 'admin':
        selectedUi = ClosureSummaryTable(
          depoName: widget.depotName,
          role: widget.role,
          cityName: widget.cityName,
          userId: widget.userId,
          id: 'Closure Page',
        );
        break;

      case 'projectManager':
        selectedUi = ClosureSummaryTable(
          depoName: widget.depotName,
          role: widget.role,
          cityName: widget.cityName,
          userId: widget.userId,
          id: 'Closure Page',
        );
        break;
    }


    return selectedUi;
  }
}
