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

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, this.email});
  final String? email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpControllers = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

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
                      AppTexts.verifyOtpText,
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          border: Border.all(
                            color: AppColors.blackColor,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _emailController.text,
                          style: AppTextStyle.k15Bold400TextStyle.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      30.sh,
                      AppTextField(
                        controller: _otpControllers,
                        textInputType: TextInputType.number,
                        hintText: AppTexts.otpPlaceholderText,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty) {
                              Utils.toastMessage(
                                "Please enter your email to resend OTP",
                              );
                            } else {
                              Map data = {
                                'email': _emailController.text.toString(),
                              };
                              auth.resendOtpApi(context, data);
                            }
                          },
                          child:
                              auth.resendLoading
                                  ? Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    AppTexts.resendOtpText,
                                    style: AppTextStyle.k15Bold400TextStyle
                                        .copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                  ),
                        ),
                      ),

                      Spacer(),
                      AppButton(
                        onPressed: () {
                          if (_otpControllers.text.toString().isEmpty) {
                            Utils.toastMessage("Please enter your otp code");
                          } else {
                            Map data = {
                              'email': _emailController.text.toString(),
                              'otp': _otpControllers.text.toString(),
                            };

                            auth.verifyOtpApi(context, data);
                          }
                        },
                        btnText: AppTexts.verifyEmail,
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
