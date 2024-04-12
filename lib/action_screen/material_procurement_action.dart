import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/overview_page/material_vendor.dart';
import 'package:web_appllication/screen_user/overview_pages/material_vendor.dart';

class MaterialProcurementAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;

  MaterialProcurementAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId});

  @override
  State<MaterialProcurementAction> createState() =>
      _MaterialProcurementActionState();
}

class _MaterialProcurementActionState extends State<MaterialProcurementAction> {
  Widget selectedUi = Container();

  @override
  void initState() {
    print("material procurement role - ${widget.role}");
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
        selectedUi = MaterialProcurementUser(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
        );

        break;
      case 'admin':
        selectedUi = MaterialProcurementAdmin(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
        );
        break;
      
      case 'projectManager':
        selectedUi = MaterialProcurementAdmin(
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
