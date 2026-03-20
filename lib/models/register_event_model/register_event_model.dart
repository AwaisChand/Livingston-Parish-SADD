class RegisterEventModel {
  String? status;
  String? message;
  Data? data;
  List<dynamic>? dataList; // for cases when API returns []

  RegisterEventModel({this.status, this.message, this.data, this.dataList});

  factory RegisterEventModel.fromJson(Map<String, dynamic> json) {
    Data? safeData;
    List<dynamic>? safeList;

    if (json['data'] is Map<String, dynamic>) {
      safeData = Data.fromJson(json['data']);
    } else if (json['data'] is List) {
      safeList = json['data'] as List<dynamic>;
    }

    return RegisterEventModel(
      status: json['status']?.toString(),
      message: json['message'],
      data: safeData,
      dataList: safeList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    if (dataList != null) map['data'] = dataList;
    return map;
  }
}

class Data {
  Event? event;

  Data({this.event});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (event != null) 'event': event!.toJson(),
  };
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

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    location: json['location'],
    eventDate: json['event_date'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    isPointsEvent: json['is_points_event'],
    image: json['image'],
    createdBy: json['created_by'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'location': location,
    'event_date': eventDate,
    'start_time': startTime,
    'end_time': endTime,
    'is_points_event': isPointsEvent,
    'image': image,
    'created_by': createdBy,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}