import 'package:cached_network_image/cached_network_image.dart';
import 'package:dp_sad/Common/AppButton/app_button.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/models/home_model/home_model.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:dp_sad/view_model/resource_detail_view_model/resource_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Common/AppAssets/app_assets.dart';
import '../../Common/AppTextStyle/app_text_style.dart';
import '../../Common/Config/size_config.dart';
import '../../res/app_url/app_url.dart';
import '../../utils/utils.dart';

class ResourceDetailsScreen extends StatefulWidget {
  const ResourceDetailsScreen({
    super.key,
    required this.index,
    required this.homeResources,
    required this.resourceCategory,
  });

  final int index;
  final HomeResources homeResources;
  final ResourceCategory resourceCategory;

  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsState();
}

class _ResourceDetailsState extends State<ResourceDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Consumer<ResourceDetailViewModel>(
      builder: (context, resourceDetail, _) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.lightBlueColor,
          drawer: Utils.drawer(context),

          // ✅ Bottom button always visible
          bottomNavigationBar:
              auth.isLoggedIn
                  ? Container(
                    padding: EdgeInsets.all(getHeight(20)),
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: SafeArea(
                      top: false,
                      child: AppButton(
                        onPressed: () {
                          resourceDetail.downloadPdf(
                            context: context,
                            title: widget.homeResources.title ?? '',
                            keywords: widget.homeResources.keywords ?? '',
                            content: widget.homeResources.content ?? '',
                          );
                        },
                        btnText: "DOWNLOAD PDF",
                        fontSize: 25,
                      ),
                    ),
                  )
                  : null,

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: getHeight(20),
                right: 20,
                left: 20,
                bottom: getHeight(20),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Header
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
                          "Resource Details",
                          style: AppTextStyle.k30Bold700TextStyle.copyWith(
                            color: AppColors.blackColor,
                            fontSize: getFont(27),
                          ),
                        ),
                      ],
                    ),

                    30.sh,

                    /// 🔹 Resource Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(getFont(20)),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${AppUrl.baseUrl}/${widget.homeResources.image?.replaceFirst(RegExp(r'^/'), '')}",
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
                                image: AssetImage(AppAssets.resourcesImage),
                                height: getHeight(200),
                                width: double.infinity,
                              ),
                            ),
                      ),
                    ),

                    25.sh,

                    /// 🔹 Resource Name
                    _columnWidget(
                      "Resource Name",
                      "${widget.homeResources.title}",
                    ),

                    25.sh,

                    /// 🔹 Keywords
                    _columnWidget(
                      "Keywords",
                      "${widget.homeResources.keywords}",
                    ),

                    25.sh,

                    /// 🔹 Category
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
                          widget.resourceCategory.name!,
                          style: AppTextStyle.k18Bold400TextStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: getFont(14),
                          ),
                        ),
                      ],
                    ),

                    25.sh,

                    /// 🔹 Details
                    _columnWidget("Details", "${widget.homeResources.content}"),

                    25.sh,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔹 Reusable column widget
  Column _columnWidget(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.k18Bold400TextStyle.copyWith(
            color: AppColors.mediumGrayColor,
            fontSize: getFont(15),
          ),
        ),
        Text(
          value,
          style: AppTextStyle.k18Bold400TextStyle.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: getFont(14),
          ),
        ),
      ],
    );
  }
}
