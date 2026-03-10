import 'package:cached_network_image/cached_network_image.dart';
import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextField/app_text_field.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/EventDetailcreen/event_detail_screen.dart';
import 'package:dp_sad/res/app_url/app_url.dart';
import 'package:dp_sad/view_model/event_detail_view_model/event_detail_view_model.dart';
import 'package:dp_sad/view_model/home_view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/home_model/home_model.dart';
import '../../utils/utils.dart';

class DisplayEvent {
  final int? id;
  final String? image;
  final String? name;
  final String? location;
  final String? description;
  final String? startTime, endTime;
  final String? eventDate;

  DisplayEvent({
    this.image,
    this.name,
    this.location,
    this.id,
    this.description,
    this.startTime,
    this.endTime,
    this.eventDate,
  });
}

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;
  String? selectedCategoryName;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();
      final filterVM = context.read<HomeViewModel>();
      filterVM.searchQuery = '';
      filterVM.filterEvents = null;
      filterVM.clearFilters();
      context.read<AllEventsViewModel>().eventDetailApi(context);
    });
  }

  DisplayEvent toDisplayEvent(dynamic event) {
    return DisplayEvent(
      image: event?.image,
      name: event?.name,
      location: event?.location,
      id: event.id,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      eventDate: event.eventDate,
    );
  }

  HomeEvents convertDisplayEventToHomeEvent(DisplayEvent event) {
    return HomeEvents(
      id: event.id,
      name: event.name,
      image: event.image,
      location: event.location,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      eventDate: event.eventDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterEvents = context.watch<HomeViewModel>();
    final allEvents = context.watch<AllEventsViewModel>();

    final isFiltering =
        filterEvents.searchQuery.isNotEmpty || _selectedCategoryId != null;
    final isLoading =
        allEvents.eventDetailLoading || filterEvents.dashboardLoading;

    final filtered = filterEvents.filterEvents ?? [];
    final showFiltered = isFiltering && filtered.isNotEmpty;
    final showEmpty = isFiltering && filtered.isEmpty && !isLoading;
    final dataList = showFiltered ? filtered : allEvents.event ?? [];

    return Scaffold(
      backgroundColor: AppColors.lightBlueColor,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: Utils.drawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header
          Padding(
            padding: EdgeInsets.only(
              top: getHeight(60),
              right: getWidth(20),
              left: getWidth(20),
            ),
            child: Row(
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
                Text("All Events", style: AppTextStyle.k25Bold700TextStyle),
              ],
            ),
          ),
          15.sh,

          /// 🔹 Search Field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: getWidth(20),
                    left: getWidth(20),
                  ),
                  child: AppTextField(
                    controller: _searchController,
                    textInputType: TextInputType.name,
                    hintText: "Search",
                    iconData: Icons.search,
                    onChanged: (value) {
                      final filterProvider = context.read<HomeViewModel>();
                      filterProvider.searchQuery = value;

                      if (value.isEmpty && _selectedCategoryId == null) {
                        filterProvider.getDashboardData(context);
                      } else {
                        filterProvider.eventFilterApi(context, {
                          "search": _searchController.text.trim(),
                          "event_category_id": _selectedCategoryId,
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          10.sh,

          /// 🔹 Category Dropdown
          Padding(
            padding: EdgeInsets.only(right: getWidth(20), left: getWidth(20)),
            child: Consumer<HomeViewModel>(
              builder: (context, homeVM, _) {
                final categories = homeVM.homeModel?.data?.eventCategories;
                return DropdownButtonFormField<int>(
                  initialValue: _selectedCategoryId,
                  iconEnabledColor: AppColors.whiteColor,
                  isExpanded: true,
                  hint: Text(
                    "Select Event Category",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyle.k15Bold400TextStyle.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  items:
                      categories?.map<DropdownMenuItem<int>>((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(
                            category.name ?? '',
                            style: AppTextStyle.k15Bold400TextStyle.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                      selectedCategoryName =
                          categories?.firstWhere((c) => c.id == value).name;
                    });
                    final filterProvider = context.read<HomeViewModel>();
                    filterProvider.eventFilterApi(context, {
                      "event_category_id": _selectedCategoryId,
                      "search": _searchController.text.trim(),
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.deepPurpleColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.deepPurpleColor),
                    ),
                  ),
                  dropdownColor: AppColors.primaryColor,
                  icon: const Icon(Icons.arrow_drop_down),
                  selectedItemBuilder: (context) {
                    return categories?.map<Widget>((category) {
                          return Text(
                            category.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyle.k15Bold400TextStyle.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          );
                        }).toList() ??
                        [];
                  },
                );
              },
            ),
          ),
          30.sh,

          /// 🔹 Active Events Label
          Padding(
            padding: EdgeInsets.only(right: getWidth(20), left: getWidth(20)),
            child: Text(
              "Active Events",
              style: AppTextStyle.k20Bold700TextStyle,
            ),
          ),
          15.sh,

          /// 🔹 Events Grid
          Expanded(
            child: Builder(
              builder: (_) {
                if (isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.deepPurpleColor,
                    ),
                  );
                }

                if (showEmpty) {
                  return Center(
                    child: Text(
                      "No matching results found",
                      style: AppTextStyle.k20Bold700TextStyle.copyWith(
                        color: AppColors.deepPurpleColor,
                      ),
                    ),
                  );
                }

                return AlignedGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 0,
                  itemCount: dataList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final DisplayEvent displayItem = toDisplayEvent(
                      dataList[index],
                    );
                    final HomeEvents homeEventItem =
                        convertDisplayEventToHomeEvent(displayItem);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EventDetailScreen(
                                  index: index,
                                  eventsDetail: homeEventItem,
                                  eventCategory:
                                      filterEvents
                                          .homeModel!
                                          .data!
                                          .eventCategories![index],
                                ),
                          ),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 0.9,
                        child: CachedNetworkImage(
                          imageUrl: "${AppUrl.baseUrl}/${displayItem.image}",
                          imageBuilder:
                              (context, imageProvider) => Container(
                                width: getWidth(170),
                                margin: EdgeInsets.only(
                                  left: getWidth(20),
                                  right: getWidth(20),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: _buildEventFooter(displayItem),
                              ),
                          placeholder:
                              (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: getWidth(170),
                                  margin: EdgeInsets.only(
                                    left: getWidth(20),
                                    right: getWidth(20),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                width: getWidth(170),
                                margin: EdgeInsets.only(
                                  left: getWidth(20),
                                  right: getWidth(20),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(AppAssets.resourcesImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: _buildEventFooter(displayItem),
                              ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventFooter(DisplayEvent item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Text(
            "${item.name}\n${item.location}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: AppTextStyle.k12Bold400TextStyle.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
