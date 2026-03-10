import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:dp_sad/view_model/dashboard_view_model/dashboard_view_model.dart';
import 'package:dp_sad/view_model/event_detail_view_model/event_detail_view_model.dart';
import 'package:dp_sad/view_model/get_log_time_view_model/get_log_time_view_model.dart';
import 'package:dp_sad/view_model/my_events_view_model/my_events_view_model.dart';
import 'package:dp_sad/view_model/resource_detail_view_model/resource_detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view_model/home_view_model/home_view_model.dart';

List<SingleChildWidget> providers = [...independentProviders];
List<SingleChildWidget> independentProviders = [
  ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ChangeNotifierProvider(create: (_) => ResourceDetailViewModel()),
  ChangeNotifierProvider(create: (_) => AllEventsViewModel()),
  ChangeNotifierProvider(create: (_) => HomeViewModel()),
  ChangeNotifierProvider(create: (_) => DashboardViewModel()),
  ChangeNotifierProvider(create: (_) => MyEventsViewModel()),
  ChangeNotifierProvider(create: (_) => GetLogTimeViewModel()),



];
