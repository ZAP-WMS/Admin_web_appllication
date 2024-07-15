import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/screen_admin/KeyEvents/view_AllFiles.dart';
import 'package:web_appllication/screen_admin/overview_page/Jmr_screen/jmr_home.dart';
import 'package:web_appllication/screen_user/overview_pages/Jmr/jmr.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';
import 'package:web_appllication/widgets/widgets_admin/nodata_available.dart';
import '../../KeyEvents/Grid_DataTable.dart';

class JmrAdmin extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String role;
  JmrAdmin(
      {super.key,
      required this.role,
      this.cityName,
      this.depoName,
      this.userId});

  @override
  State<JmrAdmin> createState() => _JmrAdminState();
}

class _JmrAdminState extends State<JmrAdmin> {
  List<dynamic> userList = [];
  bool isDataAvailable = true;
  List<List<int>> jmrTabLen = [];
  int _selectedIndex = 0;
  bool isLoading = true;
  TextEditingController selectedCityController = TextEditingController();
  List<String> title = ['R1', 'R2', 'R3', 'R4', 'R5'];
  List<String> tabName = ['Civil', 'Electrical'];
  TextEditingController selectedDepoController = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    generateAllJmrList();
    super.initState();
  }

  @override
  void dispose() {
    selectedDepoController.dispose();
    selectedCityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'JMR Page',
                    style: appFontSize,
                  ),
                ),
                Text(
                  'City - ${widget.cityName}     Depot - ${widget.depoName}',
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                )
              ],
            ),
            backgroundColor: white,
            flexibleSpace: Container(
              height: 55,
              color: blue,
            ),
            actions: [
              Container(
                padding: const EdgeInsets.all(5.0),
                width: 200,
                height: 30,
                child: TypeAheadField(
                    animationStart: BorderSide.strokeAlignCenter,
                    suggestionsCallback: (pattern) async {
                      return await getCityList(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      selectedCityController.text = suggestion.toString();
                      selectedDepoController.clear();
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(5.0),
                        hintText: widget.cityName,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      controller: selectedCityController,
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                width: 200,
                height: 30,
                child: TypeAheadField(
                    animationStart: BorderSide.strokeAlignCenter,
                    suggestionsCallback: (pattern) async {
                      return await getDepoList(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      selectedDepoController.text = suggestion.toString();

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JmrAdmin(
                              userId: widget.userId,
                              role: widget.role,
                              cityName: widget.cityName,
                              depoName: suggestion.toString(),
                            ),
                          ));
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(5.0),
                        hintText: 'Go To Depot',
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      controller: selectedDepoController,
                    )),
              ),
              widget.role == "projectManager"
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JmrUser(
                                role: widget.role,
                                cityName: widget.cityName,
                                userId: widget.userId,
                                depoName: widget.depoName,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Make An Entry',
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
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
                        widget.userId ?? '',
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ],
            bottom: TabBar(
              onTap: (value) {
                _selectedIndex = value;
                currentIndex = value;
                isLoading = true;
                setState(() {});
                generateAllJmrList();
              },
              labelColor: currentIndex == _selectedIndex ? white : blue,

              labelStyle: buttonWhite,
              unselectedLabelColor: tabbarColor,

              //indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(color: blue),
              tabs: const [
                Tab(text: 'Civil Engineer'),
                Tab(text: 'Electrical Engineer'),
              ],
            ),
          ),
          body: isLoading
              ? LoadingPage()
              : TabBarView(children: [
                  customRowList('Civil'),
                  customRowList('Electrical')
                ]),
        ));
  }

  Widget customRowList(String nameOfTab) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${tabName[_selectedIndex]}JmrTable')
          .collection('userId')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (!snapshot.hasData) {
          return const NodataAvailable();
        } else if (snapshot.hasError) {
          return const Center(
              child: Text(
            'Error fetching data',
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          //  userList = data.docs.map((e) => e.id).toList();
          return ListView.builder(
            itemCount: userList.length, //Length of user ID
            itemBuilder: (context, index) {
              // generateJmrListLen(userList[index]);
              return Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: blue),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.elliptical(
                      10,
                      10,
                    ),
                    topLeft: Radius.elliptical(
                      10,
                      10,
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ExpansionTile(
                    backgroundColor: white,
                    trailing: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blue[900],
                    ),
                    collapsedBackgroundColor: white,
                    title: Text(
                      'User ID - ${userList[index]}',
                      style: TextStyle(color: blue),
                    ),
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index2) {
                            return Container(
                              margin: const EdgeInsets.all(5.0),
                              // padding: const EdgeInsets.only(
                              // left: 15.0, right: 10.0, bottom: 10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 32,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: blue),
                                            borderRadius:
                                                BorderRadius.circular(2.0)),
                                        child: TextButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        white
                                                        //Colors.blue[900]
                                                        )),
                                            child: Text(
                                              title[index2],
                                              style: TextStyle(color: blue),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    jmrTabList(
                                      userList[index],
                                      index2,
                                      index,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  jmrTabList(String currentUserId, int secondIndex, int firstIndex) {
    List<int> currentTabList = jmrTabLen[firstIndex];
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.86,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  currentTabList[secondIndex], // Length from list of jmr items
              shrinkWrap: true,
              itemBuilder: (context, index3) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          blue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JmrHomeAdmin(
                              role: widget.role,
                              title:
                                  '${tabName[_selectedIndex]}-${title[index3]}-JMR${index3 + 1}',
                              jmrTab: title[secondIndex],
                              cityName: widget.cityName,
                              depoName: widget.depoName,
                              showTable: true,
                              dataFetchingIndex: index3 + 1,
                              tabName: tabName[_selectedIndex],
                              userId: currentUserId,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'JMR${index3 + 1}',
                        style: TextStyle(color: white),
                      )),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAllPdfAdmin(
                        title: 'jmr',
                        cityName: widget.cityName!,
                        depoName: widget.depoName!,
                        docId:
                            '/jmrFiles/${tabName[_selectedIndex]}/${widget.cityName}/${widget.depoName}/$currentUserId/${secondIndex + 1}'),
                  ),
                );
              },
              child: const Text('View'))
        ],
      ),
    );
  }

  // Function to calculate Length of JMR all components with ID

  Future<List<dynamic>> generateAllJmrList() async {
    jmrTabLen.clear();
    isDataAvailable = true;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${tabName[_selectedIndex]}JmrTable')
        .collection('userId')
        .get();

    List<dynamic> userListId =
        querySnapshot.docs.map((data) => data.id).toList();

    userList = userListId;

    if (userListId.isEmpty) {
      setState(() {
        isDataAvailable = false;
        isLoading = false;
      });
      return jmrTabLen;
    } else {
      isDataAvailable = false;
      for (int i = 0; i < userListId.length; i++) {
        List<int> tempList = [];
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('JMRCollection')
            .doc(widget.depoName)
            .collection('Table')
            .doc('${tabName[_selectedIndex]}JmrTable')
            .collection('userId')
            .doc(userListId[i])
            .collection('jmrTabName')
            .get();

        List<dynamic> jmrTabList =
            querySnapshot.docs.map((data) => data.id).toList();

        for (int j = 0; j < jmrTabList.length; j++) {
          QuerySnapshot jmrLen = await FirebaseFirestore.instance
              .collection('JMRCollection')
              .doc(widget.depoName)
              .collection('Table')
              .doc('${tabName[_selectedIndex]}JmrTable')
              .collection('userId')
              .doc(userListId[i])
              .collection('jmrTabName')
              .doc(jmrTabList[j])
              .collection('jmrTabIndex')
              .get();

          int jmrLength = jmrLen.docs.length;

          tempList.add(jmrLength);
        }

        if (tempList.length < 5) {
          int tempJmrLen = tempList.length;
          int loop = 5 - tempJmrLen;
          for (int k = 0; k < loop; k++) {
            tempList.add(0);
          }
        }

        jmrTabLen.add(tempList);
      }

      setState(() {
        isLoading = false;
      });
    }

    return jmrTabLen;
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];

    if (selectedCityController.text.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DepoName')
          .doc(selectedCityController.text)
          .collection('AllDepots')
          .get();

      depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

      if (pattern.isNotEmpty) {
        depoList = depoList
            .where((element) => element
                .toString()
                .toUpperCase()
                .startsWith(pattern.toUpperCase()))
            .toList();
      }
    } else {
      depoList.add('Please Select a City');
    }

    return depoList;
  }

  Future<List<dynamic>> getCityList(String pattern) async {
    List<dynamic> cityList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('DepoName').get();

    cityList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      cityList = cityList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return cityList;
  }
}
