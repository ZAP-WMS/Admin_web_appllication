import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/depot_overview.dart';
import 'package:web_appllication/screen_user/overview_pages/depot_overview.dart';

class DepotOverviewAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  DepotOverviewAction({
    super.key,
    required this.role,
    required this.cityName,
    required this.depotName,
    required this.userId,
  });

  @override
  State<DepotOverviewAction> createState() => _DepotOverviewActionState();
}

class _DepotOverviewActionState extends State<DepotOverviewAction> {
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
        selectedUi = DepotOverviewUser(
          role: widget.role,
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depotName,
        );

        break;
      case 'admin':
        selectedUi = DepotOverviewAdmin(
            userId: widget.userId,
            role: widget.role,
            cityName: widget.cityName,
            depoName: widget.depotName);
        break;

      case 'projectManager':
        selectedUi = DepotOverviewAdmin(
            userId: widget.userId,
            role: widget.role,
            cityName: widget.cityName,
            depoName: widget.depotName);
        break;
    }

    return selectedUi;
  }
}
