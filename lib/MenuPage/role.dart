import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_appllication/MenuPage/menu_screen/assigned_user.dart';
import 'package:web_appllication/MenuPage/menu_screen/totalUser.dart';
import 'package:web_appllication/MenuPage/menu_screen/unAssignedUserPage.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/provider/role_page_totalNum_provider.dart';
import 'package:web_appllication/style.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  bool userExist = false;
  String errorMessage = '';
  String messageForReportingManager = '';
  String selectedUserId = '';
  int totalUserNum = 0;
  int assignedUserNum = 0;
  int unAssignedUserNum = 0;
  bool isLoading = true;
  List<dynamic> allUserId = [];
  final TextEditingController citiesController = TextEditingController();
  final TextEditingController reportingManagerController =
      TextEditingController();
  final TextEditingController selectedUserController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController depotController = TextEditingController();

  List<String> gridTabLabels = [
    'Total PMIS Users',
    'Assigned PMIS Users',
    'UnAssigned PMIS Users',
    'Total O&M Users',
    'Assigned O&M Users',
    'UnAssigned O&M Users',
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
  ];

  List<Color> gridColorList = [
    Colors.blue,
    Colors.green,
    Colors.red,
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
    // storeInTotalAndUnAssigned("Demo Singh");
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
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   centerTitle: true,
      //   title: const Text('Role Management'),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //         gradient: LinearGradient(colors: [
      //       Color.fromARGB(255, 9, 52, 245),
      //       Color.fromARGB(255, 92, 152, 241),
      //     ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
      //   ),
      // ),
      body: isLoading
          ? LoadingPage()
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        childAspectRatio: 1.8,
                      ),
                      itemBuilder: (context, index) {
                        return Consumer<RolePageTotalNumProvider>(
                          builder: (context, value, child) {
                            return gridTabs(
                                index,
                                gridColorList,
                                index == 0
                                    ? totalUserNum
                                    : index == 1
                                        ? assignedUserNum
                                        : index == 2
                                            ? unAssignedUserNum
                                            : 0,
                                screens[index]);
                          },
                        );
                      }),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Assign a Role',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: blue, fontSize: 16),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    height: 5.0,
                    color: blue,
                    thickness: 2.0,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 208, 232, 253)),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                customDropDown('Reporting Manager', false,
                                    allUserList, "Search Reporting Manager", 0),
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      messageForReportingManager,
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customDropDown('Select User', false,
                                    allUserList, "Search User", 1),
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      errorMessage,
                                      style: TextStyle(
                                          color: userExist
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            customDropDown('Select Designation', true,
                                designationList, " Search Designation", 2),
                            customDropDown('Select Cities', true, allCityList,
                                "Search Cities", 3),
                            customDropDown('Select Depots', true, allDepotList,
                                "Search Depots", 4),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 40.0,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Selected Depots',
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(color: blue)),
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: GridView.builder(
                                  itemCount: selectedDepotList.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          childAspectRatio: 5.0,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Card(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border:
                                                    Border.all(color: blue)),
                                            alignment: Alignment.center,
                                            child: Text(
                                              selectedDepotList[index],
                                              style: TextStyle(
                                                  fontSize: 11, color: blue),
                                            )),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 47, 173, 74))),
                            onPressed: () {
                              customAlertBox(
                                  'Please select at least one option in each field');
                            },
                            child: Text(
                              'Assigned Role',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: white),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Future<void> fetchCompleteUserList() async {
    QuerySnapshot adminQuery =
        await FirebaseFirestore.instance.collection('Admin').get();
    List<String> adminList = adminQuery.docs.map((e) => e.id).toList();

    QuerySnapshot userQuery =
        await FirebaseFirestore.instance.collection('User').get();
    List<String> userList = userQuery.docs.map((e) => e.id).toList();

    allUserList = adminList + userList;

    QuerySnapshot cityQuery =
        await FirebaseFirestore.instance.collection('DepoName').get();
    List<String> cityList = cityQuery.docs.map((e) => e.id).toList();

    allCityList = cityList;
  }

  Widget gridTabs(
      int index, List<Color> colorList, int headerNum, Widget screen) {
    final totalValueProvider =
        Provider.of<RolePageTotalNumProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
      alignment: Alignment.center,
      height: 1000,
      width: MediaQuery.of(context).size.width / 6,
      child: Card(
        color: colorList[index],
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
                  Text(
                    headerNum.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white,
                        fontSize: 18),
                  ),
                  Card(
                    elevation: 5.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(colorList[index]),
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
                      child: const Text(
                        'More Info',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 10.0),
              alignment: Alignment.center,
              child: Text(
                gridTabLabels[index],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customDropDown(String title, bool isMultiCheckbox,
      List<String> customDropDownList, String hintText, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(
          3.0,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 180,
            height: 40,
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
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
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
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),
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
                hint: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: white,
                  ),
                ),
                items: isMultiCheckbox
                    ? customDropDownList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          //disable default onTap to avoid closing menu when selecting an item
                          enabled: false,
                          child: StatefulBuilder(
                            builder: (context, menuSetState) {
                              final isSelected = index == 2
                                  ? selectedDesignationList.contains(item)
                                  : index == 3
                                      ? selectedCitiesList.contains(item)
                                      : selectedDepotList.contains(item);
                              return InkWell(
                                onTap: () async {
                                  index == 3 ? allDepotList.clear() : () {};

                                  //Provider function
                                  isSelected
                                      ? index == 2
                                          ? selectedDesignationList.remove(item)
                                          : index == 3
                                              ? selectedCitiesList.remove(item)
                                              : selectedDepotList.remove(item)
                                      : index == 2
                                          ? selectedDesignationList.add(item)
                                          : index == 3
                                              ? selectedCitiesList.add(item)
                                              : selectedDepotList.add(item);

                                  index == 3
                                      ? await fetchDepotList(
                                          selectedCitiesList.length,
                                        )
                                      : () {};
                                  setState(() {});
                                  menuSetState(() {});

                                  //This rebuilds the StatefulWidget to update the button's text
                                  //This rebuilds the dropdownMenu Widget to update the check mark
                                },
                                child: Container(
                                  height: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_box_outlined,
                                          size: 20,
                                        )
                                      else
                                        const Icon(
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
                                color: black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                style: const TextStyle(fontSize: 10),
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
                    checkUserAlreadyExist(selectedUser!).whenComplete(() async {
                      await getSelectedUserId(selectedUser!);
                      setState(() {});
                    });
                  } else if (index == 0) {
                    messageForReportingManager = 'Reporting Manager Selected ✔';
                    setState(() {});
                  }
                },
                iconStyleData: IconStyleData(
                  iconDisabledColor: white,
                  iconEnabledColor: white,
                ),
                buttonStyleData: const ButtonStyleData(
                  elevation: 5,
                ),
              ),
            ),
          ),
        ],
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

  Future<void> storeAssignData() async {
    if (userExist) {
      updateUserData(selectedUser!.trim());
    } else {
      storeUserWithDepotName(selectedCitiesList, selectedDepotList);
      await FirebaseFirestore.instance
          .collection('AssignedRole')
          .doc(selectedUser)
          .set({
        'username': selectedUser,
        'userId': selectedUserId,
        'alphabet': selectedUser![0][0].toUpperCase(),
        'position': 'Assigned',
        'roles': selectedDesignationList,
        'depots': selectedDepotList,
        'reportingManager': selectedReportingManager,
        'cities': selectedCitiesList,
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text('Role Assigned Successfully'),
        ));
      });

      await FirebaseFirestore.instance
          .collection('TotalUsers')
          .doc(selectedUser!.trim())
          .set({
        'userId': selectedUserId,
        'alphabet': selectedUser![0][0].toUpperCase(),
        'position': 'Assigned',
        'roles': selectedDesignationList,
        'depots': selectedDepotList,
        'reportingManager': selectedReportingManager,
        'cities': selectedCitiesList,
      });
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
            FirebaseFirestore.instance
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
            fetchAllUserForProjectManager(cities[i], selectedUserId);

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

  Future fetchAllUserForProjectManager(
      String cityName, String newUserId) async {
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
              {"userId": newUserId, "name": selectedUser}
            ]
      });
    }
  }

  Future<void> updateUserData(String username) async {
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
    print('Updated');
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
    String firstName = username.split(' ')[0];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('FirstName', isEqualTo: firstName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<dynamic> tempData = querySnapshot.docs.map((e) => e.data()).toList();
      Map<String, dynamic> data = tempData[0];

      selectedUserId = data['Employee Id'];
    }
  }

  Future customAlertBox(String message) async {
    final provider =
        Provider.of<RolePageTotalNumProvider>(context, listen: false);
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
    } else {
      storeAssignData().whenComplete(() async {
        await fetchTotalValues().whenComplete(() {
          provider.reloadTotalNum(true);
        });
      });
    }
  }

  Future<void> storeInTotalAndUnAssigned(String name) async {
    await FirebaseFirestore.instance
        .collection('unAssignedRole')
        .doc(name)
        .set({
      "alphabet": name[0][0].toUpperCase(),
      "position": "unAssigned",
    });
    await FirebaseFirestore.instance.collection('TotalUsers').doc(name).set({
      "alphabet": name[0][0].toUpperCase(),
      "position": "unAssigned",
    });
    print('Stored Successfully');
  }
}
