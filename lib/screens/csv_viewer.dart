

import 'dart:io';

import 'package:flutter/material.dart';

class CsvViewer extends StatelessWidget {
  const CsvViewer({Key? key, required this.csvFile}) : super(key: key);

  final File csvFile;

  @override
  Widget build(BuildContext context) {
    // Returns a widget that displays the contents of the CSV file
    // in the form of a table with all columns form the first 8 rows and
    // the header
    return FutureBuilder(
      future: csvFile.readAsLines(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          List<String> lines = snapshot.data!;
          List<String> header = lines.first.split(',');
          List<List<String>> rows = lines.sublist(1).map((e) => e.split(',')).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: header.map((e) => DataColumn(label: Text(e))).toList(),
              rows: rows.getRange(0, 8).map((e) => DataRow(cells: e.map((e) => DataCell(Text(e))).toList())).toList(),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}