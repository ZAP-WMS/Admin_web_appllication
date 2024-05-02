import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:web_appllication/screen_user/KeysEvents/view_AllFiles.dart';
import 'package:web_appllication/screen_user/Planning_Pages/safety_checklist.dart';
import 'package:web_appllication/model/user_model/safety_checklistModel.dart';
import 'package:web_appllication/widgets/widgets_user/user_style.dart';

import '../screen_user/KeysEvents/upload.dart';

class SafetyChecklistDataSource extends DataGridSource {
  // BuildContext mainContext;
  String cityName;
  String depoName;
  dynamic userId;
  String selectedDate;
  SafetyChecklistDataSource(this._checklistModel, this.cityName, this.depoName,
      this.userId, this.selectedDate) {
    buildDataGridRows();
  }
  void buildDataGridRows() {
    dataGridRows = _checklistModel
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  @override
  List<SafetyChecklistModelUser> _checklistModel = [];

  List<DataGridRow> dataGridRows = [];
  final _dateFormatter = DateFormat.yMd();

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  TextEditingController editingController = TextEditingController();
  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black87);

  List<String> statusMenuItems = [
    'Yes',
    'No',
    'Not Applicable ',
  ];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        // : Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: dataGridCell.columnName == 'Photo'
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadDocument(
                            pagetitle: 'SafetyChecklist',
                            customizetype: const [
                              '.jpg',
                              '.jpeg',
                              '.png',
                              '.pdf'
                            ],
                            cityName: cityName,
                            depoName: depoName,
                            fldrName: '${dataGridRows.indexOf(row) + 1}',
                            userId: userId,
                            date: selectedDate,
                          ),
                        ));
                      },
                      child: const Text('Upload'));
                },
              )
            : dataGridCell.columnName == 'ViewPhoto'
                ? LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print("Date -$selectedDate");
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewAllPdfUser(
                                    title: 'SafetyChecklist',
                                    cityName: cityName,
                                    depoName: depoName,
                                    userId: userId,
                                    date: selectedDate,
                                    docId: '${dataGridRows.indexOf(row) + 1}',
                                  ),
                                ),
                              );
                            },
                            child: const Text('View'),
                          ),
                          Container(
                            child:
                                isShowPinSafetyList[dataGridRows.indexOf(row)]
                                    ? Icon(
                                        Icons.attach_file_outlined,
                                        color: blue,
                                        size: 18,
                                      )
                                    : Container(),
                          ),
                          Text(
                            globalIndexSafetyList[dataGridRows.indexOf(row)] !=
                                    0
                                ? globalIndexSafetyList[
                                            dataGridRows.indexOf(row)] >
                                        9
                                    ? '${globalIndexSafetyList[dataGridRows.indexOf(row)]}+'
                                    : '${globalIndexSafetyList[dataGridRows.indexOf(row)]}'
                                : '',
                            style: TextStyle(
                              color: blue,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : dataGridCell.columnName == 'Status'
                    ? DropdownButton<String>(
                        value: dataGridCell.value,
                        autofocus: true,
                        focusColor: Colors.transparent,
                        underline: const SizedBox.shrink(),
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        isExpanded: true,
                        style: textStyle,
                        onChanged: (String? value) {
                          final dynamic oldValue = row
                                  .getCells()
                                  .firstWhereOrNull((DataGridCell dataCell) =>
                                      dataCell.columnName ==
                                      dataGridCell.columnName)
                                  ?.value ??
                              '';
                          if (oldValue == value || value == null) {
                            return;
                          }

                          final int dataRowIndex = dataGridRows.indexOf(row);
                          dataGridRows[dataRowIndex].getCells()[2] =
                              DataGridCell<String>(
                                  columnName: 'Status', value: value);
                          _checklistModel[dataRowIndex].status =
                              value.toString();
                          notifyListeners();
                        },
                        items: statusMenuItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                      )
                    : Text(
                        dataGridCell.value.toString(),
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
      );
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
    if (column.columnName == 'srNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'srNo', value: newCellValue);
      _checklistModel[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'Details') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Details', value: newCellValue);
      _checklistModel[dataRowIndex].details = newCellValue.toString();
    } else if (column.columnName == 'Status') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Status', value: newCellValue);
      _checklistModel[dataRowIndex].status = newCellValue.toString();
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Remark', value: newCellValue);
      _checklistModel[dataRowIndex].remark = newCellValue as dynamic;
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

    final bool isNumericType = column.columnName == 'srNo';

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
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(
            0.0,
          ),
        ),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
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
