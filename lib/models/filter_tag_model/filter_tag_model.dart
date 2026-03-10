class FilterTagModel {
  int? status;
  String? message;
  List<FilterTagData>? data;

  FilterTagModel({this.status, this.message, this.data});

  FilterTagModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FilterTagData>[];
      json['data'].forEach((v) {
        data!.add(FilterTagData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterTagData {
  int? id;
  String? title;
  String? keywords;
  String? content;
  String? documentUrl;
  String? image;
  int? createdBy;
  String? createdAt;
  String? updatedAt;

  FilterTagData(
      {this.id,
        this.title,
        this.keywords,
        this.content,
        this.documentUrl,
        this.image,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  FilterTagData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    keywords = json['keywords'];
    content = json['content'];
    documentUrl = json['document_url'];
    image = json['image'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
