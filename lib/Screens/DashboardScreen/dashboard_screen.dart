import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/view_model/dashboard_view_model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Common/AppAssets/app_assets.dart';
import '../../Common/AppColors/app_colors.dart';
import '../../Common/AppTextStyle/app_text_style.dart';
import '../../Common/Config/size_config.dart';
import '../../utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = context.read<DashboardViewModel>();
      dashboardProvider.getDashboardData(context);
    });
  }

  String formatTime(String rawTime) {
    final parsedTime = DateFormat("HH:mm:ss").parse(rawTime);
    return DateFormat("hh:mm a").format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = context.watch<AuthViewModel>();
    return Consumer<DashboardViewModel>(
      builder: (context, dashboard, _) {
        return Scaffold(
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
                      ),
                    ),
                    20.sw,
                    Text("Dashboard", style: AppTextStyle.k30Bold700TextStyle),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: getHeight(125),
                child: Container(
                  padding: EdgeInsets.only(
                    top: getHeight(43),
                    bottom: getHeight(10),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child:
                      dashboard.dashboardLoading
                          ? Center(
                            child: SizedBox(
                              height: getHeight(20),
                              width: getWidth(20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.blackColor,
                              ),
                            ),
                          )
                          : SingleChildScrollView(
                            padding: EdgeInsets.only(
                              top: getHeight(43),
                              right: getWidth(10),
                              left: getWidth(10),
                              bottom: getHeight(20),
                            ),
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildEventBox(
                                      "Total Event\nRegistered",
                                      "${dashboard.dashboardModel?.data.eventRegistered}",
                                      AppAssets.eventRegIcon,
                                    ),
                                    _buildEventBox(
                                      "Total Active\nEvents",
                                      "${dashboard.dashboardModel?.data.activeEventsLength}",
                                      AppAssets.activeEventIcon,
                                    ),
                                  ],
                                ),
                                15.sh,
                                _buildEventBox(
                                  "Total Time\nSpent",
                                  "${dashboard.dashboardModel?.data.totalHours}",
                                  AppAssets.timeSpentEventIcon,
                                ),
                                25.sh,
                                Text(
                                  "Registered Events",
                                  style: AppTextStyle.k20Bold700TextStyle,
                                ),
                                dashboard
                                            .dashboardModel
                                            ?.data
                                            .registeredEventList
                                            .isEmpty ??
                                        true
                                    ? Center(
                                      child: Text(
                                        "No Registered Events",
                                        style: AppTextStyle.k18Bold400TextStyle
                                            .copyWith(color: Colors.grey),
                                      ),
                                    )
                                    : AlignedGridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          dashboard
                                              .dashboardModel
                                              ?.data
                                              .registeredEventList
                                              .length,
                                      itemBuilder: (context, index) {
                                        final dashboardData =
                                            dashboard
                                                .dashboardModel
                                                ?.data
                                                .registeredEventList[index];
                                        return Container(
                                          height: getHeight(230),
                                          padding: EdgeInsets.all(getWidth(10)),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _columnWidget(
                                                "Name",
                                                dashboardData?.event.name,
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Event Date",
                                                "${dashboardData?.event.eventDate}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Start Time",
                                                formatTime(
                                                  dashboardData
                                                          ?.event
                                                          .startTime ??
                                                      '',
                                                ),
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Description",
                                                "${dashboardData?.event.description}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Location",
                                                "${dashboardData?.event.location}",
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                25.sh,
                                Text(
                                  "Active Events",
                                  style: AppTextStyle.k20Bold700TextStyle,
                                ),
                                dashboard
                                            .dashboardModel
                                            ?.data
                                            .activeEvents
                                            .isEmpty ??
                                        true
                                    ? Center(
                                      child: Text(
                                        "No Active Events",
                                        style: AppTextStyle.k18Bold400TextStyle
                                            .copyWith(color: Colors.grey),
                                      ),
                                    )
                                    : AlignedGridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          dashboard
                                              .dashboardModel
                                              ?.data
                                              .activeEvents
                                              .length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final dashboardData =
                                            dashboard
                                                .dashboardModel
                                                ?.data
                                                .activeEvents[index];
                                        return Container(
                                          height: getHeight(210),
                                          padding: EdgeInsets.all(getWidth(10)),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _columnWidget(
                                                "Name",
                                                "${dashboardData?.name}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Due Date",
                                                "${dashboardData?.eventDate}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Time",
                                                formatTime(
                                                  dashboardData?.startTime ??
                                                      '',
                                                ),
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Description",
                                                "${dashboardData?.description}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Location",
                                                "${dashboardData?.location}",
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                25.sh,
                                Text(
                                  "Current Week Events",
                                  style: AppTextStyle.k20Bold700TextStyle,
                                ),
                                dashboard
                                            .dashboardModel
                                            ?.data
                                            .currentWeekEvents
                                            .isEmpty ??
                                        true
                                    ? Center(
                                      child: Text(
                                        "No Current Week Events",
                                        style: AppTextStyle.k18Bold400TextStyle
                                            .copyWith(color: Colors.grey),
                                      ),
                                    )
                                    : AlignedGridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          dashboard
                                              .dashboardModel
                                              ?.data
                                              .currentWeekEvents
                                              .length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final dashboardData =
                                            dashboard
                                                .dashboardModel
                                                ?.data
                                                .currentWeekEvents[index];
                                        return Container(
                                          height: getHeight(210),
                                          padding: EdgeInsets.all(getWidth(10)),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _columnWidget(
                                                "Name",
                                                "${dashboardData?.name}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Due Date",
                                                "${dashboardData?.eventDate}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Time",
                                                formatTime(
                                                  dashboardData?.startTime ??
                                                      '',
                                                ),
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Description",
                                                "${dashboardData?.description}",
                                              ),
                                              5.sh,
                                              _columnWidget(
                                                "Location",
                                                "${dashboardData?.location}",
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                              ],
                            ),
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _columnWidget(String text1, text2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.k12Bold400TextStyle,
        ),
        Text(
          text2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.k12Bold700TextStyle,
        ),
      ],
    );
  }

  Widget _buildEventBox(String title, String value, String image) {
    return Container(
      height: getHeight(95),
      width: getWidth(150),
      padding: EdgeInsets.only(
        top: getHeight(12),
        right: getWidth(10),
        left: getWidth(10),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(AppAssets.eventBoxImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.k12Bold700TextStyle),
              12.sh,
              Text(
                value,
                style: AppTextStyle.k18Bold400TextStyle.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: getHeight(40),
            width: getHeight(40),
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
            ),
            child: Image(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
