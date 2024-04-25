import 'package:flutter/material.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/FirebaseApi/firebase_api_user.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/widgets/widgets_user/custom_appbar.dart';

import 'image_page.dart';

class ViewAllPdfUser extends StatefulWidget {
  String? title;
  String? subtitle;
  String? cityName;
  String? depoName;
  dynamic userId;
  String? fldrName;
  String? date;
  int? srNo;
  dynamic docId;
  ViewAllPdfUser({
    super.key,
    required this.title,
    this.subtitle,
    required this.cityName,
    required this.depoName,
    required this.userId,
    this.fldrName,
    this.date,
    this.srNo,
    this.docId,
  });

  @override
  State<ViewAllPdfUser> createState() => _ViewAllPdfUserState();
}

class _ViewAllPdfUserState extends State<ViewAllPdfUser> {
  late Future<List<FirebaseFile>> futureFiles;
  List<String> pdfFiles = [];
  final AuthService authService = AuthService();
  List<String> assignedDepots = [];
  bool isFieldEditable = false;
  String? role;

  @override
  void initState() {
    getAssignedDepots().whenComplete(() async {
      role = await authService.getUserRole();

      futureFiles = widget.title == 'QualityChecklist'
          ? FirebaseApiUser.listAll(
              '${widget.title}/${widget.subtitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/${widget.date}/${widget.srNo}')
          : widget.title == 'jmr'
              ? FirebaseApiUser.listAll(widget.fldrName!)
              : widget.title == 'ClosureReport'
                  ? FirebaseApiUser.listAll(
                      '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.docId}')
                  : widget.title == 'Key Events' ||
                          widget.title == 'Overview Page'
                      ? FirebaseApiUser.listAll(
                          '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}')
                      : widget.title == '/BOQSurvey' ||
                              widget.title == '/BOQElectrical' ||
                              widget.title == '/BOQCivil'
                          ? FirebaseApiUser.listAll(
                              '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.docId}')
                          : FirebaseApiUser.listAll(
                              '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.date}/${widget.docId}');
    });
    super.initState();
  }

// /DetailedEngRFC/Bengaluru/BMTC KR Puram-29/ ZW3210
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            cityname: widget.cityName,
            depotName: widget.depoName,
            text: 'File List',
          )),
      //  AppBar(
      //   title: const Text('File List'),
      //   backgroundColor: blue,
      // ),
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              if (snapshot.hasError) {
                return const Center(child: Text('Some error occurred!'));
              } else {
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
                      ? Image.asset('assets/pdf_logo.png')
                      : Image.asset('assets/excel.png')),
          //PdfThumbnail.fromFile(file.ref.fullPath, currentPage: 2)),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImagePage(
                  file: file, isFieldEditable: isFieldEditable, role: role),
            ),
          ),
        ),
        Text(
          file.name,
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: Container(
          width: 52,
          height: 52,
          child: const Icon(
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

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    isFieldEditable =
        authService.verifyAssignedDepot(widget.depoName!, assignedDepots);
  }
}
