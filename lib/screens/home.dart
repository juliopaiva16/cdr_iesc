
import 'dart:io';

import 'package:cdr_iesc/screens/csv_viewer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cdr_iesc/common/csv.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _state = 'ready';
  String? _csvInputPath;
  String? _csvOutputPath;

  void _getCSVInputPath() async {
    // Open file picker and get the path
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    setState(() {
      _csvInputPath = result?.paths.first ?? '';
      _state = 'ready';
    });
  }

  void _getCSVOutputPath() async {
    // Open file picker and get the path
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    setState(() {
      _csvOutputPath = result?.paths.first ?? '';
      _state = 'ready';
    });
  }

  Widget _buildCSVInputPath() {
    double width = MediaQuery.of(context).size.width;
    TextEditingController _csvInputPathController =
      TextEditingController(text: _csvInputPath);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _csvInputPathController,
          readOnly: true,
          decoration: InputDecoration(
            enabled: false,
            hintText: '',
            constraints: BoxConstraints.tightFor(width: width * 0.75),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _getCSVInputPath,
          child: const Text('Select CSV Input File'),
        ),
      ],
    );
  }

  Widget _buildCSVOutputPath() {
    double width = MediaQuery.of(context).size.width;
    TextEditingController _csvOutputPathController =
      TextEditingController(text: _csvOutputPath);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _csvOutputPathController,
          readOnly: true,
          decoration: InputDecoration(
            enabled: false,
            hintText: '',
            constraints: BoxConstraints.tightFor(width: width * 0.75),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _getCSVOutputPath,
          child: const Text('Select CSV Output File'),
        ),
      ],
    );
  }

  File? _csvFile;

  Widget _csvViewer() {
    if (_csvInputPath == null) {
      return Center(
        child: Text('Please select a CSV file to view'),
      );
    }
    _csvFile = File(_csvInputPath!);
    return CsvViewer(csvFile: _csvFile!);
  }

  Widget _columnSelector() {
    // Shows a list of dropdowns to select the columns to be copied
    // from the input CSV file to the output CSV file
    if (_csvFile == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _state = 'loading';
            });
            // Read the input CSV file
            List<String> csv = _csvFile!.readAsLinesSync();
            List<String> header = csv.first.split(',');
            // Show a dialog with a list of dropdowns
            List<String> columns = [
              'aNameColumn',
              'bNameColumn',
              'aMotherNameColumn',
              'bMotherNameColumn',
              'aBirthDateColumn',
              'bBirthDateColumn',
              'aGenderColumn',
              'bGenderColumn',
              'aAddressColumn',
              'bAddressColumn',
            ];
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Select Columns'),
                  content: Column(
                    children: 
                      // For each column that must be selected, show a dropdown
                      // that contains the list of columns from the input CSV,
                      // that is the header of the CSV file
                      columns.map((column) {
                        return DropdownButton<String>(
                          value: header[0],
                          items: header.map((e) {
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              // Update the column in the list of columns
                              value = value ?? header[0];
                            });
                          },
                        );
                      }).toList(),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        // Write the updated CSV to the output file
                        File(_csvOutputPath!).writeAsStringSync(csv.join('\n'));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Select Columns'),
        ),
      ],
    );
  }
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _state == 'loading'
        ? const Center(child: CircularProgressIndicator())
        : Center(
          child: Column(
            children: <Widget>[
              _buildCSVInputPath(),
              _csvViewer(),
              _columnSelector(),
              const SizedBox(height: 20),
              _buildCSVOutputPath(),
            ],
          ),
        ),
    );
  }
}