class PointsModel {
  String? status;
  String? message;
  Data? data;

  PointsModel({this.status, this.message, this.data});

  PointsModel.fromJson(Map<String, dynamic> json) {
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
  int? earnPoints;
  int? pendingPoints;
  List<Points>? points;

  Data({this.earnPoints, this.pendingPoints, this.points});

  Data.fromJson(Map<String, dynamic> json) {
    earnPoints = json['earn_points'];
    pendingPoints = json['pending_points'];
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points!.add(Points.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['earn_points'] = earnPoints;
    data['pending_points'] = pendingPoints;
    if (points != null) {
      data['points'] = points!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Points {
  int? id;
  int? userId;
  int? eventId;
  String? points;
  int? status;
  String? createdAt;
  String? updatedAt;
  PointEvents? event;

  Points(
      {this.id,
        this.userId,
        this.eventId,
        this.points,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.event});

  Points.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    eventId = json['event_id'];
    points = json['points'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    event = json['event'] != null ? PointEvents.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['event_id'] = eventId;
    data['points'] = points;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (event != null) {
      data['event'] = event!.toJson();
    }
    return data;
  }
}

class PointEvents {
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
  String? createdAt;
  String? updatedAt;

  PointEvents(
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
        this.createdAt,
        this.updatedAt});

  PointEvents.fromJson(Map<String, dynamic> json) {
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
