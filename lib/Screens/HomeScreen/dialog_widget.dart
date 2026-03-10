import 'package:flutter/material.dart';

import '../../Common/AppColors/app_colors.dart';
import '../../Common/Config/size_config.dart';
import '../../view_model/home_view_model/home_view_model.dart';

Future<void> showResourceCategoryDialog(
  BuildContext context,
  HomeViewModel dashBoardProvider,
) async {
  await showDialog(
    context: context,
    builder: (_) {
      final resourceCategories =
          dashBoardProvider.homeModel?.data?.resourceCategories ?? [];

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Select Resource Categories"),
        content: SizedBox(
          width: getWidth(300),
          child:
              resourceCategories.isEmpty
                  ? const Center(child: Text("No categories available"))
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: resourceCategories.length,
                    itemBuilder: (context, index) {
                      final category = resourceCategories[index];
                      final isSelected = dashBoardProvider
                          .selectedResourceCategoryIds
                          .contains(category.id);

                      return CheckboxListTile(
                        activeColor: AppColors.deepPurpleColor,
                        title: Text(category.name ?? "Unnamed"),
                        value: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            dashBoardProvider.selectedResourceCategoryIds.add(
                              category.id!,
                            );
                          } else {
                            dashBoardProvider.selectedResourceCategoryIds
                                .remove(category.id);
                          }
                          (context as Element).markNeedsBuild();
                        },
                      );
                    },
                  ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint(
                "✅ Selected Resource Category IDs: ${dashBoardProvider.selectedResourceCategoryIds}",
              );

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepPurpleColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("Apply"),
          ),
        ],
      );
    },
  );
}

Future<void> showEventCategoryDialog(
  BuildContext context,
  HomeViewModel dashBoardProvider,
) async {
  await showDialog(
    context: context,
    builder: (_) {
      final eventCategories =
          dashBoardProvider.homeModel?.data?.eventCategories ?? [];

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Select Event Categories"),
        content: SizedBox(
          width: getWidth(300),
          child:
              eventCategories.isEmpty
                  ? const Center(child: Text("No categories available"))
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: eventCategories.length,
                    itemBuilder: (context, index) {
                      final category = eventCategories[index];
                      final isSelected = dashBoardProvider
                          .selectedEventCategoryIds
                          .contains(category.id);

                      return CheckboxListTile(
                        activeColor: AppColors.deepPurpleColor,
                        title: Text(category.name ?? "Unnamed"),
                        value: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            dashBoardProvider.selectedEventCategoryIds.add(
                              category.id!,
                            );
                          } else {
                            dashBoardProvider.selectedEventCategoryIds.remove(
                              category.id,
                            );
                          }
                          (context as Element).markNeedsBuild();
                        },
                      );
                    },
                  ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint(
                "✅ Selected Event Category IDs: ${dashBoardProvider.selectedEventCategoryIds}",
              );

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepPurpleColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("Apply"),
          ),
        ],
      );
    },
  );
}
