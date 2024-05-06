import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/Authentication/admin/login_register.dart';
import 'package:web_appllication/pmis_oAndm_split_screen.dart.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool user = false;
  String userId = '';
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    // getUserId();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Image.asset("assets/Tata-Power.jpeg"),
            ),
          ),
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Text(
              "TATA POWER",
              style: GoogleFonts.workSans(
                fontSize: 32.0,
                color: Colors.white.withOpacity(0.87),
                letterSpacing: -0.04,
                height: 5.0,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  void _getCurrentUser() async {
    String? role;
    String? roleCentre;
    bool user = false;

    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeId') != null) {
        userId = sharedPreferences.getString('employeeId') ?? '';
        role = await AuthService().getUserRole();
        roleCentre = await AuthService().getRoleCentre();
        user = true;
      }

      // Add a delay before navigating to the main page
      await Future.delayed(
        const Duration(
          milliseconds: 1500,
        ),
        () {
          //   final routes = FluroRouter();

          //         user
          // ? routes.navigateTo(
          //     context,
          //     "/pmis_oAndm?userId=$userId&role=$role&roleCentre=$roleCentre",
          //   )
          // : routes.navigateTo(
          //     context,
          //     "splashScreen/login",
          //   );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => user
                  ? PmisAndOAndMScreen(
                      role: role!,
                      roleCentre: roleCentre!,
                      userId: userId,
                    )
                  : const LoginRegister(),
            ),
          );
        },
      );
    } catch (e) {
      print("Error Occured on Spash Screen - $e");
    }
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}
