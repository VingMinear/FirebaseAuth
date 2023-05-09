// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? id;
  String? name;
  String? email;
  String? photo;
  String? provide;
  UserModel({
    this.id,
    this.name,
    this.email,
    this.photo,
    this.provide,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    provide = json["provide"];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['proide'] = this.provide;
    data['email'] = this.email;
    data['photo'] = this.photo;
    return data;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photo: $photo, provide: $provide)';
  }
}
