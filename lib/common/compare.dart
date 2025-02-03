import 'dart:math';

class Paciente {
  String nome;
  String nomeMae;
  String dataNascimento;
  String sexo;

  Paciente({
    required this.nome,
    required this.nomeMae,
    required this.dataNascimento,
    required this.sexo,
  });
}

// Função para comparar o primeiro fragmento dos nomes
int primeiroFragmentoIgual(String nome1, String nome2) {
  try {
    List<String> nomes1 = nome1.split(' ');
    List<String> nomes2 = nome2.split(' ');
    return nomes1[0] == nomes2[0] ? 1 : 0;
  } catch (e) {
    print('Erro ao comparar primeiro fragmento: $e');
    return 0;
  }
}

// Função para comparar o último fragmento dos nomes
int ultimoFragmentoIgual(String nome1, String nome2) {
  try {
    List<String> nomes1 = nome1.split(' ');
    List<String> nomes2 = nome2.split(' ');
    return nomes1.last == nomes2.last ? 1 : 0;
  } catch (e) {
    print('Erro ao comparar ultimo fragmento: $e');
    return 0;
  }
}

// Função para calcular a quantidade de fragmentos iguais
double quantidadeFragmentosIguais(String nome1, String nome2) {
  try {
    List<String> nomes1 = nome1.split(' ');
    List<String> nomes2 = nome2.split(' ');
    int iguais = 0;
    for (var fragmento1 in nomes1) {
      if (nomes2.contains(fragmento1)) iguais++;
    }
    return iguais / (nomes1.length + nomes2.length);
  } catch (e) {
    print('Erro ao comparar quantidade de fragmentos iguais: $e');
    return 0;
  }
}

// Função para calcular a quantidade de fragmentos raros
double quantidadeFragmentosRaros(String nome1, String nome2) {
  try {
    // Suponhamos que nomes raros sejam palavras com 3 ou mais caracteres
    List<String> nomes1 = nome1.split(' ');
    List<String> nomes2 = nome2.split(' ');
    int raros = 0;
    for (var fragmento1 in nomes1) {
      if (fragmento1.length >= 3 && !nomes2.contains(fragmento1)) raros++;
    }
    for (var fragmento2 in nomes2) {
      if (fragmento2.length >= 3 && !nomes1.contains(fragmento2)) raros++;
    }
    return raros / (nomes1.length + nomes2.length);
  } catch (e) {
    print('Erro ao comparar quantidade de fragmentos raros: $e');
    return 0;
  }
}

// Função para calcular a quantidade de fragmentos comuns
double quantidadeFragmentosComuns(String nome1, String nome2) {
  try {
    List<String> nomes1 = nome1.split(' ');
    List<String> nomes2 = nome2.split(' ');
    int comuns = 0;
    for (var fragmento1 in nomes1) {
      if (nomes2.contains(fragmento1)) comuns++;
    }
    return -comuns / (nomes1.length + nomes2.length);
  } catch (e) {
    print('Erro ao comparar quantidade de fragmentos comuns: $e');
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

    // Mapeamento fonético para português
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

    // Codificar primeira letra
    result += chars[0];

    // Codificar caracteres restantes
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

    // Completar com zeros e limitar a 4 caracteres
    result = result.replaceAll(' ', '');
    result = result.padRight(4, '0').substring(0, 4);

    return result;
  } catch (e) {
    print('Erro ao calcular soundex: $e');
    return '';
  }
}
double quantidadeFragmentosParecidos(String nome1, String nome2) {
  try {
    List<String> fragments1 = nome1.split(' ');
    List<String> fragments2 = nome2.split(' ');

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
    print('Erro ao comparar quantidade de fragmentos parecidos: $e');
    return 0;
  }
}

// Função para verificar abreviações
double quantidadeFragmentosAbreviados(String nome1, String nome2) {
  try {
    final RegExp abbrevRegex = RegExp(r'^[A-Za-z]\.$');

    List<String> fragments1 = nome1.split(' ');
    List<String> fragments2 = nome2.split(' ');

    int abbrevCount = 0;

    // Contar abreviações em ambos os nomes
    abbrevCount += fragments1.where((f) => abbrevRegex.hasMatch(f)).length;
    abbrevCount += fragments2.where((f) => abbrevRegex.hasMatch(f)).length;

    // Calcular razão pelo tamanho do primeiro nome (paciente A)
    int tamanhoPrimeiroNome = fragments1.isNotEmpty ? fragments1.length : 1;

    return (abbrevCount / tamanhoPrimeiroNome) * 0.5;
  } catch (e) {
    print('Erro ao comparar quantidade de fragmentos abreviados: $e');
    return 0;
  }
}

// Função para calcular a quantidade média de fragmentos
int quantidadeMediaFragmentos(String nome1, String nome2) {
  try {
    return (nome1.split(' ').length + nome2.split(' ').length) ~/ 2;
  } catch (e) {
    print('Erro ao calcular quantidade média de fragmentos: $e');
    return 0;
  }
}

// Função para verificar se as datas são iguais
int datasIguais(String data1, String data2) {
  try {
    return data1 == data2 ? 1 : 0;
  } catch (e) {
    print('Erro ao comparar datas iguais: $e');
    return 0;
  }
}

// Função para verificar se há apenas um dígito trocado nas datas
int datasUmDigitoTrocado(String data1, String data2) {
  try {
    int diffs = 0;
    for (int i = 0; i < data1.length; i++) {
      if (data1[i] != data2[i]) diffs++;
    }
    return diffs == 1 ? 1 : 0;
  } catch (e) {
    print('Erro ao comparar datas com um dígito trocado: $e');
    return 0;
  }
}

// Função para verificar se as datas estão invertidas
int datasInversoDia(String data1, String data2) {
  try {
    if (data1.length != 8 || data2.length != 8) return 0; // Validação
    var dia1 = data1.substring(6, 8);
    var mes1 = data1.substring(4, 6);
    var ano1 = data1.substring(0, 4);
    var dia2 = data2.substring(6, 8);
    var mes2 = data2.substring(4, 6);
    var ano2 = data2.substring(0, 4);
    return (dia1 == mes2 && mes1 == dia2 && ano1 == ano2) ? 1 : 0;
  } catch (e) {
    print('Erro ao comparar datas com dia invertido: $e');
    return 0;
  }
}

// Função para aplicar a distância de Levenshtein nas datas
double distanciaLevenshteinData(String data1, String data2) {
  try {
    int dist = levenshtein(data1, data2);
    return (1 - dist / 8);
  } catch (e) {
    print('Erro ao calcular distância de Levenshtein nas datas: $e');
    return 0;
  }
}

// Função de distância de Levenshtein (algoritmo básico)
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
    print('Erro ao calcular distância de Levenshtein: $e');
    return 0;
  }
}

class Compare {
  Paciente pacienteA;
  Paciente pacienteB;
  String classe;

  Compare({
    required this.pacienteA,
    required this.pacienteB,
    required this.classe,
  });

  // Cria uma mapa com os resultados de cada criterio para o par
  // Os criterios de nomes são:
  // primeiroFragmentoIgual
  // ultimoFragmentoIgual
  // quantidadeFragmentosIguais
  // quantidadeFragmentosRaros
  // quantidadeFragmentosComuns
  // quantidadeFragmentosParecidos
  // quantidadeFragmentosAbreviados
  // quantidadeMediaFragmentos
  // E devem ser executados para nome do paciente e nome da mãe
  // Os criterios de datas são:
  // datasIguais
  // datasUmDigitoTrocado
  // datasInversoDia
  // distanciaLevenshteinData
  Map<String, dynamic> runComparision() {
    return {
      'primeiroFragmentoIgual':
          primeiroFragmentoIgual(pacienteA.nome, pacienteB.nome),
      'ultimoFragmentoIgual':
          ultimoFragmentoIgual(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosIguais':
          quantidadeFragmentosIguais(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosRaros':
          quantidadeFragmentosRaros(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosComuns':
          quantidadeFragmentosComuns(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosParecidos':
          quantidadeFragmentosParecidos(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosAbreviados':
          quantidadeFragmentosAbreviados(pacienteA.nome, pacienteB.nome),
      'quantidadeMediaFragmentos':
          quantidadeMediaFragmentos(pacienteA.nome, pacienteB.nome),
      'maePrimeiroFragmentoIgual':
          primeiroFragmentoIgual(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeUltimoFragmentoIgual':
          ultimoFragmentoIgual(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosIguais':
          quantidadeFragmentosIguais(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosRaros':
          quantidadeFragmentosRaros(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosComuns':
          quantidadeFragmentosComuns(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosParecidos':
          quantidadeFragmentosParecidos(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosAbreviados':
          quantidadeFragmentosAbreviados(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeMediaFragmentos':
          quantidadeMediaFragmentos(pacienteA.nomeMae, pacienteB.nomeMae),
      'datasIguais':
          datasIguais(pacienteA.dataNascimento, pacienteB.dataNascimento),
      'datasUmDigitoTrocado': datasUmDigitoTrocado(
          pacienteA.dataNascimento, pacienteB.dataNascimento),
      'datasInversoDia':
          datasInversoDia(pacienteA.dataNascimento, pacienteB.dataNascimento),
      'distanciaLevenshteinData': distanciaLevenshteinData(
          pacienteA.dataNascimento, pacienteB.dataNascimento),
      'classe': classe,
    };
  }

  List<String> getResultLine() {
    var results = runComparision();
    return [
      // Dados Originais
      pacienteA.nome,
      pacienteA.nomeMae,
      pacienteA.dataNascimento,
      pacienteA.sexo,
      pacienteB.nome,
      pacienteB.nomeMae,
      pacienteB.dataNascimento,
      pacienteB.sexo,

      // Critérios CdR (Nomes)
      results['primeiroFragmentoIgual'].toString(),
      results['ultimoFragmentoIgual'].toString(),
      results['quantidadeFragmentosIguais'].toString(),
      results['quantidadeFragmentosRaros'].toString(),
      results['quantidadeFragmentosComuns'].toString(),
      results['quantidadeFragmentosParecidos'].toString(),
      results['quantidadeFragmentosAbreviados'].toString(),
      results['quantidadeMediaFragmentos'].toString(),

      // Critérios CdR (Nome da Mãe)
      results['maePrimeiroFragmentoIgual'].toString(),
      results['maeUltimoFragmentoIgual'].toString(),
      results['maeQuantidadeFragmentosIguais'].toString(),
      results['maeQuantidadeFragmentosRaros'].toString(),
      results['maeQuantidadeFragmentosComuns'].toString(),
      results['maeQuantidadeFragmentosParecidos'].toString(),
      results['maeQuantidadeFragmentosAbreviados'].toString(),
      results['maeQuantidadeMediaFragmentos'].toString(),

      // Critérios CdR (Datas)
      results['datasIguais'].toString(),
      results['datasUmDigitoTrocado'].toString(),
      results['datasInversoDia'].toString(),
      results['distanciaLevenshteinData'].toString(),

      // Classe (se houver)
      results['classe'],
    ];
  }

  static List<String> get getResultHeader => [
    // Dados Originais
    'Nome A',
    'Nome da Mãe A',
    'Data de Nascimento A',
    'Sexo A',
    'Nome B',
    'Nome da Mãe B',
    'Data de Nascimento B',
    'Sexo B',

    // Critérios CdR (Nomes)
    'primeiroFragmentoIgual',
    'ultimoFragmentoIgual',
    'quantidadeFragmentosIguais',
    'quantidadeFragmentosRaros',
    'quantidadeFragmentosComuns',
    'quantidadeFragmentosParecidos',
    'quantidadeFragmentosAbreviados',
    'quantidadeMediaFragmentos',

    // Critérios CdR (Nome da Mãe)
    'maePrimeiroFragmentoIgual',
    'maeUltimoFragmentoIgual',
    'maeQuantidadeFragmentosIguais',
    'maeQuantidadeFragmentosRaros',
    'maeQuantidadeFragmentosComuns',
    'maeQuantidadeFragmentosParecidos',
    'maeQuantidadeFragmentosAbreviados',
    'maeQuantidadeMediaFragmentos',

    // Critérios CdR (Datas)
    'datasIguais',
    'datasUmDigitoTrocado',
    'datasInversoDia',
    'distanciaLevenshteinData',

    // Classe
    'classe',
  ];
}
