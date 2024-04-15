import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/provider/provider_admin/role_page_totalNum_provider.dart';
import 'package:web_appllication/screen_admin/MenuPage/menu_screen/assigned_user.dart';
import 'package:web_appllication/screen_admin/MenuPage/menu_screen/totalUser.dart';
import 'package:web_appllication/screen_admin/MenuPage/menu_screen/unAssignedUserPage.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  final player = AudioPlayer();
  bool isSelectAllDepots = false;
  bool userExist = false;
  String errorMessage = '';
  String messageForReportingManager = '';
  String selectedUserId = '';
  int totalUserNum = 0;
  int assignedUserNum = 0;
  int unAssignedUserNum = 0;
  bool isLoading = true;
  List<dynamic> allUserId = [];
  List<String> unAssignedUsersList = [];
  final TextEditingController citiesController = TextEditingController();
  final TextEditingController reportingManagerController =
      TextEditingController();
  final TextEditingController selectedUserController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController depotController = TextEditingController();

  List<String> gridTabLabels = [
    'Total',
    'Assigned',
    'UnAssigned',
  ];

  List<String> designationList = [
    "Civil Engineer",
    "Electric Engineer",
    "Project Manager",
    "Head Business Operation",
    "Group Head E-Bus Project and O & M",
    "Groud Head E-Bus Project",
    "Group Head Civil EV",
    "Head Civil EV",
    "Vendor",
    "Lead Quality & Safety",
    "Lead EV-Bus Project",
    "Admin"
  ];

  List<Color> gridColorList = [
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  String? selectedUser;
  String? selectedCity;
  String? selectedDesignation;
  String? selectedReportingManager;
  String? selectedDepot;

  List<String> selectedDesignationList = [];
  List<String> selectedCitiesList = [];
  List<String> selectedDepotList = [];

  List<String> allUserList = [];
  List<String> allCityList = [];
  List<String> allDepotList = [];

  List<Widget> screens = [
    const TotalUsers(),
    const AssignedUser(),
    const UnAssingedUsers(),
    const AssignedUser(),
    const AssignedUser(),
    const AssignedUser(),
  ];

  @override
  void initState() {
    // storeUserDataToUnAssignedRole().whenComplete(() {
    //   storeUnAssignedToTotalUser();
    // });
    // updateRoleManagementData([]);
    fetchCompleteUserList().whenComplete(() async {
      await fetchTotalValues();
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    citiesController.dispose();
    reportingManagerController.dispose();
    selectedUserController.dispose();
    designationController.dispose();
    depotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingPage()
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //EV PMIS

                    Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              52,
                              91,
                              199,
                            ),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: const Text(
                              "PMIS Users",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(
                                    255,
                                    52,
                                    91,
                                    199,
                                  ),
                                  letterSpacing: 1.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: GridView.builder(
                                itemCount: 3,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3.5,
                                ),
                                itemBuilder: (context, index) {
                                  return Consumer<
                                      RolePageTotalNumProviderAdmin>(
                                    builder: (context, value, child) {
                                      return gridTabs(
                                        index,
                                        index == 2
                                            ? unAssignedUserNum != 0
                                                ? Colors.red
                                                : const Color.fromARGB(
                                                    255, 52, 91, 199)
                                            : const Color.fromARGB(
                                                255, 52, 91, 199),
                                        index == 0
                                            ? totalUserNum
                                            : index == 1
                                                ? assignedUserNum
                                                : index == 2
                                                    ? unAssignedUserNum
                                                    : 0,
                                        screens[index],
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),

                    //O&M users

                    Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 84, 122, 230),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: const Text(
                              "O & M Users",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 84, 122, 230),
                                  letterSpacing: 1.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: GridView.builder(
                                itemCount: 3,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3.5,
                                ),
                                itemBuilder: (context, index) {
                                  return Consumer<
                                      RolePageTotalNumProviderAdmin>(
                                    builder: (context, value, child) {
                                      return gridTabs(
                                        index,
                                        index == 2
                                            ? 0 != 0
                                                ? Colors.red
                                                : const Color.fromARGB(
                                                    255, 52, 91, 199)
                                            : const Color.fromARGB(
                                                255, 52, 91, 199),
                                        0,
                                        screens[index],
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(
                      255,
                      208,
                      232,
                      253,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Card(
                                elevation: 5.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(
                                      3.0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 180,
                                  child: Text(
                                    "Select Reporting Manager:",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: blue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: [
                                    customDropDown(
                                        'Reporting Manager',
                                        false,
                                        allUserList,
                                        "Search Reporting Manager",
                                        0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        messageForReportingManager,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Row(
                            children: [
                              Card(
                                elevation: 5.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(
                                      3.0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 180,
                                  child: Text(
                                    "Select User:",
                                    style: TextStyle(fontSize: 11, color: blue),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: [
                                    customDropDown(
                                      'Select User',
                                      false,
                                      allUserList,
                                      "Search User",
                                      1,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        errorMessage,
                                        style: TextStyle(
                                          color: userExist
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customDropDown(
                                'Select Designation',
                                true,
                                designationList,
                                "Search Designation",
                                2,
                              ),
                              Container(),
                            ],
                          ),
                          customShowBox(
                            selectedDesignationList,
                            0.75,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customDropDown(
                                  'Select Cities',
                                  true,
                                  allCityList,
                                  "Search Cities",
                                  3,
                                ),
                                Container(),
                              ],
                            ),
                          ),
                          customShowBox(selectedCitiesList, 0.75)
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customDropDown(
                                  'Select Depots',
                                  true,
                                  allDepotList,
                                  "Search Depots",
                                  4,
                                ),
                                Container(),
                              ],
                            ),
                          ),
                          customShowBox(
                            selectedDepotList,
                            0.75,
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          10.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(
                                    255,
                                    47,
                                    173,
                                    74,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                customAlertBox(
                                    'Please select at least one option in each field');
                              },
                              child: Text(
                                'Assign Role',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 65, 54, 221))),
                                onPressed: () async {
                                  if (selectedDesignationList
                                          .contains("Admin") ==
                                      true) {
                                    final provider = Provider.of<
                                            RolePageTotalNumProviderAdmin>(
                                        context,
                                        listen: false);
                                    storeAssignData().whenComplete(
                                      () async {
                                        await fetchTotalValues().whenComplete(
                                          () {
                                            provider.reloadTotalNum(true);
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    customAlert();
                                  }
                                },
                                child: Text(
                                  'Approve As Admin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: white),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: Stack(
          children: [
            Positioned(
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 223, 237, 247),
                onPressed: () {
                  showDialogueForRoleRequest();
                },
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: blue,
                ),
              ),
            ),
            Positioned(
                right: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: const Color.fromARGB(255, 1, 37, 156),
                  child: Text('$unAssignedUserNum',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ))
          ],
        ),
      ),
    );
  }

  Future playNotificationTone() async {
    await player.play(
        DeviceFileSource('assets/notification_sound/notification.mp3'),
        volume: 1.0,
        mode: PlayerMode.lowLatency);
  }

  Future notifyUser() async {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        playNotificationTone();
      },
    );
  }

  Future<void> fetchCompleteUserList() async {
    // QuerySnapshot adminQuery =
    //     await FirebaseFirestore.instance.collection('Admin').get();
    // List<String> adminList = adminQuery.docs.map((e) => e.id).toList();

    QuerySnapshot userQuery =
        await FirebaseFirestore.instance.collection('User').get();
    List<String> userList = userQuery.docs.map((e) => e.id).toList();

    allUserList = userList;

    QuerySnapshot cityQuery =
        await FirebaseFirestore.instance.collection('DepoName').get();
    List<String> cityList = cityQuery.docs.map((e) => e.id).toList();

    allCityList = cityList;
  }

  Widget gridTabs(int index, Color cardColor, int headerNum, Widget screen) {
    final totalValueProvider =
        Provider.of<RolePageTotalNumProviderAdmin>(context, listen: false);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
      child: Card(
        color: cardColor,
        elevation: 5,
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              margin: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headerNum.toString(), //O&M value
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: white,
                            fontSize: 18),
                      ),
                      Text(
                        gridTabLabels[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Card(
                      elevation: 5.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => screen,
                            ),
                          ).whenComplete(() {
                            fetchTotalValues().whenComplete(() {
                              totalValueProvider.reloadTotalNum(true);
                            });
                          });
                        },
                        child: Text(
                          'More Info',
                          style: TextStyle(fontSize: 12, color: cardColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customDropDown(String title, bool isMultiCheckbox,
      List<String> customDropDownList, String hintText, int index) {
    return Card(
      elevation: 5.0,
      child: Container(
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
            color: blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(
            3.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 180,
              height: 30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownSearchData: DropdownSearchData(
                    searchController: index == 0
                        ? reportingManagerController
                        : index == 1
                            ? selectedUserController
                            : index == 2
                                ? designationController
                                : index == 3
                                    ? citiesController
                                    : depotController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: index == 4 ? 90 : 42,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            width: 160,
                            height: 30,
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: index == 0
                                  ? reportingManagerController
                                  : index == 1
                                      ? selectedUserController
                                      : index == 2
                                          ? designationController
                                          : index == 3
                                              ? citiesController
                                              : depotController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                hintText: hintText,
                                hintStyle: const TextStyle(
                                  fontSize: 11,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (index == 4)
                            InkWell(
                              onTap: () {
                                isSelectAllDepots = !isSelectAllDepots;

                                if (isSelectAllDepots) {
                                  selectedDepotList.clear();
                                  customDropDownList.forEach((element) {
                                    selectedDepotList.add(element);
                                  });
                                } else {
                                  selectedDepotList.clear();
                                }
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                    value: isSelectAllDepots,
                                    onChanged: (value) {},
                                  ),
                                  Text(
                                    "All Depots",
                                    style:
                                        TextStyle(fontSize: 11, color: black),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  value: index == 0
                      ? selectedReportingManager
                      : index == 1
                          ? selectedUser
                          : index == 2
                              ? selectedDesignation
                              : index == 3
                                  ? selectedCity
                                  : selectedDepot,
                  isExpanded: true,
                  onMenuStateChange: (isOpen) {
                    if (index == 0) messageForReportingManager = "";
                    index == 3
                        ? selectedCitiesList.isEmpty
                            ? allDepotList.clear()
                            : () {}
                        : () {};
                    setState(() {});
                  },
                  // selectedItemBuilder: (context) {
                  //   return [
                  //     Text(
                  //       title,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 11,
                  //         color: white,
                  //       ),
                  //       textAlign: TextAlign.left,
                  //     ),
                  //   ];
                  // },
                  hint: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: blue,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  items: isMultiCheckbox
                      ? customDropDownList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            enabled: false,
                            child: StatefulBuilder(
                              builder: (context, menuSetState) {
                                bool isSelected = index == 2
                                    ? selectedDesignationList.contains(item)
                                    : index == 3
                                        ? selectedCitiesList.contains(item)
                                        : selectedDepotList.contains(item);

                                return InkWell(
                                  onTap: () async {
                                    switch (isSelected) {
                                      case true:
                                        if (isSelectAllDepots) {
                                          isSelectAllDepots =
                                              !isSelectAllDepots;
                                        }
                                        index == 2
                                            ? selectedDesignationList
                                                .remove(item)
                                            : index == 3
                                                ? selectedCitiesList
                                                    .remove(item)
                                                : selectedDepotList
                                                    .remove(item);
                                        break;
                                      case false:
                                        index == 2
                                            ? selectedDesignationList.add(item)
                                            : index == 3
                                                ? selectedCitiesList.add(item)
                                                : selectedDepotList.add(item);
                                        break;
                                    }
                                    index == 3 ? allDepotList.clear() : () {};
                                    index == 3
                                        ? await fetchDepotList(
                                            selectedCitiesList.length,
                                          )
                                        : () {};
                                    setState(() {});
                                    menuSetState(() {});
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        isSelected
                                            ? const Icon(
                                                Icons.check_box_outlined,
                                                size: 20,
                                              )
                                            : const Icon(
                                                Icons.check_box_outline_blank,
                                                size: 20,
                                              ),
                                        const SizedBox(width: 3),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                                fontSize: 12, color: black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList()
                      : customDropDownList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: blue,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          .toList(),
                  style: TextStyle(fontSize: 10, color: blue),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 300,
                  ),
                  onChanged: (value) {
                    index == 0
                        ? selectedReportingManager = value
                        : index == 1
                            ? selectedUser = value
                            : index == 2
                                ? selectedDesignation = value
                                : selectedCity = value;
                    if (index == 1) {
                      selectedUserId = '';
                      errorMessage = 'Role can be assigned ✔';
                      userExist = false;
                      checkUserAlreadyExist(selectedUser!)
                          .whenComplete(() async {
                        await getSelectedUserId(selectedUser!);
                        setState(() {});
                      });
                    } else if (index == 0) {
                      messageForReportingManager =
                          'Reporting Manager Selected ✔';
                    }
                  },
                  iconStyleData: IconStyleData(
                    iconDisabledColor: blue,
                    iconEnabledColor: blue,
                  ),
                  buttonStyleData: const ButtonStyleData(
                    elevation: 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchDepotList(int cityListLen) async {
    if (cityListLen != 0) {
      for (int i = 0; i < cityListLen; i++) {
        QuerySnapshot depotQuery = await FirebaseFirestore.instance
            .collection('DepoName')
            .doc(selectedCitiesList[i])
            .collection('AllDepots')
            .get();

        List<String> depotList = depotQuery.docs.map((e) => e.id).toList();
        allDepotList = allDepotList + depotList;
      }
    }
  }

  Future<void> fetchTotalValues() async {
    QuerySnapshot totalQuery =
        await FirebaseFirestore.instance.collection('TotalUsers').get();

    List<String> totalUsersList = totalQuery.docs.map((e) => e.id).toList();
    totalUserNum = totalUsersList.length;

    QuerySnapshot assignedQuery =
        await FirebaseFirestore.instance.collection('AssignedRole').get();

    List<String> assignedUsersList =
        assignedQuery.docs.map((e) => e.id).toList();
    assignedUserNum = assignedUsersList.length;

    QuerySnapshot unAssignedQuery =
        await FirebaseFirestore.instance.collection('unAssignedRole').get();

    List<String> unAssignedUsersList =
        unAssignedQuery.docs.map((e) => e.id).toList();
    unAssignedUserNum = unAssignedUsersList.length;
  }

  Future<List<String>> getUserPassword() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('Employee Id', isEqualTo: selectedUserId)
        .get();

    List<dynamic> userData = querySnapshot.docs.map((e) => e.data()).toList();
    String userPassword = userData[0]['Password'];
    String userCompany = userData[0]['CompanyName'];
    return [userPassword, userCompany];
  }

  Future<void> storeAssignData() async {
    if (userExist) {
      updateUserData(selectedUser!.trim()).whenComplete(() {
        updateRoleManagementData(selectedCitiesList);
      });
    } else {
      List<String> userPassAndCompany = await getUserPassword();
      storeUserWithDepotName(selectedCitiesList, selectedDepotList);
      await FirebaseFirestore.instance
          .collection('AssignedRole')
          .doc(selectedUser)
          .set({
        "companyName": userPassAndCompany[1],
        'username': selectedUser,
        'userId': selectedUserId,
        'alphabet': selectedUser![0][0].toUpperCase(),
        'position': 'Assigned',
        'roles': selectedDesignationList,
        'depots': selectedDepotList,
        'reportingManager': selectedReportingManager,
        'cities': selectedCitiesList,
        "password": userPassAndCompany[0]
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text('Approved As Admin'),
        ));
      });

      await FirebaseFirestore.instance
          .collection('TotalUsers')
          .doc(selectedUser!.trim())
          .set(
        {
          "companyName": userPassAndCompany[1],
          'userId': selectedUserId,
          'alphabet': selectedUser![0][0].toUpperCase(),
          'position': 'Assigned',
          'roles': selectedDesignationList,
          'depots': selectedDepotList,
          'reportingManager': selectedReportingManager,
          'cities': selectedCitiesList,
          "password": userPassAndCompany[0]
        },
      );
    }

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('unAssignedRole')
        .doc(selectedUser);

    await documentReference.delete();
  }

  Future<void> storeUserWithDepotName(
      List<String> cities, List<String> depots) async {
    bool isPmRoleAssigned = false;
    for (int i = 0; i < selectedDesignationList.length; i++) {
      if (selectedDesignationList[i] == "Project Manager") {
        isPmRoleAssigned = true;
      }
    }

    for (int i = 0; i < cities.length; i++) {
      for (int j = 0; j < depots.length; j++) {
        DocumentSnapshot dataDocSnap = await FirebaseFirestore.instance
            .collection('DepoName')
            .doc(cities[i])
            .collection('AllDepots')
            .doc(depots[j])
            .get();

        if (dataDocSnap.exists) {
          if (isPmRoleAssigned) {
            await FirebaseFirestore.instance
                .collection('roleManagement')
                .doc(cities[i])
                .collection("projectManager")
                .doc(selectedUser)
                .set({
              "userId": selectedUserId,
              "roles": selectedDesignationList,
              "reportingManager": selectedReportingManager,
              "alphabet": selectedUser![0][0].toUpperCase(),
              "position": "Assigned",
              "depots": selectedDepotList,
              "allUserId": []
            });
          } else {
            updateProjectManagerData(cities[i], selectedUserId);

            await FirebaseFirestore.instance
                .collection('roleManagement')
                .doc(cities[i])
                .collection('projectManager')
                .doc(selectedReportingManager!)
                .collection('users')
                .doc(selectedUser)
                .set({
              "userId": selectedUserId,
              "roles": selectedDesignationList,
              "reportingManager": selectedReportingManager,
              "alphabet": selectedUser![0][0].toUpperCase(),
              "position": "Assigned",
              "depots": selectedDepotList
            });
          }
        }
      }
    }
  }

  Future updateProjectManagerData(String cityName, String newUserId) async {
    allUserId.clear();
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('roleManagement')
        .doc(cityName)
        .collection('projectManager')
        .doc(selectedReportingManager)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      allUserId = mapData['allUserId'];

      FirebaseFirestore.instance
          .collection('roleManagement')
          .doc(cityName)
          .collection('projectManager')
          .doc(selectedReportingManager)
          .update({
        "allUserId": allUserId +
            [
              {
                "userId": newUserId,
                "name": selectedUser,
                "depots": selectedDepotList
              }
            ]
      });
    }
  }

  Future<void> updateUserData(String username) async {
    //Update AssignedRole Collection
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .doc(username)
        .get();

    List<dynamic> updatedRole = [];
    List<dynamic> updatedDepo = [];
    List<dynamic> updatedCity = [];

    Map<String, dynamic> tempData =
        documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> presentRoles = tempData['roles'];
    List<dynamic> presentDepots = tempData['depots'];
    List<dynamic> presentCities = tempData['cities'];

    updatedRole = presentRoles + selectedDesignationList;
    updatedDepo = presentDepots + selectedDepotList;
    updatedCity = presentCities + selectedCitiesList;

    updatedRole = updatedRole.toSet().toList();
    updatedDepo = updatedDepo.toSet().toList();
    updatedCity = updatedCity.toSet().toList();

    await FirebaseFirestore.instance
        .collection('AssignedRole')
        .doc(selectedUser)
        .update({
      'username': selectedUser!.trim(),
      'userId': selectedUserId,
      'alphabet': selectedUser![0][0].toUpperCase(),
      'position': 'Assigned',
      'roles': updatedRole,
      'depots': updatedDepo,
      'reportingManager': selectedReportingManager,
      'cities': updatedCity,
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Role Assigned Successfully'),
      ));
    });

    await FirebaseFirestore.instance
        .collection('TotalUsers')
        .doc(selectedUser)
        .update({
      'userId': selectedUserId,
      'alphabet': selectedUser![0][0].toUpperCase(),
      'position': 'Assigned',
      'roles': updatedRole,
      'depots': updatedDepo,
      'reportingManager': selectedReportingManager,
      'cities': updatedCity,
    }).whenComplete(() {
      updatedCity.clear();
      updatedDepo.clear();
      updatedRole.clear();
    });
  }

  Future updateRoleManagementData(List<String> cityList) async {
    for (int i = 0; i < cityList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("roleManagement")
          .doc(cityList[i])
          .collection("projectManager")
          .doc(selectedReportingManager)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> mapData =
            documentSnapshot.data() as Map<String, dynamic>;

        List<dynamic> allUserIdData = mapData['allUserId'];

        for (int j = 0; j < allUserIdData.length; j++) {
          if (allUserIdData[j]["userId"] == selectedUserId) {
            List<dynamic> oldDepots = allUserIdData[j]["depots"];

            for (int k = 0; k < selectedDepotList.length; k++) {
              if (oldDepots.contains(selectedDepotList[k]) == false) {
                oldDepots.add(selectedDepotList[k]);
              }
            }

            allUserIdData.removeAt(j);

            print("allUserIdData: $allUserIdData");

            FirebaseFirestore.instance
                .collection("roleManagement")
                .doc(cityList[i])
                .collection("projectManager")
                .doc(selectedReportingManager)
                .update(
              {
                "allUserId": allUserIdData +
                    [
                      {
                        "depots": oldDepots, // updated depots
                        "name": selectedUser,
                        "userId": selectedUserId
                      }
                    ],
              },
            );
          }
        }
      }
    }
    print("Role Management Data Updated");
  }

  Future<void> checkUserAlreadyExist(String username) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('AssignedRole').get();
    List<dynamic> assignedUsers = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < assignedUsers.length; i++) {
      if (assignedUsers[i].toString().toUpperCase().trim() ==
          username.toUpperCase().trim()) {
        errorMessage = 'Warning! User Already Assigned A Role';
        userExist = true;
      }
    }
  }

  Future<void> getSelectedUserId(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('fullName', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<dynamic> tempData = querySnapshot.docs.map((e) => e.data()).toList();
      Map<String, dynamic> data = tempData[0];

      selectedUserId = data['Employee Id'];
    }
    print("selectedUserId: $selectedUserId");
  }

  Future customAlertBox(String message) async {
    final provider =
        Provider.of<RolePageTotalNumProviderAdmin>(context, listen: false);
    if (selectedUser == null ||
        selectedReportingManager == null ||
        selectedDepotList.isEmpty ||
        selectedDesignationList.isEmpty ||
        selectedCitiesList.isEmpty) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.all(5.0),
              iconPadding: const EdgeInsets.all(5.0),
              contentPadding: const EdgeInsets.all(10.0),
              elevation: 10,
              content: Text(
                message,
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.warning_amber,
                size: 60.0,
                color: blue,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Container(
                  decoration: BoxDecoration(border: Border.all(color: blue)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(color: blue),
                    ),
                  ),
                )
              ],
            );
          });
    } else {
      storeAssignData().whenComplete(() async {
        await fetchTotalValues().whenComplete(() {
          provider.reloadTotalNum(true);
        });
      });
    }
  }

  void showDialogueForRoleRequest() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('unAssignedRole')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      Text('Loading...')
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                unAssignedUsersList =
                    snapshot.data!.docs.map((e) => e.id).toList();
                return Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 20, bottom: 10.0),
                            child: Text(
                              'Manage Role Request',
                              style: TextStyle(fontSize: 20, color: blue),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel_presentation_sharp,
                                  color: red,
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: unAssignedUsersList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(unAssignedUsersList[index]),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(blue)),
                                        onPressed: () {
                                          _showConfirmationDialog(
                                              unAssignedUsersList[index]);
                                        },
                                        child: const Text("Confirm"),
                                      ),
                                      // const SizedBox(width: 8.0),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     _showDeletionDialog(friendRequests[index]);
                                      //   },
                                      //   child: const Text("Delete"),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ));
        });
  }

  Future customAlert() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.all(5.0),
            iconPadding: const EdgeInsets.all(5.0),
            contentPadding: const EdgeInsets.all(10.0),
            elevation: 10,
            content: const Text(
              "Please Select Admin as Designation to Approve",
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.warning_amber,
              size: 60.0,
              color: blue,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Container(
                decoration: BoxDecoration(border: Border.all(color: blue)),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(white)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: blue),
                  ),
                ),
              )
            ],
          );
        });
  }

  void _showConfirmationDialog(String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Role Request"),
          content: Text("Do you want to Assign role to $userName?"),
          actions: [
            TextButton(
              style:
                  ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
              onPressed: () async {
                if (userName != selectedUser) {
                  selectedUser = userName;
                  errorMessage = 'Role can be assigned ✔';
                  getSelectedUserId(selectedUser!).whenComplete(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    setState(() {});
                  });
                }
              },
              child: Text(
                "Assign",
                style: TextStyle(color: white),
              ),
            ),
            TextButton(
              style:
                  ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget customShowBox(List<String> buildList, double widhtSize) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        border: Border.all(
          color: blue,
        ),
      ),
      height:
          buildList.length > 6 ? MediaQuery.of(context).size.height * 0.13 : 40,
      width: MediaQuery.of(context).size.width * widhtSize,
      child: GridView.builder(
          itemCount: buildList.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 4.5,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 3.0,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      2.0,
                    ),
                    border: Border.all(
                      color: blue,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    buildList[index],
                    style: TextStyle(
                        fontSize: 11, color: blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future storeUnAssignedToTotalUser() async {
    QuerySnapshot unAssignedQuery =
        await FirebaseFirestore.instance.collection('unAssignedRole').get();
    List<dynamic> unAssignedList =
        unAssignedQuery.docs.map((e) => e.data()).toList();

    for (int i = 0; i < unAssignedList.length; i++) {
      await FirebaseFirestore.instance
          .collection('TotalUsers')
          .doc(unAssignedList[i]["fullName"])
          .set(unAssignedList[i]);
    }
  }

  Future<void> storeUserDataToUnAssignedRole() async {
    QuerySnapshot unAssignedQuery =
        await FirebaseFirestore.instance.collection("unAssignedRole").get();

    List<dynamic> unAssignedList =
        unAssignedQuery.docs.map((e) => e.id).toList();

    QuerySnapshot userQuery =
        await FirebaseFirestore.instance.collection("User").get();

    List<dynamic> userMapData = userQuery.docs.map((e) => e.data()).toList();

    for (int i = 0; i < unAssignedList.length; i++) {
      for (int j = 0; j < userMapData.length; j++) {
        if (unAssignedList[i] == userMapData[j]['fullName']) {
          print(userMapData[j]['fullName']);
          await FirebaseFirestore.instance
              .collection('unAssignedRole')
              .doc(unAssignedList[i])
              .set({
            "position": "unAssigned",
            "alphabet": userMapData[j]['FirstName'][0].toString().toUpperCase(),
            "FirstName": userMapData[j]['FirstName'],
            "LastName": userMapData[j]['LastName'],
            "Phone Number": userMapData[j]['Phone Number'],
            "Email": userMapData[j]['Email'],
            "Designation": userMapData[j]['Designation'],
            "Department": userMapData[j]['Department'],
            "CompanyName": "TATA POWER",
            "Password": userMapData[j]['Password'],
            "ConfirmPassword": userMapData[j]['ConfirmPassword'],
            'userId': userMapData[j]['Employee Id'],
            "fullName": userMapData[j]['fullName'],
          });
        }
      }
    }
  }
}
