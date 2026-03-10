import 'package:dp_sad/models/filter_api_data_model/filter_api_data_model.dart';
import 'package:dp_sad/models/filter_tag_model/filter_tag_model.dart';
import 'package:dp_sad/models/home_model/home_model.dart';
import 'package:flutter/foundation.dart';

import '../../data/network/base_api_service.dart';
import '../../data/network/network_api_service.dart';
import '../../res/app_url/app_url.dart';

class HomeRepository {
  BaseApiServices baseApiServices = NetworkApiService();

  Future<HomeModel> homeRepo() async {
    try {
      dynamic response = await baseApiServices.getRequest(AppUrl.homeEndPoint);
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.homeEndPoint}");

      return HomeModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<ResourceFilterModel> resourceFilterRepo(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postRequest(
        AppUrl.resourceFilterEndPoint,
        data,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.resourceFilterEndPoint}");

      return ResourceFilterModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<EventFilterModel> eventFilterRepo(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postRequest(
        AppUrl.eventFilterEndPoint,
        data,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.eventFilterEndPoint}");

      return EventFilterModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<FilterTagModel> filterRepoTag(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postRequest(
        AppUrl.filterTagApiEndPoint,
        data,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.filterTagApiEndPoint}");

      return FilterTagModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
