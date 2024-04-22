import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_appllication/screen_admin/overview_page/quality_checklist.dart';
import 'package:web_appllication/screen_user/Planning_Pages/quality_checklist.dart';

class QualityChecklistAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  QualityChecklistAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<QualityChecklistAction> createState() => _QualityChecklistActionState();
}

class _QualityChecklistActionState extends State<QualityChecklistAction> {

  String currentDate = DateFormat.yMMMMd().format(DateTime.now());

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
        selectedUi = QualityChecklistUser(
          cityName:widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
          currentDate: currentDate,
          role: widget.role,
        );

        break;
      case 'admin':
        selectedUi = QualityChecklistAdmin(
          currentDate: currentDate,
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
        );
        break;

        case 'projectManager':
        selectedUi = QualityChecklistAdmin(
          currentDate: currentDate,
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
        );
        break;
    }

    return selectedUi;
  }
}
