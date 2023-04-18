class DataModel {
  final int? id;
  final String type;
  final int sourseId;
  final int targetId;
  final String message;

  DataModel({
    this.id,
    required this.type,
    required this.sourseId,
    required this.targetId,
    required this.message,
  });

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        id: json["id"],
        type: json["type"],
        sourseId: json["sourseId"],
        targetId: json["targetId"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "sourseId": sourseId,
        "targetId": targetId,
        "message": message,
      };
}
