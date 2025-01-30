import 'dart:math';

class Paciente {
  String nome;
  String nomeMae;
  String dataNascimento;
  String sexo;

  Paciente(this.nome, this.nomeMae, this.dataNascimento, this.sexo);
}

// Função para comparar o primeiro fragmento dos nomes
int primeiroFragmentoIgual(String nome1, String nome2) {
  List<String> nomes1 = nome1.split(' ');
  List<String> nomes2 = nome2.split(' ');
  return nomes1[0] == nomes2[0] ? 1 : 0;
}

// Função para comparar o último fragmento dos nomes
int ultimoFragmentoIgual(String nome1, String nome2) {
  List<String> nomes1 = nome1.split(' ');
  List<String> nomes2 = nome2.split(' ');
  return nomes1.last == nomes2.last ? 1 : 0;
}

// Função para calcular a quantidade de fragmentos iguais
double quantidadeFragmentosIguais(String nome1, String nome2) {
  List<String> nomes1 = nome1.split(' ');
  List<String> nomes2 = nome2.split(' ');
  int iguais = 0;
  for (var fragmento1 in nomes1) {
    if (nomes2.contains(fragmento1)) iguais++;
  }
  return iguais / (nomes1.length + nomes2.length);
}

// Função para calcular a quantidade de fragmentos raros
double quantidadeFragmentosRaros(String nome1, String nome2) {
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
}

// Função para calcular a quantidade de fragmentos comuns
double quantidadeFragmentosComuns(String nome1, String nome2) {
  List<String> nomes1 = nome1.split(' ');
  List<String> nomes2 = nome2.split(' ');
  int comuns = 0;
  for (var fragmento1 in nomes1) {
    if (nomes2.contains(fragmento1)) comuns++;
  }
  return -comuns / (nomes1.length + nomes2.length);
}

// Função para comparar se os nomes são parecidos usando Soundex
double quantidadeFragmentosParecidos(String nome1, String nome2) {
  // Aqui seria necessário implementar ou usar uma função Soundex
  return 0.8; // Exemplo fixo, substitua pelo cálculo real
}

// Função para verificar abreviações
double quantidadeFragmentosAbreviados(String nome1, String nome2) {
  // Implementação simples para identificar abreviações
  return 0.5; // Exemplo fixo, substitua pelo cálculo real
}

// Função para calcular a quantidade média de fragmentos
int quantidadeMediaFragmentos(String nome1, String nome2) {
  return (nome1.split(' ').length + nome2.split(' ').length) ~/ 2;
}

// Função para verificar se as datas são iguais
int datasIguais(String data1, String data2) {
  return data1 == data2 ? 1 : 0;
}

// Função para verificar se há apenas um dígito trocado nas datas
int datasUmDigitoTrocado(String data1, String data2) {
  int diffs = 0;
  for (int i = 0; i < data1.length; i++) {
    if (data1[i] != data2[i]) diffs++;
  }
  return diffs == 1 ? 1 : 0;
}

// Função para verificar se as datas estão invertidas
int datasInversoDia(String data1, String data2) {
  var dia1 = data1.substring(6, 8);
  var mes1 = data1.substring(4, 6);
  var ano1 = data1.substring(0, 4);
  var dia2 = data2.substring(6, 8);
  var mes2 = data2.substring(4, 6);
  var ano2 = data2.substring(0, 4);
  return (dia1 == mes2 && mes1 == dia2 && ano1 == ano2) ? 1 : 0;
}

// Função para aplicar a distância de Levenshtein nas datas
double distanciaLevenshteinData(String data1, String data2) {
  int dist = levenshtein(data1, data2);
  return (1 - dist / 8);
}

// Função de distância de Levenshtein (algoritmo básico)
int levenshtein(String a, String b) {
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
}


class Compare {
  Paciente pacienteA;
  Paciente pacienteB;

  Compare({
    required this.pacienteA,
    required this.pacienteB,
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
      'primeiroFragmentoIgual': primeiroFragmentoIgual(pacienteA.nome, pacienteB.nome),
      'ultimoFragmentoIgual': ultimoFragmentoIgual(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosIguais': quantidadeFragmentosIguais(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosRaros': quantidadeFragmentosRaros(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosComuns': quantidadeFragmentosComuns(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosParecidos': quantidadeFragmentosParecidos(pacienteA.nome, pacienteB.nome),
      'quantidadeFragmentosAbreviados': quantidadeFragmentosAbreviados(pacienteA.nome, pacienteB.nome),
      'quantidadeMediaFragmentos': quantidadeMediaFragmentos(pacienteA.nome, pacienteB.nome),
      'maePrimeiroFragmentoIgual': primeiroFragmentoIgual(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeUltimoFragmentoIgual': ultimoFragmentoIgual(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosIguais': quantidadeFragmentosIguais(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosRaros': quantidadeFragmentosRaros(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosComuns': quantidadeFragmentosComuns(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosParecidos': quantidadeFragmentosParecidos(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeFragmentosAbreviados': quantidadeFragmentosAbreviados(pacienteA.nomeMae, pacienteB.nomeMae),
      'maeQuantidadeMediaFragmentos': quantidadeMediaFragmentos(pacienteA.nomeMae, pacienteB.nomeMae),
      'datasIguais': datasIguais(pacienteA.dataNascimento, pacienteB.dataNascimento),
      'datasUmDigitoTrocado': datasUmDigitoTrocado(pacienteA.dataNascimento, pacienteB.dataNascimento),
      'datasInversoDia': datasInversoDia(pacienteA.dataNascimento, pacienteB.dataNascimento),
      'distanciaLevenshteinData': distanciaLevenshteinData(pacienteA.dataNascimento, pacienteB.dataNascimento),
    };
  }

  List<String> getResultLine() {
    var results = runComparision();
    return [
      pacienteA.nome,
      pacienteA.nomeMae,
      pacienteA.dataNascimento,
      pacienteB.nome,
      pacienteB.nomeMae,
      pacienteB.dataNascimento,
      results['primeiroFragmentoIgual'].toString(),
      results['ultimoFragmentoIgual'].toString(),
      results['quantidadeFragmentosIguais'].toString(),
      results['quantidadeFragmentosRaros'].toString(),
      results['quantidadeFragmentosComuns'].toString(),
      results['quantidadeFragmentosParecidos'].toString(),
      results['quantidadeFragmentosAbreviados'].toString(),
      results['quantidadeMediaFragmentos'].toString(),
      results['maePrimeiroFragmentoIgual'].toString(),
      results['maeUltimoFragmentoIgual'].toString(),
      results['maeQuantidadeFragmentosIguais'].toString(),
      results['maeQuantidadeFragmentosRaros'].toString(),
      results['maeQuantidadeFragmentosComuns'].toString(),
      results['maeQuantidadeFragmentosParecidos'].toString(),
      results['maeQuantidadeFragmentosAbreviados'].toString(),
      results['maeQuantidadeMediaFragmentos'].toString(),
      results['datasIguais'].toString(),
      results['datasUmDigitoTrocado'].toString(),
      results['datasInversoDia'].toString(),
      results['distanciaLevenshteinData'].toString(),
    ];
  }

  List<String> get getResultHeader => [
    'Nome A',
    'Nome da Mãe A',
    'Data de Nascimento A',
    'Nome B',
    'Nome da Mãe B',
    'Data de Nascimento B',
    'primeiroFragmentoIgual',
    'ultimoFragmentoIgual',
    'quantidadeFragmentosIguais',
    'quantidadeFragmentosRaros',
    'quantidadeFragmentosComuns',
    'quantidadeFragmentosParecidos',
    'quantidadeFragmentosAbreviados',
    'quantidadeMediaFragmentos',
    'maePrimeiroFragmentoIgual',
    'maeUltimoFragmentoIgual',
    'maeQuantidadeFragmentosIguais',
    'maeQuantidadeFragmentosRaros',
    'maeQuantidadeFragmentosComuns',
    'maeQuantidadeFragmentosParecidos',
    'maeQuantidadeFragmentosAbreviados',
    'maeQuantidadeMediaFragmentos',
    'datasIguais',
    'datasUmDigitoTrocado',
    'datasInversoDia',
    'distanciaLevenshteinData',
  ];
}
