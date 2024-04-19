import 'dart:convert';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/screen_user/Planning_Pages/safety_checklist.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';
import 'package:web_appllication/widgets/widgets_admin/custom_appbar.dart';
import 'package:web_appllication/widgets/widgets_admin/nodata_available.dart';

class SafetySummary extends StatefulWidget {
  final String? userId;
  final String? cityName;
  final String? depoName;
  final String? id;
  String role;
   SafetySummary(
      {super.key, this.userId, this.cityName, required this.depoName, this.id,required this.role});

  @override
  State<SafetySummary> createState() => _SafetySummaryState();
}

class _SafetySummaryState extends State<SafetySummary> {
  //Daily Project Row List for view summary
  List<List<dynamic>> rowList = [];
  bool enableLoading = false;

  Future<List<List<dynamic>>> fetchData() async {
    rowList.clear();
    await getRowsForFutureBuilder();
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBar(
            isProjectManager: widget.role == 'projectManager' ? true : false,
            makeAnEntryPage: SafetyChecklistUser(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
        ),
            role: widget.role,
            depoName: widget.depoName,
            toSafety: true,
            showDepoBar: true,
            cityName: widget.cityName,
            text: 'Safety Summary',
            userId: widget.userId,
          ),
          preferredSize: const Size.fromHeight(50)),
      body: enableLoading
          ? LoadingPage()
          : FutureBuilder<List<List<dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching data'),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;

                  if (data.isEmpty) {
                    return const NodataAvailable();
                  }

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              showBottomBorder: true,
                              sortAscending: true,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[600]!,
                                  width: 1.0,
                                ),
                              ),
                              columnSpacing: 150.0,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => white
                                  // Colors.blue[800]!
                                  ),
                              headingTextStyle: TextStyle(color: blue),
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'User_ID',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                )),
                                DataColumn(
                                    label: Text('Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))),
                                DataColumn(
                                    label: Text('Monthly Report Data',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))),
                                DataColumn(
                                    label: Text('PDF Download',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))),
                              ],
                              dividerThickness: 3.0,
                              rows: data.map(
                                (rowData) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(rowData[0])),
                                      DataCell(Text(rowData[2])),
                                      DataCell(ElevatedButton(
                                        onPressed: () {
                                          _generatePDF(
                                              rowData[0], rowData[2], 1);
                                        },
                                        child: const Text('View Report'),
                                      )),
                                      DataCell(ElevatedButton(
                                        onPressed: () {
                                          _generatePDF(
                                              rowData[0], rowData[2], 2);
                                        },
                                        child: const Text('Download'),
                                      )),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
    );
  }

  Future<void> getRowsForFutureBuilder() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('SafetyChecklistTable2')
        .doc('${widget.depoName}')
        .collection('userId')
        .get();

    List<dynamic> userIdList = querySnapshot.docs.map((e) => e.id).toList();
    print(userIdList.length);

    for (int i = 0; i < userIdList.length; i++) {
      QuerySnapshot userEntryDate = await FirebaseFirestore.instance
          .collection('SafetyChecklistTable2')
          .doc('${widget.depoName}')
          .collection('userId')
          .doc(userIdList[i])
          .collection('date')
          .get();

      List<dynamic> withDateData = userEntryDate.docs.map((e) => e.id).toList();

      for (int j = 0; j < withDateData.length; j++) {
        rowList.add([userIdList[i], 'PDF', withDateData[j]]);
      }
    }
  }

  Future<void> _generatePDF(String user_id, String date, int decision) async {
    bool isImageEmpty = false;
    setState(() {
      enableLoading = true;
    });
    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 = await rootBundle.load('fonts/IBMPlexSans-Medium.ttf');
    final fontData2 = await rootBundle.load('fonts/IBMPlexSans-Bold.ttf');

    const cellStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 14,
    );

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    final white_background = pw.MemoryImage(
      (await rootBundle.load('assets/white_background2.jpeg'))
          .buffer
          .asUint8List(),
    );

    //Getting safety Field Data from firestore

    DocumentSnapshot safetyFieldDocSanpshot = await FirebaseFirestore.instance
        .collection('SafetyFieldData2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(user_id)
        .collection('date')
        .doc(date)
        .get();

    Map<String, dynamic> safetyMapData =
        safetyFieldDocSanpshot.data() as Map<String, dynamic>;

    bool isDate1Empty = false;
    bool isDate2Empty = false;
    bool isDate3Empty = false;
    if (safetyMapData['InstallationDate'].toString().trim().isEmpty) {
      isDate1Empty = true;
    }
    if (safetyMapData['EnegizationDate'].toString().trim().isEmpty) {
      isDate2Empty = true;
    }
    if (safetyMapData['BoardingDate'].toString().trim().isEmpty) {
      isDate3Empty = true;
    }

    dynamic installationDateToDateTime =
        isDate1Empty ? "" : safetyMapData['InstallationDate'].toDate();
    String date1 = isDate1Empty
        ? ""
        : "${installationDateToDateTime.day}-${installationDateToDateTime.month}-${installationDateToDateTime.year}";

    dynamic EnegizationDateToDateTime =
        isDate2Empty ? "" : safetyMapData['EnegizationDate'].toDate();

    String date2 = isDate2Empty
        ? ""
        : "${EnegizationDateToDateTime.day}-${EnegizationDateToDateTime.month}-${EnegizationDateToDateTime.year}";

    dynamic BoardingDateToDateTime =
        isDate3Empty ? "" : safetyMapData['BoardingDate'].toDate();

    String date3 = isDate3Empty
        ? ""
        : "${BoardingDateToDateTime.day}-${BoardingDateToDateTime.month}-${BoardingDateToDateTime.year}";

    List<List<dynamic>> fieldData = [
      ['Installation Date', '$date1'],
      ['Enegization Date', '$date2'],
      ['On Boarding Date', '$date3'],
      ['TPNo : ', '${safetyMapData['TPNo']}'],
      ['Rev :', '${safetyMapData['Rev']}'],
      ['Bus Depot Location :', '${safetyMapData['DepotLocation']}'],
      ['Address :', '${safetyMapData['Address']}'],
      ['Contact no / Mail Id :', '${safetyMapData['ContactNo']}'],
      ['Latitude & Longitude :', '${safetyMapData['Latitude']}'],
      ['State :', '${safetyMapData['State']}'],
      ['Charger Type : ', '${safetyMapData['ChargerType']}'],
      ['Conducted By :', '${safetyMapData['ConductedBy']}']
    ];

    List<pw.TableRow> rows = [];

    rows.add(pw.TableRow(children: [
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Sr No',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding:
              const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: pw.Center(
              child: pw.Text('Details',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Status',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Remark',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Image5',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Image6',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Image7',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Image8',
          ))),
    ]));

    List<dynamic> userData = [];

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('SafetyChecklistTable2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(user_id)
        .collection('date')
        .doc(date)
        .get();

    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;
    if (docData.isNotEmpty) {
      userData.addAll(docData['data']);
      List<pw.Widget> imageUrls = [];

      for (Map<String, dynamic> mapData in userData) {
        String images_Path =
            'SafetyChecklist/${widget.cityName}/${widget.depoName}/$user_id/$date/${mapData['srNo']}';

        ListResult result =
            await FirebaseStorage.instance.ref().child(images_Path).listAll();

        if (result.items.isNotEmpty) {
          for (var image in result.items) {
            String downloadUrl = await image.getDownloadURL();
            if (image.name.endsWith('.pdf')) {
              imageUrls.add(
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 100,
                  child: pw.UrlLink(
                      child: pw.Text(image.name,
                          style: const pw.TextStyle(color: PdfColors.blue)),
                      destination: downloadUrl),
                ),
              );
            } else {
              final myImage = await networkImage(downloadUrl);
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Center(
                      child: pw.Image(myImage),
                    )),
              );
            }
          }

          if (imageUrls.length > 4) {
            int imageLoop = 12 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Text('')),
              );
            }
          } else if (imageUrls.length < 4) {
            int imageLoop = 4 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Text('')),
              );
            }
          }
        } else {
          isImageEmpty = true;
        }
        
        result.items.clear();

        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData['srNo'].toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(mapData['Details'],
                      style: const pw.TextStyle(
                        fontSize: 13,
                      )))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Status'],
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Remark'].toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          isImageEmpty ? pw.Container() : pw.Center(child: imageUrls[0]),
          isImageEmpty ? pw.Container() : pw.Center(child: imageUrls[1]),
          isImageEmpty ? pw.Container() : pw.Center(child: imageUrls[2]),
          isImageEmpty ? pw.Container() : pw.Center(child: imageUrls[3]),
        ]));

        if (imageUrls.length > 4) {
          //Image Rows of PDF Table
          rows.add(pw.TableRow(children: [
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: pw.Text('')),
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 60,
                height: 100,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      imageUrls[4],
                      imageUrls[5],
                    ])),
            imageUrls[6],
            imageUrls[7],
            imageUrls[8],
            imageUrls[9],
            imageUrls[10],
            imageUrls[11],
          ]));
        }

        imageUrls.clear();
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Safety Report',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('UserID - $user_id',
                  textScaleFactor: 1.5,
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Place : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: '${widget.cityName} / ${widget.depoName}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Date : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: '$date',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'UserID : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 15)),
                    pw.TextSpan(
                        text: '$user_id',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FixedColumnWidth(100),
            },
            headers: ['Details', 'Values'],
            headerStyle: headerStyle,
            headerPadding: const pw.EdgeInsets.all(10.0),
            data: fieldData,
            cellHeight: 35,
            cellStyle: cellStyle,
          )
        ],
      ),
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Safety Report',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('User ID - $user_id',
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Place:  ${widget.cityName}/${widget.depoName}',
                    textScaleFactor: 1.1,
                  ),
                  pw.Text(
                    'Date:  $date ',
                    textScaleFactor: 1.1,
                  )
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(160),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(70),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(70),
                6: const pw.FixedColumnWidth(70),
                7: const pw.FixedColumnWidth(70),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    final List<int> pdfData = await pdf.save();
    const String pdfPath = 'SafetyReport.pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      if (decision == 1) {
        final blob = html.Blob([pdfData], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final encodedUrl = Uri.encodeFull(url);
        html.window.open(encodedUrl, '_blank');
      } else if (decision == 2) {
        html.AnchorElement(
            href:
                "data:application/octet-stream;base64,${base64Encode(pdfData)}")
          ..setAttribute("download", pdfPath)
          ..click();
      }
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
    setState(() {
      enableLoading = false;
    });
    // // For mobile platforms
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // final String path = '$dir/$pdfPath';
    // final File file = File(path);
    // await file.writeAsBytes(pdfData);
    //
    // // Open the PDF file for preview or download
    // OpenFile.open(file.path);
  }
}