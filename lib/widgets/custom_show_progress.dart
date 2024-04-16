import 'package:flutter/material.dart';
import 'package:web_appllication/components/loading_page.dart';

void showProgressDilogue(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Container(
          height: 100,
          width: 100,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: LoadingPage(),
              )
            ],
          ),
        ));
      });
}
