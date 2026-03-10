import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextField/app_text_field.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/AppTexts/app_texts.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/AuthScreens/RegisterScreen/register_screen.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Common/AppButton/app_button.dart';
import '../../../utils/utils.dart';
import '../EmailVerifyScreen/email_verify_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                        AppTexts.loginText,
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
                  padding: EdgeInsets.only(
                    top: getHeight(60),
                    right: getWidth(30),
                    left: getWidth(30)
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
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          hintText: AppTexts.emailText,
                        ),
                        30.sh,
                        AppTextField(
                          controller: _passwordController,
                          textInputType: TextInputType.visiblePassword,
                          hintText: AppTexts.passwordText,
                          isPassword: true,
                        ),
                        6.sh,
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailVerifyScreen(),
                              ),
                            );
                          },
                          child: Text(
                            AppTexts.forgotPasswordText,
                            style: AppTextStyle.k15Bold400TextStyle,
                          ),
                        ),
                        90.sh,
                        AppButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty) {
                              Utils.toastMessage('Please Enter Email');
                            } else if (_passwordController.text.isEmpty) {
                              Utils.toastMessage('Please Enter password');
                            } else if (_passwordController.text.length < 8) {
                              Utils.toastMessage('Please Enter 8 digit password');
                            } else {
                              Map data = {
                                'email': _emailController.text.toString(),
                                'password': _passwordController.text.toString(),
                              };
                              auth.loginApi(context, data);
                            }
                          },
                          btnText: AppTexts.loginText,
                          fontSize: 30,
                          isLoading: auth.isLoading,
                        ),
                        10.sh,
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Text(
                                AppTexts.registrationPromptText1,
                                style: AppTextStyle.k18Bold400TextStyle.copyWith(
                                  fontSize: getFont(20),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppTexts.registrationPromptText2,
                                  style: AppTextStyle.k25Bold700TextStyle.copyWith(
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                            ],
                          ),
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
