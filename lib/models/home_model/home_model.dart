import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));
String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  String? status;
  String? message;
  HomeData? data;

  HomeModel({
    this.status,
    this.message,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : HomeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class HomeData {
  List<HomeResources>? resources;
  List<HomeEvents>? events;
  List<EventCategory>? eventCategories;
  List<ResourceCategory>? resourceCategories;

  HomeData({
    this.resources,
    this.events,
    this.eventCategories,
    this.resourceCategories,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    resources: json["resources"] == null
        ? []
        : List<HomeResources>.from(
        json["resources"].map((x) => HomeResources.fromJson(x))),
    events: json["events"] == null
        ? []
        : List<HomeEvents>.from(json["events"].map((x) => HomeEvents.fromJson(x))),
    eventCategories: json["event_categories"] == null
        ? []
        : List<EventCategory>.from(
        json["event_categories"].map((x) => EventCategory.fromJson(x))),
    resourceCategories: json["resource_categories"] == null
        ? []
        : List<ResourceCategory>.from(json["resource_categories"]
        .map((x) => ResourceCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "resources": resources == null
        ? []
        : List<dynamic>.from(resources!.map((x) => x.toJson())),
    "events": events == null
        ? []
        : List<dynamic>.from(events!.map((x) => x.toJson())),
    "event_categories": eventCategories == null
        ? []
        : List<dynamic>.from(eventCategories!.map((x) => x.toJson())),
    "resource_categories": resourceCategories == null
        ? []
        : List<dynamic>.from(resourceCategories!.map((x) => x.toJson())),
  };
}

class HomeResources {
  int? id;
  String? title;
  String? keywords;
  String? content;
  String? documentUrl;
  String? image;
  int? resourceCategoryId;
  int? isShow;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  HomeResources({
    this.id,
    this.title,
    this.keywords,
    this.content,
    this.documentUrl,
    this.image,
    this.resourceCategoryId,
    this.isShow,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory HomeResources.fromJson(Map<String, dynamic> json) => HomeResources(
    id: json["id"],
    title: json["title"],
    keywords: json["keywords"],
    content: json["content"],
    documentUrl: json["document_url"],
    image: json["image"],
    resourceCategoryId: json["resource_category_id"],
    isShow: json["is_show"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "keywords": keywords,
    "content": content,
    "document_url": documentUrl,
    "image": image,
    "resource_category_id": resourceCategoryId,
    "is_show": isShow,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class HomeEvents {
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
  DateTime? createdAt;
  DateTime? updatedAt;

  HomeEvents({
    this.id,
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
    this.updatedAt,
  });

  factory HomeEvents.fromJson(Map<String, dynamic> json) => HomeEvents(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    location: json["location"],
    eventDate: json["event_date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    isPointsEvent: json["is_points_event"],
    image: json["image"],
    isShow: json["is_show"],
    createdBy: json["created_by"],
    eventCategoryId: json["event_category_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "location": location,
    "event_date": eventDate,
    "start_time": startTime,
    "end_time": endTime,
    "is_points_event": isPointsEvent,
    "image": image,
    "is_show": isShow,
    "created_by": createdBy,
    "event_category_id": eventCategoryId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class EventCategory {
  int? id;
  String? name;

  EventCategory({
    this.id,
    this.name,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) => EventCategory(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class ResourceCategory {
  int? id;
  String? name;

  ResourceCategory({
    this.id,
    this.name,
  });

  factory ResourceCategory.fromJson(Map<String, dynamic> json) =>
      ResourceCategory(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
