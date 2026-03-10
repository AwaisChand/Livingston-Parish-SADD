import 'package:cached_network_image/cached_network_image.dart';
import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Common/Config/sizedbox_extension.dart';
import 'package:dp_sad/Screens/AuthScreens/UpdatePasswordScreen/update_password_screen.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Common/AppButton/app_button.dart';
import '../../../utils/utils.dart';

class ViewInfoScreen extends StatefulWidget {
  const ViewInfoScreen({super.key});

  @override
  State<ViewInfoScreen> createState() => _ViewInfoScreenState();
}

class _ViewInfoScreenState extends State<ViewInfoScreen> {
  bool isEditing = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userVM = context.read<AuthViewModel>();

      userVM.getProfileApi(context).then((_) {
        final user = userVM.userModel;

        nameController.text = user?.fullName ?? 'N/A';
        emailController.text = user?.email ?? 'N/A';
        phoneController.text = user?.phoneNumber ?? 'N/A';
        addressController.text = user?.address ?? 'N/A';
        cityController.text = user?.city ?? 'N/A';
        stateController.text = user?.state ?? 'N/A';
        zipController.text = user?.zip ?? 'N/A';

        if (user?.dob != null && user!.dob!.isNotEmpty) {
          try {
            final parsedDate = DateTime.tryParse(user.dob!);
            if (parsedDate != null) {
              dobController.text = DateFormat('dd/MM/yyyy').format(parsedDate);
              selectedDate = parsedDate;
            } else {
              dobController.text = user.dob!;
            }
          } catch (_) {
            dobController.text = user.dob!;
          }
        } else {
          dobController.text = 'N/A';
        }
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, auth, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          drawer: Utils.drawer(context),
          body: Stack(
            children: [
              // Background
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

              // Top bar
              Positioned(
                top: getHeight(60),
                left: getWidth(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text("My Info", style: AppTextStyle.k30Bold700TextStyle),
                  ],
                ),
              ),

              // Profile image
              Positioned(
                top: getHeight(120),
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        height: getHeight(120),
                        width: getHeight(120),
                        margin: EdgeInsets.only(top: getHeight(20)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(getHeight(50)),
                          child:
                              auth.pickedImage != null
                                  ? Image.file(
                                    auth.pickedImage!,
                                    fit: BoxFit.cover,
                                  )
                                  : auth.userModel?.image != null &&
                                      auth.userModel!.image!.isNotEmpty
                                  ? CachedNetworkImage(
                                    imageUrl:
                                        "https://lpsadd.thetechnologies.net/${auth.userModel!.image!}",
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Image.asset(
                                          AppAssets.avatarImage,
                                          fit: BoxFit.cover,
                                        ),
                                  )
                                  : Image.asset(
                                    AppAssets.avatarImage,
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

              // Info form
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: getHeight(280),
                child: Container(
                  padding: EdgeInsets.only(
                    top: getHeight(60),
                    right: getWidth(30),
                    left: getWidth(30),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child:
                      auth.userLoading
                          ? Center(
                            child: SizedBox(
                              height: getHeight(20),
                              width: getWidth(20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.blackColor,
                              ),
                            ),
                          )
                          : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    top: getHeight(20),
                                    right: getWidth(20),
                                    left: getWidth(20),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.lightGray,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      _rowWidget("Name", nameController),
                                      20.sh,
                                      _rowWidget("Email", emailController),
                                      20.sh,
                                      _rowWidget("Phone", phoneController),
                                      20.sh,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Password",
                                            style: AppTextStyle
                                                .k15Bold400TextStyle
                                                .copyWith(
                                                  color: AppColors.whiteColor,
                                                ),
                                          ),
                                          auth.userModel != null
                                              ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (_) =>
                                                              UpdatePasswordScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    top: getHeight(6),
                                                    bottom: getHeight(6),
                                                    left: getWidth(10),
                                                    right: getWidth(10),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.coralRedColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          getHeight(12),
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Update Password",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppTextStyle
                                                          .k15Bold400TextStyle
                                                          .copyWith(
                                                            color:
                                                                AppColors
                                                                    .whiteColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              : Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: getHeight(6),
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.coralRedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        getHeight(12),
                                                      ),
                                                ),
                                                child: Text(
                                                  "N/A",
                                                  style: AppTextStyle
                                                      .k12Bold400TextStyle
                                                      .copyWith(
                                                        color:
                                                            AppColors
                                                                .whiteColor,
                                                        fontSize: getFont(17),
                                                      ),
                                                ),
                                              ),
                                        ],
                                      ),
                                      20.sh,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "DOB",
                                            style: AppTextStyle
                                                .k15Bold400TextStyle
                                                .copyWith(
                                                  color: AppColors.whiteColor,
                                                ),
                                          ),
                                          SizedBox(
                                            width: getWidth(180),
                                            child:
                                                isEditing
                                                    ? GestureDetector(
                                                      onTap: () async {
                                                        final picked =
                                                            await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  selectedDate ??
                                                                  DateTime(
                                                                    2000,
                                                                  ),
                                                              firstDate:
                                                                  DateTime(
                                                                    1900,
                                                                  ),
                                                              lastDate:
                                                                  DateTime.now(),
                                                            );
                                                        if (picked != null) {
                                                          setState(() {
                                                            selectedDate =
                                                                picked;
                                                            dobController.text =
                                                                DateFormat(
                                                                  'dd/MM/yyyy',
                                                                ).format(
                                                                  picked,
                                                                );
                                                          });
                                                        }
                                                      },
                                                      child: AbsorbPointer(
                                                        child: TextField(
                                                          controller:
                                                              dobController,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  vertical: 4,
                                                                ),
                                                            border:
                                                                UnderlineInputBorder(),
                                                          ),
                                                          style: AppTextStyle
                                                              .k15Bold400TextStyle
                                                              .copyWith(
                                                                color:
                                                                    AppColors
                                                                        .whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                    )
                                                    : Text(
                                                      dobController.text,
                                                      style: AppTextStyle
                                                          .k15Bold400TextStyle
                                                          .copyWith(
                                                            color:
                                                                AppColors
                                                                    .whiteColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                          ),
                                        ],
                                      ),
                                      20.sh,
                                      _rowWidget("Address", addressController),
                                      20.sh,
                                      _rowWidget("City", cityController),
                                      20.sh,
                                      _rowWidget("State", stateController),
                                      20.sh,
                                      _rowWidget("Zip", zipController),
                                      10.sh,
                                    ],
                                  ),
                                ),
                                20.sh,
                                if (auth.isLoggedIn)
                                  AppButton(
                                    onPressed: () {
                                      if (isEditing) {
                                        Map<String, dynamic> data = {
                                          'full_name': nameController.text,
                                          'email': emailController.text,
                                          'phone_number': phoneController.text,
                                          'password': passwordController.text,
                                          'dob': dobController.text,
                                          'address': addressController.text,
                                          'city': cityController.text,
                                          'state': stateController.text,
                                          'zip': zipController.text,
                                        };
                                        if (passwordController.text
                                            .trim()
                                            .isNotEmpty) {
                                          data['password'] =
                                              passwordController.text.trim();
                                        }
                                        auth.updateProfileApi(
                                          context,
                                          data,
                                          auth.pickedImage,
                                        );
                                      }

                                      setState(() {
                                        isEditing = !isEditing;
                                      });
                                    },
                                    btnText: isEditing ? "Save" : "Edit Info",
                                    fontSize: 25,
                                    isLoading: auth.isLoading,
                                  ),
                                10.sh,
                                if (!isEditing && auth.isLoggedIn)
                                  AppButton(
                                    onPressed: () {
                                      auth.deleteAccountApi(context);
                                    },
                                    btnText: "Delete Account",
                                    fontSize: 25,
                                  ),
                                10.sh,
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

  Widget _rowWidget(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.k15Bold400TextStyle.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        SizedBox(
          width: getWidth(180),
          child:
              isEditing
                  ? TextField(
                    controller: controller,
                    obscureText: isPassword,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      border: UnderlineInputBorder(),
                    ),
                    style: AppTextStyle.k15Bold400TextStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  )
                  : Text(
                    controller.text,
                    style: AppTextStyle.k15Bold400TextStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
        ),
      ],
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
