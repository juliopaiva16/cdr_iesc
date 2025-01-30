class Arguments {

  // We need the the input path, the output path, and the map of column indices
  // to be passed to the comparision_loader screen. We can create a class to
  // hold these arguments.
  //
  // The class Arguments will have three fields: inputPath, outputPath, and
  // columns. The inputPath and outputPath will be of type String, and columns
  // will be of type Map<String, int>. The class will have a constructor that
  // initializes the fields with the provided values. The class will also have
  // a method toMap that returns a map with the fields as keys and their values
  // as values. This method will be used to pass the arguments to the
  // comparision_loader screen.

  String inputPath;
  String outputPath;
  Map<String, int?> columns;

  Arguments({
    required this.inputPath,
    required this.outputPath,
    required this.columns,
  });

  Map<String, dynamic> toMap() {
    return {
      'inputPath': inputPath,
      'outputPath': outputPath,
      'columns': columns,
    };
  }
}