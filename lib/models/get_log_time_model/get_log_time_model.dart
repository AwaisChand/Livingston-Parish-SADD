class GetLogTimeModel {
  String? status;
  String? message;
  Data? data;

  GetLogTimeModel({this.status, this.message, this.data});

  GetLogTimeModel.fromJson(Map<String, dynamic> json) {
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
  ActiveEntry? activeEntry;
  List<TimeEntries>? timeEntries;

  Data({this.activeEntry, this.timeEntries});

  Data.fromJson(Map<String, dynamic> json) {
    activeEntry = json['active_entry'] != null
        ? ActiveEntry.fromJson(json['active_entry'])
        : null;
    if (json['time_entries'] != null) {
      timeEntries = <TimeEntries>[];
      json['time_entries'].forEach((v) {
        timeEntries!.add(TimeEntries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (activeEntry != null) {
      data['active_entry'] = activeEntry!.toJson();
    }
    if (timeEntries != null) {
      data['time_entries'] = timeEntries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActiveEntry {
  int? id;
  int? userId;
  String? startTime;
  Null endTime;
  Null totalHours;
  String? workType;
  String? status;
  String? submittedAt;
  int? eventId;
  String? updatedAt;
  String? createdAt;

  ActiveEntry(
      {this.id,
        this.userId,
        this.startTime,
        this.endTime,
        this.totalHours,
        this.workType,
        this.status,
        this.submittedAt,
        this.eventId,
        this.updatedAt,
        this.createdAt});

  ActiveEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalHours = json['total_hours'];
    workType = json['work_type'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    eventId = json['event_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['total_hours'] = totalHours;
    data['work_type'] = workType;
    data['status'] = status;
    data['submitted_at'] = submittedAt;
    data['event_id'] = eventId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}

class TimeEntries {
  int? id;
  int? userId;
  String? startTime;
  String? endTime;
  String? totalHours;
  String? workType;
  String? status;
  String? submittedAt;
  int? eventId;
  String? updatedAt;
  String? createdAt;

  TimeEntries(
      {this.id,
        this.userId,
        this.startTime,
        this.endTime,
        this.totalHours,
        this.workType,
        this.status,
        this.submittedAt,
        this.eventId,
        this.updatedAt,
        this.createdAt});

  TimeEntries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalHours = json['total_hours'];
    workType = json['work_type'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    eventId = json['event_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['total_hours'] = totalHours;
    data['work_type'] = workType;
    data['status'] = status;
    data['submitted_at'] = submittedAt;
    data['event_id'] = eventId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
