import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/datasource_user/materialprocurement_datasource.dart';
import 'package:web_appllication/model/user_model/material_vendor.dart';
import 'package:web_appllication/widgets/widgets_user/custom_appbar.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';

import '../../widgets/custom_show_progress.dart';

class MaterialProcurementUser extends StatefulWidget {
  String? cityName;
  String? depoName;
  String role;
  String? userId;
  MaterialProcurementUser(
      {super.key,
      required this.cityName,
      required this.role,
      required this.depoName,
      this.userId});

  @override
  State<MaterialProcurementUser> createState() =>
      _MaterialProcurementUserState();
}

class _MaterialProcurementUserState extends State<MaterialProcurementUser> {
  final AuthService authService = AuthService();
  List<String> assignedDepots = [];
  bool isFieldEditable = false;
  final List<MaterialProcurementModelUser> _materialprocurement =
      <MaterialProcurementModelUser>[];
  late MaterialDatasource _materialDatasource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  bool _isloading = true;
  dynamic alldata;

  @override
  void initState() {
    getAssignedDepots().whenComplete(() {
      // _materialprocurement = getmonthlyReport();
      _materialDatasource = MaterialDatasource(_materialprocurement, context,
          widget.cityName, widget.depoName, removeRow);
      _dataGridController = DataGridController();
      _stream = FirebaseFirestore.instance
          .collection('MaterialProcurement')
          .doc('${widget.depoName}')
          .collection('Material Data')
          .doc(widget.userId)
          .snapshots();
      _isloading = false;
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: CustomAppBar(
              role: widget.role,
              showDepoBar: true,
              toMaterial: true,
              cityname: widget.cityName,
              text: 'Material Procurement',
              haveSummary: false,
              depotName: widget.depoName,
              haveSynced: isFieldEditable,
              store: () {
                showProgressDilogue(context);
                storeData();
              },
            ),
            preferredSize: const Size.fromHeight(50)),
        body: _isloading
            ? LoadingPage()
            : Column(children: [
                Expanded(
                    child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: white,
                    gridLineColor: blue,
                  ),
                  child: StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.exists == false) {
                        return SfDataGrid(
                            source: _materialDatasource,
                            allowEditing: isFieldEditable,
                            frozenColumnsCount: 2,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            editingGestureType: EditingGestureType.tap,
                            rowHeight: 50,
                            isScrollbarAlwaysShown: true,
                            controller: _dataGridController,
                            columns: [
                              GridColumn(
                                columnName: 'cityName',
                                allowEditing: true,
                                width: 100,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('City Name',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'details',
                                width: 250,
                                allowEditing: true,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Details item description',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'olaNo',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('OLA No',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'vendorName',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Vendor Name',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'oemApproval',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('OEM drawing approval by eng',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'oemClearance',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      'Manufacturing clearance\ngiven to OEM',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'croPlacement',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      'Delivery time line after\n placement of CRO',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'croVendor',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('CRO release to vendor',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'croNumber',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('CRO number ',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'unit',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Unit',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'qty',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Qty',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'materialSite',
                                allowEditing: false,
                                width: 200,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Receipt of material at site',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Add row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Delete row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      } else {
                        alldata = '';
                        alldata = snapshot.data['data'] as List<dynamic>;
                        _materialprocurement.clear();
                        _materialDatasource.buildDataGridRows();
                        _materialDatasource.updateDatagridSource();
                        alldata.forEach((element) {
                          _materialprocurement.add(
                              MaterialProcurementModelUser.fromjsaon(element));
                          _materialDatasource = MaterialDatasource(
                              _materialprocurement,
                              context,
                              widget.cityName,
                              widget.depoName,
                              removeRow);
                          _dataGridController = DataGridController();
                        });
                        return SfDataGrid(
                            source: _materialDatasource,
                            allowEditing: isFieldEditable,
                            frozenColumnsCount: 2,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            editingGestureType: EditingGestureType.tap,
                            rowHeight: 50,
                            controller: _dataGridController,
                            columns: [
                              GridColumn(
                                columnName: 'cityName',
                                allowEditing: true,
                                width: 100,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('City name',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'details',
                                width: 250,
                                allowEditing: true,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Details item description',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'olaNo',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('OLA no',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'vendorName',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Vendor name',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'oemApproval',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('OEM drawing approval by eng',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'oemClearance',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      'Manufacturing clearance\ngiven to OEM',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'croPlacement',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      'Delivery time line after\nplacement of CRO',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'croVendor',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 250,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      'CRO release to vendor',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'croNumber',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      'CRO number ',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'unit',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Unit',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'qty',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Qty',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'materialSite',
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Receipt of\nmaterial at site',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                allowEditing: false,
                                width: 90,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Add Row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Delete Row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      }
                    },
                  ),
                )),
              ]),
        floatingActionButton: isFieldEditable
            ? FloatingActionButton(
                onPressed: (() {
                  _materialprocurement.add(
                    MaterialProcurementModelUser(
                      cityName: '',
                      details: '',
                      olaNo: '',
                      vendorName: '',
                      oemApproval: '',
                      oemClearance: '',
                      croPlacement: '',
                      croVendor: '',
                      croNumber: '',
                      unit: '',
                      qty: 1,
                      materialSite: DateFormat('MM-dd-yyyy').format(
                        DateTime.now(),
                      ),
                    ),
                  );
                  _materialDatasource.buildDataGridRows();
                  _materialDatasource.updateDatagridSource();
                }),
                child: const Icon(Icons.add),
              )
            : Container());
  }

  void storeData() {
    Map<String, dynamic> tableData = Map();
    for (var i in _materialDatasource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          tableData[data.columnName] = data.value;
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('MaterialProcurement')
        .doc('${widget.depoName}')
        .collection('Material Data')
        .doc(widget.userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Data are synced',
          ),
          backgroundColor: blue,
        ),
      );
    });
  }

  void _showDialog(BuildContext context) {
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
  }

  List<MaterialProcurementModelUser> getmonthlyReport() {
    return [
      MaterialProcurementModelUser(
          cityName: '',
          details: '',
          olaNo: '',
          vendorName: '',
          oemApproval: '',
          oemClearance: '',
          croPlacement: '',
          croVendor: '',
          croNumber: '',
          unit: '',
          qty: 1,
          materialSite: DateFormat().add_yMd().format(DateTime.now()))
    ];
  }

  removeRow(dynamic selectedIndex) {
    alldata.removeAt(selectedIndex);
    print('Selected Row Removed');
  }

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    isFieldEditable =
        authService.verifyAssignedDepot(widget.depoName!, assignedDepots);
    print("isFieldEditable - $isFieldEditable");
  }
}
