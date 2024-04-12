import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';

showDial(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: CircularProgressIndicator(
            color: blue,
          ),
        ),
      ),
    ),
  );
}
