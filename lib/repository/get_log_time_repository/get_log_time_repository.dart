import 'package:dp_sad/models/get_log_time_model/get_log_time_model.dart';
import 'package:flutter/foundation.dart';

import '../../data/network/base_api_service.dart';
import '../../data/network/network_api_service.dart';
import '../../res/app_url/app_url.dart';

class GetLogTimeRepository {
  BaseApiServices baseApiServices = NetworkApiService();

  Future<GetLogTimeModel> getLogTime(String eventId) async {
    try {
      final url = "${AppUrl.getLogTimeEndPoint}$eventId";
      debugPrint("Full URL: $url");

      dynamic response = await baseApiServices.getRequest(url);
      debugPrint("Raw API response JSON: $response");

      return GetLogTimeModel.fromJson(response);
    } catch (e) {
      debugPrint("Get time log error: $e");
      rethrow;
    }
  }

  Future saveTimeLog(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postRequest(
        AppUrl.saveTimeLogEndPoint,
        data,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.saveTimeLogEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Future<TimeLogStartModel> timeLogStart(dynamic data) async {
  //   try {
  //     dynamic response = await baseApiServices.postRequest(
  //       AppUrl.timeLogStartEndPoint,
  //       data,
  //     );
  //     debugPrint("Raw API response JSON: $response");
  //     debugPrint("Api url: ${AppUrl.timeLogStartEndPoint}");
  //
  //     return TimeLogStartModel.fromJson(response);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  // }

  Future<dynamic> timeLogStop(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postRequest(
        AppUrl.timeLogStopEndPoint,
        data,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.timeLogStopEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
