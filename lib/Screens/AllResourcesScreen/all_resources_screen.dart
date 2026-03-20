import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextField/app_text_field.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/ResourceDetailsScreen/resource_details_screen.dart';
import 'package:dp_sad/res/app_url/app_url.dart';
import 'package:dp_sad/utils/utils.dart';
import 'package:dp_sad/view_model/home_view_model/home_view_model.dart';
import 'package:dp_sad/view_model/resource_detail_view_model/resource_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/filter_api_data_model/filter_api_data_model.dart' as r;
import '../../models/home_model/home_model.dart';
import '../../models/resource_detail_model/resource_detail_model.dart';

class DisplayResource {
  final int? id;
  final String? image;
  final String? title;
  final String? keywords;
  final String? content;

  DisplayResource({
    this.image,
    this.title,
    this.keywords,
    this.id,
    this.content,
  });
}

class AllResourcesScreen extends StatefulWidget {
  const AllResourcesScreen({super.key});

  @override
  State<AllResourcesScreen> createState() => _AllResourcesScreenState();
}

class _AllResourcesScreenState extends State<AllResourcesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? _selectedCategoryId;
  String? _selectedCategoryName;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();
      final filterVM = context.read<HomeViewModel>();
      filterVM.searchQuery = '';
      filterVM.filterEvents = null;
      filterVM.clearFilters();
      context.read<ResourceDetailViewModel>().resourceDetailApi(context);
    });
  }

  DisplayResource toDisplayResource(dynamic resource) {
    if (resource is Resources) {
      return DisplayResource(
        id: resource.id,
        image: resource.image,
        title: resource.title,
        keywords: resource.keywords,
        content: resource.content,
      );
    } else if (resource is r.Resources) {
      return DisplayResource(
        id: resource.id,
        image: resource.image,
        title: resource.title,
        keywords: resource.keywords,
        content: resource.content,
      );
    } else {
      throw Exception("Unsupported resource type: ${resource.runtimeType}");
    }
  }

  HomeResources convertDisplayEventToHomeResource(DisplayResource resource) {
    return HomeResources(
      id: resource.id,
      image: resource.image,
      title: resource.title,
      keywords: resource.keywords,
      content: resource.content,
    );
  }

  void _applyFilters() {
    final filterProvider = context.read<HomeViewModel>();
    final resourceVM = context.read<ResourceDetailViewModel>();

    final search = _searchController.text.trim();
    final categoryId = _selectedCategoryId;

    final isSearching = search.isNotEmpty;
    final isCategorySelected =
        categoryId != null && categoryId != 0;

    // ✅ CASE 1: No filters → load ALL
    if (!isSearching && !isCategorySelected) {
      filterProvider.searchQuery = '';
      resourceVM.resourceDetailApi(context);
      return;
    }

    // ✅ CASE 2: Apply filters
    filterProvider.searchQuery = search;

    filterProvider.resourceFilterApi(context, {
      "search": search.isNotEmpty ? search : "",
      "resource_category_id": isCategorySelected ? categoryId : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    final resource = context.watch<ResourceDetailViewModel>();

    return Consumer<HomeViewModel>(
      builder: (context, filterProvider, _) {
        return Scaffold(
          backgroundColor: AppColors.lightBlueColor,
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
                        height: getHeight(30),
                        color: AppColors.blackColor,
                      ),
                    ),
                    20.sw,
                    Text(
                      "All Resources",
                      style: AppTextStyle.k25Bold700TextStyle,
                    ),
                  ],
                ),
              ),
              15.sh,

              /// 🔹 Search Field
              Padding(
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
                      filterProvider.resourceFilterApi(context, {
                        "search": _searchController.text,
                        "resource_category_id": _selectedCategoryId,
                      });
                    }
                  },
                ),
              ),

              10.sh,

              /// 🔹 Category Dropdown
              Padding(
                padding: EdgeInsets.only(
                  right: getWidth(18),
                  left: getWidth(20),
                ),
                child: Consumer<HomeViewModel>(
                  builder: (context, homeVM, _) {
                    final categories =
                        homeVM.homeModel?.data?.resourceCategories ?? [];

                    return DropdownButtonFormField<int>(
                      iconEnabledColor: AppColors.whiteColor,
                      value: _selectedCategoryId ?? 0,
                      isExpanded: true,

                      hint: Text(
                        "Select Resource Category",
                        style: AppTextStyle.k15Bold400TextStyle.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),

                      items: [
                        // ✅ ALL RESOURCES
                         DropdownMenuItem<int>(
                          value: 0,
                          child: Text(
                            "All Resources",
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.k15Bold400TextStyle.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),

                        // ✅ Categories
                        ...categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(
                              category.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.k15Bold400TextStyle.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ],

                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value ?? 0;
                        });

                        // ✅ Smart filter handler
                        _applyFilters();
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
                          borderSide:
                          BorderSide(color: AppColors.deepPurpleColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: AppColors.deepPurpleColor),
                        ),
                      ),

                      dropdownColor: AppColors.primaryColor,
                      icon: const Icon(Icons.arrow_drop_down),

                      // ✅ Selected item UI
                      selectedItemBuilder: (context) {
                        return [
                          Text(
                            "All Resources",
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.k15Bold400TextStyle.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          ...categories.map<Widget>((category) {
                            return Text(
                              category.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.k15Bold400TextStyle.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            );
                          }).toList(),
                        ];
                      },
                    );
                  },
                ),
              ),
              15.sh,

              Padding(
                padding: EdgeInsets.only(
                  right: getWidth(20),
                  left: getWidth(20),
                ),
                child: Text(
                  "Our Resources",
                  style: AppTextStyle.k20Bold700TextStyle,
                ),
              ),

              /// 🔹 Resource Grid
              Expanded(
                child: Builder(
                  builder: (context) {
                    final isSearching =
                        filterProvider.searchQuery.isNotEmpty ||
                            (_selectedCategoryId != null && _selectedCategoryId != 0);

                    final isKeywordSearchActive =
                        isSearching &&
                        (filterProvider.filterResources?.isNotEmpty ?? false);

                    final isSearchLoading =
                        isSearching && filterProvider.dashboardLoading;

                    final isEmptySearchResult =
                        isSearching &&
                        !filterProvider.dashboardLoading &&
                        (filterProvider.filterResources?.isEmpty ?? true);

                    if (!isSearching && resource.resourceDetailLoading) {
                      return _buildShimmerGrid(resource.resource?.length);
                    }

                    if (isSearchLoading) {
                      return const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.blackColor,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    if (isEmptySearchResult) {
                      return Center(
                        child: Text(
                          "No matching results found",
                          style: AppTextStyle.k20Bold700TextStyle.copyWith(
                            color: AppColors.deepPurpleColor,
                          ),
                        ),
                      );
                    }
                    if (!isSearching &&
                        !resource.resourceDetailLoading &&
                        (resource.resource == null || resource.resource!.isEmpty)) {
                      return Center(
                        child: Text(
                          "No Resources Available Yet",
                          style: AppTextStyle.k20Bold700TextStyle.copyWith(
                            color: AppColors.deepPurpleColor,
                          ),
                        ),
                      );
                    }

                    final dataList =
                        isSearching
                            ? (isKeywordSearchActive
                                ? filterProvider.filterResources!
                                : resource.resource ?? [])
                            : resource.resource ?? [];

                    return AlignedGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 0,
                      itemCount: dataList.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final DisplayResource displayItem = toDisplayResource(
                          dataList[index],
                        );
                        final HomeResources homeResourceItem =
                            convertDisplayEventToHomeResource(displayItem);

                        // ✅ find correct category for this resource
                        final categories =
                            filterProvider
                                .homeModel
                                ?.data
                                ?.resourceCategories ??
                            [];
                        final matchedCategory = categories.firstWhere(
                          (cat) => cat.id == displayItem.id,
                          orElse:
                              () =>
                                  categories.isNotEmpty
                                      ? categories.first
                                      : ResourceCategory(
                                        id: 0,
                                        name: "Unknown",
                                      ),
                        );

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ResourceDetailsScreen(
                                      index: index,
                                      homeResources: homeResourceItem,
                                      resourceCategory: matchedCategory,
                                    ),
                              ),
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: 0.9,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${AppUrl.baseUrl}/${displayItem.image}",
                              imageBuilder:
                                  (context, imageProvider) => Container(
                                    width: getWidth(180),
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
                                    child: _buildItemFooter(displayItem),
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
                              errorWidget: (context, url, error) => Container(
                                width: getWidth(170),
                                height: getHeight(200),
                                margin: EdgeInsets.only(
                                  left: getWidth(20),
                                  right: getWidth(20),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        AppAssets.logo,
                                        height: 90,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    // Footer stays same
                                    _buildItemFooter(displayItem),
                                  ],
                                ),
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
      },
    );
  }

  Widget _buildItemFooter(DisplayResource item) {
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
            "${item.title}\n${item.keywords}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.k12Bold400TextStyle.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerGrid(int? itemCount) {
    return AlignedGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 0,
      itemCount: itemCount ?? 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: getWidth(200),
            height: getHeight(200),
            margin: EdgeInsets.only(left: getWidth(15)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
