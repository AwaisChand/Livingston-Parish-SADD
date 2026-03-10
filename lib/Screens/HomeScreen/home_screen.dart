import 'package:cached_network_image/cached_network_image.dart';
import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextField/app_text_field.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/AllEventsScreen/all_events_screen.dart';
import 'package:dp_sad/Screens/AllResourcesScreen/all_resources_screen.dart';
import 'package:dp_sad/Screens/EventDetailcreen/event_detail_screen.dart';
import 'package:dp_sad/Screens/ResourceDetailsScreen/resource_details_screen.dart';
import 'package:dp_sad/res/app_url/app_url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/utils.dart';
import '../../view_model/auth_view_model/auth_view_model.dart';
import '../../view_model/home_view_model/home_view_model.dart';
import 'dialog_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().getDashboardData(context);
      final authVM = context.read<AuthViewModel>();
      authVM.initFCMToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Utils.drawer(context),
      backgroundColor: AppColors.lightBlueColor,
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, dashBoardProvider, _) {
            final List<dynamic> resources =
                isSearching
                    ? (dashBoardProvider.filterResources ?? [])
                    : (dashBoardProvider.homeResources ?? []);
            final List<dynamic> events =
                isSearching
                    ? (dashBoardProvider.filterEvents ?? [])
                    : (dashBoardProvider.homeEvents ?? []);
            final resourceCategory =
                dashBoardProvider.homeModel?.data?.resourceCategories ?? [];
            final eventCategory =
                dashBoardProvider.homeModel?.data?.eventCategories ?? [];

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidth(20),
                      vertical: getHeight(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => _scaffoldKey.currentState?.openDrawer(),
                          child: Image.asset(
                            AppAssets.menuIcon,
                            height: getHeight(30),
                            color: AppColors.blackColor,
                          ),
                        ),
                        15.sw,
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 15)),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllResourcesScreen(),
                              ),
                            ),
                        child: _labelRowWidget("Our Resources", "View all"),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                dashBoardProvider.dashboardLoading
                    ? _buildShimmerGridSliver()
                    : _buildResourcesGrid(resources, resourceCategory, context),
                const SliverToBoxAdapter(child: SizedBox(height: 15)),
                SliverToBoxAdapter(
                  child: InkWell(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllEventsScreen(),
                          ),
                        ),
                    child: _labelRowWidget("Active Events", "View all"),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 15)),

                dashBoardProvider.dashboardLoading
                    ? _buildShimmerGridSliver()
                    : _buildEventsGrid(events, eventCategory, context),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverPadding _buildResourcesGrid(
    List<dynamic> resources,
    List<dynamic> category,
    BuildContext context,
  ) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(20), vertical: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final resource = resources[index];
          final resourceCategory =
              index < category.length ? category[index] : {}; // ✅ safe fallback

          return GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ResourceDetailsScreen(
                          index: index,
                          homeResources: resource,
                          resourceCategory: resourceCategory,
                        ),
                  ),
                ),
            child: CachedNetworkImage(
              imageUrl: "${AppUrl.baseUrl}/${resource.image}",
              imageBuilder:
                  (context, imageProvider) => _buildCard(
                    backgroundWidget: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    title: resource.title ?? '',
                    keywords: resource.keywords ?? '',
                  ),
              placeholder:
                  (context, url) => _buildCard(
                    backgroundWidget: Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    title: resource.title ?? '',
                    keywords: resource.keywords ?? '',
                  ),
              errorWidget:
                  (context, url, error) => _buildCard(
                    backgroundWidget: Image.asset(AppAssets.resourcesImage),
                    title: resource.title ?? '',
                    keywords: resource.keywords ?? '',
                  ),
            ),
          );
        }, childCount: resources.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: getHeight(15),
          crossAxisSpacing: getWidth(10),
          childAspectRatio: 0.8,
        ),
      ),
    );
  }

  SliverPadding _buildEventsGrid(
    List<dynamic> events,
    List<dynamic> category,
    BuildContext context,
  ) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(20), vertical: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final event = events[index];
          final eventCategory = category[index];
          return GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EventDetailScreen(
                          index: index,
                          eventsDetail: event,
                          eventCategory: eventCategory,
                        ),
                  ),
                ),
            child: CachedNetworkImage(
              imageUrl: "${AppUrl.baseUrl}/${event.image}",
              imageBuilder:
                  (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          "${event.name}\n${event.description}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.k12Bold400TextStyle.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          );
        }, childCount: events.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: getHeight(15),
          crossAxisSpacing: getWidth(10),
          childAspectRatio: 0.8,
        ),
      ),
    );
  }

  Widget _buildCard({
    required Widget backgroundWidget,
    required String title,
    required String keywords,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(child: backgroundWidget),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(8),
                vertical: getHeight(10),
              ),
              color: AppColors.primaryColor,
              child: Text(
                "$title\n$keywords",
                style: AppTextStyle.k12Bold400TextStyle.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelRowWidget(String text1, String text2) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text1, style: AppTextStyle.k20Bold700TextStyle),
          Container(
            height: getHeight(40),
            width: getWidth(80),
            decoration: BoxDecoration(
              color: AppColors.coralRedColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(text2, style: AppTextStyle.k12Bold400TextStyle),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildShimmerGridSliver() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: getHeight(15),
          crossAxisSpacing: getWidth(10),
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}
