import 'package:flutter/material.dart';

void showProgressDilogue(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
            5.0,
          )),
          height: 100,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'animations/loading_animation.gif',
                height: 70,
              ),
              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
