import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:web_appllication/style.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  final TextEditingController textEditingController = TextEditingController();

  String? selectedValue;

  List<String> gridTabLabels = [
    'Total PMIS Users',
    'Assigned PMIS Users',
    'UnAssigned PMIS Users',
    'Total O&M Users',
    'Assigned O&M Users',
    'UnAssigned O&M Users',
  ];

  List<Color> gridColorList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Role Management'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 9, 52, 245),
            Color.fromARGB(255, 92, 152, 241),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
                itemCount: 6,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) {
                  return gridTabs(index, gridColorList);
                }),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  width: 200,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                    dropdownSearchData: DropdownSearchData(
                      searchController: textEditingController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: textEditingController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for an item...',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    value: selectedValue,
                    isExpanded: true,
                    hint: Text(
                      'Select Item',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  gridTabs(int index, List<Color> colorList) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
      alignment: Alignment.center,
      height: 1000,
      width: MediaQuery.of(context).size.width / 6,
      child: Card(
        color: colorList[index],
        elevation: 5,
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              margin: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '100',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white,
                        fontSize: 18),
                  ),
                  Card(
                    elevation: 5.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(colorList[index]),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'More Info',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 10.0),
              alignment: Alignment.center,
              child: Text(
                gridTabLabels[index],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
