import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/view_model/dashboard_view_model/dashboard_view_model.dart';
import 'package:dp_sad/view_model/get_log_time_view_model/get_log_time_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Common/AppButton/app_button.dart';
import '../../utils/utils.dart';

class LogTimeScreen extends StatefulWidget {
  final String initialEventId;
  final String initialEventName;

  const LogTimeScreen({
    super.key,
    required this.initialEventId,
    required this.initialEventName,
  });

  @override
  State<LogTimeScreen> createState() => _LogTimeScreenState();
}

class _LogTimeScreenState extends State<LogTimeScreen> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  late String eventId;
  late String eventName;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize event state
    eventId = widget.initialEventId;
    eventName = widget.initialEventName;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = context.read<GetLogTimeViewModel>();
      // final allEvents = context.read<AllEventsViewModel>();
      final dashboard = context.read<DashboardViewModel>();
      dashboardProvider.getLogTimeApi(context, eventId);
      // allEvents.eventDetailApi(context);
      dashboard.getDashboardData(context);
    });
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      controller.text = DateFormat('hh:mm a').format(dt);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardViewModel>();

    final registeredEvents =
        dashboardProvider.registerEvent?.map((e) => e.event).toList() ?? [];
    final activeEvents = dashboardProvider.activeEvents ?? [];

    final Map<int, dynamic> combinedMap = {
      for (var e in [...registeredEvents, ...activeEvents]) e.id: e,
    };
    final combinedEvents = combinedMap.values.toList();

    String formatDate(String rawDate) {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    }

    String formatTime(String rawDate) {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat('hh:mm a').format(parsedDate);
    }

    return Consumer<GetLogTimeViewModel>(
      builder: (context, timeLog, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          drawer: Utils.drawer(context),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightBlueColor,
                  image: DecorationImage(
                    image: AssetImage(AppAssets.backgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: getHeight(50),
                left: getWidth(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Image(
                        image: AssetImage(AppAssets.menuIcon),
                        fit: BoxFit.cover,
                        height: getHeight(30),
                        color: AppColors.whiteColor,
                      ),
                    ),
                    20.sw,
                    Text("Log Time", style: AppTextStyle.k30Bold700TextStyle),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: getHeight(125),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight(43),
                    horizontal: getWidth(30),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Event",
                        style: AppTextStyle.k20Bold700TextStyle,
                      ),
                      8.sh,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryColor, // background of the field
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor:
                                AppColors
                                    .primaryColor, // 👈 menu background color
                            iconEnabledColor: AppColors.whiteColor,
                            value: eventId,
                            isExpanded: true,
                            items:
                                combinedEvents.map<DropdownMenuItem<String>>((
                                  event,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: event.id.toString(),
                                    child: Text(
                                      event.name ?? "No Name",
                                      style: AppTextStyle.k15Bold400TextStyle
                                          .copyWith(
                                            fontSize: 15,
                                            color:
                                                AppColors
                                                    .whiteColor, // 👈 text color
                                          ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              final selectedEvent = combinedEvents.firstWhere(
                                (e) => e.id.toString() == value,
                              );
                              setState(() {
                                eventId = selectedEvent.id.toString();
                                eventName = selectedEvent.name ?? '';
                              });
                              context.read<GetLogTimeViewModel>().getLogTimeApi(
                                context,
                                eventId,
                              );
                            },
                          ),
                        ),
                      ),
                      15.sh,
                      Divider(),
                      10.sh,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Start Time",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                5.sh,
                                TextField(
                                  controller: _startTimeController,
                                  readOnly: true,
                                  onTap:
                                      () => _selectTime(_startTimeController),
                                  decoration: InputDecoration(
                                    hintText: "e.g. 09:30 AM",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          30.sw,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "End Time",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                5.sh,
                                TextField(
                                  controller: _endTimeController,
                                  readOnly: true,
                                  onTap: () => _selectTime(_endTimeController),
                                  decoration: InputDecoration(
                                    hintText: "e.g. 05:00 PM",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      30.sh,
                      AppButton(
                        onPressed: () async {
                          final timeLog = context.read<GetLogTimeViewModel>();
                          try {
                            final DateFormat format = DateFormat('hh:mm a');
                            final DateTime parsedStart = format.parse(
                              _startTimeController.text.trim(),
                            );
                            final DateTime parsedEnd = format.parse(
                              _endTimeController.text.trim(),
                            );

                            final String formattedStart = DateFormat(
                              'HH:mm',
                            ).format(parsedStart);
                            final String formattedEnd = DateFormat(
                              'HH:mm',
                            ).format(parsedEnd);

                            final data = {
                              'start_time': formattedStart,
                              'end_time': formattedEnd,
                              'event_id': eventId,
                            };

                            await timeLog.saveTimeLogApi(context, data);
                            await timeLog.getLogTimeApi(context, eventId);

                            _startTimeController.clear();
                            _endTimeController.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Invalid time format. Use hh:mm AM/PM",
                                ),
                              ),
                            );
                          }
                        },
                        btnText: 'Save Time',
                        fontSize: 20,
                        isLoading: timeLog.timeLogLoading,
                      ),
                      30.sh,
                      Text(
                        "Total Entries",
                        style: AppTextStyle.k20Bold700TextStyle,
                      ),
                      10.sh,
                      Expanded(
                        child:
                            timeLog.getLogLoading
                                ? Center(child: CircularProgressIndicator())
                                : (timeLog.timeEntries == null ||
                                    timeLog.timeEntries!.isEmpty)
                                ? Center(
                                  child: Text(
                                    "You have not entries yet",
                                    style: AppTextStyle.k20Bold700TextStyle
                                        .copyWith(
                                          color: AppColors.mediumGrayColor,
                                        ),
                                  ),
                                )
                                : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: timeLog.timeEntries!.length,
                                  itemBuilder: (context, index) {
                                    final entry = timeLog.timeEntries![index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: AppColors.primaryColor,
                                      child: Container(
                                        height: getHeight(180),
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          vertical: getHeight(12),
                                          horizontal: getWidth(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    eventName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppTextStyle
                                                        .k20Bold700TextStyle
                                                        .copyWith(
                                                          fontSize: getFont(15),
                                                          color:
                                                              AppColors
                                                                  .whiteColor,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  entry.status ?? '-',
                                                  style: AppTextStyle
                                                      .k20Bold700TextStyle
                                                      .copyWith(
                                                        fontSize: getFont(15),
                                                        color:
                                                            AppColors
                                                                .whiteColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            25.sh,
                                            Text(
                                              formatDate(
                                                entry.submittedAt ?? '',
                                              ),
                                              style: AppTextStyle
                                                  .k18Bold400TextStyle
                                                  .copyWith(
                                                    color: AppColors.whiteColor,
                                                  ),
                                            ),
                                            12.sh,
                                            Row(
                                              children: [
                                                _columnWidget(
                                                  "Start Time",
                                                  formatTime(
                                                    entry.startTime ?? '',
                                                  ),
                                                ),
                                                30.sw,
                                                Flexible(
                                                  child: _columnWidget(
                                                    "End Time",
                                                    formatTime(
                                                      entry.endTime ?? '',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column _columnWidget(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.k18Bold400TextStyle.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        5.sh,
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.k12Bold700TextStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: getFont(15),
          ),
        ),
      ],
    );
  }
}
