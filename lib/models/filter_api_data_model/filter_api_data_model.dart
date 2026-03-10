class ResourceFilterModel {
  int? status;
  String? message;
  ResourceFilterData? data;

  ResourceFilterModel({this.status, this.message, this.data});

  ResourceFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ResourceFilterData.fromJson(json['data']) : null;
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

class ResourceFilterData {
  List<Resources>? resources;

  ResourceFilterData({this.resources});

  ResourceFilterData.fromJson(Map<String, dynamic> json) {
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
  int? resourceCategoryId;
  int? isShow;
  int? createdBy;
  String? createdAt;
  String? updatedAt;

  Resources(
      {this.id,
        this.title,
        this.keywords,
        this.content,
        this.documentUrl,
        this.image,
        this.resourceCategoryId,
        this.isShow,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  Resources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    keywords = json['keywords'];
    content = json['content'];
    documentUrl = json['document_url'];
    image = json['image'];
    resourceCategoryId = json['resource_category_id'];
    isShow = json['is_show'];
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
    data['resource_category_id'] = resourceCategoryId;
    data['is_show'] = isShow;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class EventFilterModel {
  int? status;
  String? message;
  EventFilterData? data;

  EventFilterModel({this.status, this.message, this.data});

  EventFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? EventFilterData.fromJson(json['data']) : null;
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

class EventFilterData {
  List<Events>? events;

  EventFilterData({this.events});

  EventFilterData.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int? id;
  String? name;
  String? description;
  String? location;
  String? eventDate;
  String? startTime;
  String? endTime;
  int? isPointsEvent;
  String? image;
  int? isShow;
  int? createdBy;
  int? eventCategoryId;
  String? createdAt;
  String? updatedAt;

  Events(
      {this.id,
        this.name,
        this.description,
        this.location,
        this.eventDate,
        this.startTime,
        this.endTime,
        this.isPointsEvent,
        this.image,
        this.isShow,
        this.createdBy,
        this.eventCategoryId,
        this.createdAt,
        this.updatedAt});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    location = json['location'];
    eventDate = json['event_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isPointsEvent = json['is_points_event'];
    image = json['image'];
    isShow = json['is_show'];
    createdBy = json['created_by'];
    eventCategoryId = json['event_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['location'] = location;
    data['event_date'] = eventDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['is_points_event'] = isPointsEvent;
    data['image'] = image;
    data['is_show'] = isShow;
    data['created_by'] = createdBy;
    data['event_category_id'] = eventCategoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

