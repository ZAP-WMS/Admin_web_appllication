import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/daily_project.dart';
import 'package:web_appllication/screen_user/overview_pages/daily_project.dart';

class DailyProjectAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  DailyProjectAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<DailyProjectAction> createState() => _DailyProjectActionState();
}

class _DailyProjectActionState extends State<DailyProjectAction> {
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
        selectedUi = DailyProjectUser(
          role: widget.role,
          userId: widget.userId,
          depoName: widget.depotName,
          cityName: widget.cityName,
        );

        break;
      case 'admin':
        selectedUi = DailyProjectAdmin(
          role: widget.role,
          depoName: widget.depotName,
          cityName: widget.cityName,
          userId: widget.userId,
        );
        break;

      case 'projectManager':
        selectedUi = DailyProjectAdmin(
          role: widget.role,
          depoName: widget.depotName,
          cityName: widget.cityName,
          userId: widget.userId,
        );
        break;
    }

    return selectedUi;
  }
}
