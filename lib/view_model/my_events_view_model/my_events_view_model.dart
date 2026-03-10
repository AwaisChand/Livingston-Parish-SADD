import 'package:dp_sad/models/MyEventsModel/my_events_model.dart';
import 'package:dp_sad/repository/my_events_repository/my_events_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../utils/utils.dart';

class MyEventsViewModel extends ChangeNotifier {
  final MyEventsRepository authRepository = MyEventsRepository();

  int? eventId;

  List<MyEvents>? _myEvent;
  List<MyEvents>? get myEvent => _myEvent;

  bool _myEventsLoading = false;
  bool get myEventsLoading => _myEventsLoading;

  set mEventLoading(bool setLoading) {
    _myEventsLoading = setLoading;
    notifyListeners();
  }

  Future<void> myEventsApi(BuildContext context) async {
    mEventLoading = true;
    try {
      final response = await authRepository.myEvents();

      if (response.status == "1") {
        _myEvent = response.data?.events;
        Utils.toastMessage(response.message ?? '');
      } else {
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Get my Events API Response: $response");
      }
    } catch (e) {
      debugPrint("My Event error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      mEventLoading = false;
    }
  }
}
