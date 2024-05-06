import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_appllication/action_screen/dashboard_action.dart';
import 'package:web_appllication/widgets/coming_soon_screen.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

class PmisAndOAndMScreen extends StatefulWidget {
  final String role;
  final String userId;
  final String roleCentre;

  const PmisAndOAndMScreen(
      {super.key,
      required this.role,
      required this.userId,
      required this.roleCentre});

  @override
  State<PmisAndOAndMScreen> createState() => _PmisAndOAndMScreenState();
}

class _PmisAndOAndMScreenState extends State<PmisAndOAndMScreen> {
  bool animateImages = false;
  bool isHover = false;

  @override
  void initState() {
    _animate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          filterQuality: FilterQuality.low,
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/pmis_oAndm/EV MONITORING_bg.jpg",
          ),
        )),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 50.0,
                ),
                alignment: Alignment.center,
                child: TweenAnimationBuilder(
                  duration: const Duration(
                    milliseconds: 1500,
                  ),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "EV M",
                          style: GoogleFonts.acme(
                            fontSize: 55,
                            color: const Color.fromARGB(255, 9, 12, 109),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.offline_bolt,
                            size: 40,
                            color: Color.fromARGB(255, 9, 12, 109),
                          ),
                        ),
                        TextSpan(
                          text: "nit",
                          style: GoogleFonts.acme(
                            fontSize: 55,
                            color: const Color.fromARGB(255, 9, 12, 109),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.offline_bolt,
                            size: 40,
                            color: Color.fromARGB(255, 9, 12, 109),
                          ),
                        ),
                        TextSpan(
                          text: "ring",
                          style: GoogleFonts.acme(
                            fontSize: 55,
                            color: const Color.fromARGB(255, 9, 12, 109),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        )
                      ]),
                    );
                  },
                ),
              ),
            ),
            Opacity(
              opacity: 0.95,
              child: Container(
                margin: const EdgeInsets.only(top: 70, left: 10, right: 10),
                padding: const EdgeInsets.only(top: 10),
                color: white,
                height: 210,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(
                        milliseconds: 800,
                      ),
                      left: animateImages
                          ? 0
                          : MediaQuery.of(context).size.width * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              // final route = FluroRouter();
                              // route.navigateTo(context, "login",
                              //     clearStack: true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardAction(
                                    role: widget.role,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(
                              "assets/pmis_oAndm/pmis_new.png",
                              height: 220,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.95,
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10.0,
                ),
                color: white,
                height: 220,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 30,
                      bottom: 0,
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        "assets/Tata-Power.jpeg",
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(
                        milliseconds: 800,
                      ),
                      right: animateImages
                          ? 0
                          : MediaQuery.of(context).size.width * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ComingSoonScreen(),
                                ),
                              );
                            },
                            child: Image.asset(
                              "assets/pmis_oAndm/oAndM_new.png",
                              height: 210,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _animate() async {
    Future.delayed(
      const Duration(
        milliseconds: 200,
      ),
      () {
        setState(() {
          animateImages = true;
        });
      },
    );
  }
}
