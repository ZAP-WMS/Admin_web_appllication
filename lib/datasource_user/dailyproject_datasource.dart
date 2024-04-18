import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:web_appllication/screen_user/KeysEvents/upload.dart';
import 'package:web_appllication/screen_user/KeysEvents/view_AllFiles.dart';
import 'package:web_appllication/screen_user/overview_pages/daily_project.dart';
import 'package:web_appllication/provider/provider_user/summary_provider.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';

import '../model/user_model/daily_projectModel.dart';

class DailyDataSource extends DataGridSource {
  String cityName;
  String depoName;
  String userId;
  String selectedDate;
  BuildContext mainContext;
  Function deleteFileFun;

  List data = [];
  DailyDataSource(this._dailyproject, this.mainContext, this.cityName,
      this.depoName, this.selectedDate, this.userId, this.deleteFileFun) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = _dailyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<DailyProjectModelUser> _dailyproject = [];

  List<DataGridRow> dataGridRows = [];
  final _dateFormatter = DateFormat.yMd();

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    DateTime? rangeEndDate = DateTime.now();
    DateTime? date;
    DateTime? endDate;
    DateTime? rangeStartDate1 = DateTime.now();
    DateTime? rangeEndDate1 = DateTime.now();
    DateTime? date1;
    DateTime? endDate1;
    final int dataRowIndex = dataGridRows.indexOf(row);

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      void addRowAtIndex(int index, DailyProjectModelUser rowData) {
        _dailyproject.insert(index, rowData);
        buildDataGridRows();
        notifyListeners();
      }

      void removeRowAtIndex(int index) {
        _dailyproject.removeAt(index);
        buildDataGridRows();
        notifyListeners();
      }

      String Pagetitle = 'Daily Report';

      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: (dataGridCell.columnName == 'view')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              mainContext,
                              MaterialPageRoute(
                                builder: (context) => ViewAllPdfUser(
                                  title: Pagetitle,
                                  cityName: cityName,
                                  depoName: depoName,
                                  userId: userId,
                                  date: selectedDate,
                                  docId: globalRowIndex.isNotEmpty
                                      ? globalRowIndex[
                                          dataGridRows.indexOf(row)]
                                      : dataGridRows.indexOf(row) + 1,
                                ),
                              ));
                        },
                        child: const Text(
                          'View',
                        ),
                      ),
                    ),
                    Container(
                      child: isShowPinIcon[dataGridRows.indexOf(row)]
                          ? Icon(
                              Icons.attach_file_outlined,
                              color: blue,
                              size: 18,
                            )
                          : Container(),
                    ),
                    Text(
                      globalItemLengthList[dataGridRows.indexOf(row)] != 0
                          ? globalItemLengthList[dataGridRows.indexOf(row)] > 9
                              ? '${globalItemLengthList[dataGridRows.indexOf(row)]}+'
                              : '${globalItemLengthList[dataGridRows.indexOf(row)]}'
                          : '',
                      style: TextStyle(
                        color: blue,
                        fontSize: 11,
                      ),
                    )
                  ],
                )
              : (dataGridCell.columnName == 'upload')
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                            builder: (context) => UploadDocument(
                              pagetitle: Pagetitle,
                              customizetype: const [
                                'jpg',
                                'jpeg',
                                'png',
                                'pdf'
                              ],
                              cityName: cityName,
                              depoName: depoName,
                              userId: userId,
                              date: selectedDate,
                              fldrName: '${dataGridRows.indexOf(row) + 1}',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Upload',
                      ),
                    )
                  : (dataGridCell.columnName == 'Add')
                      ? ElevatedButton(
                          onPressed: () {
                            isShowPinIcon.add(false);
                            addRowAtIndex(
                                dataRowIndex + 1,
                                DailyProjectModelUser(
                                    siNo: dataRowIndex + 2,
                                    typeOfActivity: '',
                                    activityDetails: '',
                                    progress: '',
                                    status: ''));
                          },
                          child: const Text(
                            'Add',
                          ),
                        )
                      : (dataGridCell.columnName == 'Delete')
                          ? IconButton(
                              onPressed: () async {
                                deleteFileFun(dataRowIndex);
                                removeRowAtIndex(dataRowIndex);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: red,
                                size: 15,
                              ))
                          // : (dataGridCell.columnName == 'Date')
                          //     ? Row(
                          //         children: [
                          //           IconButton(
                          //             onPressed: () {
                          //               showDialog(
                          //                   context: mainContext,
                          //                   builder: (context) => AlertDialog(
                          //                         title: const Text('All Date'),
                          //                         content: SizedBox(
                          //                             height: 400,
                          //                             width: 500,
                          //                             child: SfDateRangePicker(
                          //                               view:
                          //                                   DateRangePickerView
                          //                                       .month,
                          //                               showTodayButton: true,
                          //                               onSelectionChanged:
                          //                                   (DateRangePickerSelectionChangedArgs
                          //                                       args) {
                          //                                 if (args.value
                          //                                     is PickerDateRange) {
                          //                                   rangeEndDate = args
                          //                                       .value.endDate;
                          //                                 } else {
                          //                                   final List<
                          //                                           PickerDateRange>
                          //                                       selectedRanges =
                          //                                       args.value;
                          //                                 }
                          //                               },
                          //                               selectionMode:
                          //                                   DateRangePickerSelectionMode
                          //                                       .single,
                          //                               showActionButtons: true,
                          //                               onSubmit: ((value) {
                          //                                 date = DateTime.parse(
                          //                                     value.toString());

                          //                                 final int
                          //                                     dataRowIndex =
                          //                                     dataGridRows
                          //                                         .indexOf(row);
                          //                                 if (dataRowIndex !=
                          //                                     null) {
                          //                                   final int
                          //                                       dataRowIndex =
                          //                                       dataGridRows
                          //                                           .indexOf(
                          //                                               row);
                          //                                   dataGridRows[
                          //                                               dataRowIndex]
                          //                                           .getCells()[
                          //                                       1] = DataGridCell<
                          //                                           String>(
                          //                                       columnName:
                          //                                           'Date',
                          //                                       value: DateFormat(
                          //                                               'dd-MM-yyyy')
                          //                                           .format(
                          //                                               date!));
                          //                                   _dailyproject[
                          //                                           dataRowIndex]
                          //                                       .date = DateFormat(
                          //                                           'dd-MM-yyyy')
                          //                                       .format(date!);
                          //                                   notifyListeners();

                          //                                   Navigator.pop(
                          //                                       context);
                          //                                 }
                          //                               }),
                          //                             )),
                          //                       ));
                          //             },
                          //             icon: const Icon(Icons.calendar_today),
                          //           ),
                          //           Text(dataGridCell.value.toString()),
                          //         ],
                          //       )

                          : Text(
                              dataGridCell.value.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ));
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  void updateDataGrid({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == 'Date') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Date', value: newCellValue);
      _dailyproject[dataRowIndex].date = newCellValue;
    } else if (column.columnName == 'SiNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'SiNo', value: newCellValue);
      _dailyproject[dataRowIndex].siNo = newCellValue as int;
    } else if (column.columnName == 'TypeOfActivity') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'TypeOfActivity', value: newCellValue);
      _dailyproject[dataRowIndex].typeOfActivity = newCellValue;
    } else if (column.columnName == 'ActivityDetails') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'ActivityDetails', value: newCellValue);
      _dailyproject[dataRowIndex].activityDetails = newCellValue;
    } else if (column.columnName == 'Progress') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Progress', value: newCellValue);
      _dailyproject[dataRowIndex].progress = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Status', value: newCellValue);
      _dailyproject[dataRowIndex].status = newCellValue;
    }
  }

  @override
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == 'SiNo';
    //  ||
    // column.columnName == 'StartDate' ||
    // column.columnName == 'EndDate' ||
    // column.columnName == 'ActualStart' ||
    // column.columnName == 'ActualEnd' ||
    // column.columnName == 'ActualDuration' ||
    // column.columnName == 'Delay' ||
    // column.columnName == 'Unit' ||
    // column.columnName == 'QtyScope' ||
    // column.columnName == 'QtyExecuted' ||
    // column.columnName == 'BalancedQty' ||
    // column.columnName == 'Progress' ||
    // column.columnName == 'Weightage';

    final bool isDateTimeType = column.columnName == 'StartDate' ||
        column.columnName == 'EndDate' ||
        column.columnName == 'ActualStart' ||
        column.columnName == 'ActualEnd';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5, right: 5),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        keyboardType: isNumericType
            ? TextInputType.number
            : isDateTimeType
                ? TextInputType.datetime
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = '';
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  RegExp _getRegExp(
      bool isNumericKeyBoard, bool isDateTimeBoard, String columnName) {
    return isNumericKeyBoard
        ? RegExp('[0-9]')
        : isDateTimeBoard
            ? RegExp('[0-9/]')
            : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
  }
}
