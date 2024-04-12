import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClosureReportModelAdmin {
  double? siNo;
  String? content;
  // String? attachment;

  ClosureReportModelAdmin({
    required this.siNo,
    required this.content,
    // required this.attachment,
  });

  factory ClosureReportModelAdmin.fromjson(Map<String, dynamic> json) {
    return ClosureReportModelAdmin(
      siNo: json['SiNo'],
      content: json['Content'],
      // attachment: json['Attachment'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'SiNo', value: siNo),
      DataGridCell(columnName: 'Content', value: content),
      const DataGridCell(columnName: 'Upload', value: null),
      const DataGridCell(columnName: 'View', value: null)
      // DataGridCell(columnName: 'Attachment', value: attachment),

      // const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
