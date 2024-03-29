import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_appllication/OverviewPages/quality_checklist.dart';
import '../../components/Loading_page.dart';
import '../../datasource/jmr_datasource.dart';
import '../../model/jmr.dart';
import '../../style.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/nodata_available.dart';
import 'package:intl/intl.dart';

class JMRPage extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String? title;
  String? jmrTab;
  String? tabName;
  bool showTable;
  dynamic dataFetchingIndex;

  JMRPage(
      {super.key,
      this.title,
      this.cityName,
      this.depoName,
      this.jmrTab,
      this.tabName,
      required this.showTable,
      this.dataFetchingIndex,
      this.userId});

  @override
  State<JMRPage> createState() => _JMRPageState();
}

class _JMRPageState extends State<JMRPage> {
  final TextEditingController projectName = TextEditingController();
  final loiRefNum = TextEditingController();
  final siteLocation = TextEditingController();
  final refNo = TextEditingController();
  final date = TextEditingController();
  final note = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();

  List nextJmrIndex = [];
  List<List<dynamic>> data = [];

  List<JMRModel> jmrtable = <JMRModel>[];
  late JmrDataSource _jmrDataSource;
  late List<dynamic> jmrSyncList;
  late DataGridController _dataGridController;
  bool _isLoading = true;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;

  @override
  void initState() {
    print(widget.title);
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('userId')
        .doc(widget.userId)
        .snapshots();

    if (widget.showTable == true) {
      _fetchDataFromFirestore().then((value) => {
            setState(() {
              for (dynamic item in jmrSyncList) {
                List<dynamic> tempData = [];
                if (item is List<dynamic>) {
                  for (dynamic innerItem in item) {
                    if (innerItem is Map<String, dynamic>) {
                      tempData = [
                        innerItem['srNo'],
                        innerItem['Description'],
                        innerItem['Activity'],
                        innerItem['RefNo'],
                        innerItem['Abstract'],
                        innerItem['Uom'],
                        innerItem['Rate'],
                        innerItem['TotalQty'],
                        innerItem['TotalAmount']
                      ];
                    }
                    data.add(tempData);
                  }
                }
              }

              _isLoading = false;
            })
          });
    } else {
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: _isLoading
          ? LoadingPage()
          : Scaffold(
              appBar: PreferredSize(
                // ignore: sort_child_properties_last
                child: CustomAppBar(
                  isdownload: true,
                  donwloadFun: _generatePDF,
                  depoName: widget.depoName,
                  userId: widget.userId,
                  text:
                      '${widget.cityName} / ${widget.depoName} / ${widget.title.toString()}',
                  // icon: Icons.logout,
                  haveSynced: widget.showTable ? false : true,
                  store: () {
                    nextIndex().then((value) => StoreData());
                  },
                  cityName: widget.cityName,
                ),
                preferredSize: const Size.fromHeight(50),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            HeaderValue(
                                'Project', 'TML e-bus Project', projectName),
                            HeaderValue(
                                'LOI Ref Number', 'TML-LOI-Dated', loiRefNum),
                            HeaderValue('Site Location', '', siteLocation),
                            Container(
                              width: 505,
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  const SizedBox(
                                      width: 110, child: Text('Working Dates')),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        controller: startDate,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(5.0),
                                            labelText: 'Start Date'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        controller: endDate,
                                        decoration: const InputDecoration(
                                            labelText: 'End Date',
                                            contentPadding:
                                                EdgeInsets.all(5.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              HeaderValue(
                                  'Ref No', 'Abstract of Cost/1', refNo),
                              HeaderValue('Date', '', date),
                              HeaderValue('Note', '', note),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingPage();
                        }
                        if (!snapshot.hasData) {
                          jmrtable = getData();
                          _jmrDataSource = JmrDataSource(jmrtable);
                          _dataGridController = DataGridController();
                          return SfDataGridTheme(
                            data: SfDataGridThemeData(   gridLineStrokeWidth: 2,
                      gridLineColor: blue,
                      frozenPaneLineColor: blue,
                      frozenPaneLineWidth: 4),
                            child: SfDataGrid(
                              source: _jmrDataSource,
                              //key: key,
                              allowEditing: widget.showTable ? false : true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.auto,
                              editingGestureType: EditingGestureType.tap,
                              controller: _dataGridController,
                              columns: [
                                GridColumn(
                                  columnName: 'srNo',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Sr No',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  width: 200,
                                  columnName: 'Description',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Description of items',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Activity',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: const Text('Activity Details',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'RefNo',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('BOQ RefNo',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Abstract',
                                  allowEditing: true,
                                  width: 180,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Abstract of JMR',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'UOM',
                                  allowEditing: true,
                                  width: 80,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('UOM',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Rate',
                                  allowEditing: true,
                                  width: 80,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Rate',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TotalQty',
                                  allowEditing: true,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Total Qty',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TotalAmount',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Amount',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  visible: false,
                                  columnName: 'Delete',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Delete Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasData) {
                          jmrtable = convertListToJmrModel(data);
                          _jmrDataSource = JmrDataSource(jmrtable);
                          _dataGridController = DataGridController();

                          return SfDataGridTheme(
                            data:
                                SfDataGridThemeData(   gridLineStrokeWidth: 2,
                      gridLineColor: blue,
                      frozenPaneLineColor: blue,
                      frozenPaneLineWidth: 4),
                            child: SfDataGrid(
                              source: _jmrDataSource,
                              //key: key,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.auto,
                              editingGestureType: EditingGestureType.tap,
                              controller: _dataGridController,

                              // onQueryRowHeight: (details) {
                              //   return details.rowIndex == 0 ? 60.0 : 49.0;
                              // },
                              columns: [
                                GridColumn(
                                  columnName: 'srNo',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Sr No',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  width: 200,
                                  columnName: 'Description',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Description of items',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Activity',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child:  Text('Activity Details',
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  width: 150,
                                  columnName: 'RefNo',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('BOQ RefNo',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Abstract',
                                  allowEditing: true,
                                  width: 200,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Abstract of JMR',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'UOM',
                                  allowEditing: true,
                                  width: 80,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('UOM',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Rate',
                                  allowEditing: true,
                                  width: 80,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Rate',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TotalQty',
                                  allowEditing: true,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Total Qty',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TotalAmount',
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Amount',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  visible: false,
                                  columnName: 'Delete',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Delete Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const NodataAvailable();
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Visibility(
                          visible: widget.showTable ? false : true,
                          child: FloatingActionButton(
                            hoverColor: Colors.blue[900],
                            heroTag: "btn1",
                            onPressed: () {
                              data.add([
                                data.length + 1,
                                'Supply and Laying',
                                'onboarding one no. of EV charger of 200kw',
                                '8.31 (Additional)',
                                'abstract of JMR sheet No 1 & Item Sr No 1',
                                'Mtr',
                                500.00,
                                110,
                                55000.00
                              ]);
                              setState(() {});
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Visibility(
                          visible: widget.showTable ? false : true,
                          child: FloatingActionButton.extended(
                            hoverColor: Colors.blue[900],
                            heroTag: "btn2",
                            isExtended: true,
                            onPressed: () {
                              selectExcelFile().then((value) {
                                setState(() {});
                              });
                            },
                            label: const Text('Upload Excel'),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              //   Center(
              // child: Image.asset(widget.img.toString()),
            ),
    );
  }

  Future<List<List<dynamic>>> selectExcelFile() async {
    final input = html.FileUploadInputElement()..accept = '.xlsx';
    input.click();

    await input.onChange.first;
    final files = input.files;

    if (files?.length == 1) {
      final file = files?[0];
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file!);

      await reader.onLoadEnd.first;

      final excel = Excel.decodeBytes(reader.result as List<int>);
      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        for (var rows in sheet!.rows.skip(1)) {
          List<dynamic> rowData = [];
          for (var cell in rows) {
            rowData.add(cell?.value);
          }
          data.add(rowData);
        }
      }
      data = convertSubstringsToStrings(data);
    }
    return data;
  }

  List<List<dynamic>> convertSubstringsToStrings(
      List<List<dynamic>> listOfLists) {
    List<List<dynamic>> result = [];

    for (List<dynamic> sublist in listOfLists) {
      List<dynamic> convertedSublist =
          sublist.map((item) => item.toString()).toList();
      result.add(convertedSublist);
    }
    return result;
  }

  List<JMRModel> convertListToJmrModel(List<List<dynamic>> data) {
    return data.map((list) {
      return JMRModel(
          srNo: list[0],
          Description: list[1],
          Activity: list[2],
          RefNo: list[3],
          JmrAbstract: list[4],
          Uom: list[5],
          rate: list[6],
          TotalQty: list[7],
          TotalAmount: list[8]);
    }).toList();
  }

  Future<void> StoreData() async {
    Map<String, dynamic> tableData = {};
    for (var i in _jmrDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        tableData[data.columnName] = data.value;
      }
      tabledata2.add(tableData);
      tableData = {};
    }
    //Storing data in JmrField
    storeDataInJmrField();

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .collection('date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Data are synced'),
        backgroundColor: Colors.blue,
      ));
    });

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .set({'deponame': widget.depoName});

    nextJmrIndex.clear();
  }

  Future<void> nextIndex() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .get();

    nextJmrIndex.add(querySnapshot.docs.length + 1);
  }

  Future<void> storeDataInJmrField() async {
    //Adding Field Data
    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .collection('date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .set({
      'project': projectName.text,
      'loiRefNum': loiRefNum.text,
      'siteLocation': siteLocation.text,
      'refNo': refNo.text,
      'date': date.text,
      'note': note.text,
      'startDate': startDate.text,
      'endDate': endDate.text
    });

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .set({'deponame': widget.depoName});
  }

  //Function to fetch data and show in JMR view

  Future<List<dynamic>> _fetchDataFromFirestore() async {
    data.clear();
    getFieldData();
    print('Error Occured1');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${widget.dataFetchingIndex}')
        .collection('date')
        .get();

    print('Error Occured2');
    List<dynamic> tempList = querySnapshot.docs.map((date) => date.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${widget.tabName}JmrTable')
          .collection('userId')
          .doc(widget.userId)
          .collection('jmrTabName')
          .doc(widget.jmrTab)
          .collection('jmrTabIndex')
          .doc('jmr${widget.dataFetchingIndex}')
          .collection('date')
          .doc(tempList[i])
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data1 =
            documentSnapshot.data() as Map<String, dynamic>;

        jmrSyncList = data1.entries.map((entry) => entry.value).toList();

        return jmrSyncList;
      }
    }

    return jmrSyncList;
  }

  Future<void> getFieldData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${widget.dataFetchingIndex}')
        .collection('date')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((date) => date.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${widget.tabName}JmrField')
          .collection('userId')
          .doc(widget.userId)
          .collection('jmrTabName')
          .doc(widget.jmrTab)
          .collection('jmrTabIndex')
          .doc('jmr${widget.dataFetchingIndex}')
          .collection('date')
          .doc(tempList[i])
          .get();

      Map<String, dynamic> fieldData =
          documentSnapshot.data() as Map<String, dynamic>;

      projectName.text = fieldData['project'];
      loiRefNum.text = fieldData['loiRefNum'];
      siteLocation.text = fieldData['siteLocation'];
      refNo.text = fieldData['refNo'];
      date.text = fieldData['date'];
      note.text = fieldData['note'];
      startDate.text = fieldData['startDate'];
      endDate.text = fieldData['endDate'];
    }
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

    List<List<dynamic>> fieldData = [
      ['Project :', projectName.text],
      ['Ref Number :', refNo.text],
      ['LOI Ref Number :', loiRefNum.text],
      ['Date :', date.text],
      ['Site Location :', siteLocation.text],
      ['Note :', note.text],
      ['Start Date :', startDate.text],
      ['End Date :', endDate.text],
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
              child: pw.Text('Description',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Activity Details',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('BOQ RefNo',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Abstract',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'UOM',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Rate',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Total Qty',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Amount',
          ))),
    ]));

    List<dynamic> userData = [];

    if (jmrSyncList.isNotEmpty) {
      userData = jmrSyncList[0];
      List<pw.Widget> imageUrls = [];

      for (Map<String, dynamic> mapData in userData) {
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
                  child: pw.Text(mapData['Description'],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 13,
                      )))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Activity'],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['RefNo'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Abstract'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Uom'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Rate'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['TotalQty'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['TotalAmount'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
        ]));
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
                      pw.Text('Jmr Report',
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
              child: pw.Text('UserID - $userId',
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
                  // pw.RichText(
                  //     text: pw.TextSpan(children: [
                  //   const pw.TextSpan(
                  //       text: 'Date : ',
                  //       style:
                  //           pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                  //   pw.TextSpan(
                  //       text: date.text,
                  //       style: const pw.TextStyle(
                  //           color: PdfColors.blue700, fontSize: 15))
                  // ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'UserID : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 15)),
                    pw.TextSpan(
                        text: '$userId',
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
                      pw.Text('JMR Report',
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
              child: pw.Text('User ID - $userId',
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
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(120),
                2: const pw.FixedColumnWidth(120),
                3: const pw.FixedColumnWidth(120),
                4: const pw.FixedColumnWidth(120),
                5: const pw.FixedColumnWidth(120),
                6: const pw.FixedColumnWidth(70),
                7: const pw.FixedColumnWidth(50),
                8: const pw.FixedColumnWidth(50),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    final List<int> pdfData = await pdf.save();
    const String pdfPath = 'JmrReport.pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      html.AnchorElement(
          href: "data:application/octet-stream;base64,${base64Encode(pdfData)}")
        ..setAttribute("download", pdfPath)
        ..click();
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
    setState(() {
      _isLoading = false;
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

List<JMRModel> getData() {
  return [
    JMRModel(
      Activity: 'Software',
      Description: 'Supply and Laying',
      JmrAbstract: 'Dumble Door',
      RefNo: '8.31 (Additional)',
      Uom: 'Mtr',
      srNo: 1,
      rate: 500.00,
      TotalQty: null,
      TotalAmount: null,
    ),
  ];
}

HeaderValue(String title, String hintValue, TextEditingController fieldData) {
  return Container(
    padding: const EdgeInsets.only(bottom: 4, top: 4),
    width: 400,
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
            width: 100,
            child: Text(
              title,
            )),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: fieldData,
            decoration: InputDecoration(
              hintText: title,
              contentPadding: const EdgeInsets.all(4),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
