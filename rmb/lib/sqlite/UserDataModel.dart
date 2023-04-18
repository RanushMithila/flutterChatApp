class UserDataModel {
  final int userid;
  final String username;
  final String icon;

  UserDataModel({
    required this.userid,
    required this.username,
    required this.icon,
  });

  factory UserDataModel.fromMap(Map<String, dynamic> json) => UserDataModel(
        userid: json["userid"],
        username: json["username"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "username": username,
        "icon": icon,
      };
}
