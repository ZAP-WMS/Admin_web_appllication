import 'package:flutter/material.dart';

class LoadingPdf extends StatelessWidget {
  const LoadingPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'animations/loading_animation.gif',
              height: 100,
            ),
          ],
        )
        // Lottie.asset('animations/loading.json'),

        );
  }
}
