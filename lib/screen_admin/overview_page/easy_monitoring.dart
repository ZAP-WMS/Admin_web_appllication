import 'package:flutter/material.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

class EasyMonitoringAdmin extends StatefulWidget {
  String? cityName;
  String? userId;
  String? depoName;
  EasyMonitoringAdmin(
      {super.key, required this.cityName, required this.depoName, this.userId});

  @override
  State<EasyMonitoringAdmin> createState() => _EasyMonitoringAdminState();
}

class _EasyMonitoringAdminState extends State<EasyMonitoringAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title:
            Text('${widget.cityName} / ${widget.depoName} / Testing Report '),
      ),
      body: const Center(
        child: Text(
          'Easy Monitoring of O & M Are \n Under Process',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
