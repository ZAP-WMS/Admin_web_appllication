import 'package:flutter/material.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

class TestingReportAdmin extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  TestingReportAdmin(
      {super.key, required this.cityName, required this.depoName, this.userId});

  @override
  State<TestingReportAdmin> createState() => _TestingReportAdminState();
}

class _TestingReportAdminState extends State<TestingReportAdmin> {
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
          'Testing & Commissioning flow \n Under Process',
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
