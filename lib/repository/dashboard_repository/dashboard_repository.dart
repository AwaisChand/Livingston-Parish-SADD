import 'package:dp_sad/models/dashboard_model/dashboard_model.dart';
import 'package:dp_sad/models/points_model/points_model.dart';
import 'package:flutter/foundation.dart';

import '../../data/network/base_api_service.dart';
import '../../data/network/network_api_service.dart';
import '../../res/app_url/app_url.dart';

class DashboardRepository {
  BaseApiServices baseApiServices = NetworkApiService();

  Future<DashboardModel> dashBoard() async {
    try {
      dynamic response = await baseApiServices.getRequest(
        AppUrl.dashBoardEndPoint,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.dashBoardEndPoint}");

      return DashboardModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<PointsModel> getPointsRepo() async {
    try {
      dynamic response = await baseApiServices.getRequest(
        AppUrl.pointsApiEndPoint,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.pointsApiEndPoint}");

      return PointsModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
