
  List<Map<String, String>> csv2json(String csv) {
    List<String> lines = csv.split('\n');
    if (lines.isEmpty) {
      return [];
    }

    List<String> headers =
    lines.first.split(',').map((header) => header.trim()).toList();
    List<Map<String, String>> jsonList = [];

    lines.skip(1).forEach((line) {
      List<String> values = _splitCsvLine(line);
      if (values.length == headers.length) {
        jsonList.add(Map<String, String>.fromIterables(headers, values));
      } else {
        print(
            'Skipping row: $line. Number of values does not match number of headers.');
      }
    });

    return jsonList;
  }

  List<String> _splitCsvLine(String line) {
    List<String> values = [];
    bool inQuotes = false;
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < line.length; i++) {
      String char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        values.add(buffer.toString().trim());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    values.add(buffer.toString().trim());
    return values;
  }
