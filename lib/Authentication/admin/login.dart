//import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/Authentication/admin/reset_password.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/overview.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String projectManagerName = '';
  String adminName = '';
  bool isProjectManager = false;
  bool isAdmin = false;
  bool isloading = false;
  // String _companyName = '';
  String _id = "";
  String _pass = "";
  bool _isHidden = true;
  AuthService authService = AuthService();
  // AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? LoadingPage()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  reverse: false,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            _space(16),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                labelText: "Employee ID",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _id = value;
                                });
                                debugPrint(_id);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Employee Id is required';
                                }
                                return null;
                              },
                              style: bodyText2White60,
                              keyboardType: TextInputType.emailAddress,
                              // onSaved: (value) {
                              //      updateEmail(context, value!, ref);
                              //   _email = value;
                              // },
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) => login(),
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: _togglePasswordView,
                                    child: _isHidden
                                        ? const Icon(Icons.visibility)
                                        : Icon(
                                            Icons.visibility_off,
                                            color: grey,
                                          )),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                labelText: "Password",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }

                                // if (value.length < 5 || value.length > 20) {
                                //   return 'Password must be betweem 5 and 20 characters';
                                // }

                                return null;
                              },
                              // key: ValueKey('password'),
                              obscureText: _isHidden,
                              style: bodyText2White60,
                              keyboardType: TextInputType.visiblePassword,
                              // onSaved: (value) {
                              //       updatepPassword(context, value!, ref);
                              //   _pass = value;
                              // },
                              onChanged: (value) {
                                //     updatepPassword(context, value, ref);
                                setState(() {
                                  _pass = value;
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: bodyText2White,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' Forget Password ?',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = (() => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResetPass(
                                                            // email: FirebaseAuth
                                                            //     .instance
                                                            //     .currentUser!
                                                            //     .email!,
                                                            ),
                                                  ),
                                                )),
                                          style: bodyText2White.copyWith(
                                              color: blue))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _space(30),
                            GestureDetector(
                              onTap: () => login(),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: blue,
                                ),
                                child: Center(
                                  child: Text("Sign In", style: button),
                                ),
                              ),
                            ),
                            _space(28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Tata-Power.jpeg',
                                  height: 150,
                                  width: 200,
                                )
                              ],
                            ),
                            _space(28),
                            _space(38),
                            _space(38),
                          ],
                        ),
                      ),
                    ),
                  ),
                )));
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }

  login() async {
    if (_formkey.currentState!.validate()) {
      String companyName = '';

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: blue,
                  ),
                ),
              ),
              Text(
                'Verifying..',
                style: TextStyle(color: blue, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );

      try {
        isProjectManager = await verifyProjectManager(_id);

        if (isProjectManager == true) {
          QuerySnapshot pmData = await FirebaseFirestore.instance
              .collection('AssignedRole')
              .where("userId", isEqualTo: _id)
              .get();

          //Search project Manager On User Collection

          if (pmData.docs.isNotEmpty) {
            List<dynamic> userData = pmData.docs.map((e) => e.data()).toList();
            companyName = 'TATA POWER';
            if (_pass == userData[0]['password'] &&
                _id == userData[0]['userId']) {
              // print('ProjectManager here ${passWord}');
              authService.storeUserRole("projectManager");
              authService.storeEmployeeId(_id);
              authService.storeCompanyName(companyName).then((_) {
                Navigator.pushReplacementNamed(context, 'login/EVDashboard/',
                    arguments: {'userId': _id, "role": "projectManager"});
              });
            }
          }
        } else {
          isAdmin = await verifyAdmin(_id);
          //Login as an admin

          if (!isAdmin) {
            //Login as a user

            QuerySnapshot userQuery = await FirebaseFirestore.instance
                .collection('AssignedRole')
                .where('userId', isEqualTo: _id)
                .get();

            // QuerySnapshot userQuery = await FirebaseFirestore.instance
            //     .collection('User')
            //     .where('Employee Id', isEqualTo: _id)
            //     .get();

            if (_pass == userQuery.docs[0]['password'] &&
                _id == userQuery.docs[0]['userId'] &&
                userQuery.docs.isNotEmpty) {
              List<dynamic> assignedDepots = userQuery.docs[0]["depots"];
              List<String> depots =
                  assignedDepots.map((e) => e.toString()).toList();
              await authService.storeUserRole("user");
              await authService.storeCompanyName(companyName);
              await authService.storeDepoList(depots);
              authService.storeEmployeeId(_id).then((_) {
                Navigator.pushReplacementNamed(context, 'login/EVDashboard/',
                    arguments: {'userId': _id, "role": "user"});
              });
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Password is not Correct or no roles are assigned to this user'),
                ),
              );
            }
          }
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        String error = '';
        if (e.toString() ==
            'RangeError (index): Invalid value: Valid value range is empty: 0') {
          error = 'Employee Id does not exist!';
        } else {
          error = e.toString();
        }
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: blue,
        ));
      }
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<bool> verifyAdmin(String userId) async {
    bool userIsAdmin = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('userId', isEqualTo: userId)
        .get();

    List<dynamic> dataList = querySnapshot.docs.map((e) => e.data()).toList();

    if (dataList.isNotEmpty) {
      adminName = dataList[0]['username'];
      List<dynamic> rolesList = dataList[0]['roles'];
      if (rolesList.contains("Admin")) {
        userIsAdmin = true;
      }

      if (userIsAdmin) {
        String companyName = dataList[0]['companyName'];
        if (_pass == dataList[0]['password'] &&
            _id == dataList[0]['userId'] &&
            dataList[0]['companyName'] == 'TATA POWER') {
          authService.storeUserRole("admin");
          authService.storeCompanyName(companyName);
          authService.storeEmployeeId(_id).then((_) {
            Navigator.pushReplacementNamed(context, 'login/EVDashboard/',
                arguments: {'userId': _id, "role": "admin"});
          });
        } else if (_pass == dataList[0]['password'] &&
            _id == dataList[0]['userId'] &&
            dataList[0]['companyName'] == 'TATA MOTOR') {
          authService.storeCompanyName(companyName);
          authService.storeEmployeeId(_id).then((_) {
            Navigator.pushReplacementNamed(context, 'login/EVDashboard/',
                arguments: {'userId': _id, "role": "admin"});
          });
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Password is not Correct",
                style: TextStyle(color: white),
              ),
            ),
          );
        }
      }
    }
    return userIsAdmin;
  }

  Future<bool> verifyProjectManager(String userId) async {
    bool userIsProjectManager = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('userId', isEqualTo: userId)
        .get();

    List<dynamic> dataList = querySnapshot.docs.map((e) => e.data()).toList();

    if (dataList.isNotEmpty) {
      projectManagerName = dataList[0]['username'];
      List<dynamic> rolesList = dataList[0]['roles'];

      rolesList.every(
        (element) {
          if (element == 'Project Manager') {
            userIsProjectManager = true;
          }
          return false;
        },
      );
    }

    return userIsProjectManager;
  }
}
