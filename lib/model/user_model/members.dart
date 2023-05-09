class MembersModel {
  String? id;
  String? name;
  String? age;
  String? email;

  MembersModel({this.id, this.name, this.age, this.email});

  MembersModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json['name'];
    age = json['age'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data["id"] = this.id;
    data['email'] = this.email;
    return data;
  }
}
