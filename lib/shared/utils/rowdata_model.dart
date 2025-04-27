
class RowData {
  int id;
  String columnName;
  String range;
  String dataType;

  RowData({
    required this.id,
    required  this.columnName ,
    required this.dataType,
    required this.range,
  });

  factory RowData.fromJson(Map<String, dynamic> json) {
    return RowData(
      id: json['ID'],
      columnName: json['name'],
      dataType: json['Type'],
      range: json['Range'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'name': columnName,
      'Type': dataType,
      'Range': range,
    };
  }

    @override
  String toString() {
    // TODO: implement toString

    return '${id} variableName: '+columnName+
    ' DataType: '+dataType+' Range: '+range;

  }

}
