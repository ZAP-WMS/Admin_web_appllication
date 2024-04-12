import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/detailed_Eng.dart';
import 'package:web_appllication/screen_user/overview_pages/detailed_Eng.dart';

class DetailEngineeringAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  DetailEngineeringAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<DetailEngineeringAction> createState() =>
      _DetailEngineeringActionState();
}

class _DetailEngineeringActionState extends State<DetailEngineeringAction> {
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
        selectedUi = DetailedEngUser(
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
          role: widget.role,
        );

        break;
      case 'admin':
        selectedUi = DetailedEngAdmin(
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,role: widget.role,
        );
        break;
      
      case 'projectManager':
        selectedUi = DetailedEngAdmin(
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
          role: widget.role,
        );
        break;
    }

    return selectedUi;
  }
}
