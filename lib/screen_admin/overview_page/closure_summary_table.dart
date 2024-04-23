import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_appllication/components/loading_page.dart';
import 'package:web_appllication/screen_admin/overview_page/closure_summary.dart';
import 'package:web_appllication/screen_user/overview_pages/closure_report.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';
import 'package:web_appllication/widgets/widgets_admin/custom_appbar.dart';

class ClosureSummaryTable extends StatefulWidget {
  final String? userId;
  final String? cityName;
  final String? depoName;
  final String? id;
  final String role;
  const ClosureSummaryTable(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      this.id,
      required this.role});

  @override
  State<ClosureSummaryTable> createState() => _ClosureSummaryTableState();
}

class _ClosureSummaryTableState extends State<ClosureSummaryTable> {

  List<List<dynamic>> rowList = [];
  TextEditingController selectedDepoController = TextEditingController();
  TextEditingController selectedCityController = TextEditingController();

  Future<List<List<dynamic>>> fetchData() async {
    await getRowsForFutureBuilder();
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBar(
            
            makeAnEntryPage: ClosureReportUser(
              role: widget.role,
              cityName: widget.cityName,
              depoName: widget.depoName,
              userId: widget.userId,
            ),
            isProjectManager: widget.role == 'projectManager' ? true : false,
            role: widget.role,
            showDepoBar: true,
            toClosure: true,
            depoName: widget.depoName,
            cityName: widget.cityName,
            text: '${widget.id}',
            userId: widget.userId,
          ),
          preferredSize: const Size.fromHeight(50)),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingPage(),
                );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'No Data Available for Selected Depo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
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
                      headingRowColor:
                          MaterialStateColor.resolveWith((states) => white
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
                            label: Text('Closure Report',
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
                              DataCell(ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClosureSummary(
                                        role: widget.role,
                                        depoName: widget.depoName,
                                        cityName: widget.cityName,
                                        id: 'Closure Summary',
                                        user_id: rowData[0],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('View Report'),
                              )),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Future<void> getRowsForFutureBuilder() async {
    rowList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ClosureReportTable')
        .doc('${widget.depoName}')
        .collection('userId')
        .get();

    List<dynamic> userIdList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < userIdList.length; i++) {
      rowList.add([userIdList[i], 'PDF']);
    }
  }
}
