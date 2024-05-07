import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

Widget cards(BuildContext context, String desc, String img, int index,
    String path, String role, String cityName, String userId,String roleCentre) {
  late SharedPreferences _sharedPreferences;

  return Container(
    margin: const EdgeInsets.only(top: 20.0),
    child: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 5,
          height: MediaQuery.of(context).size.height / 4,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(202, 202, 202, 0.5)
                      .withOpacity(0.2), // Shadow color
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: const Offset(
                      0, 3), // Offset to control the shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                  color: borderColor, width: 2, style: BorderStyle.solid)),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, path, arguments: {
                "role": role,
                "depoName": desc,
                "cityName": cityName,
                "userId": userId,
                "roleCentre":roleCentre
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.175,
                  width: MediaQuery.of(context).size.height * 0.3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      image: DecorationImage(
                          image: NetworkImage(img), fit: BoxFit.fill),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(color: Color.fromRGBO(202, 202, 202, 0.5))
            ]),
            height: 23,
            child: VerticalDivider(
              color: grey,
              width: 2,
            )),
        Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Divider(
                  color: grey,
                  thickness: 4,
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: const Offset(0, 3), // Offset from top-left corner
                    ),
                  ], shape: BoxShape.circle),
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    backgroundColor: grey,
                    child: Image.asset(
                      'assets/depots/bus_icon.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
