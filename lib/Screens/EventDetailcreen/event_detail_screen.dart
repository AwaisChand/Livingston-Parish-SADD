import 'package:cached_network_image/cached_network_image.dart';
import 'package:dp_sad/Common/AppButton/app_button.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/AuthScreens/RegisterScreen/register_screen.dart';
import 'package:dp_sad/models/home_model/home_model.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Common/AppAssets/app_assets.dart';
import '../../Common/AppTextStyle/app_text_style.dart';
import '../../Common/Config/size_config.dart';
import '../../res/app_url/app_url.dart';
import '../../utils/utils.dart';

class EventDetailScreen extends StatelessWidget {
  EventDetailScreen({
    super.key,
    required this.index,
    required this.eventsDetail,
    required this.eventCategory,
  });

  final int index;
  final dynamic eventsDetail;
  final EventCategory eventCategory;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthViewModel>();
    String formatTime(String rawTime) {
      final parsedTime = DateFormat("HH:mm:ss").parse(rawTime);
      return DateFormat(
        "hh:mm a",
      ).format(parsedTime); // 12-hour format with AM/PM
    }

    return Scaffold(
      backgroundColor: AppColors.lightBlueColor,
      key: _scaffoldKey,
      drawer: Utils.drawer(context),
      // ✅ Bottom button always visible
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(getHeight(20)),
        decoration: BoxDecoration(color: Colors.transparent),
        child: SafeArea(
          top: false,
          child: AppButton(
            onPressed: () {
              if (authProvider.isLoggedIn) {
                Map data = {'event_id': eventsDetail.id};
                authProvider.registerEvent(context, data);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              }
            },
            btnText: "Register Now".toUpperCase(),
            fontSize: 25,
            isLoading: authProvider.isLoading,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.only(top: getHeight(40), right: 20, left: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Image(
                      image: AssetImage(AppAssets.menuIcon),
                      fit: BoxFit.cover,
                      height: getHeight(30),
                      color: AppColors.blackColor,
                    ),
                  ),
                  20.sw,
                  Text(
                    "Event Details",
                    style: AppTextStyle.k30Bold700TextStyle.copyWith(
                      color: AppColors.blackColor,
                      fontSize: getFont(27),
                    ),
                  ),
                ],
              ),
              40.sh,
              ClipRRect(
                borderRadius: BorderRadius.circular(getFont(20)),
                child: CachedNetworkImage(
                  imageUrl:
                      "${AppUrl.baseUrl}/${eventsDetail.image?.replaceFirst(RegExp(r'^/'), '')}",
                  fit: BoxFit.cover,
                  height: getHeight(200),
                  width: double.infinity,
                  placeholder:
                      (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: getHeight(200),
                          margin: EdgeInsets.only(left: getWidth(15)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: AssetImage(AppAssets.activeEventImage),
                          height: getHeight(180),
                          width: double.infinity,
                        ),
                      ),
                ),
              ),
              25.sh,
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _columnWidget("Event Name", "${eventsDetail.name}"),
                    20.sh,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Time",
                              style: AppTextStyle.k18Bold400TextStyle.copyWith(
                                color: AppColors.mediumGrayColor,
                                fontSize: getFont(16),
                              ),
                            ),
                            Text(
                              formatTime(eventsDetail.startTime),
                              style: AppTextStyle.k18Bold400TextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: getFont(16),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Time",
                              style: AppTextStyle.k18Bold400TextStyle.copyWith(
                                color: AppColors.mediumGrayColor,
                                fontSize: getFont(16),
                              ),
                            ),
                            Text(
                              formatTime(eventsDetail.endTime),
                              style: AppTextStyle.k18Bold400TextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: getFont(16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.sh,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _columnWidget(
                          "Event Date",
                          "${eventsDetail.eventDate}",
                        ),
                        20.sh,
                        _columnWidget(
                          "Event Location",
                          "${eventsDetail.location}",
                        ),
                      ],
                    ),
                    20.sh,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category",
                          style: AppTextStyle.k18Bold400TextStyle.copyWith(
                            color: AppColors.mediumGrayColor,
                            fontSize: getFont(15),
                          ),
                        ),
                        Text(
                          eventCategory.name!,
                          style: AppTextStyle.k18Bold400TextStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: getFont(14),
                          ),
                        ),
                      ],
                    ),

                    20.sh,
                    _columnWidget(
                      "Event Details",
                      "${eventsDetail.description}",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _columnWidget(String text1, text2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: AppTextStyle.k18Bold400TextStyle.copyWith(
            color: AppColors.mediumGrayColor,
            fontSize: getFont(16),
          ),
        ),
        Text(
          text2,
          style: AppTextStyle.k18Bold400TextStyle.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: getFont(16),
          ),
        ),
      ],
    );
  }
}
