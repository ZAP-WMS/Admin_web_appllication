import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_appllication/MenuPage/KeyEvents/datasource/employee_datasouce.dart';
import 'package:web_appllication/MenuPage/KeyEvents/model/employee.dart';
import 'package:web_appllication/style.dart';

void main() {
  runApp(StatutoryAprovalA2());
}

/// The application that contains datagrid on it.
typedef AppyCallback = void Function();

/// The home page of the application which hosts the datagrid.
class StatutoryAprovalA2 extends StatefulWidget {
  /// Creates the home page.
  String? depoName;
  final AppyCallback? appyCallback;
  StatutoryAprovalA2({Key? key, this.depoName, this.appyCallback})
      : super(key: key);

  @override
  _StatutoryAprovalA2State createState() => _StatutoryAprovalA2State();
}

class _StatutoryAprovalA2State extends State<StatutoryAprovalA2> {
  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];
  late DataGridController _dataGridController;

  List<EmployeeDataSource> blockresult2 = [];

  @override
  void initState() {
    super.initState();
    _employees = getEmployeeData();
    _employeeDataSource = EmployeeDataSource(_employees);
    _dataGridController = DataGridController();
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('A1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Key Events / ' + widget.depoName! + ' /A2'),
        backgroundColor: blue,
      ),
      body: Column(
        children: [
          Flexible(
            child: SfDataGrid(
              source: _employeeDataSource,
              allowEditing: true,
              frozenColumnsCount: 2,
              gridLinesVisibility: GridLinesVisibility.both,
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.cell,
              columnWidthMode: ColumnWidthMode.auto,
              controller: _dataGridController,
              // onQueryRowHeight: (details) {
              //   return details.rowIndex == 0 ? 60.0 : 49.0;
              // },
              columns: [
                GridColumn(
                  columnName: 'srNo',
                  autoFitPadding: EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: false,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  columnName: 'OriginalDuration',
                  allowEditing: true,
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'End Date',
                      overflow: TextOverflow.values.first,
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'ActualStart',
                  allowEditing: true,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Actual Start',
                      overflow: TextOverflow.values.first,
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'ActualEnd',
                  allowEditing: true,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('A1')
                      .add({'SrNo': _employeeDataSource.dataGridRows});

                  print(_employeeDataSource.dataGridRows[0].getCells());
                },
                child: const Text('Upload Data')),
          )
        ],
      ),
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(
          srNo: 1,
          activity: 'Initial Survey Of Depot With TML & STA Team.',
          originalDuration: 1,
          startDate: DateFormat().add_yMd().format(DateTime.now()),
          endDate: DateFormat().add_yMd().format(DateTime.now()),
          actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
          actualendDate: DateFormat().add_yMd().format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.5),
      Employee(
          srNo: 2,
          activity: 'Details Survey Of Depot With TPC Civil & Electrical Team',
          originalDuration: 1,
          startDate: DateFormat().add_yMd().format(DateTime.now()),
          endDate: DateFormat().add_yMd().format(DateTime.now()),
          actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
          actualendDate: DateFormat().add_yMd().format(DateTime.now()),
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
          startDate: DateFormat().add_yMd().format(DateTime.now()),
          endDate: DateFormat().add_yMd().format(DateTime.now()),
          actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
          actualendDate: DateFormat().add_yMd().format(DateTime.now()),
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
          startDate: DateFormat().add_yMd().format(DateTime.now()),
          endDate: DateFormat().add_yMd().format(DateTime.now()),
          actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
          actualendDate: DateFormat().add_yMd().format(DateTime.now()),
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
          startDate: DateFormat().add_yMd().format(DateTime.now()),
          endDate: DateFormat().add_yMd().format(DateTime.now()),
          actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
          actualendDate: DateFormat().add_yMd().format(DateTime.now()),
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
}
