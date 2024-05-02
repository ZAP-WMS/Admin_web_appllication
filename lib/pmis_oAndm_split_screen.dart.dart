import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplitScreen extends StatelessWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50.0, bottom: 50.0,
            ),
            alignment: Alignment.center,
            child: const Text(
              'WELCOME',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/pmis_oAndm/pmis.png",
                height: 180,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/pmis_oAndm/oAndM.png",
                height: 200,
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class HexagonWidget extends StatelessWidget {
  final double size;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final String imagePath;

  HexagonWidget(
      {super.key,
      required this.size,
      required this.color,
      required this.borderColor,
      required this.borderWidth,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(size, size),
        painter: HexagonPainter(
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
        ),
        child: Image.asset(
          imagePath,
          scale: 3.0,
        ));
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  HexagonPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double sideLength = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const double angle = math.pi / 3;

    final path = Path();
    path.moveTo(centerX + sideLength * math.cos(0.0),
        centerY + sideLength * math.sin(0.0));

    for (int i = 1; i <= 6; i++) {
      path.lineTo(
        centerX + sideLength * math.cos(angle * i),
        centerY + sideLength * math.sin(angle * i),
      );
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
