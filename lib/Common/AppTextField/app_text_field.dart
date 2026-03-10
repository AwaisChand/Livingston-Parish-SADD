import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;
  final IconData? iconData;
  final bool isPassword;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.textInputType,
    required this.hintText,
    this.iconData,
    this.isPassword = false,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? _obscureText : false,
      onChanged: widget.onChanged,
      style: AppTextStyle.k15Bold400TextStyle.copyWith(
        color: AppColors.whiteColor,
      ),
      // cursorColor: AppColors.whiteColor.withOpacity(0.6),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyle.k15Bold400TextStyle.copyWith(
          color: AppColors.whiteColor,
        ),
        prefixIcon:
            widget.iconData != null
                ? Icon(widget.iconData, color: AppColors.whiteColor)
                : null,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : null,
        fillColor: AppColors.primaryColor,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
