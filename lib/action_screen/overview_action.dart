import 'package:flutter/material.dart';
import 'package:web_appllication/overview_oAndM.dart';
import 'package:web_appllication/overview_pmis.dart';

class OverviewAction extends StatefulWidget {
  final String role;
  final String cityName;
  final String depotName;
  final String userId;
  final String roleCentre;

  const OverviewAction(
      {super.key,
      required this.roleCentre,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<OverviewAction> createState() => _OverviewActionState();
}

class _OverviewActionState extends State<OverviewAction> {
  Widget selectedUi = Container();

  @override
  void initState() {
    print("OverviewAction - ${widget.roleCentre}");
    selectWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return selectedUi;
  }

  Widget selectWidget() {
    switch (widget.roleCentre) {
      case 'PMIS':
        selectedUi = MyOverview(
          role: widget.role,
          depoName: widget.depotName,
          cityName: widget.cityName,
          userId: widget.userId,
        );

        break;
      case 'O&M':
        selectedUi = OverviewOAndM(
          depoName: widget.depotName,
          role: widget.role,
          cityName: widget.cityName,
          userId: widget.userId,
        );
        break;
    }

    return selectedUi;
  }
}
