import 'dart:io';
import 'package:diacritic/diacritic.dart';
import 'package:cdr_iesc/common/compare.dart';

class Result {
  final bool isSuccess;
  final String message;

  Result({
    required this.isSuccess,
    required this.message,
  });

  Result.success({
    required this.message,
  }) : isSuccess = true;

  Result.error({
    required this.message,
  }) : isSuccess = false;
}

class CsvResult extends Result {
  String? additionalMessage;

  CsvResult.success({
    this.additionalMessage,
  }) : super.success(
    message: 'Success',
  );

  CsvResult.noColumns({
    this.additionalMessage,
  }) : super.error(
    message: 'No columns found',
  );

  CsvResult.validationError({
    this.additionalMessage,
  }) : super.error(
    message: 'Validation error',
  );

  CsvResult.parsingError({
    this.additionalMessage,
  }) : super.error(
    message: 'Parsing error',
  );

  CsvResult.fileDoesNotExist({
    this.additionalMessage,
  }) : super.error(
    message: 'File does not exist',
  );

  CsvResult.fileError({
    this.additionalMessage,
  }) : super.error(
    message: 'File error',
  );

  CsvResult.unknownError({
    this.additionalMessage,
  }) : super.error(
    message: 'Unknown error',
  );

  CsvResult.comparisonError({
    this.additionalMessage,
  }) : super.error(
    message: 'Comparison error',
  );

  Map<String, dynamic> get toMap => <String, dynamic>{
    'success': isSuccess,
    'message': message,
    'additionalMessage': additionalMessage,
  };

  @override
  String toString() {
    return 'CsvResult: $toMap';
  }
}

class PersonBirthdate {
  late final int day;
  late final int month;
  late final int year;
  final String dateFormat;

  PersonBirthdate(
    String date, {
    this.dateFormat = 'ddmmyyyy',
  }) {
    fromString(date);
  }

  @override
  String toString() {
    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');
    String year = this.year.toString().padLeft(4, '0');
    return '$day$month$year';
  }

  PersonBirthdate fromString(String date) {
    CsvUtils.isValidDate(date);
    if (dateFormat == 'ddmmyyyy') {
      day = int.parse(date.substring(0, 2));
      month = int.parse(date.substring(2, 4));
      year = int.parse(date.substring(4, 8));
    } else {
      year = int.parse(date.substring(0, 4));
      month = int.parse(date.substring(4, 6));
      day = int.parse(date.substring(6, 8));
    }
    return this;
  }

  static void validateFormat(String format) {
    format = format.toLowerCase();
    if (format != 'ddmmyyyy' && format != 'yyyymmdd') {
      throw Exception(CsvResult.parsingError().toString());
    }
  }
}

class PersonName {
  late final String name;
  late final List<String> parts;

  PersonName(this.name) {
    CsvUtils.isValidName(name);
    parts = name.trim().split(' ');
  }

  @override
  String toString() => name;
}

class PersonAddress {
  late final String address;
  late List<String> parts;

  PersonAddress(this.address) {
    CsvUtils().isValidAddress(address);
    parts = address.trim().split(' ');
    // Remove numbers from the address
    parts.removeWhere((element) => int.tryParse(element) != null);
  }

  @override
  String toString() => address;
}

class CsvUtils {
  static void isValidDate(String date) {
    // Dates must be in the format of 'ddmmyyyy' or 'yyyymmdd'
    final RegExp datePattern =
        RegExp('^(0[1-9]|[12][0-9]|3[01])(0[1-9]|1[0-2])(19|20)\\d\\d\$');
    if (!datePattern.hasMatch(date)) {
      throw Exception(CsvResult.parsingError(
          additionalMessage: 'Invalid date format').toString());
    }
  }

  static void isValidName(String name) {
    // Simplify names removing graphical accents
    name = removeDiacritics(name).replaceAll(
      // Everything that is not a letter or space
      RegExp(r'[^a-zA-Z ]'),
      '',
    );
    // Names must only contain letters and spaces
    final RegExp namePattern = RegExp('^[a-zA-Z ]+\$');
    if (!namePattern.hasMatch(name)) {
      throw Exception(CsvResult.parsingError(
          additionalMessage: 'Invalid name format').toString());
    }
  }

  void isValidAddress(String address) {
    // Addresses must only contain letters, numbers, and spaces
    final RegExp addressPattern = RegExp('^[a-zA-Z0-9 ]+\$');
    if (!addressPattern.hasMatch(address)) {
      throw Exception(CsvResult.parsingError(
          additionalMessage: 'Invalid address format').toString());
    }
  }

  void isValidGender(String gender) {
    // Gender must be either 'M' or 'F'
    final RegExp genderPattern = RegExp('^[MF]\$');
    if (!genderPattern.hasMatch(gender)) {
      throw Exception(CsvResult.parsingError(
          additionalMessage: 'Invalid gender format').toString());
    }
  }
}

enum PersonGender {
  male,
  female;

  static PersonGender fromString(String gender) {
    if (gender == 'M') return PersonGender.male;
    if (gender == 'F') return PersonGender.female;
    throw Exception(CsvResult.parsingError(
        additionalMessage: 'Invalid date format').toString());
  }

  @override
  String toString() => switch (this) {
      male => 'M',
      female => 'F',
    };
}

class Person {
  final PersonName name;
  final PersonName motherName;
  final PersonBirthdate birthDate;
  final PersonGender gender;
  late final PersonAddress? address;

  Person({
    required this.name,
    required this.motherName,
    required this.birthDate,
    required this.gender,
    this.address,
  });

  @override
  String toString() {
    return 'Person('
      'name: ${name.toString()}, '
      'motherName: ${motherName.toString()}, '
      'birthDate: ${birthDate.toString()}, '
      'gender: ${gender.toString()}'
      ')';
  }
}

class Csv {
  String inputFilePath;
  String outputFilePath;
  String dateFormat;
  int aNameColumn;
  int bNameColumn;
  int aMotherNameColumn;
  int bMotherNameColumn;
  int aBirthDateColumn;
  int bBirthDateColumn;
  int aGenderColumn;
  int bGenderColumn;
  int classColumn;
  int? aAddressColumn;
  int? bAddressColumn;

  late List<String> lines;
  List<List<Person>> allRecords = [];

  Csv({
    required this.inputFilePath,
    required this.outputFilePath,
    required this.dateFormat,
    required this.aNameColumn,
    required this.bNameColumn,
    required this.aMotherNameColumn,
    required this.bMotherNameColumn,
    required this.aBirthDateColumn,
    required this.bBirthDateColumn,
    required this.aGenderColumn,
    required this.bGenderColumn,
    required this.classColumn,
    this.aAddressColumn,
    this.bAddressColumn,
  });

  List<String> get columns {
    if (lines.isEmpty) throw Exception(CsvResult.noColumns().toString());
    List<String> columns = [
      lines.first[aNameColumn],
      lines.first[bNameColumn],
      lines.first[aMotherNameColumn],
      lines.first[bMotherNameColumn],
      lines.first[aBirthDateColumn],
      lines.first[bBirthDateColumn],
      lines.first[aGenderColumn],
      lines.first[bGenderColumn],
      lines.first[classColumn],
    ];
    if (aAddressColumn != null) columns.add(lines.first[aAddressColumn!]);
    if (bAddressColumn != null) columns.add(lines.first[bAddressColumn!]);
    return columns;
  }

  Future<void> read() async {
    lines = await File(inputFilePath).readAsLines();
    lines.removeAt(0); // Remove the header
    _validate();

    // Write the header
    await File(outputFilePath).writeAsString(
      '${Compare.getResultHeader.join(',')}\n',
      mode: FileMode.writeOnly,
    );

    for (final (int, String) element in lines.indexed) {
      final String line = element.$2;
      final List<String> columns = line.split(',');

      Person personA = Person(
        name: PersonName(columns[aNameColumn]),
        motherName: PersonName(columns[aMotherNameColumn]),
        gender: PersonGender.fromString(columns[aGenderColumn]),
        birthDate: PersonBirthdate(
          columns[aBirthDateColumn],
          dateFormat: dateFormat,
        ),
        address: aAddressColumn != null
          ? PersonAddress(columns[aAddressColumn!])
          : null,
      );
      Person personB = Person(
        name: PersonName(columns[bNameColumn]),
        motherName: PersonName(columns[bMotherNameColumn]),
        gender: PersonGender.fromString(columns[bGenderColumn]),
        birthDate: PersonBirthdate(
          columns[bBirthDateColumn],
          dateFormat: dateFormat,
        ),
        address: bAddressColumn != null
          ? PersonAddress(columns[bAddressColumn!])
          : null,
      );
      // If everything is valid, add the record to the list
      await Comparator.compare(
        personA: personA,
        personB: personB,
        outputFilePath: outputFilePath,
        classe: columns[classColumn],
      );
    }
  }

  void _validate() {
    if (!File(inputFilePath).existsSync()) {
      throw Exception(CsvResult.fileDoesNotExist(
        additionalMessage: 'Error on validation',
      ).toString());
    }
    // Validate each line
    int index = 0;
    try {
      PersonBirthdate.validateFormat(dateFormat);
      for (index; index < lines.length; index++) {
        final String line = lines[index];
        final List<String> columns = line.split(',');
        Person(
          name: PersonName(columns[aNameColumn]),
          motherName: PersonName(columns[aMotherNameColumn]),
          gender: PersonGender.fromString(columns[aGenderColumn]),
          birthDate: PersonBirthdate(
            columns[aBirthDateColumn],
            dateFormat: dateFormat,
          ),
        );
        Person(
          name: PersonName(columns[bNameColumn]),
          motherName: PersonName(columns[bMotherNameColumn]),
          gender: PersonGender.fromString(columns[bGenderColumn]),
          birthDate: PersonBirthdate(
            columns[bBirthDateColumn],
            dateFormat: dateFormat,
          ),
        );
      }
    } on CsvResult catch (e) {
      e.additionalMessage = 'Error on line $index - ${e.additionalMessage}';
      rethrow;
    }
  }
}

class Comparator {
  final Csv csv;

  Comparator({
    required this.csv,
  });

  static Future<void> compare({
    required Person personA,
    required Person personB,
    required String outputFilePath,
    required String classe,
  }) async {
      final Patient pacienteA = Patient(
        name: personA.name.name,
        motherName: personA.motherName.name,
        birthDate: personA.birthDate.toString(),
        gender: personA.gender.toString(),
      );
      final Patient pacienteB = Patient(
        name: personB.name.name,
        motherName: personB.motherName.name,
        birthDate: personB.birthDate.toString(),
        gender: personB.gender.toString(),
      );

      Compare comparator = Compare(
        patientA: pacienteA,
        patientB: pacienteB,
        classification: classe,
      );

      // Write the line to the output file
      await File(outputFilePath).writeAsString(
          '${comparator.getResultLine().join(',')}\n',
          mode: FileMode.writeOnlyAppend,
      );
  }
}
