import 'package:flutter/material.dart';

import '../AppColors/app_colors.dart';
import '../AppTextStyle/app_text_style.dart';
import '../Config/size_config.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.btnText,
    required this.fontSize,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String btnText;
  final double fontSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        height: getHeight(60),
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getWidth(10)),
        ),
        onPressed: onPressed,
        child:
            isLoading
                ? SizedBox(
                  height: getHeight(25),
                  width: getWidth(25),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.whiteColor,
                      strokeWidth: 4,
                    ),
                  ),
                )
                : Text(
                  btnText,
                  style: AppTextStyle.k30Bold700TextStyle.copyWith(
                    fontSize: getFont(fontSize),
                  ),
                ),
      ),
    );
  }
}
