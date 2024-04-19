import 'package:flutter/material.dart';
import 'package:web_appllication/screen_user/KeysEvents/Grid_DataTable.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';

// ignore: must_be_immutable
class SplitDashboard extends StatelessWidget {
  String userId;
  String role;
  SplitDashboard({super.key, required this.userId, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          45,
        ),
        child: AppBar(
          backgroundColor: blue,
          centerTitle: true,
          title: const Text('Dashboard'),
          actions: [
            Container(
                margin: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    onTap: () {
                      onWillPop(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/logout.png',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          userId ?? '',
                          style: appFontSize,
                        )
                      ],
                    ))),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30),
            height: MediaQuery.of(context).size.height * 0.74,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/evDashboard',
                              arguments: userId);
                        },
                        child: Card(
                          elevation: 15,
                          child: Container(
                            height: 300,
                            width: 600,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/ev_dashboard.png'))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: 35,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(blue)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/evDashboard',
                                  arguments: userId);
                            },
                            child: const Text(
                                'EV Bus Project Analysis Dashboard')),
                      )
                    ],
                  ),
                )),
                VerticalDivider(color: blue, thickness: 2),
                Expanded(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/demand',
                              arguments: userId);
                        },
                        child: Card(
                          elevation: 15,
                          child: Container(
                            height: 300,
                            width: 600,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/demand_energy.png'))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: 35,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(blue)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/demand',
                                arguments: userId);
                          },
                          child: const Text('EV Bus Depot Management System'),
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 35,
            width: 150,
            child: ElevatedButton(
              style:
                  ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
              onPressed: () {
                Navigator.pushNamed(context, 'login/EVDashboard/Cities/');
                // Navigator.push(context, CustomPageRoute(page: CitiesPage()));
                // Navigator.pushNamed(context, '/cities');
              },
              child: const Text('Proceed to Cities'),
            ),
          ),
        ],
      ),
    );
  }
}