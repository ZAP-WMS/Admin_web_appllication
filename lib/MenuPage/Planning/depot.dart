import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_appllication/MenuPage/Planning/overview.dart';
import 'package:web_appllication/Service/database_service.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/style.dart';

class Mydepots extends StatefulWidget {
  String? cityName;
  Mydepots({super.key, this.cityName});

  @override
  State<Mydepots> createState() => _MydepotsState();
}

class _MydepotsState extends State<Mydepots> {
  String? cityName = "";
  File? pickedImage;
  // Uint8List? webImage;
  var webImage;
  bool? _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PopupDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: blue,
      ),
      appBar: AppBar(
        backgroundColor: blue,
        title: Text('Depots - ' + widget.cityName!),
      ),
      body: depolist(),

      // Center(child: Text(widget.cityName!)),
    );
  }

  PopupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Add Depot',
                  ),
                  content: Container(
                    height: 200,
                    width: 250,
                    child: Column(children: [
                      GestureDetector(
                        onTap: () async {
                          if (!kIsWeb) {
                            final ImagePicker picker = ImagePicker();
                            XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              var selected = File(image.path);
                              setState(() {
                                pickedImage = selected;
                                _isLoading == false;
                              });
                            } else {
                              print('No Image has been picked');
                            }
                          } else if (kIsWeb) {
                            final ImagePicker picker = ImagePicker();
                            XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              var f = await image.readAsBytes();
                              setState(() {
                                webImage = f;
                                pickedImage = File('a');
                                _isLoading == false;
                              });
                            } else {
                              print('No Image has been picked');
                            }
                          } else {
                            print('Something went wrong!');
                          }
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: pickedImage == null
                              ? const CircleAvatar(
                                  child: Icon(Icons.person),
                                )
                              : kIsWeb
                                  ? Image.memory(
                                      webImage!,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      pickedImage!,
                                      fit: BoxFit.fill,
                                    ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (val) {
                          setState(() {
                            cityName = val;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ]),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // setState() {
                        //   pickedImage = File('null');
                        //   Navigator.pop(context);
                        // }
                      },
                      child: Text("CANCEL"),
                      style: ElevatedButton.styleFrom(),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (kIsWeb) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              content: SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: blue,
                                  ),
                                ),
                              ),
                            ),
                          );

                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('DepoImages')
                              .child('/' + cityName!);
                          await ref.putData(webImage,
                              SettableMetadata(contentType: 'image/jpeg'));
                          var downloadurl = await ref
                              .getDownloadURL()
                              .whenComplete(() => null);

                          FirebaseFirestore.instance
                              .collection(widget.cityName!)
                              // .doc(widget.cityName)
                              .add({
                            'DepoName': cityName,
                            'DepoUrl': downloadurl,
                          }).whenComplete(() => pickedImage == null);
                          Navigator.pop(context);
                          pickedImage == null;
                          Navigator.pop(context);
                          // DatabaseService()
                          //     .uploadDepoData(cityName!, downloadurl)
                          //     .whenComplete(() {
                          //   Navigator.pop(context);
                          //   pickedImage == null;
                          //   setState() {
                          //     _isLoading = false;
                          //   }

                          //   Navigator.pop(context);
                          // });
                        }
                      },
                      child: Text("ADD"),
                      style: ElevatedButton.styleFrom(),
                    ),
                  ],
                );
              },
            ));
  }

  depolist() {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(widget.cityName!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data!.docs.isNotEmpty) {
                return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          // onTap: () => onToScreen(index),
                          child: Stack(children: [
                            Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: blue,
                                    image: DecorationImage(
                                        image: NetworkImage(snapshot
                                            .data!.docs[index]['DepoUrl']),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(snapshot.data!.docs[index]['DepoName']),
                                const SizedBox(height: 5),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor: blue),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyOverview(
                                                    cityName: widget.cityName!,
                                                    depoName: snapshot
                                                            .data!.docs[index]
                                                        ['DepoName'],
                                                  )
                                              // Mydepots(
                                              //       cityName: snapshot.data!
                                              //           .docs[index]['cityName'],
                                              //     )
                                              ));
                                    },
                                    child: const Text('Add Overview'))
                              ],
                            ),
                          ]),
                        ),
                      );
                    });
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 1000,
                    width: 1000,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: blue)),
                    child: Column(children: [
                      Image.asset(
                        'assets/Tata-Power.jpeg',
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/sustainable.jpeg',
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(width: 50),
                          Image.asset(
                            'assets/Green.jpeg',
                            height: 100,
                            width: 100,
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: blue)),
                          child: const Text(
                            'No depots available yet \n Please add to process',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ]),
                  ),
                )
                    // Text(
                    //   "No Depot Available at This Time....",
                    //   style: TextStyle(color: black),
                    // ),
                    );
              }
            } else {
              return const Center(
                child: Text("No Depot Available at This Time...."),
              );
            }
          } else {
            return LoadingPage();
          }
        });
  }
}
