import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppButton/app_button.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextField/app_text_field.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/AppTexts/app_texts.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/AuthScreens/LoginScreen/login_screen.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? selectedDate;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<AuthViewModel>(
      builder: (context, auth, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          drawer: Utils.drawer(context),
          body: Stack(
            fit: StackFit.expand,
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
                      AppTexts.registerLabelText,
                      style: AppTextStyle.k30Bold700TextStyle,
                    ),
                  ],
                ),
              ),

              Positioned(
                top: getHeight(120),
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        height: getHeight(100),
                        width: getHeight(100),
                        margin: EdgeInsets.only(top: getHeight(40)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          image: DecorationImage(
                            image:
                                auth.pickedImage == null
                                    ? AssetImage(AppAssets.avatarImage)
                                        as ImageProvider
                                    : FileImage(auth.pickedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Edit icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _showImagePickerSheet(context);
                          },
                          child: Container(
                            height: getHeight(30),
                            width: getWidth(30),
                            decoration: BoxDecoration(
                              color: AppColors.deepPurpleColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: getHeight(280),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight(30),
                    horizontal: getWidth(30),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: _nameController,
                          textInputType: TextInputType.name,
                          hintText: 'Name',
                        ),
                        18.sh,
                        AppTextField(
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          hintText: AppTexts.emailText,
                        ),
                        18.sh,
                        IntlPhoneField(
                          controller: _phoneController,
                          style: AppTextStyle.k15Bold400TextStyle.copyWith(
                            color: AppColors.whiteColor,
                          ),
                          dropdownTextStyle: AppTextStyle.k15Bold400TextStyle
                              .copyWith(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: AppTextStyle.k15Bold400TextStyle
                                .copyWith(color: AppColors.whiteColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.primaryColor,
                          ),
                          initialCountryCode: 'US',
                          onChanged: (phone) {
                            _phoneController.text = phone.number;
                            auth.fullPhone = phone.completeNumber;
                          },
                          onCountryChanged: (country) {
                            auth.countryCode = "+${country.dialCode}";
                          },
                        ),

                        18.sh,
                        AppTextField(
                          controller: _passwordController,
                          textInputType: TextInputType.visiblePassword,
                          hintText: AppTexts.passwordText,
                          isPassword: true,
                        ),
                        18.sh,
                        AppTextField(
                          controller: _confirmPasswordController,
                          textInputType: TextInputType.visiblePassword,
                          hintText: 'Confirm Password',
                          isPassword: true,
                        ),
                        18.sh,

                        // DOB Picker
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                                _dobController.text =
                                "${pickedDate.day.toString().padLeft(2, '0')}/"
                                    "${pickedDate.month.toString().padLeft(2, '0')}/"
                                    "${pickedDate.year}";

                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: AppTextField(
                              controller: _dobController,
                              hintText: 'Date of Birth',
                              textInputType: TextInputType.datetime,
                            ),
                          ),
                        ),
                        18.sh,
                        AppTextField(
                          controller: _addressController,
                          textInputType: TextInputType.name,
                          hintText: 'Address',
                        ),
                        18.sh,
                        AppTextField(
                          controller: _cityController,
                          textInputType: TextInputType.name,
                          hintText: 'City',
                        ),
                        18.sh,
                        AppTextField(
                          controller: _stateController,
                          textInputType: TextInputType.name,
                          hintText: 'State',
                        ),
                        18.sh,
                        AppTextField(
                          controller: _zipController,
                          textInputType: TextInputType.number,
                          hintText: 'Zip',
                        ),
                        30.sh,
                        AppButton(
                          onPressed: () {
                            if (_nameController.text.isEmpty) {
                              Utils.toastMessage('Please enter name');
                            } else if (_emailController.text.isEmpty) {
                              Utils.toastMessage('Please enter email');
                            } else if (_phoneController.text.isEmpty) {
                              Utils.toastMessage('Please enter phone');
                            } else if (_passwordController.text.isEmpty) {
                              Utils.toastMessage('Please enter password');
                            } else if (_passwordController.text.length < 8) {
                              Utils.toastMessage('Please Enter 8 digit password');
                            }
                            else if (_confirmPasswordController
                                .text
                                .isEmpty) {
                              Utils.toastMessage('Please re-enter password');
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              Utils.toastMessage('Password does not match');
                            } else if (_dobController.text.isEmpty) {
                              Utils.toastMessage(
                                'Please enter your date of birth',
                              );
                            } else if (_addressController.text.isEmpty) {
                              Utils.toastMessage('Please enter your address');
                            } else if (_cityController.text.isEmpty) {
                              Utils.toastMessage('Please enter your city');
                            } else if (_stateController.text.isEmpty) {
                              Utils.toastMessage('Please enter your state');
                            } else if (_zipController.text.isEmpty) {
                              Utils.toastMessage('Please enter your zip code');
                            } else if (auth.pickedImage == null) {
                              Utils.toastMessage('Please pick your profile image');
                            }
                            else {
                              Map<String, dynamic> data = {
                                'full_name': _nameController.text.toString(),
                                'email': _emailController.text.toString(),
                                'phone_number': auth.fullPhone,

                                'password': _passwordController.text.toString(),
                                'password_confirmation':
                                    _confirmPasswordController.text.toString(),
                                'dob': _dobController.text.toString(),
                                'address': _addressController.text.toString(),
                                'city': _cityController.text.toString(),
                                'state': _stateController.text.toString(),
                                'zip': _zipController.text.toString(),
                              };

                              auth.registerApi(context, data, auth.pickedImage);
                            }
                          },
                          btnText: "Register",
                          fontSize: 25,
                          isLoading: auth.isLoading,
                        ),
                        SizedBox(height: 6),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Wrap(
                            children: [
                              Text(
                                'Already have an account?',
                                style: AppTextStyle.k18Bold400TextStyle
                                    .copyWith(fontSize: getFont(20)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: AppTextStyle.k25Bold700TextStyle
                                      .copyWith(
                                        fontSize: getFont(20),
                                        decoration: TextDecoration.underline,
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
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerSheet(BuildContext context) {
    final authProvider = context.read<AuthViewModel>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Image", style: AppTextStyle.k25Bold700TextStyle),
              SizedBox(height: 20),

              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: AppColors.deepPurpleColor,
                ),
                title: Text("Camera", style: AppTextStyle.k15Bold400TextStyle),
                onTap: () {
                  authProvider.pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.photo_library_rounded,
                  size: 30,
                  color: AppColors.deepPurpleColor,
                ),
                title: Text("Gallery", style: AppTextStyle.k15Bold400TextStyle),
                onTap: () {
                  authProvider.pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
