class TimeLogStartModel {
  String? status;
  String? message;
  Data? data;

  TimeLogStartModel({this.status, this.message, this.data});

  TimeLogStartModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message'];

    if (json['data'] is Map<String, dynamic>) {
      data = Data.fromJson(json['data']);
    } else if (json['data'] is List && json['data'].isNotEmpty) {
      data = Data.fromJson(json['data'][0]);
    } else {
      data = null;
    }
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
  int? userId;
  String? eventId;
  String? startTime;
  String? workType;
  String? status;
  String? submittedAt;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({
    this.userId,
    this.eventId,
    this.startTime,
    this.workType,
    this.status,
    this.submittedAt,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    eventId = json['event_id'];
    startTime = json['start_time'];
    workType = json['work_type'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['event_id'] = eventId;
    data['start_time'] = startTime;
    data['work_type'] = workType;
    data['status'] = status;
    data['submitted_at'] = submittedAt;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
