import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_appllication/MenuPage/KeyEvents/datasource/employee_datasouce.dart';
import 'package:web_appllication/MenuPage/KeyEvents/model/employee.dart';
import 'package:web_appllication/style.dart';

import '../../components/loading_page.dart';

void main() {
  runApp(StatutoryAprovalA2());
}

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class StatutoryAprovalA2 extends StatefulWidget {
  /// Creates the home page.
  String? depoName;
  String? cityName;

  StatutoryAprovalA2({Key? key, this.depoName, this.cityName})
      : super(key: key);

  @override
  _StatutoryAprovalA2State createState() => _StatutoryAprovalA2State();
}

class _StatutoryAprovalA2State extends State<StatutoryAprovalA2> {
  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      getFirestoreData().whenComplete(() {
        setState(() {
          if (_employees.length == 0 || _employees.isEmpty) {
            _employees = getEmployeeData();
          }
          _isLoading = false;
          _employeeDataSource = EmployeeDataSource(_employees, context);
          _dataGridController = DataGridController();
        });
        // _employeeDataSource = EmployeeDataSource(_employees);
        // _dataGridController = DataGridController();
      });
      //getFirestoreData() as List<Employee>;
      // getEmployeeData();

    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('5', 35, Colors.teal),
      ChartData('4', 23, Colors.orange),
      ChartData('3', 34, Colors.brown),
      ChartData('2', 25, Colors.deepOrange),
      ChartData('1', 50, Colors.blue),
      // ChartData('A6', 35, Colors.teal),
      // ChartData('A7', 23, Colors.orange),
      // ChartData('A8', 34, Colors.brown),
      // ChartData('A9', 25, Colors.deepOrange),
      // ChartData('A10', 50, Colors.blue),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Key Events / ' + widget.depoName! + ' /A2'),
        backgroundColor: blue,
      ),
      body: _isLoading
          ? LoadingPage()
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SfDataGrid(
                        source: _employeeDataSource,
                        allowEditing: true,
                        frozenColumnsCount: 2,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
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
                            autoFitPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            allowEditing: false,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Sr No',
                                overflow: TextOverflow.values.first,
                                //    textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Activity',
                            width: 300,
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Activity',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'button',
                            width: 130,
                            allowEditing: false,
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('View File '),
                            ),
                          ),
                          GridColumn(
                            columnName: 'OriginalDuration',
                            allowEditing: true,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Original Duration',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'StartDate',
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Start Date',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'EndDate',
                            allowEditing: true,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'End Date',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'ActualStart',
                            allowEditing: false,
                            width: 180,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Actual Start',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'ActualEnd',
                            allowEditing: false,
                            width: 180,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Actual End',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'ActualDuration',
                            allowEditing: true,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Actual Duration',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Delay',
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Delay',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Unit',
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Unit',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'QtyScope',
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Oty as per scope',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'QtyExecuted',
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Qty executed',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'BalancedQty',
                            allowEditing: true,
                            label: Container(
                              width: 150,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Balanced Qty',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Progress',
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                '% of Progress',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Weightage',
                            allowEditing: true,
                            label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Weightage',
                                overflow: TextOverflow.values.first,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 25),
                        width: 400,
                        child: SfCartesianChart(
                            title:
                                ChartTitle(text: 'All Events Wightage Graph'),
                            primaryXAxis: CategoryAxis(
                                // title: AxisTitle(text: 'Key Events')
                                ),
                            primaryYAxis: NumericAxis(
                                // title: AxisTitle(text: 'Weightage')
                                ),
                            series: <ChartSeries>[
                              // Renders column chart
                              BarSeries<ChartData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  pointColorMapper: (ChartData data, _) =>
                                      data.y1)
                            ]))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: blue),
                      onPressed: () async {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => const CupertinoAlertDialog(
                            content: SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                        StoreData();
                      },
                      child: const Text(
                        'Sync Data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            _employees.add(
              Employee(
                srNo: 1,
                activity: 'Initial Survey Of Depot With TML & STA Team.',
                originalDuration: 1,
                startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                actualstartDate:
                    DateFormat('dd-MM-yyyy').format(DateTime.now()),
                actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                actualDuration: 0,
                delay: 0,
                unit: 0,
                scope: 0,
                qtyExecuted: 0,
                balanceQty: 0,
                percProgress: 0,
                weightage: 0.5,
              ),
            );
            _employeeDataSource.buildDataGridRows();
            _employeeDataSource.updateDatagridSource();
          })),
    );
  }

  Future<void> getFirestoreData() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    CollectionReference tabledata = instance.collection('${widget.depoName}A2');

    DocumentSnapshot snapshot = await tabledata.doc(widget.depoName).get();
    var data = snapshot.data() as Map;
    var alldata = data['data'] as List<dynamic>;

    _employees = [];
    alldata.forEach((element) {
      _employees.add(Employee.fromJson(element));
    });
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(
        srNo: 1,
        activity: 'Initial Survey Of Depot With TML & STA Team.',
        originalDuration: 1,
        startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: 0,
        delay: 0,
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: 0,
        weightage: 0.5,
      ),
      Employee(
          srNo: 2,
          activity: 'Details Survey Of Depot With TPC Civil & Electrical Team',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.5),
      Employee(
          srNo: 3,
          activity:
              'Survey Report Submission With Existing & Proposed Layout Drawings.',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.5),
      Employee(
          srNo: 4,
          activity: 'Job Scope Finalization & Preparation Of BOQ',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.5),
      Employee(
          srNo: 5,
          activity: 'Power Connection / Load Applied By STA To Discom.',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.5)
    ];
  }

  void StoreData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        table_data[data.columnName] = data.value;
      }
      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection(widget.depoName.toString() + 'A2')
        .doc(widget.depoName)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final Color y1;
}
