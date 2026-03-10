import 'package:dp_sad/models/get_log_time_model/get_log_time_model.dart';
import 'package:dp_sad/repository/get_log_time_repository/get_log_time_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../models/time_log_start_model/time_log_start_model.dart';
import '../../utils/utils.dart';

class GetLogTimeViewModel extends ChangeNotifier {
  final GetLogTimeRepository authRepository = GetLogTimeRepository();

  List<TimeEntries>? _timeEntries;
  List<TimeEntries>? get timeEntries => _timeEntries;

  GetLogTimeModel? _getLogTimeModel;
  GetLogTimeModel? get getLogTimeModel => _getLogTimeModel;

  bool _getLogLoading = false;
  bool get getLogLoading => _getLogLoading;

  set getLogTimeLoading(bool setLoading) {
    _getLogLoading = setLoading;
    notifyListeners();
  }

  TimeLogStartModel? _timeLogStartModel;
  TimeLogStartModel? get timeLogStartModel => _timeLogStartModel;

  bool _timeLogLoading = false;
  bool get timeLogLoading => _timeLogLoading;

  set _timeLoading(bool setLoading) {
    _timeLogLoading = setLoading;
    notifyListeners();
  }

  Future<void> getLogTimeApi(BuildContext context, String eventId) async {
    getLogTimeLoading = true;
    try {
      final response = await authRepository.getLogTime(eventId);

      if (response.status == "1") {
        _getLogTimeModel = response;
        _timeEntries = response.data?.timeEntries;
        Utils.toastMessage(response.message ?? '');
      } else {
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Get time log API Response: $response");
      }
    } catch (e) {
      debugPrint("Get time log error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      getLogTimeLoading = false;
    }
  }

  Future<void> saveTimeLogApi(BuildContext context, dynamic data) async {
    _timeLoading = true;

    try {
      final response = await authRepository.saveTimeLog(data);

      if (response['status'] == "1") {
        Utils.toastMessage(response['message']);
      } else {
        Utils.toastMessage(response['message']);
      }
      if (kDebugMode) {
        debugPrint("Save Time Log API Response: $response");
      }
    } catch (e, stackTrace) {
      debugPrint("Save Time Log error: $e");
      debugPrint("Save Time Log stacktrace err: $stackTrace");

      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      _timeLoading = false;
    }
  }

  // Future<void> timeLogStartApi(BuildContext context, dynamic data) async {
  //   _timeLoading = true;
  //
  //   try {
  //     final response = await authRepository.timeLogStart(data);
  //
  //     if (response.status == "1") {
  //       _timeLogStartModel = response;
  //       // _registerEventModel = response;
  //       Utils.toastMessage(response.message ?? '');
  //     } else {
  //       Utils.toastMessage(response.message ?? '');
  //     }
  //
  //     if (kDebugMode) {
  //       debugPrint("Get Resource Detail API Response: $response");
  //     }
  //   } catch (e, stackTrace) {
  //     debugPrint("Resource Detail error: $e");
  //     debugPrint("Resource Detail stacktrace err: $stackTrace");
  //
  //     Utils.toastMessage("Error: ${e.toString()}");
  //   } finally {
  //     _timeLoading = false;
  //   }
  // }

  Future<void> timeLogStopApi(BuildContext context, dynamic data) async {
    _timeLoading = true;

    try {
      final response = await authRepository.timeLogStop(data);

      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"]);
      } else {
        Utils.toastMessage(response["message"]);
      }

      if (kDebugMode) {
        debugPrint("Stop Log Time API Response: $response");
      }
    } catch (e, stackTrace) {
      debugPrint("Stop Log Time error: $e");
      debugPrint("Stop Log Time stacktrace err: $stackTrace");

      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      _timeLoading = false;
    }
  }
}
