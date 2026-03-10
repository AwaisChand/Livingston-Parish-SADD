class AllResourceModel {
  String? status;
  String? message;
  Data? data;

  AllResourceModel({this.status, this.message, this.data});

  AllResourceModel.fromJson(Map<String, dynamic> json) {
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
  List<Resources>? resources;

  Data({this.resources});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['resources'] != null) {
      resources = <Resources>[];
      json['resources'].forEach((v) {
        resources!.add(Resources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resources != null) {
      data['resources'] = resources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Resources {
  int? id;
  String? title;
  String? keywords;
  String? content;
  String? documentUrl;
  String? image;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  User? user;

  Resources(
      {this.id,
        this.title,
        this.keywords,
        this.content,
        this.documentUrl,
        this.image,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.user});

  Resources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    keywords = json['keywords'];
    content = json['content'];
    documentUrl = json['document_url'];
    image = json['image'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['keywords'] = keywords;
    data['content'] = content;
    data['document_url'] = documentUrl;
    data['image'] = image;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? fullName;

  User({this.id, this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    return data;
  }
}
