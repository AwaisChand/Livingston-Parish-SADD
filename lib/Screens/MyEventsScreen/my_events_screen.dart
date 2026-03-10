import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/view_model/my_events_view_model/my_events_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myEventsProvider = context.read<MyEventsViewModel>();
      myEventsProvider.myEventsApi(context);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // final authProvider = context.watch<AuthViewModel>();
    return Consumer<MyEventsViewModel>(
      builder: (context, myEvents, _) {
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
                    Text("My Events", style: AppTextStyle.k30Bold700TextStyle),
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
                    // vertical: getHeight(43),
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
                      Expanded(
                        child:
                            myEvents.myEventsLoading
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
                                : (myEvents.myEvent == null ||
                                    myEvents.myEvent!.isEmpty)
                                ? Center(
                                  child: Text(
                                    "You have no events",
                                    style: AppTextStyle.k20Bold700TextStyle
                                        .copyWith(
                                          color: AppColors.mediumGrayColor,
                                        ),
                                  ),
                                )
                                : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: myEvents.myEvent!.length,
                                  itemBuilder: (context, index) {
                                    final myEventsData =
                                        myEvents.myEvent![index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: AppColors.whiteColor,
                                      child: Container(
                                        height: getHeight(300),
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          vertical: getHeight(20),
                                          horizontal: getWidth(12),
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _rowWidget(
                                              "Event Name",
                                              "${myEventsData.event?.name}",
                                            ),
                                            20.sh,
                                            _rowWidget(
                                              "Date",
                                              "${myEventsData.event?.eventDate}",
                                            ),
                                            20.sh,
                                            _rowWidget(
                                              "Start Time",
                                              "${myEventsData.event?.startTime}",
                                            ),
                                            20.sh,
                                            _rowWidget(
                                              "End Time",
                                              "${myEventsData.event?.endTime}",
                                            ),
                                            20.sh,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Details',
                                                  style: AppTextStyle
                                                      .k18Bold400TextStyle
                                                      .copyWith(
                                                        color:
                                                            AppColors
                                                                .whiteColor,
                                                      ),
                                                ),
                                                ResourceDetailPopup(
                                                  detailText:
                                                      myEventsData
                                                          .event
                                                          ?.description ??
                                                      '',
                                                ),
                                              ],
                                            ),
                                            20.sh,
                                            _rowWidget(
                                              "Location",
                                              "${myEventsData.event?.location}",
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

  Row _rowWidget(String text1, text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: AppTextStyle.k18Bold400TextStyle.copyWith(
            fontSize: getFont(16),
            color: AppColors.whiteColor,
          ),
        ),
        SizedBox(width: 20),
        Flexible(
          child: Text(
            text2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.k12Bold700TextStyle.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}

class ResourceDetailPopup extends StatelessWidget {
  final String detailText;
  const ResourceDetailPopup({super.key, required this.detailText});

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Event Details",
              style: AppTextStyle.k20Bold700TextStyle,
            ),
            content: Text(detailText, style: AppTextStyle.k15Bold400TextStyle),
            actions: [
              TextButton(
                child: Text(
                  "Close",
                  style: AppTextStyle.k15Bold400TextStyle.copyWith(
                    color: AppColors.coralRedColor,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Container(
        height: getHeight(35),
        width: getHeight(70),
        decoration: BoxDecoration(
          color: AppColors.coralRedColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text("View All", style: AppTextStyle.k12Bold700TextStyle),
        ),
      ),
    );
  }
}
