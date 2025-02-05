import 'dart:math';

class Patient {
  String name;
  String motherName;
  String birthDate;
  String gender;

  Patient({
    required this.name,
    required this.motherName,
    required this.birthDate,
    required this.gender,
  });
}

// Function to compare the first fragment of the names
int firstFragmentEqual(String name1, String name2) {
  try {
    List<String> names1 = name1.split(' ');
    List<String> names2 = name2.split(' ');
    return names1[0] == names2[0] ? 1 : 0;
  } catch (e) {
    print('Error comparing first fragment: $e');
    return 0;
  }
}

// Function to compare the last fragment of the names
int lastFragmentEqual(String name1, String name2) {
  try {
    List<String> names1 = name1.split(' ');
    List<String> names2 = name2.split(' ');
    return names1.last == names2.last ? 1 : 0;
  } catch (e) {
    print('Error comparing last fragment: $e');
    return 0;
  }
}

// Function to calculate the number of equal fragments
double numberOfEqualFragments(String name1, String name2) {
  try {
    List<String> names1 = name1.split(' ');
    List<String> names2 = name2.split(' ');
    int equal = 0;
    for (var fragment1 in names1) {
      if (names2.contains(fragment1)) equal++;
    }
    return equal / (names1.length + names2.length);
  } catch (e) {
    print('Error comparing number of equal fragments: $e');
    return 0;
  }
}

// Function to calculate the number of rare fragments
double numberOfRareFragments(String name1, String name2) {
  try {
    // Assuming rare names are words with 3 or more characters
    List<String> names1 = name1.split(' ');
    List<String> names2 = name2.split(' ');
    int rare = 0;
    for (var fragment1 in names1) {
      if (fragment1.length >= 3 && !names2.contains(fragment1)) rare++;
    }
    for (var fragment2 in names2) {
      if (fragment2.length >= 3 && !names1.contains(fragment2)) rare++;
    }
    return rare / (names1.length + names2.length);
  } catch (e) {
    print('Error comparing number of rare fragments: $e');
    return 0;
  }
}

// Function to calculate the number of common fragments
double numberOfCommonFragments(String name1, String name2) {
  try {
    List<String> names1 = name1.split(' ');
    List<String> names2 = name2.split(' ');
    int common = 0;
    for (var fragment1 in names1) {
      if (names2.contains(fragment1)) common++;
    }
    return -common / (names1.length + names2.length);
  } catch (e) {
    print('Error comparing number of common fragments: $e');
    return 0;
  }
}

String _soundex(String input) {
  try {
    if (input.isEmpty) return '';

    String result = '';
    final String upper = input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    if (upper.isEmpty) return '';

    List<String> chars = upper.split('');

    // Phonetic mapping for Portuguese
    const Map<String, String> encoding = {
      'BFPV': '1',
      'CGJKQSXZ': '2',
      'DT': '3',
      'L': '4',
      'MN': '5',
      'R': '6',
      'H': '',
      'W': '',
      'AÁÀÂÃ': '',
      'EÉÈÊ': '',
      'IÍÌÎ': '',
      'OÓÒÔÕ': '',
      'UÚÙÛ': '',
      'YÝ': ''
    };

    // Encode first letter
    result += chars[0];

    // Encode remaining characters
    String previousCode = '';
    for (int i = 1; i < chars.length; i++) {
      String code = '';
      encoding.forEach((key, value) {
        if (key.contains(chars[i])) {
          code = value;
          return;
        }
      });

      if (code.isNotEmpty && code != previousCode) {
        result += code;
        previousCode = code;
      }
    }

    // Pad with zeros and limit to 4 characters
    result = result.replaceAll(' ', '');
    result = result.padRight(4, '0').substring(0, 4);

    return result;
  } catch (e) {
    print('Error calculating soundex: $e');
    return '';
  }
}

double numberOfSimilarFragments(String name1, String name2) {
  try {
    List<String> fragments1 = name1.split(' ');
    List<String> fragments2 = name2.split(' ');

    int similarCount = 0;

    for (String frag1 in fragments1) {
      String code1 = _soundex(frag1);
      for (String frag2 in fragments2) {
        String code2 = _soundex(frag2);
        if (code1 == code2 && code1.isNotEmpty) {
          similarCount++;
          break;
        }
      }
    }

    int totalFragments = fragments1.length + fragments2.length;
    return totalFragments > 0
        ? (similarCount / totalFragments) * 0.8
        : 0.0;
  } catch (e) {
    print('Error comparing number of similar fragments: $e');
    return 0;
  }
}

// Function to check abbreviations
double numberOfAbbreviatedFragments(String name1, String name2) {
  try {
    final RegExp abbrevRegex = RegExp(r'^[A-Za-z]\.$');

    List<String> fragments1 = name1.split(' ');
    List<String> fragments2 = name2.split(' ');

    int abbrevCount = 0;

    // Count abbreviations in both names
    abbrevCount += fragments1.where((f) => abbrevRegex.hasMatch(f)).length;
    abbrevCount += fragments2.where((f) => abbrevRegex.hasMatch(f)).length;

    // Calculate ratio by the length of the first name (patient A)
    int firstNameLength = fragments1.isNotEmpty ? fragments1.length : 1;

    return (abbrevCount / firstNameLength) * 0.5;
  } catch (e) {
    print('Error comparing number of abbreviated fragments: $e');
    return 0;
  }
}

// Function to calculate the average number of fragments
int averageNumberOfFragments(String name1, String name2) {
  try {
    return (name1.split(' ').length + name2.split(' ').length) ~/ 2;
  } catch (e) {
    print('Error calculating average number of fragments: $e');
    return 0;
  }
}

// Function to check if the dates are equal
int datesEqual(String date1, String date2) {
  try {
    return date1 == date2 ? 1 : 0;
  } catch (e) {
    print('Error comparing equal dates: $e');
    return 0;
  }
}

// Function to check if there is only one digit swapped in the dates
int datesOneDigitSwapped(String date1, String date2) {
  try {
    int diffs = 0;
    for (int i = 0; i < date1.length; i++) {
      if (date1[i] != date2[i]) diffs++;
    }
    return diffs == 1 ? 1 : 0;
  } catch (e) {
    print('Error comparing dates with one digit swapped: $e');
    return 0;
  }
}

// Function to check if the dates are reversed
int datesReversedDay(String date1, String date2) {
  try {
    if (date1.length != 8 || date2.length != 8) return 0; // Validation
    var day1 = date1.substring(6, 8);
    var month1 = date1.substring(4, 6);
    var year1 = date1.substring(0, 4);
    var day2 = date2.substring(6, 8);
    var month2 = date2.substring(4, 6);
    var year2 = date2.substring(0, 4);
    return (day1 == month2 && month1 == day2 && year1 == year2) ? 1 : 0;
  } catch (e) {
    print('Error comparing dates with reversed day: $e');
    return 0;
  }
}

// Function to apply the Levenshtein distance to the dates
double levenshteinDistanceDate(String date1, String date2) {
  try {
    int dist = levenshtein(date1, date2);
    return (1 - dist / 8);
  } catch (e) {
    print('Error calculating Levenshtein distance for dates: $e');
    return 0;
  }
}

// Levenshtein distance function (basic algorithm)
int levenshtein(String a, String b) {
  try {
    var matrix = List.generate(a.length + 1, (i) => List.filled(b.length + 1, 0));
    for (var i = 0; i <= a.length; i++) {
      for (var j = 0; j <= b.length; j++) {
        if (i == 0) {
          matrix[i][j] = j;
        } else if (j == 0) {
          matrix[i][j] = i;
        } else {
          var cost = (a[i - 1] == b[j - 1]) ? 0 : 1;
          matrix[i][j] = min(
            matrix[i - 1][j] + 1,
            min(matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost),
          );
        }
      }
    }
    return matrix[a.length][b.length];
  } catch (e) {
    print('Error calculating Levenshtein distance: $e');
    return 0;
  }
}

class Compare {
  Patient patientA;
  Patient patientB;
  String classification;

  Compare({
    required this.patientA,
    required this.patientB,
    required this.classification,
  });

  // Creates a map with the results of each criterion for the pair
  // The name criteria are:
  // firstFragmentEqual
  // lastFragmentEqual
  // numberOfEqualFragments
  // numberOfRareFragments
  // numberOfCommonFragments
  // numberOfSimilarFragments
  // numberOfAbbreviatedFragments
  // averageNumberOfFragments
  // And should be executed for patient name and mother's name
  // The date criteria are:
  // datesEqual
  // datesOneDigitSwapped
  // datesReversedDay
  // levenshteinDistanceDate
  Map<String, dynamic> runComparison() {
    return {
      'firstFragmentEqual': firstFragmentEqual(patientA.name, patientB.name),
      'lastFragmentEqual': lastFragmentEqual(patientA.name, patientB.name),
      'numberOfEqualFragments': numberOfEqualFragments(patientA.name, patientB.name),
      'numberOfRareFragments': numberOfRareFragments(patientA.name, patientB.name),
      'numberOfCommonFragments': numberOfCommonFragments(patientA.name, patientB.name),
      'numberOfSimilarFragments': numberOfSimilarFragments(patientA.name, patientB.name),
      'numberOfAbbreviatedFragments': numberOfAbbreviatedFragments(patientA.name, patientB.name),
      'averageNumberOfFragments': averageNumberOfFragments(patientA.name, patientB.name),
      'motherFirstFragmentEqual': firstFragmentEqual(patientA.motherName, patientB.motherName),
      'motherLastFragmentEqual': lastFragmentEqual(patientA.motherName, patientB.motherName),
      'motherNumberOfEqualFragments': numberOfEqualFragments(patientA.motherName, patientB.motherName),
      'motherNumberOfRareFragments': numberOfRareFragments(patientA.motherName, patientB.motherName),
      'motherNumberOfCommonFragments': numberOfCommonFragments(patientA.motherName, patientB.motherName),
      'motherNumberOfSimilarFragments': numberOfSimilarFragments(patientA.motherName, patientB.motherName),
      'motherNumberOfAbbreviatedFragments': numberOfAbbreviatedFragments(patientA.motherName, patientB.motherName),
      'motherAverageNumberOfFragments': averageNumberOfFragments(patientA.motherName, patientB.motherName),
      'datesEqual': datesEqual(patientA.birthDate, patientB.birthDate),
      'datesOneDigitSwapped': datesOneDigitSwapped(patientA.birthDate, patientB.birthDate),
      'datesReversedDay': datesReversedDay(patientA.birthDate, patientB.birthDate),
      'levenshteinDistanceDate': levenshteinDistanceDate(patientA.birthDate, patientB.birthDate),
      'classification': classification,
    };
  }

  List<String> getResultLine() {
    var results = runComparison();
    return [
      // Original Data
      patientA.name,
      patientA.motherName,
      patientA.birthDate,
      patientA.gender,
      patientB.name,
      patientB.motherName,
      patientB.birthDate,
      patientB.gender,

      // CdR Criteria (Names)
      results['firstFragmentEqual'].toString(),
      results['lastFragmentEqual'].toString(),
      results['numberOfEqualFragments'].toString(),
      results['numberOfRareFragments'].toString(),
      results['numberOfCommonFragments'].toString(),
      results['numberOfSimilarFragments'].toString(),
      results['numberOfAbbreviatedFragments'].toString(),
      results['averageNumberOfFragments'].toString(),

      // CdR Criteria (Mother's Name)
      results['motherFirstFragmentEqual'].toString(),
      results['motherLastFragmentEqual'].toString(),
      results['motherNumberOfEqualFragments'].toString(),
      results['motherNumberOfRareFragments'].toString(),
      results['motherNumberOfCommonFragments'].toString(),
      results['motherNumberOfSimilarFragments'].toString(),
      results['motherNumberOfAbbreviatedFragments'].toString(),
      results['motherAverageNumberOfFragments'].toString(),

      // CdR Criteria (Dates)
      results['datesEqual'].toString(),
      results['datesOneDigitSwapped'].toString(),
      results['datesReversedDay'].toString(),
      results['levenshteinDistanceDate'].toString(),

      // Classification (if any)
      results['classification'],
    ];
  }

  static List<String> get getResultHeader => [
    // Original Data
    'Name A',
    'Mother\'s Name A',
    'Birth Date A',
    'Gender A',
    'Name B',
    'Mother\'s Name B',
    'Birth Date B',
    'Gender B',

    // CdR Criteria (Names)
    'firstFragmentEqual',
    'lastFragmentEqual',
    'numberOfEqualFragments',
    'numberOfRareFragments',
    'numberOfCommonFragments',
    'numberOfSimilarFragments',
    'numberOfAbbreviatedFragments',
    'averageNumberOfFragments',

    // CdR Criteria (Mother's Name)
    'motherFirstFragmentEqual',
    'motherLastFragmentEqual',
    'motherNumberOfEqualFragments',
    'motherNumberOfRareFragments',
    'motherNumberOfCommonFragments',
    'motherNumberOfSimilarFragments',
    'motherNumberOfAbbreviatedFragments',
    'motherAverageNumberOfFragments',

    // CdR Criteria (Dates)
    'datesEqual',
    'datesOneDigitSwapped',
    'datesReversedDay',
    'levenshteinDistanceDate',

    // Classification
    'classification',
  ];
}