import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_appllication/screen_admin/KeyEvents/upload.dart';
import 'package:web_appllication/screen_admin/KeyEvents/view_AllFiles.dart';
import 'package:web_appllication/screen_user/KeysEvents/upload.dart';

class DepotInsightsAction extends StatefulWidget {
  String role;
  String cityName;
  String depotName;
  String userId;
  String title;
  String docId;

  DepotInsightsAction(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depotName,
      required this.userId,
      required this.docId,
      required this.title});

  @override
  State<DepotInsightsAction> createState() => _DepotInsightsActionState();
}

class _DepotInsightsActionState extends State<DepotInsightsAction> {
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
        selectedUi = UploadDocument(
          cityName: widget.cityName,
          depoName: widget.depotName,
          userId: widget.userId,
          title: 'Depot Insights',
          date: DateFormat.yMMMMd().format(
            DateTime.now(),
          ),
          pagetitle: 'Depot Insights',
          fldrName: '',
        );

        break;
      case 'admin':
        selectedUi = ViewAllPdfAdmin(
          cityName: widget.cityName,
          depoName: widget.depotName,
          title: 'Depot Insights',
          docId: widget.docId,
          userId: widget.userId,
          role: widget.role,
        );
        break;

      case 'projectManager':
        selectedUi = ViewAllPdfAdmin(
          cityName: widget.cityName,
          depoName: widget.depotName,
          title: 'Depot Insights',
          docId: widget.docId,
          userId: widget.userId,
          role: widget.role,
        );
        break;
    }

    return selectedUi;
  }
}
