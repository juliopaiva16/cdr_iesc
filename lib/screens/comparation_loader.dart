import 'dart:io';

import 'package:cdr_iesc/common/arguments.dart';
import 'package:cdr_iesc/common/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({super.key, required this.title});

  final String title;

  @override
  LoaderState createState() => LoaderState();
}

class LoaderState extends State<Loader> {
  Future<void> _comparisionFuture = Future.value();
  String _state = 'loading';
  late Arguments _args;
  String? inputPath = null;
  String? outputPath = null;
  Map<String, int?>? columns = null;

  Future<void> _compare() async {
    if (inputPath == null || outputPath == null || columns == null) {
      setState(() {
        _state = 'error';
      });
      return;
    }

    Csv csv = Csv(
      inputFilePath: inputPath!,
      outputFilePath: outputPath!,
      dateFormat: 'DDMMYYYY',
      aNameColumn: columns!['aNameColumn'] ?? -1,
      bNameColumn: columns!['bNameColumn'] ?? -1,
      aMotherNameColumn: columns!['aMotherNameColumn'] ?? -1,
      bMotherNameColumn: columns!['bMotherNameColumn'] ?? -1,
      aBirthDateColumn: columns!['aBirthDateColumn'] ?? -1,
      bBirthDateColumn: columns!['bBirthDateColumn'] ?? -1,
      aGenderColumn: columns!['aGenderColumn'] ?? -1,
      bGenderColumn: columns!['bGenderColumn'] ?? -1,
    );

    Comparator comparator = Comparator(csv: csv);
    comparator.compare().then(
          (value) => setState(() {
            _state = 'ready';
          }),
          onError: (error) => setState(() {
            _state = 'error';
          }),
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the arguments
      _args = ModalRoute.of(context)!.settings.arguments as Arguments;
      inputPath ??= _args.inputPath;
      outputPath ??= _args.outputPath;
      columns ??= _args.columns;
      // Compare the CSV files
      _comparisionFuture = _compare();
    });
  }

  Widget _buildBody() => switch (_state) {
        'loading' => const Center(child: CircularProgressIndicator()),
        'ready' => Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            ListTile(
              title: const Text('Comparison finished'),
              // Display a message with the path to the output file on a hyperlink
              // that opens the file in the default application
              subtitle: GestureDetector(
                onTap: () => {
                  // Open the output file with the default application
                  Process.run('open', [outputPath!]),
                },
                child: Row(
                  children: [
                    const Text('The comparison results are available at '),
                    Text(
                      outputPath!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        'error' => const Center(
            child: ListTile(
              title: Text('Error'),
              subtitle: Text('An error occurred while comparing the CSV files'),
            ),
          ),
        String() => throw UnimplementedError(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: _comparisionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildBody();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
