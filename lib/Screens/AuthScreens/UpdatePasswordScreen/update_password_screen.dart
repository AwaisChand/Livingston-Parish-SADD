import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextField/app_text_field.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/AppTexts/app_texts.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Common/AppButton/app_button.dart';
import '../../../utils/utils.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, auth, _) {
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
                    Text(
                      AppTexts.updatePasswordText,
                      style: AppTextStyle.k30Bold700TextStyle,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: getHeight(280),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight(60),
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
                      AppTextField(
                        controller: _currentPasswordController,
                        textInputType: TextInputType.emailAddress,
                        hintText: AppTexts.currentPasswordText,
                        isPassword: true,
                      ),
                      18.sh,
                      AppTextField(
                        controller: _newPasswordController,
                        textInputType: TextInputType.visiblePassword,
                        hintText: AppTexts.newPasswordText,
                        isPassword: true,
                      ),
                      18.sh,
                      AppTextField(
                        controller: _confirmPasswordController,
                        textInputType: TextInputType.visiblePassword,
                        hintText: AppTexts.confirmPasswordText,
                        isPassword: true,
                      ),
                      Spacer(),
                      AppButton(
                        onPressed: () {
                          if (_currentPasswordController.text.isEmpty) {
                            Utils.toastMessage(
                              "Please enter your existing password",
                            );
                          } else if (_newPasswordController.text.isEmpty) {
                            Utils.toastMessage('Please enter new password');
                          } else if (_confirmPasswordController.text.isEmpty) {
                            Utils.toastMessage('Please re-enter password');
                          } else if (_newPasswordController.text !=
                              _confirmPasswordController.text) {
                            Utils.toastMessage('Password does not match');
                          } else {
                            Map data = {
                              'current_password': _currentPasswordController.text.toString(),
                              'new_password': _newPasswordController.text.toString(),
                              'confirm_password':
                              _confirmPasswordController.text.toString(),
                            };

                            auth.updatePasswordApi(context, data);
                          }
                        },
                        btnText: AppTexts.updateText,
                        fontSize: 25,
                        isLoading: auth.isLoading,
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
}
