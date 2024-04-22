import 'dart:html';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/overview.dart';
import 'package:web_appllication/screen_user/KeysEvents/upload.dart';
import 'package:web_appllication/widgets/widgets_admin/custom_appbar.dart';
import '../../FirebaseApi/firebase_api_admin.dart';
import 'image_page.dart';

class ViewAllPdfAdmin extends StatefulWidget {
  String title;
  String cityName;
  String depoName;
  String? userId;
  String? date;
  String docId;
  String? role;

  ViewAllPdfAdmin(
      {super.key,
      required this.title,
      required this.cityName,
      required this.depoName,
      this.userId,
      this.date,
      required this.docId,
      this.role});

  @override
  State<ViewAllPdfAdmin> createState() => _ViewAllPdfAdminState();
}

class _ViewAllPdfAdminState extends State<ViewAllPdfAdmin> {
  late Future<List<FirebaseFile>> futureFiles;
  List<dynamic> drawingId = [];
  List<dynamic> drawingRef = [];
  List<dynamic> drawingfullpath = [];
  bool _isload = true;

  @override
  void initState() {
    futureFiles = FirebaseApiAdmin.listAll(
        '${widget.title}/${widget.cityName}/${widget.depoName}/null/${widget.docId}');
    if (widget.title == '/BOQSurvey' ||
        widget.title == '/BOQElectrical' ||
        widget.title == '/BOQCivil') {
      futureFiles = FirebaseApiAdmin.listAll(
          '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.docId}');
      setState(() {
        _isload = false;
      });
    } else if (widget.title == 'jmr') {
      futureFiles = FirebaseApiAdmin.listAll(widget.docId);
      setState(() {
        _isload = false;
      });
    } else if (widget.title == 'Daily Report') {
      futureFiles = FirebaseApiAdmin.listAll(
          '/Daily Report/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.docId}');
      print(
          '/Daily Report/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.docId}');
      setState(() {
        _isload = false;
      });
    } else {
      getrefdata().whenComplete(() {
        for (int i = 0; i < drawingRef.length; i++) {
          if (widget.title == 'Overview Page') {
            print(
                '${widget.title}/${widget.cityName}/${widget.depoName}/${drawingRef[i]}/');
            futureFiles = FirebaseApiAdmin.listAll(
                '${widget.title}/${widget.cityName}/${widget.depoName}/${drawingRef[i]}');
          }
          for (int j = 0; j < drawingfullpath.length; j++) {
            print('before ' + drawingfullpath[j]);
            print(
                'after  ${widget.title}/${widget.cityName}/${widget.depoName}/${drawingRef[i]}/${widget.docId}');

            if (drawingfullpath[j] ==
                '${widget.title}/${widget.cityName}/${widget.depoName}/${drawingRef[i]}/${widget.docId}') {
              // futureFiles = FirebaseApi.listAll(
              //     '${widget.title}/${widget.cityName}/${widget.depoName}/RM7292/${widget.docId}');
              futureFiles = FirebaseApiAdmin.listAll(drawingfullpath[j]);
            }
          }
        }

        setState(() {
          _isload = false;
        });

        // futureFiles = data__[1];
      });
    }

    super.initState();
  }

// /DetailedEngRFC/Bengaluru/BMTC KR Puram-29/ ZW3210
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            50,
          ),
          child: CustomAppBar(
            isProjectManager: widget.role == 'projectManager' ? true : false,
            makeAnEntryPage: UploadDocument(
              cityName: widget.cityName,
              depoName: widget.depoName,
              userId: widget.userId,
              title: 'Overview Page',
              pagetitle: "Overview Page",
              fldrName: '',
            ),
            cityName: widget.cityName,
            userId: userId,
            depoName: widget.depoName,
            text: 'Depot Insights',
          )),
      body: _isload
          ? LoadingPage()
          : FutureBuilder<List<FirebaseFile>>(
              future: futureFiles,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return const Center(child: Text('Some error occurred!'));
                    } else {
                      print('Else part is running');
                      final files = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildHeader(files.length),
                          const SizedBox(height: 12),
                          Expanded(
                              child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5),
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              final file = files[index];
                              return buildFile(context, file);
                            },
                          )
                              //  ListView.builder(
                              //   itemCount: files.length,
                              //   itemBuilder: (context, index) {
                              //     final file = files[index];

                              //     return buildFile(context, file);
                              //   },
                              // ),
                              ),
                        ],
                      );
                    }
                }
              },
            ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    final isPdf = ['.pdf'].any(file.name.contains);
    final isexcel = ['.xlsx'].any(file.name.contains);
    return Column(
      children: [
        InkWell(
          child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 120,
              width: 120,
              child: isImage
                  ? Image.network(
                      file.url,
                      fit: BoxFit.fill,
                    )
                  : isPdf
                      ? Image.asset('assets/pdf_logo.jpeg')
                      : Image.asset('assets/excel.png')),
          //PdfThumbnail.fromFile(file.ref.fullPath, currentPage: 2)),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ImagePage(file: file))),
        ),
        Text(file.name)
      ],
    );
  }

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: const SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );

  Future getrefdata() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('${widget.title}/${widget.cityName}/${widget.depoName}');
    final listResult = await storageRef.listAll();
    print(listResult.prefixes[0]);
    for (var prefix in listResult.prefixes) {
      drawingRef.add(prefix.name);
      // print(drawingRef);

      final storageRef1 = FirebaseStorage.instance.ref().child(
          '${widget.title}/${widget.cityName}/${widget.depoName}/${prefix.name}');
      final listResult1 = await storageRef1.listAll();

      for (var prefix in listResult1.prefixes) {
        drawingId.add(prefix.fullPath);

        final storageRef2 =
            FirebaseStorage.instance.ref().child('${prefix.fullPath}');
        final listResult2 = await storageRef2.listAll();
        for (var prefix in listResult2.prefixes) {
          drawingfullpath.add('${storageRef2.fullPath}/${prefix.name}');

          print(drawingfullpath[0]);
        }
      }
    }
  }
}
