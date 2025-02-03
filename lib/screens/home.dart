import 'dart:io';

import 'package:cdr_iesc/common/arguments.dart';
import 'package:cdr_iesc/screens/csv_viewer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String _state = 'ready';
  String? _csvInputPath;
  String? _csvOutputPath;

  Map<String, int?> columns = {
    'aNameColumn': null,
    'aMotherNameColumn': null,
    'aBirthDateColumn': null,
    'aGenderColumn': null,
    'bNameColumn': null,
    'bMotherNameColumn': null,
    'bBirthDateColumn': null,
    'bGenderColumn': null,
    'classColumn': null,
  };

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

  void _getCSVOutputPath() {
    if (_csvInputPath != null && _csvInputPath!.isNotEmpty) {
      String inputFileName = _csvInputPath!.split('/').last;
      String inputFileNameWithoutExtension =
          inputFileName.replaceAll('.csv', '');
      String directory =
          _csvInputPath!.substring(0, _csvInputPath!.lastIndexOf('/'));
      String dateTime = DateTime.now().toIso8601String().replaceAll(':', '-');
      String outputFileName =
          '$inputFileNameWithoutExtension-saida-$dateTime.csv';
      String outputPath = '$directory/$outputFileName';

      setState(() {
        _csvOutputPath = outputPath;
        _state = 'ready';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an input file first')),
      );
    }
  }

  Widget _buildCSVInputPath() {
    double width = MediaQuery.of(context).size.width;
    TextEditingController csvInputPathController =
        TextEditingController(text: _csvInputPath);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: csvInputPathController,
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
    TextEditingController csvOutputPathController =
        TextEditingController(text: _csvOutputPath);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: csvOutputPathController,
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
          child: const Text('Generate CSV Output File'),
        ),
      ],
    );
  }

  File? _csvFile;

  Widget _csvViewer() {
    if (_csvInputPath == null || _csvInputPath!.isEmpty) {
      return const Center(
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
          onPressed: () {
            // Read the input CSV file
            List<String> csv = _csvFile!.readAsLinesSync();
            List<String> header = csv.first.split(',');
            // Show a dialog with a list of dropdowns
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: const Text('Select Columns'),
                      content: Column(
                        children: columns.map((key, val) {
                          return MapEntry(
                            key,
                            Row(
                              children: [
                                Text(key),
                                DropdownButton<int>(
                                  value: val,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      columns[key] = newValue;
                                    });
                                  },
                                  items: header.asMap().entries.map((entry) {
                                    return DropdownMenuItem<int>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).values.toList(),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            if (_csvOutputPath != null) {
                              // Write the updated CSV to the output file
                              File(_csvOutputPath!).writeAsStringSync(
                                  csv.join('\n'));
                              // Navigate to comparision_loader passing csv
                              Navigator.pushReplacementNamed(
                                context,
                                '/compare',
                                arguments: Arguments(
                                  inputPath: _csvInputPath!,
                                  outputPath: _csvOutputPath!,
                                  columns: columns,
                                ),
                              );
                            } else {
                              // Handle the case where the output path is null
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select an output file path',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
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
        title: Row(
          children: [
            const Icon(Icons.info),
            const SizedBox(width: 10),
            Text(widget.title),
          ],
        ),
      ),
      body: _state == 'loading'
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Column(
              children: <Widget>[
                // Alinhados acima
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    _buildCSVInputPath(),
                    const SizedBox(height: 20),
                    _csvViewer(),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Alinhados abaixo
                    _buildCSVOutputPath(),
                    const SizedBox(height: 20),
                    _columnSelector(),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
