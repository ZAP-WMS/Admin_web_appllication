import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_appllication/Authentication/admin/auth_service.dart';
import 'package:web_appllication/FirebaseApi/firebase_api_user.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/datasource_user/energymanagement_datasource.dart';
import 'package:web_appllication/model/user_model/energy_management.dart';
import 'package:web_appllication/provider/provider_user/energy_provider.dart';
import 'package:web_appllication/screen_admin/overview_page/quality_checklist.dart';
import 'package:web_appllication/widgets/custom_show_progress.dart';
import 'package:web_appllication/widgets/widgets_user/custom_appbar.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';
import '../Planning_Pages/summary.dart';

class EnergyManagementUser extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String role;
  EnergyManagementUser(
      {super.key,
      required this.role,
      required this.cityName,
      required this.depoName,
      required this.userId});

  @override
  State<EnergyManagementUser> createState() => _EnergyManagementUserState();
}

class _EnergyManagementUserState extends State<EnergyManagementUser> {
  final AuthService authService = AuthService();
  List<String> assignedCities = [];
  bool isFieldEditable = false;
  final ScrollController _scrollController = ScrollController();
  late EnergyManagementDatasource _energyManagementdatasource;
  late DataGridController _dataGridController;
  final List<EnergyManagementModelUser> _energyManagement =
      <EnergyManagementModelUser>[];
  Stream? _stream;
  bool _isloading = true;
  List<dynamic> tabledata2 = [];
  int currentMonth = DateTime.now().month;
  final double candleWidth = 10;
  EnergyProviderUser? _energyProvider;
  final List<dynamic> timeIntervalList = [];
  String monthName = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    _energyProvider = Provider.of<EnergyProviderUser>(context, listen: false);
    _energyProvider!
        .fetchGraphData(widget.cityName!, widget.depoName!, widget.userId);
    String monthName = DateFormat('MMMM').format(DateTime.now());
    _stream = FirebaseFirestore.instance
        .collection('EnergyManagementTable')
        .doc(widget.cityName)
        .collection('Depots')
        .doc(widget.depoName)
        .collection('Year')
        .doc(DateTime.now().year.toString())
        .collection('Months')
        .doc(monthName)
        .collection('Date')
        .doc(
          DateFormat.yMMMMd().format(
            DateTime.now(),
          ),
        )
        .collection('UserId')
        .doc(widget.userId)
        .snapshots();
    _energyManagementdatasource = EnergyManagementDatasource(_energyManagement,
        context, widget.userId!, widget.cityName, widget.depoName);
    _dataGridController = DataGridController();
    getAssignedCities().whenComplete(() {
      setState(() {});
      _isloading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            role: widget.role,
            depotName: widget.depoName,
            showDepoBar: true,
            toOverview: true,
            cityname: widget.cityName,
            text: 'Depot Energy Management',
            haveSummary: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewSummary(
                  role: widget.role,
                  cityName: widget.cityName.toString(),
                  depoName: widget.depoName.toString(),
                  id: 'Energy Management',
                  userId: widget.userId,
                ),
              ),
            ),
            haveSynced: isFieldEditable,
            store: () {
              showProgressDilogue(context);
              FirebaseApiUser().defaultKeyEventsField(
                  'EnergyManagementTable', widget.cityName!);
              FirebaseApiUser().nestedKeyEventsField('EnergyManagementTable',
                  widget.cityName!, 'Depots', widget.depoName!);
              FirebaseApiUser().energydefaultKeyEventsField(
                  'EnergyManagementTable',
                  widget.cityName!,
                  'Depots',
                  widget.depoName!,
                  'Year',
                  DateTime.now().year.toString());
              FirebaseApiUser().energynestedKeyEventsField(
                  'EnergyManagementTable',
                  widget.cityName!,
                  'Depots',
                  widget.depoName!,
                  'Year',
                  DateTime.now().year.toString(),
                  'Months',
                  monthName);

              FirebaseApiUser().energynestedKeyEventsField2(
                  'EnergyManagementTable',
                  widget.cityName!,
                  'Depots',
                  widget.depoName!,
                  'Year',
                  DateTime.now().year.toString(),
                  'Months',
                  monthName,
                  'Date',
                  DateFormat.yMMMMd().format(DateTime.now()));

              storeData();
            },
          )),
      body: _isloading
          ? LoadingPage()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: white, gridLineColor: blue),
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data!.exists == false) {
                          _energyManagementdatasource =
                              EnergyManagementDatasource(
                                  _energyManagement,
                                  context,
                                  widget.userId!,
                                  widget.cityName,
                                  widget.depoName);
                          _dataGridController = DataGridController();
                          return SfDataGrid(
                            rowHeight: 40,
                            isScrollbarAlwaysShown: true,
                            source: _energyManagementdatasource,
                            allowEditing: isFieldEditable,
                            frozenColumnsCount: 2,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.multiple,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            editingGestureType: EditingGestureType.tap,
                            controller: _dataGridController,

                            // onQueryRowHeight: (details) {
                            //   return details.rowIndex == 0 ? 60.0 : 49.0;
                            // },
                            columns: [
                              GridColumn(
                                visible: true,
                                columnName: 'srNo',
                                allowEditing: false,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Sr No',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'DepotName',
                                width: 180,
                                allowEditing: false,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Depot Name',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'VehicleNo',
                                width: 180,
                                allowEditing: true,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Vehicle No',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'pssNo',
                                width: 80,
                                allowEditing: true,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('PSS No',
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'chargerId',
                                width: 80,
                                allowEditing: true,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Charger ID',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'startSoc',
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Start SOC',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'endSoc',
                                allowEditing: true,
                                columnWidthMode: ColumnWidthMode.fitByCellValue,
                                width: 80,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('End SOC',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'startDate',
                                allowEditing: false,
                                width: 230,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Start Date & Time',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'endDate',
                                allowEditing: false,
                                width: 230,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text('End Date & Time',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'totalTime',
                                allowEditing: false,
                                width: 180,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Total time of Charging',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'energyConsumed',
                                allowEditing: true,
                                width: 160,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Engery Consumed (inkW)',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'timeInterval',
                                allowEditing: false,
                                width: 150,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Interval',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                allowEditing: false,
                                width: 120,
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
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Delete Row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          alldata = '';
                          alldata = snapshot.data!['data'] as List<dynamic>;
                          _energyManagement.clear();
                          _energyManagementdatasource.buildDataGridRows();
                          _energyManagementdatasource.updateDatagridSource();
                          alldata.forEach((element) {
                            _energyManagement.add(
                                EnergyManagementModelUser.fromJson(element));
                            _energyManagementdatasource =
                                EnergyManagementDatasource(
                                    _energyManagement,
                                    context,
                                    widget.userId!,
                                    widget.cityName,
                                    widget.depoName);
                            _dataGridController = DataGridController();
                            _energyManagementdatasource.buildDataGridRows();
                            _energyManagementdatasource.updateDatagridSource();
                          });
                          return SfDataGridTheme(
                            data: SfDataGridThemeData(
                              headerColor: white,
                              gridLineColor: blue,
                            ),
                            child: SfDataGrid(
                              source: _energyManagementdatasource,
                              allowEditing: isFieldEditable,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.multiple,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.auto,
                              editingGestureType: EditingGestureType.tap,
                              rowHeight: 40.0,
                              controller: _dataGridController,
                              columns: [
                                GridColumn(
                                  visible: true,
                                  columnName: 'srNo',
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Sr No',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'DepotName',
                                  width: 180,
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Depot Name',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'VehicleNo',
                                  width: 180,
                                  allowEditing: true,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Veghicle No',
                                        textAlign: TextAlign.center,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'pssNo',
                                  width: 80,
                                  allowEditing: true,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('PSS No',
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'chargerId',
                                  width: 80,
                                  allowEditing: true,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Charger ID',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'startSoc',
                                  allowEditing: true,
                                  width: 80,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Start SOC',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'endSoc',
                                  allowEditing: true,
                                  columnWidthMode:
                                      ColumnWidthMode.fitByCellValue,
                                  width: 80,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('End SOC',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'startDate',
                                  allowEditing: false,
                                  width: 230,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Start Date & Time',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'endDate',
                                  allowEditing: false,
                                  width: 230,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text('End Date & Time',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'totalTime',
                                  allowEditing: false,
                                  width: 180,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Total time of Charging',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'energyConsumed',
                                  allowEditing: true,
                                  width: 160,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Engery Consumed (inkW)',
                                        overflow: TextOverflow.values.first,
                                        textAlign: TextAlign.center,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'timeInterval',
                                  allowEditing: false,
                                  width: 150,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Interval',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Add',
                                  allowEditing: false,
                                  width: 120,
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
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Delete Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.blue,
                ),
                Consumer<EnergyProviderUser>(builder: (context, value, child) {
                  _energyProvider!.fetchGraphData(
                      widget.cityName!, widget.depoName!, widget.userId);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    width: 2000,
                    height: 250,
                    child: Scrollbar(
                      thickness: 3,
                      radius: const Radius.circular(1),
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: _scrollController,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            width: 150 *
                                _energyManagementdatasource.dataGridRows.length
                                    .toDouble(),
                            height: 220,
                            child: BarChart(
                              swapAnimationCurve: Curves.linear,
                              swapAnimationDuration: const Duration(
                                milliseconds: 1000,
                              ),
                              BarChartData(
                                backgroundColor: white,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  allowTouchBarBackDraw: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipRoundedRadius: 5,
                                    tooltipBgColor: Colors.transparent,
                                    tooltipMargin: 5,
                                  ),
                                ),
                                minY: 0,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (data1, meta) {
                                        return Text(
                                          value.intervalData[data1.toInt()],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        );
                                      },
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                      getTitlesWidget: (data2, meta) {
                                        return Text(
                                          value.energyData[data2.toInt()],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(
                                  drawHorizontalLine: false,
                                  drawVerticalLine: false,
                                ),
                                borderData: FlBorderData(
                                  border: const Border(
                                    left: BorderSide(),
                                    bottom: BorderSide(),
                                  ),
                                ),
                                maxY: (value.intervalData.isEmpty &&
                                        value.energyData.isEmpty)
                                    ? 50000
                                    : value.energyData.reduce((max, current) =>
                                        max > current ? max : current),
                                barGroups: barChartGroupData(value.energyData),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                })
              ],
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            _energyManagement.add(EnergyManagementModelUser(
                srNo: _energyManagement.length + 1,
                depotName: widget.depoName.toString(),
                vehicleNo: '',
                pssNo: 1,
                chargerId: 1,
                startSoc: 1,
                endSoc: 1,
                startDate:
                    DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
                endDate:
                    DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
                totalTime:
                    DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
                energyConsumed: 1500,
                timeInterval:
                    '${DateTime.now().hour}:${DateTime.now().minute} - ${DateTime.now().add(const Duration(hours: 6)).hour}:${DateTime.now().add(const Duration(hours: 6)).minute}'));
            _energyManagementdatasource.buildDataGridRows();
            _energyManagementdatasource.updateDatagridSource();
          }),
          child: Icon(Icons.add)),
    );
  }

  void storeData() {
    _energyManagementdatasource.buildDataGridRows();
    _energyManagementdatasource.updateDatagridSource();
    Map<String, dynamic> tableData = Map();
    String monthName = DateFormat('MMMM').format(DateTime.now());
    for (var i in _energyManagementdatasource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Add' && data.columnName != 'Delete') {
          tableData[data.columnName] = data.value;
        }
      }
      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('EnergyManagementTable')
        .doc(widget.cityName)
        .collection('Depots')
        .doc(widget.depoName)
        .collection('Year')
        .doc(DateTime.now().year.toString())
        .collection('Months')
        .doc(monthName)
        .collection('Date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .collection('UserId')
        .doc(widget.userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() async {
      tabledata2.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  List<BarChartGroupData> barChartGroupData(List<dynamic> data) {
    return List.generate(data.length, ((index) {
      print('$index${data[index]}');
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
              borderSide: BorderSide(color: white),
              backDrawRodData: BackgroundBarChartRodData(
                toY: 0,
                fromY: 0,
                show: true,
              ),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 16, 81, 231),
                  Color.fromARGB(255, 190, 207, 252)
                ],
              ),
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: data[index]),
        ],
      );
    }));
  }

  Future getAssignedCities() async {
    assignedCities = await authService.getCityList();
    isFieldEditable =
        authService.verifyAssignedCities(widget.cityName!, assignedCities);
  }
  
}
