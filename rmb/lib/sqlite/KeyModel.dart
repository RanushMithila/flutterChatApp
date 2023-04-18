class KeyModel {
  final int? id;
  final String privateKey;
  final String publicKey;

  KeyModel({
    this.id,
    required this.privateKey,
    required this.publicKey,
  });

  factory KeyModel.fromMap(Map<String, dynamic> json) => KeyModel(
        id: json["id"],
        privateKey: json["privateKey"],
        publicKey: json["publicKey"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "privateKey": privateKey,
        "publicKey": publicKey,
      };
}
