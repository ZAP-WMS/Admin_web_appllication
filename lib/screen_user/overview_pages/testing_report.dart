import 'package:flutter/material.dart';
import 'package:web_appllication/widgets/widgets_user/custom_appbar.dart';

class TestingReportUser extends StatefulWidget {
  String? cityName;
  String? depoName;
  String role;
  TestingReportUser(
      {super.key, required this.cityName, required this.depoName,required this.role});

  @override
  State<TestingReportUser> createState() => _TestingReportUserState();
}

class _TestingReportUserState extends State<TestingReportUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          role: widget.role,
          showDepoBar: true,
          toTesting: true,
          cityname: widget.cityName,
          text: ' ${widget.cityName} / ${widget.depoName} / Keys Events',
          haveSynced: false,
        ),
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
