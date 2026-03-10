class UserModel {
  String? status;
  String? message;
  Data? data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  UserData? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? fullName;
  String? email;
  String? password;
  String? phoneNumber;
  String? role;
  String? image;
  String? status;
  String? dob;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? points;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;

  UserData(
      {this.id,
        this.fullName,
        this.email,
        this.password,
        this.phoneNumber,
        this.role,
        this.image,
        this.status,
        this.dob,
        this.address,
        this.city,
        this.state,
        this.zip,
        this.points,
        this.deviceToken,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    image = json['image'];
    status = json['status'];
    dob = json['dob'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    points = json['points'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    data['image'] = image;
    data['status'] = status;
    data['dob'] = dob;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['points'] = points;
    data['device_token'] = deviceToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
