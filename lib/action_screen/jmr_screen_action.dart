import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/Jmr_screen/jmr.dart';
import 'package:web_appllication/screen_user/overview_pages/Jmr/jmr.dart';

class JmrScreenAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  JmrScreenAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<JmrScreenAction> createState() => _JmrScreenActionState();
}

class _JmrScreenActionState extends State<JmrScreenAction> {
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
        selectedUi = JmrUser(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
        );

        break;
      case 'admin':
        selectedUi = JmrAdmin(
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,role: widget.role,
        );
        break;

      case 'projectManager':
        selectedUi = JmrAdmin(
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,role: widget.role,
        );
        break;

    }

    return selectedUi;
  }
}
