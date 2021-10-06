// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/products_repository.dart';
import 'model/product.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

List<bool> checked = List.generate(3, (index) => false);
DateTime selectedDate = DateTime.now();

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String checkList() {
      String check = "";
      if (checked[0] == true) {
        check += "No Kids Zone / ";
      }
      if (checked[1] == true) {
        check += "Pet-Friendly / ";
      }
      if (checked[2] == true) {
        check += "Free breakfast";
      }

      return check;
    }

    String parseDate() {
      String date = "";
      date += selectedDate.year.toString() + "." + selectedDate.month.toString() + "." + selectedDate.day.toString() + "(";

      switch (selectedDate.weekday) {
        case 1:
          date += "Mon)";
          break;
        case 2:
          date += "Tue)";
          break;
        case 3:
          date += "Wed)";
          break;
        case 4:
          date += "Thu)";
          break;
        case 5:
          date += "Fri)";
          break;
        case 6:
          date += "Sat)";
          break;
        case 7:
          date += "Sun)";
          break;
      }

      return date;
    }

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: ListView (
          children: [
            FilterWidget(),
            const Divider(
              height: 1.0,
              color: Colors.black,
            ),
            DateWidget(),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Please check your choice'),
                  content: Column(
                    children: [
                      Text (
                        checkList(),
                      ),
                      Text (
                        parseDate(),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<FilterWidget> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return Colors.blue;
    }

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          expand = !expand;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text('Filter'),
            );
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: checked[0],
                    onChanged: (bool? value) {
                      setState(() {
                        checked[0] = value!;
                      });
                    },
                  ),
                  const Text(
                    'No Kids Zone',
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: checked[1],
                    onChanged: (bool? value) {
                      setState(() {
                        checked[1] = value!;
                      });
                    },
                  ),
                  const Text(
                    'Pet-Friendly',
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: checked[2],
                    onChanged: (bool? value) {
                      setState(() {
                        checked[2] = value!;
                      });
                    },
                  ),
                  const Text(
                    'Free breakfast',
                  ),
                ],
              ),
            ],
          ),
          isExpanded: expand,
        ),
      ],
    );
  }
}

class DateWidget extends StatefulWidget {
  const DateWidget({Key? key}) : super(key: key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<DateWidget> {

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(2100)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Date'
        ),
        Row(
          children: [
            Text(
              selectedDate.toString(),
            ),
            IconButton(
              icon: const Icon(
                Icons.language,
                semanticLabel: 'filter',
              ),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}