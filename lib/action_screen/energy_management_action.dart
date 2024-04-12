import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/detailed_Eng.dart';
import 'package:web_appllication/screen_admin/overview_page/energy_management.dart';
import 'package:web_appllication/screen_user/overview_pages/detailed_Eng.dart';
import 'package:web_appllication/screen_user/overview_pages/energy_management.dart';

class EnergyManagementAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  EnergyManagementAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<EnergyManagementAction> createState() => _EnergyManagementActionState();
}

class _EnergyManagementActionState extends State<EnergyManagementAction> {
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
        selectedUi = EnergyManagementUser(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
        );

        break;
      case 'admin':
        selectedUi = EnergyManagementAdmin(
          role:widget.role ,
          userId:widget.userId,
          cityName: widget.cityName,
          depoName: widget.depotName,
        );
        break;
      
      case 'projectManager':
        selectedUi = EnergyManagementAdmin(
          role:widget.role ,
          userId:widget.userId,
          cityName: widget.cityName,
          depoName: widget.depotName,
        );
        break;
    }

    return selectedUi;
  }
}
