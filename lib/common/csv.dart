import 'dart:io';

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

  CsvResult.unknownError ({
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
}

class CsvUtils {
  static void isValidDate(String date) {
    // Dates must be in the format of 'ddmmyyyy' or 'yyyymmdd'
    final RegExp datePattern = RegExp(
      '^(0[1-9]|[12][0-9]|3[01])(0[1-9]|1[0-2])(19|20)\\d\\d\$');
    if (!datePattern.hasMatch(date)) {
      throw Exception(CsvResult.parsingError(
        additionalMessage: 'Invalid date format'
      ).toString());
    }
  }

  static void isValidName(String name) {
    // Names must only contain letters and spaces
    final RegExp namePattern = RegExp('^[a-zA-Z ]+\$');
    if (!namePattern.hasMatch(name)) {
      throw Exception(CsvResult.parsingError(
        additionalMessage: 'Invalid name format'
      ).toString());
    }
  }

  void isValidAddress(String address) {
    // Addresses must only contain letters, numbers, and spaces
    final RegExp addressPattern = RegExp('^[a-zA-Z0-9 ]+\$');
    if (!addressPattern.hasMatch(address)) {
      throw Exception(CsvResult.parsingError(
        additionalMessage: 'Invalid address format'
      ).toString());
    }
  }

  void isValidGender(String gender) {
    // Gender must be either 'M' or 'F'
    final RegExp genderPattern = RegExp('^[MF]\$');
    if (!genderPattern.hasMatch(gender)) {
      throw Exception(CsvResult.parsingError(
        additionalMessage: 'Invalid gender format'
      ).toString());
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
      additionalMessage: 'Invalid date format'
    ).toString());
  }
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
  int? aAddressColumn;
  int? bAddressColumn;

  late List<String> lines;
  late List<List<Person>> allRecords; // Pairs of records

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
    ];
    if (aAddressColumn != null) columns.add(lines.first[aAddressColumn!]);
    if (bAddressColumn != null) columns.add(lines.first[bAddressColumn!]);
    return columns;
  }

  void read() {
    lines = File(inputFilePath).readAsLinesSync();
    _validate();
    for (final String line in lines) {
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
      allRecords.add([personA, personB]);
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

  void compare() {
    // Write the header to the output file
    File(csv.outputFilePath)
      .writeAsStringSync(
        'nameA,nameB,motherA,motherB,'
        'birthDateA,birthDateB'
        'addressA,addressB,'
        'nameMatch,motherNameMatch,'
        'nameSoundexMatch,motherNameSoundexMatch,'
        'nameAbbreviationMatch,motherNameAbbreviationMatch,'
        'birthDateMatch,'
        'addressMatch,addressSoundexMatch,addressAbbreviationMatch\n',
      );
    for (final List<Person> record in csv.allRecords) {
      if (record.length != 2) {
        throw Exception(CsvResult.comparisonError(
          additionalMessage: 'Invalid record length, must be a pair',
        ).toString());
      }
      final Person personA = record.first;
      final Person personB = record.last;

      // Get the fraction of name parts that match
      final double nameMatch = _compareNames(personA.name, personB.name);
      // Get the fraction of mother name parts that match
      final double motherNameMatch = _compareNames(
        personA.motherName,
        personB.motherName,
      );
      // Get the fraction of soundex codes that match
      final double nameSoundexMatch = _compareNamesBySoundex(
        personA.name,
        personB.name,
      );
      // Get the fraction of soundex codes that match for the mother names
      final double motherNameSoundexMatch = _compareNamesBySoundex(
        personA.motherName,
        personB.motherName,
      );
      // Get the fraction of abbreviated names that match
      final double nameAbbreviationMatch = _compareNamesByAbbreviation(
        personA.name,
        personB.name,
      );
      // Get the fraction of abbreviated names that match for the mother names
      final double motherNameAbbreviationMatch = _compareNamesByAbbreviation(
        personA.motherName,
        personB.motherName,
      );
      // Get the fraction of birthdate parts that match
      final double birthDateMatch = _compareBirthDates(
        personA.birthDate,
        personB.birthDate,
      );
      double? addressMatch;
      double? addressSoundexMatch;
      double? addressAbbreviationMatch;
      if (
        personA.address != null &&
        personB.address != null
      ) {
      // Get the fraction of address parts that match
        addressMatch = _compareNames(
          PersonName(personA.address!.address),
          PersonName(personB.address!.address),
        );
        // Get the fraction of address parts that the soundex codes match
        addressSoundexMatch = _compareNamesBySoundex(
          PersonName(personA.address!.address),
          PersonName(personB.address!.address),
        );
        // Get the fraction of address parts that the abbreviated names match
        addressAbbreviationMatch = _compareNamesByAbbreviation(
          PersonName(personA.address!.address),
          PersonName(personB.address!.address),
        );
      }
      String line = '${personA.name},${personB.name},'
        '${personA.motherName},${personB.motherName},'
        '${personA.birthDate},${personB.birthDate},'
        '${personA.address?.address ?? ''},${personB.address?.address ?? ''},'
        '${writeLine(
          nameMatch: nameMatch,
          motherNameMatch: motherNameMatch,
          nameSoundexMatch: nameSoundexMatch,
          motherNameSoundexMatch: motherNameSoundexMatch,
          nameAbbreviationMatch: nameAbbreviationMatch,
          motherNameAbbreviationMatch: motherNameAbbreviationMatch,
          birthDateMatch: birthDateMatch,
          addressMatch: addressMatch,
          addressSoundexMatch: addressSoundexMatch,
          addressAbbreviationMatch: addressAbbreviationMatch,
        )}';
      // Write the line to the output file
      File(csv.outputFilePath)
        .writeAsStringSync('$line\n', mode: FileMode.append);
    }

  }

  String writeLine({
    required double nameMatch,
    required double motherNameMatch,
    required double nameSoundexMatch,
    required double motherNameSoundexMatch,
    required double nameAbbreviationMatch,
    required double motherNameAbbreviationMatch,
    required double birthDateMatch,
    double? addressMatch,
    double? addressSoundexMatch,
    double? addressAbbreviationMatch,
  }) {
    return 
      '$nameMatch,$motherNameMatch,'
      '$nameSoundexMatch,$motherNameSoundexMatch,'
      '$nameAbbreviationMatch,$motherNameAbbreviationMatch,'
      '$birthDateMatch,'
      '${addressMatch ?? ''},'
      '${addressSoundexMatch ?? ''},'
      '${addressAbbreviationMatch ?? ''}';
  }

  double _compareNames(PersonName nameA, PersonName nameB) {
    // Get the number of names that are common to both
    int commonNames = Set<String>
      .from(nameA.parts)
      .intersection(Set<String>.from(nameB.parts))
      .length;
    // Which name is larger?
    int largerSetSize = nameA.parts.length > nameB.parts.length
      ? nameA.parts.length
      : nameB.parts.length;
    // Get the proportion of common names
    double proportion = commonNames / largerSetSize;
    return proportion;
  }


  List<String> soundex(PersonName name) {
    Map<String, int> soundexMap = <String, int>{
      'B': 1, 'F': 1, 'P': 1, 'V': 1,
      'C': 2, 'G': 2, 'J': 2, 'K': 2, 'Q': 2, 'S': 2, 'X': 2, 'Z': 2,
      'D': 3, 'T': 3,
      'L': 4,
      'M': 5, 'N': 5,
      'R': 6,
    };
    // Get the soundex code for each name
    // The soundex code is a 4-character string, where the first character is
    // the first letter of the name and the remaining characters are the
    // soundex values of the remaining letters
    List<String> soundexCodes = [];
    for (final String part in name.parts) {
      String soundexCode = part[0];
      for (int i = 1; i < part.length; i++) {
        final String letter = part[i].toUpperCase();
        final int soundexValue = soundexMap[letter] ?? 0;
        if (soundexValue != 0) {
          soundexCode += soundexValue.toString();
        }
      }
      // Pad the soundex code with zeros
      soundexCode = soundexCode.padRight(4, '0');
      soundexCodes.add(soundexCode);
    }
    return soundexCodes;
  }


  double _compareNamesBySoundex(PersonName nameA, PersonName nameB) {
    // Get the soundex codes for each name
    List<String> soundexA = soundex(nameA);
    List<String> soundexB = soundex(nameB);
    // Get the number of soundex codes that are common to both
    int commonSoundex = Set<String>
      .from(soundexA)
      .intersection(Set<String>.from(soundexB))
      .length;
    // Which name is larger?
    int largerSetSize = soundexA.length > soundexB.length
      ? soundexA.length
      : soundexB.length;
    // Get the proportion of common soundex codes
    double proportion = commonSoundex / largerSetSize;
    return proportion;
  }
  
  // Get names that are abbreviated (e.g. 'John' -> 'J')
  List<String> abbreviate(PersonName name) {
    List<String> abbreviations = [];
    name.parts.where((element) => element.length == 1).forEach((element) {
      abbreviations.add(element);
    });
    return abbreviations;
  }

  // Get the fraction of abbreviated names that match with complete names
  double _compareNamesByAbbreviation(PersonName nameA, PersonName nameB) {
    //
    // First, for A
    // Get the abbreviated names for each name
    List<String> abbreviationsA = abbreviate(nameA);
    List<String> abbreviationsB = nameB.parts.map((e) => e[0]).toList();
    // Get the number of abbreviated names that are common to B
    int commonAbbreviationsFromA = Set<String>
      .from(abbreviationsA)
      .intersection(Set<String>.from(abbreviationsB))
      .length;
    //
    // Now, for B
    // Get the abbreviated names for each name
    abbreviationsB = abbreviate(nameB);
    abbreviationsA = nameA.parts.map((e) => e[0]).toList();
    // Get the number of abbreviated names that are common to A
    int commonAbbreviationsFromB = Set<String>
      .from(abbreviationsB)
      .intersection(Set<String>.from(abbreviationsA))
      .length;
    // Which name is larger?
    int setSize = abbreviationsA.length + abbreviationsB.length;
    // Get the proportion of common abbreviated names
    double proportion =
      (commonAbbreviationsFromA / setSize) +
      (commonAbbreviationsFromB / setSize);
    return proportion;
  }

  double _compareBirthDates(
    PersonBirthdate birthDateA,
    PersonBirthdate birthDateB,
  ) {
    // This comparison must return the percentage of matching characteres
    // between the two birthdates
    int commonCharacters = 0;
    for (int i = 0; i < 8; i++) {
      if ('$birthDateA'[i] == '$birthDateB'[i]) {
        commonCharacters++;
      }
    }
    return commonCharacters / 8;
  }
}