class DashboardModel {
  final String status;
  final String message;
  final DashboardData data;

  DashboardModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      status: json['status'],
      message: json['message'],
      data: DashboardData.fromJson(json['data']),
    );
  }
}

class DashboardData {
  final int eventRegistered;
  final List<RegisteredEvent> registeredEventList;
  final List<Event> activeEvents;
  final int activeEventsLength;
  final String totalHours;
  final List<Event> currentWeekEvents;

  DashboardData({
    required this.eventRegistered,
    required this.registeredEventList,
    required this.activeEvents,
    required this.activeEventsLength,
    required this.totalHours,
    required this.currentWeekEvents,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      eventRegistered: json['event_registered'],
      registeredEventList: List<RegisteredEvent>.from(
        json['registered_event_list'].map((x) => RegisteredEvent.fromJson(x)),
      ),
      activeEvents: List<Event>.from(
        json['active_events'].map((x) => Event.fromJson(x)),
      ),
      activeEventsLength: json['active_events_length'],

      totalHours: json['total_hours']?.toString() ?? "0",

      currentWeekEvents: List<Event>.from(
        json['current_week_events'].map((x) => Event.fromJson(x)),
      ),
    );
  }
}

class RegisteredEvent {
  final int id;
  final int eventId;
  final int userId;
  final String registrationDate;
  final String createdAt;
  final String updatedAt;
  final Event event;

  RegisteredEvent({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.registrationDate,
    required this.createdAt,
    required this.updatedAt,
    required this.event,
  });

  factory RegisteredEvent.fromJson(Map<String, dynamic> json) {
    return RegisteredEvent(
      id: json['id'],
      eventId: json['event_id'],
      userId: json['user_id'],
      registrationDate: json['registration_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      event: Event.fromJson(json['event']),
    );
  }
}

class Event {
  final int id;
  final String name;
  final String description;
  final String location;
  final String eventDate;
  final String startTime;
  final String endTime;
  final int isPointsEvent;
  final String image;
  final int isShow;
  final int createdBy;
  final String createdAt;
  final String updatedAt;
  final bool? isRegistered;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.isPointsEvent,
    required this.image,
    required this.isShow,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.isRegistered,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      eventDate: json['event_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isPointsEvent: json['is_points_event'],
      image: json['image'],
      isShow: json['is_show'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isRegistered: json['is_registered'] ?? false,
    );
  }
}
