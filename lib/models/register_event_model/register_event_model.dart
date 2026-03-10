class RegisterEventModel {
  String? status;
  String? message;
  Data? data;

  RegisterEventModel({this.status, this.message, this.data});

  RegisterEventModel.fromJson(Map<String, dynamic> json) {
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
  Event? event;

  Data({this.event});

  Data.fromJson(Map<String, dynamic> json) {
    event = json['event'] != null ? Event.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (event != null) {
      data['event'] = event!.toJson();
    }
    return data;
  }
}

class Event {
  int? id;
  String? name;
  String? description;
  String? location;
  String? eventDate;
  String? startTime;
  String? endTime;
  int? isPointsEvent;
  String? image;
  int? createdBy;
  String? createdAt;
  String? updatedAt;

  Event({
    this.id,
    this.name,
    this.description,
    this.location,
    this.eventDate,
    this.startTime,
    this.endTime,
    this.isPointsEvent,
    this.image,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    location = json['location'];
    eventDate = json['event_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isPointsEvent = json['is_points_event'];
    image = json['image'];
    createdBy = json['created_by'];
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
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
