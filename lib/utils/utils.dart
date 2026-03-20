import 'package:cached_network_image/cached_network_image.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/AuthScreens/LoginScreen/login_screen.dart';
import 'package:dp_sad/Screens/AuthScreens/RegisterScreen/register_screen.dart';
import 'package:dp_sad/Screens/HomeScreen/home_screen.dart';
import 'package:dp_sad/Screens/PointsScreen/points_screen.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:dp_sad/view_model/dashboard_view_model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/AppAssets/app_assets.dart';
import '../Common/AppColors/app_colors.dart';
import '../Common/AppTextStyle/app_text_style.dart';
import '../Common/Config/size_config.dart';
import '../Screens/AuthScreens/ViewInfoScreen/view_info_screen.dart';
import '../Screens/DashboardScreen/dashboard_screen.dart';
import '../Screens/LogTimeScreen/log_time_screen.dart';
import '../Screens/MyEventsScreen/my_events_screen.dart';

class Utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: AppColors.whiteColor,
      backgroundColor: AppColors.primaryColor
    );
  }

  static Widget drawer(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final dashboardViewModel = context.watch<DashboardViewModel>();
    return Consumer<AuthViewModel>(
      builder: (context, authProvider, _) {
        return Drawer(
          backgroundColor: AppColors.lightBlueColor,
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    AppAssets.logo,
                    height: height * 0.25,
                    width: height * 0.25,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              20.sh,
              ListTile(
                leading: Icon(
                  Icons.home_outlined,
                  color: AppColors.blackColor,
                  size: getFont(35),
                ),
                title: Text(
                  'Main Page',
                  style: AppTextStyle.k18Bold400TextStyle,
                ),
                onTap:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
              ),
              if (authProvider.isLoggedIn) ...[
                ListTile(
                  leading: Image.asset(
                    AppAssets.dashboardIcon,
                    height: getHeight(30),
                  ),
                  title: Text(
                    'Dashboard',
                    style: AppTextStyle.k18Bold400TextStyle,
                  ),
                  onTap:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.point_of_sale_outlined,
                    color: AppColors.blackColor,
                    size: getFont(35),
                  ),
                  title: Text(
                    'Points',
                    style: AppTextStyle.k18Bold400TextStyle,
                  ),
                  onTap:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PointsScreen()),
                      ),
                ),
                ListTile(
                  leading: Image.asset(
                    AppAssets.eventIcon,
                    height: getHeight(30),
                  ),
                  title: Text(
                    'My Events',
                    style: AppTextStyle.k18Bold400TextStyle,
                  ),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyEventsScreen(),
                        ),
                      ),
                ),
                ListTile(
                  leading: Image(
                    image: AssetImage(AppAssets.timeLogIcon),
                    fit: BoxFit.cover,
                    height: getHeight(30),
                  ),
                  title: Text(
                    'Time Log',
                    style: AppTextStyle.k18Bold400TextStyle,
                  ),
                  onTap: () async {
                    final dashboardVM = context.read<DashboardViewModel>();

                    /// If data not loaded yet → fetch it first
                    if (dashboardVM.dashboardModel == null) {
                      await dashboardVM.getDashboardData(context, showMessage: false);
                    }

                    final registeredEvents =
                        dashboardVM.dashboardModel?.data.registeredEventList ?? [];

                    /// Still empty
                    if (registeredEvents.isEmpty) {
                      Utils.toastMessage("Please register an event first");
                      return;
                    }

                    /// Navigate
                    final event = registeredEvents.first.event;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogTimeScreen(
                          initialEventId: event.id.toString(),
                          initialEventName: event.name,
                        ),
                      ),
                    );
                  },
                ),
              ],
              const Spacer(),
              Divider(color: Colors.white30),
              if (authProvider.isLoggedIn)
                ListTile(
                  leading: SizedBox(
                    height: getHeight(40),
                    width: getHeight(40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(getHeight(50)),
                      child:
                          authProvider.pickedImage != null
                              ? Image.file(
                                authProvider.pickedImage!,
                                fit: BoxFit.cover,
                              )
                              : authProvider.userModel?.image != null &&
                                  authProvider.userModel!.image!.isNotEmpty
                              ? CachedNetworkImage(
                                imageUrl:
                                    "https://applpsadd.com/public/${authProvider.userModel!.image!}",
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Center(
                                      child: SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          color: AppColors.blackColor,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Image.asset(
                                      AppAssets.avatarImage,
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : Image.asset(
                                AppAssets.avatarImage,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),

                  title: Text(
                    'Profile',
                    style: AppTextStyle.k18Bold400TextStyle,
                  ),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewInfoScreen(),
                        ),
                      ),
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.app_registration),
                  title: Text(
                    'Register',
                    style: AppTextStyle.k18Bold400TextStyle,
                  ),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      ),
                ),
                ListTile(
                  leading: Icon(Icons.login),
                  title: Text('Login', style: AppTextStyle.k18Bold400TextStyle),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                ),
              ],
              if (authProvider.isLoggedIn)
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: AppTextStyle.k18Bold400TextStyle,
                  ),
                  onTap: () {
                    authProvider.logoutUser(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              40.sh,
            ],
          ),
        );
      },
    );
  }
}
