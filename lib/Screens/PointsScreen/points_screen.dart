import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/EventDetailcreen/event_detail_screen.dart';
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
import '../../view_model/auth_view_model/auth_view_model.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = context.read<DashboardViewModel>();
      dashboardProvider.getPointsAPi(context);
    });
  }

  String formatDate(String rawDate) {
    DateTime parsedDate = DateTime.parse(rawDate);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthViewModel>();
    return Consumer<DashboardViewModel>(
      builder: (context, pointsProvider, _) {
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
                    Text("Points", style: AppTextStyle.k30Bold700TextStyle),
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
                      !authProvider.isLoggedIn
                          ? Center(
                            child: Text(
                              "Unauthenticated",
                              style: AppTextStyle.k30Bold700TextStyle.copyWith(
                                color: AppColors.coralRedColor,
                              ),
                            ),
                          )
                          : pointsProvider.dashboardLoading
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
                              top: getHeight(10),
                              right: getWidth(20),
                              left: getWidth(20),
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
                                      "Earned\nPoints",
                                      "${pointsProvider.pointsModel?.data?.earnPoints}",
                                      AppAssets.earnedPointsImage,
                                    ),
                                    _buildEventBox(
                                      "Pending\nPoints",
                                      "${pointsProvider.pointsModel?.data?.pendingPoints}",
                                      AppAssets.pendingPointsImage,
                                    ),
                                  ],
                                ),
                                40.sh,
                                Text(
                                  "Points",
                                  style: AppTextStyle.k20Bold700TextStyle,
                                ),
                                ListView.builder(
                                  itemCount: pointsProvider.points.length,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final pointsData =
                                        pointsProvider.points[index];
                                    return Container(
                                      height: getHeight(185),
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                        bottom: getHeight(20),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        border: Border.all(
                                          color: AppColors.lightGray,
                                          width: 1.2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              height: 30,
                                              width: getWidth(80),
                                              decoration: BoxDecoration(
                                                color: AppColors.blackColor,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),

                                                  bottomLeft: Radius.circular(
                                                    5,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  pointsData.status == 1
                                                      ? "Approved"
                                                      : "Pending",
                                                  style: AppTextStyle
                                                      .k12Bold400TextStyle
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          _rowWidget(
                                            "Points",
                                            "${pointsData.points}",
                                          ),
                                          _rowWidget(
                                            "Name",
                                            "${pointsData.event?.name}",
                                          ),
                                          _rowWidget(
                                            "Location",
                                            "${pointsData.event?.location}",
                                          ),
                                          _rowWidget(
                                            "Created At",
                                            formatDate(
                                              pointsData.createdAt ?? '',
                                            ),
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

  Widget _rowWidget(String text1, text2) {
    return Padding(
      padding: EdgeInsets.only(
        top: getHeight(15),
        right: getWidth(20),
        left: getWidth(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: AppTextStyle.k12Bold400TextStyle.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
          Text(
            text2,
            style: AppTextStyle.k12Bold700TextStyle.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
            height: getHeight(42),
            width: getHeight(42),
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.whiteColor,
            ),
            child: Image(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
