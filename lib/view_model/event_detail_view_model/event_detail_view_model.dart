import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../models/event_detail_model/event_detail_model.dart';
import '../../repository/event_detail_repository/event_detail_repository.dart';
import '../../utils/utils.dart';

class AllEventsViewModel extends ChangeNotifier {
  final AllEventsRepository authRepository = AllEventsRepository();

  int? eventId;

  List<Events>? _event;
  List<Events>? get event => _event;

  bool _eventDetailLoading = false;
  bool get eventDetailLoading => _eventDetailLoading;

  set eventLoading(bool setLoading) {
    _eventDetailLoading = setLoading;
    notifyListeners();
  }

  Future<void> eventDetailApi(BuildContext context) async {
    eventLoading = true;
    try {
      final response = await authRepository.eventDetail();

      if (response.status == "1") {
        _event = response.data?.events;
        Utils.toastMessage(response.message ?? '');
      } else {
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Get all Events API Response: $response");
      }
    } catch (e) {
      debugPrint("Event Detail error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      eventLoading = false;
    }
  }
}
