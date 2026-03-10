import 'package:dp_sad/models/event_detail_model/event_detail_model.dart';
import 'package:flutter/foundation.dart';

import '../../data/network/base_api_service.dart';
import '../../data/network/network_api_service.dart';
import '../../res/app_url/app_url.dart';

class AllEventsRepository {
  BaseApiServices baseApiServices = NetworkApiService();

  Future<AllEventsModel> eventDetail() async {
    try {
      dynamic response = await baseApiServices.getRequest(
        AppUrl.allEventsEndPoint,
      );
      debugPrint("Raw API response JSON: $response");
      debugPrint("Api url: ${AppUrl.allEventsEndPoint}");

      return AllEventsModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
