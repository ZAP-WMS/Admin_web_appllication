import 'package:flutter/material.dart';

import 'package:web_appllication/widgets/widgets_user/user_style.dart';

Widget cards(BuildContext context, String desc, String img, int index,
    String path, String userId, String roleCentre) {

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
              // _sharedPreferences = await SharedPreferences.getInstance();
              // _sharedPreferences.setString('depotName', desc);
              Navigator.pushNamed(context, path,
                  arguments: {"cityName": desc, "userId": userId,"roleCentre":roleCentre});

              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => toPage));
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
              color: imgbg,
              width: 2,
            )),
        Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Divider(
                  color: imgbg,
                  thickness: 4,
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: imgbg.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: const Offset(0, 3), // Offset from top-left corner
                    ),
                  ], shape: BoxShape.circle),
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    backgroundColor: imgbg,
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
