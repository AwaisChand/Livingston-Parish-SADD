import 'package:dp_sad/models/filter_api_data_model/filter_api_data_model.dart';
import 'package:dp_sad/models/filter_tag_model/filter_tag_model.dart';
import 'package:dp_sad/repository/home_repository/home_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/home_model/home_model.dart';
import '../../utils/utils.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository authRepository = HomeRepository();

  List<HomeResources>? _homeResources;
  List<HomeResources>? get homeResources => _homeResources;

  List<HomeEvents>? _homeEvents;
  List<HomeEvents>? get homeEvents => _homeEvents;
  HomeModel? _homeModel;
  HomeModel? get homeModel => _homeModel;


  List<Resources>? _filterResources;
  List<Resources>? get filterResources => _filterResources;

  List<FilterTagData>? _filterTagData;
  List<FilterTagData>? get filterTagData => _filterTagData;

  List<Events>? _filterEvents;
  List<Events>? get filterEvents => _filterEvents;

  List<int> selectedResourceCategoryIds = [];
  List<int> selectedEventCategoryIds = [];

  set filterEvents(List<Events>? value) {
    _filterEvents = value;
    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  bool _dashboardLoading = false;
  bool get dashboardLoading => _dashboardLoading;

  set homeLoading(bool setLoading) {
    _dashboardLoading = setLoading;
    notifyListeners();
  }

  Future<void> getDashboardData(BuildContext context) async {
    homeLoading = true;
    try {
      final response = await authRepository.homeRepo();

      if (response.status == "1") {
        _homeResources = response.data?.resources;
        _homeEvents = response.data?.events;
        _homeModel = response;
        Utils.toastMessage(response.message ?? '');
      } else {
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Get Dashboard Data API Response: $response");
      }
    } catch (e) {
      debugPrint("Dashboard data error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      homeLoading = false;
    }
  }

  Future<void> resourceFilterApi(BuildContext context, dynamic data) async {
    homeLoading = true;
    notifyListeners();

    _searchQuery = data["search"]?.toString().trim() ?? "";
    final resourceCategoryId = data["resource_category_id"];

    debugPrint("🔍 Search Query: $_searchQuery");
    debugPrint("🎯 Resource Category ID: $resourceCategoryId");

    try {
      final response = await authRepository.resourceFilterRepo({
        "search": _searchQuery,
        "resource_category_id": resourceCategoryId,
      });

      if (response.status == 1) {
        _filterResources = response.data?.resources;

        if (_filterResources!.isEmpty) {
          Utils.toastMessage("No matching result found");
        } else {
          Utils.toastMessage("Filtered successfully");
        }

        debugPrint("✅ Filtered resources: ${_filterResources?.length}");
      } else {
        _filterResources = [];
        Utils.toastMessage(response.message ?? '');
      }
    } catch (e, stackTrace) {
      _filterResources = [];
      debugPrint("❌ Filter API error: $e $stackTrace");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      homeLoading = false;
      notifyListeners();
    }
  }

  Future<void> eventFilterApi(BuildContext context, dynamic data) async {
    homeLoading = true;
    notifyListeners();

    _searchQuery = data["search"]?.toString().trim() ?? "";
    final eventCategoryId = data["event_category_id"];

    debugPrint("🔍 Search Query: $_searchQuery");
    debugPrint("🎯 Event Category ID: $eventCategoryId");

    try {
      final response = await authRepository.eventFilterRepo({
        "search": _searchQuery,
        "event_category_id": eventCategoryId,
      });

      if (response.status == 1) {
        _filterEvents = response.data?.events;

        if (_filterEvents!.isEmpty) {
          Utils.toastMessage("No matching result found");
        } else {
          Utils.toastMessage("Filtered successfully");
        }

        debugPrint("✅ Filtered events: ${_filterEvents?.length}");
      } else {
        _filterEvents = [];
        Utils.toastMessage(response.message ?? '');
      }
    } catch (e) {
      _filterEvents = [];
      debugPrint("❌ Filter API error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      homeLoading = false;
      notifyListeners();
    }
  }




  Future<void> getFilterTagData(BuildContext context, dynamic data) async {
    homeLoading = true;
    _searchQuery = data["tag"]?.toString().toLowerCase().trim() ?? '';
    notifyListeners();

    try {
      final response = await authRepository.filterRepoTag(data);

      if (response.status == 1) {
        final List<FilterTagData> allResources = response.data ?? [];

        // 🔍 Filter resources by title
        _filterTagData =
            allResources.where((resource) {
              final keyword = resource.keywords?.toLowerCase() ?? '';
              return keyword.contains(_searchQuery);
            }).toList();

        if (_filterTagData!.isEmpty) {
          Utils.toastMessage("No matching Tag found");
        } else {
          Utils.toastMessage("Filtered successfully");
        }
      } else {
        _filterTagData = [];
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Filtered resources: ${_filterTagData?.length}");
      }
    } catch (e) {
      _filterTagData = [];
      debugPrint("Filter API error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      homeLoading = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _filterEvents = null;
    notifyListeners();
  }
}
