import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/model/admin_model/daily_projectModel.dart';
import 'package:web_appllication/screen_admin/overview_page/summary.dart';
import 'package:web_appllication/screen_user/overview_pages/daily_project.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';
import 'package:web_appllication/widgets/widgets_admin/custom_appbar.dart';
import 'package:web_appllication/widgets/widgets_admin/nodata_available.dart';
import '../../datasource_admin/dailyproject_datasource.dart';
import '../../components/loading_page.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

List<dynamic> availableUserId = [];
List<int> globalIndexList = [];

class DailyProjectAdmin extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String role;
  DailyProjectAdmin(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      required this.role});

  @override
  State<DailyProjectAdmin> createState() => _DailyProjectAdminState();
}

class _DailyProjectAdminState extends State<DailyProjectAdmin> {
  List<dynamic> dataForPdf = [];
  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  DateTime? rangestartDate;
  Map<String, dynamic> useridWithData = {};
  DateTime? rangeEndDate;
  List<DailyProjectModelAdmin> DailyProject = <DailyProjectModelAdmin>[];
  late DailyDataSource _dailyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  bool _isLoading = true;
  bool specificUser = true;
  QuerySnapshot? snap;
  dynamic companyId;
  dynamic alldata;
  List id = [];
  List<dynamic> chosenDateList = [];
  List<Map<String, dynamic>> mapDataList = [];

  @override
  void initState() {
    getUserId();
    identifyUser();
    // getmonthlyReport();
    // DailyProject = getmonthlyReport();
    _dailyDataSource = DailyDataSource(
        DailyProject, context, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();
    super.initState();
    getAllData();
  }

  getAllData() {
    DailyProject.clear();
    id.clear();
    nestedTableData().whenComplete(() {
      _dailyDataSource = DailyDataSource(
          DailyProject, context, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      _isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBar(
            isProjectManager: widget.role == 'projectManager' ? true : false,
            makeAnEntryPage: DailyProjectUser(
              role: widget.role,
              userId: widget.userId,
              depoName: widget.depoName,
              cityName: widget.cityName,
            ),
            role: widget.role,
            showDepoBar: true,
            donwloadFun: _generatePDF,
            toDaily: true,
            depoName: widget.depoName,
            cityName: widget.cityName,
            text: 'Daily Report',
            userId: widget.userId,
            haveSynced: false,
            //specificUser ? true : false,
            isdownload: true,
            haveSummary: false,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSummaryAdmin(
                    role: widget.role,
                    cityName: widget.cityName.toString(),
                    depoName: widget.depoName.toString(),
                    id: 'Daily Report',
                    userId: widget.userId,
                  ),
                )),
          ),
          preferredSize: const Size.fromHeight(50)),
      body: _isLoading
          ? LoadingPage()
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: blue)),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('choose Date'),
                                            content: SizedBox(
                                              width: 400,
                                              height: 500,
                                              child: SfDateRangePicker(
                                                view: DateRangePickerView.year,
                                                showTodayButton: false,
                                                showActionButtons: true,
                                                selectionMode:
                                                    DateRangePickerSelectionMode
                                                        .range,
                                                onSelectionChanged:
                                                    (DateRangePickerSelectionChangedArgs
                                                        args) {
                                                  if (args.value
                                                      is PickerDateRange) {
                                                    rangestartDate =
                                                        args.value.startDate;
                                                    rangeEndDate =
                                                        args.value.endDate;
                                                  }
                                                },
                                                onSubmit: (value) {
                                                  setState(() {
                                                    startdate = DateTime.parse(
                                                        rangestartDate
                                                            .toString());
                                                    enddate = DateTime.parse(
                                                        rangeEndDate
                                                            .toString());
                                                  });

                                                  getAllData();
                                                  Navigator.pop(context);
                                                },
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.today)),
                                  Text(
                                    DateFormat.yMMMMd().format(startdate!),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        border: Border.all(
                          color: blue,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.yMMMMd().format(
                              enddate!,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingPage();
                    } else if (!snapshot.hasData ||
                        snapshot.data.exists == false) {
                      return SfDataGridTheme(
                        data: SfDataGridThemeData(
                            gridLineStrokeWidth: 2,
                            gridLineColor: blue,
                            frozenPaneLineColor: blue,
                            frozenPaneLineWidth: 4),
                        child: SfDataGrid(
                            source: _dailyDataSource,
                            allowEditing: false,
                            frozenColumnsCount: 2,
                            // rowHeight: 50,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            editingGestureType: EditingGestureType.tap,
                            controller: _dataGridController,
                            columns: [
                              GridColumn(
                                columnName: 'Date',
                                visible: true,
                                allowEditing: true,
                                width: MediaQuery.of(context).size.width *
                                    0.09, //150
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Date',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: columnStyle
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SiNo',
                                visible: false,
                                allowEditing: true,
                                width: 70,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('SI No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: columnStyle
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'TypeOfActivity',
                                allowEditing: true,
                                width: MediaQuery.of(context).size.width *
                                    0.14, //200
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Type of Activity',
                                      overflow: TextOverflow.values.first,
                                      style: columnStyle
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ActivityDetails',
                                allowEditing: true,
                                width: MediaQuery.of(context).size.width *
                                    0.15, //220
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Activity Details',
                                      overflow: TextOverflow.values.first,
                                      style: columnStyle
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Progress',
                                allowEditing: true,
                                width: MediaQuery.of(context).size.width *
                                    0.30, //340
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Progress',
                                      overflow: TextOverflow.values.first,
                                      style: columnStyle
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Status',
                                allowEditing: true,
                                width: MediaQuery.of(context).size.width *
                                    0.19, //320
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Remark / Status',
                                      overflow: TextOverflow.values.first,
                                      style: columnStyle
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'View',
                                allowEditing: false,
                                width: MediaQuery.of(context).size.width *
                                    0.14, //140
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('View Image',
                                      overflow: TextOverflow.values.first,
                                      style: columnStyle
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]),
                      );
                    } else {
                      // alldata = '';
                      // alldata = snapshot.data['data'] as List<dynamic>;
                      // DailyProject.clear();
                      // alldata.forEach((element) {
                      //   DailyProject.add(DailyProjectModel.fromjson(element));
                      //   _dailyDataSource = DailyDataSource(
                      //       DailyProject, context, widget.depoName!);
                      //   _dataGridController = DataGridController();
                      // });
                      return const NodataAvailable();
                    }
                  },
                ),
              )
            ]),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: (() {
      //       DailyProject.add(DailyProjectModel(
      //           siNo: 1,
      //           // date: DateFormat().add_yMd().format(DateTime.now()),
      //           // state: "Maharashtra",
      //           // depotName: 'depotName',
      //           typeOfActivity: 'Electrical Infra',
      //           activityDetails: "Initial Survey of DEpot",
      //           progress: '',
      //           status: ''));
      //       _dailyDataSource.buildDataGridRows();
      //       _dailyDataSource.updateDatagridSource();
      //     })),
    );
  }

  // List<DailyProjectModel> getmonthlyReport() {
  //   return [
  //     DailyProjectModel(
  //         siNo: 1,
  //         // date: DateFormat().add_yMd().format(DateTime.now()),
  //         // state: "Maharashtra",
  //         // depotName: 'depotName',
  //         typeOfActivity: 'Electrical Infra',
  //         activityDetails: "Initial Survey of DEpot",
  //         progress: '',
  //         status: '')
  //   ];
  // }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      companyId = value;
    });
  }

  identifyUser() async {
    snap = await FirebaseFirestore.instance.collection('Admin').get();

    for (int i = 0; i < snap!.docs.length; i++) {
      if (snap!.docs[i]['Employee Id'] == companyId &&
          snap!.docs[i]['CompanyName'] == 'TATA MOTOR') {
        setState(() {
          specificUser = false;
        });
      }
    }
  }

  Future<void> nestedTableData() async {
    globalIndexList.clear();
    availableUserId.clear();
    chosenDateList.clear();
    setState(() {
      _isLoading = true;
    });

    useridWithData.clear();
    for (DateTime initialdate = startdate!;
        initialdate.isBefore(enddate!.add(const Duration(days: 1)));
        initialdate = initialdate.add(const Duration(days: 1))) {
      useridWithData.clear();

      String nextDate = DateFormat.yMMMMd().format(initialdate);

      QuerySnapshot userIdQuery = await FirebaseFirestore.instance
          .collection('DailyProject3')
          .doc(widget.depoName!)
          .collection(nextDate)
          .get();

      List<dynamic> userList = userIdQuery.docs.map((e) => e.id).toList();

      for (int i = 0; i < userList.length; i++) {
        await FirebaseFirestore.instance
            .collection('DailyProject3')
            .doc(widget.depoName!)
            .collection(nextDate)
            .doc(userList[i])
            .get()
            .then((value) {
          if (value.exists) {
            List<dynamic> userData = value.data()!['data'];
            useridWithData[userList[i]] = userData;
            for (int j = 0; j < userData.length; j++) {
              DailyProject.add(DailyProjectModelAdmin.fromjson(userData[j]));
              globalIndexList.add(j + 1);
              availableUserId.add(userList[i]);
              chosenDateList.add(nextDate);
            }
          }
          return value;
        });
      }

      print('global indexes are - $globalIndexList');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _generatePDF() async {
    setState(() {
      _isLoading = true;
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
              child: pw.Text('Date',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Type of Activity',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Activity Details',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Progress',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Remark / Status',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image1',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image2',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
    ]));

    if (DailyProject.isNotEmpty) {
      List<pw.Widget> imageUrls = [];
      // for (int i = 0; i < chosenDateList.length; i++){
      // for (int j = 0; j < availableUserId.length; j++){
      // final currentUserId = availableUserId[j];
      for (int i = 0; i < DailyProject.length; i++) {
        String imagesPath =
            '/Daily Report/${widget.cityName}/${widget.depoName}/${availableUserId[i]}/${chosenDateList[i]}/${globalIndexList[i]}';
        // print(
        //     '/Daily Report/${widget.cityName}/${widget.depoName}/${availableUserId[i]}/${chosenDateList[i]}/${DailyProject[i].siNo}');
        // print(imagesPath);
        ListResult result =
            await FirebaseStorage.instance.ref().child(imagesPath).listAll();

        if (result.items.isNotEmpty) {
          for (var image in result.items) {
            String downloadUrl = await image.getDownloadURL();
            if (image.name.endsWith('.pdf')) {
              imageUrls.add(
                pw.Container(
                    width: 60,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: pw.UrlLink(
                        child: pw.Text(image.name,
                            style: const pw.TextStyle(color: PdfColors.blue)),
                        destination: downloadUrl)),
              );
            } else {
              final myImage = await networkImage(downloadUrl);
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 80,
                    child: pw.Center(
                      child: pw.Image(myImage),
                    )),
              );
            }
          }

          if (imageUrls.length < 2) {
            int imageLoop = 2 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 80,
                  child: pw.Text(''),
                ),
              );
            }
          }

          // else if (imageUrls.length > 2) {
          //   int imageLoop = 10 - imageUrls.length;
          //   for (int i = 0; i < imageLoop; i++) {
          //     imageUrls.add(
          //       pw.Container(
          //           padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
          //           width: 80,
          //           height: 100,
          //           child: pw.Text('')),
          //     );
          //   }
          // }
        } else {
          for (int i = 0; i < 2; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 80,
                  child: pw.Text('')),
            );
          }
        }

        result.items.clear();

        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text('${i + 1}',
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(DailyProject[i].date.toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(DailyProject[i].typeOfActivity.toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(DailyProject[i].activityDetails.toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(DailyProject[i].progress.toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(DailyProject[i].status.toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          imageUrls[0],
          imageUrls[1]
        ]));

        if (imageUrls.length - 2 > 0) {
          int n = 2;
          int nextLineLength = imageUrls.length - 2;
          if (nextLineLength % 8 != 0) {
            int remainder = nextLineLength % 8;
            int imageLoop = 8 - remainder;
            print('imageLoop - $imageLoop - $nextLineLength ');
            for (int m = 0; m < imageLoop; m++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 80,
                    child: pw.Text('')),
              );
            }
          }
          //Image Rows of PDF Table

          while (nextLineLength != 0) {
            print('n value - $n');
            rows.add(
              pw.TableRow(
                children: [
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
                            imageUrls[n],
                            imageUrls[n + 1],
                          ])),
                  imageUrls[n + 2],
                  imageUrls[n + 3],
                  imageUrls[n + 4],
                  imageUrls[n + 5],
                  imageUrls[n + 6],
                  imageUrls[n + 7]
                ],
              ),
            );

            n = 10;
            print('n -- $n');

            nextLineLength = nextLineLength >= 8
                ? nextLineLength - 8
                : nextLineLength - nextLineLength;
            print('nextLen - $nextLineLength');
          }
        }

        imageUrls.clear();
        // }
      }
      // }

      // }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1600, 1000,
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
                      pw.Text('Daily Report Table',
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
        // footer: (pw.Context context) {
        //   return pw.Container(
        //       alignment: pw.Alignment.centerRight,
        //       margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        //       child: pw.Text('User ID - $user_id',
        //           // 'Page ${context.pageNumber} of ${context.pagesCount}',
        //           style: pw.Theme.of(context)
        //               .defaultTextStyle
        //               .copyWith(color: PdfColors.black)));
        // },
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
                        text:
                            '${startdate?.day}-${startdate?.month}-${startdate?.year} to ${enddate?.day}-${enddate?.month}-${enddate?.year}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  // pw.RichText(
                  //     text: pw.TextSpan(children: [
                  //   pw.TextSpan(
                  //       text: 'UserID : ${widget.userId}',
                  //       style: const pw.TextStyle(
                  //           color: PdfColors.blue700, fontSize: 15)
                  //           ),
                  // ])),
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
    const String pdfPath = 'Daily Report.pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      html.AnchorElement(
          href: "data:application/octet-stream;base64,${base64Encode(pdfData)}")
        ..setAttribute("download", pdfPath)
        ..click();
    }

    setState(() {
      _isLoading = false;
    });
  }
}