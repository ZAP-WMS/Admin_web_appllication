import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/energy_management.dart';
import 'package:web_appllication/screen_user/overview_pages/energy_management.dart';

class DepotDemandEnergyAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  DepotDemandEnergyAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<DepotDemandEnergyAction> createState() =>
      _DepotDemandEnergyActionState();
}

class _DepotDemandEnergyActionState extends State<DepotDemandEnergyAction> {
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
          userId: widget.userId,
          role:widget.role ,
          depoName: widget.depotName,
          cityName: widget.cityName,
        );

        break;
      case 'admin':
        selectedUi = EnergyManagementAdmin(
          role: widget.role,
          cityName: widget.cityName,userId:widget.userId ,
          depoName: widget.depotName,
        );
        break;
      
      case 'projectManager':
        selectedUi = EnergyManagementAdmin(
          role: widget.role,
          cityName: widget.cityName,userId:widget.userId ,
          depoName: widget.depotName,
        );
        break;

    }

    return selectedUi;
  }
}
