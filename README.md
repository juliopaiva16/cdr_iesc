## Novo Comparador de Registros (CdR2)
Este projeto é uma aplicação Flutter que permite aos usuários selecionar arquivos CSV, e comparar colunas de nomes e datas de nascimento entre dois pacientes de um provável link. A aplicação oferece uma interface gráfica para selecionar arquivos, visualizar seu conteúdo e configurar as colunas a serem comparadas.

### Funcionalidades Principais
**Seleção de Arquivos CSV:** Permite ao usuário selecionar um arquivo CSV de entrada.
**Geração de Arquivo CSV de Saída:** Gera um caminho de arquivo de saída com base no arquivo de entrada e na data/hora atual.
**Visualização de Arquivo CSV:** Exibe o conteúdo do arquivo CSV selecionado em uma tabela.
**Seleção de Colunas:** Permite ao usuário selecionar quais colunas do arquivo CSV de entrada serão comparadas.
**Comparação de Dados:** Compara as colunas selecionadas entre dois conjuntos de dados e gera um arquivo CSV de saída com os resultados da comparação.


### Estrutura do Projeto
1. main.dart
Arquivo principal que inicializa a aplicação Flutter e define as rotas para as diferentes telas.

2. home.dart
Tela principal da aplicação onde o usuário pode selecionar o arquivo CSV de entrada, gerar o arquivo de saída e selecionar as colunas a serem comparadas.

3. csv_viewer.dart
Widget que exibe o conteúdo do arquivo CSV selecionado em uma tabela.

4. comparation_loader.dart
Tela que realiza a comparação dos dados entre os arquivos CSV selecionados e exibe o resultado da comparação.

5. arguments.dart
Classe que define os argumentos necessários para a tela de comparação, incluindo o caminho do arquivo de entrada, o caminho do arquivo de saída e o mapa de colunas.

6. csv.dart
Classe que lida com a leitura, validação e comparação dos dados dos arquivos CSV. Inclui utilitários para validar formatos de data, nome e endereço.

7. compare.dart
Classe que define os critérios de comparação entre os dados dos pacientes, incluindo fragmentos de nomes, datas de nascimento e outros critérios específicos.

### Como Funciona

#### Seleção do Arquivo CSV de Entrada:

O usuário seleciona um arquivo CSV de entrada usando um seletor de arquivos.
O caminho do arquivo selecionado é armazenado na variável _csvInputPath.

#### Geração do Caminho do Arquivo CSV de Saída:

O caminho do arquivo de saída é gerado automaticamente com base no nome do arquivo de entrada e na data/hora atual.
O caminho do arquivo de saída é armazenado na variável _csvOutputPath.

#### Visualização do Arquivo CSV:

O conteúdo do arquivo CSV de entrada é exibido em uma tabela, mostrando as primeiras 8 linhas e o cabeçalho.

#### Seleção de Colunas:

O usuário pode selecionar quais colunas do arquivo CSV de entrada serão comparadas.
As colunas selecionadas são armazenadas em um mapa chamado columns.

#### Comparação dos Dados:

Os dados das colunas selecionadas são comparados entre dois conjuntos de dados.
Os resultados da comparação são salvos em um arquivo CSV de saída.
Exemplo de Uso

#### Iniciar a Aplicação:

Execute o comando flutter run para iniciar a aplicação.

#### Selecionar o Arquivo CSV de Entrada:

Clique no botão "Select CSV Input File" e selecione o arquivo CSV de entrada.

#### Gerar o Caminho do Arquivo CSV de Saída:

Clique no botão "Generate CSV Output File" para gerar o caminho do arquivo de saída.

#### Visualizar o Arquivo CSV:

O conteúdo do arquivo CSV de entrada será exibido em uma tabela.

#### Selecionar as Colunas para Comparação:

Clique no botão "Select Columns" e selecione as colunas a serem comparadas.

#### Realizar a Comparação:

Clique no botão "Save" para iniciar a comparação dos dados.
O resultado da comparação será salvo no arquivo CSV de saída.
