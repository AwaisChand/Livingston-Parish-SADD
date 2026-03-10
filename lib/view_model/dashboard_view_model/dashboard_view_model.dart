import 'package:dp_sad/models/points_model/points_model.dart';
import 'package:dp_sad/repository/dashboard_repository/dashboard_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/dashboard_model/dashboard_model.dart';
import '../../utils/utils.dart';
import '../auth_view_model/auth_view_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository authRepository = DashboardRepository();

  DashboardModel? _dashboardModel;
  DashboardModel? get dashboardModel => _dashboardModel;

  List<RegisteredEvent>? _registerEvent;
  List<RegisteredEvent>? get registerEvent => _registerEvent;

  List<Event>? _event;
  List<Event>? get event => _event;

  List<Event>? _activeEvents;
  List<Event>? get activeEvents => _activeEvents;

  PointsModel? _pointsModel;
  PointsModel? get pointsModel => _pointsModel;

  List<Points> _points = [];
  List<Points> get points => _points;

  bool _dashboardLoading = false;
  bool get dashboardLoading => _dashboardLoading;

  set dashboard(bool setLoading) {
    _dashboardLoading = setLoading;
    notifyListeners();
  }

  Future<void> getDashboardData(BuildContext context) async {
    dashboard = true;
    try {
      final response = await authRepository.dashBoard();
      final authProvider = context.read<AuthViewModel>();

      if (response.status == "1") {
        _dashboardModel = response;
        _registerEvent = response.data.registeredEventList;

        // Show all if logged in, otherwise filter where isShow == 1
        final allCurrentWeekEvents = response.data.currentWeekEvents;
        final allActiveEvents = response.data.activeEvents;

        _event =
            authProvider.isLoggedIn
                ? allCurrentWeekEvents
                : allCurrentWeekEvents.where((e) => e.isShow == 1).toList();

        _activeEvents =
            authProvider.isLoggedIn
                ? allActiveEvents
                : allActiveEvents.where((e) => e.isShow == 1).toList();

        Utils.toastMessage(response.message);
      } else {
        Utils.toastMessage(response.message);
      }

      if (kDebugMode) {
        debugPrint("Dashboard API Response: $response");
      }
    } catch (e, stackTrace) {
      debugPrint("Dashboard error: $e");
      debugPrint("Dashboard stack error: $stackTrace");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      dashboard = false;
    }
  }

  Future<void> getPointsAPi(BuildContext context) async {
    dashboard = true;
    try {
      final response = await authRepository.getPointsRepo();

      if (response.status == "1") {
        _pointsModel = response;
        _points = response.data!.points!;
        Utils.toastMessage(response.message ?? '');
      } else {
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Get Points Detail API Response: $response");
      }
    } catch (e, stackTrace) {
      debugPrint("Points error: $e");
      debugPrint("Points stack error: $stackTrace");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      dashboard = false;
    }
  }
}
