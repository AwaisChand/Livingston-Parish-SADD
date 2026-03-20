import 'dart:io';

import 'package:dp_sad/Models/login_model/login_model.dart';
import 'package:dp_sad/Screens/AuthScreens/LoginScreen/login_screen.dart';
import 'package:dp_sad/Screens/AuthScreens/ResetPasswordScreen/reset_password_screen.dart';
import 'package:dp_sad/Screens/AuthScreens/VerifyOtpScreen/verify_otp_screen.dart';
import 'package:dp_sad/Screens/HomeScreen/home_screen.dart';
import 'package:dp_sad/Screens/LogTimeScreen/log_time_screen.dart';
import 'package:dp_sad/data/network/network_api_service.dart';
import 'package:dp_sad/repository/auth_repository/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/AuthScreens/RegisterScreen/register_screen.dart';
import '../../models/register_event_model/register_event_model.dart';
import '../../models/user_model/user_model.dart';
import '../../utils/utils.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository = AuthRepository();
  final ImagePicker _picker = ImagePicker();
  String countryCode = "+1";
  String fullPhone = "+1";

  UserData? _userModel;
  UserData? get userModel => _userModel;
  User? _user;
  User? get user => _user;
  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _userLoading = false;
  bool get userLoading => _userLoading;
  bool _resendLoading = false;
  bool get resendLoading => _resendLoading;
  LoginModel? loginModel;
  bool get isLoggedIn => _userModel != null;
  RegisterEventModel? _registerEventModel;
  RegisterEventModel? get registerEventModel => _registerEventModel;

  set loading(bool setLoading) {
    _isLoading = setLoading;
    notifyListeners();
  }

  set profileLoading(bool setLoading) {
    _userLoading = setLoading;
    notifyListeners();
  }

  set resend(bool setLoading) {
    _resendLoading = setLoading;
    notifyListeners();
  }

  ///Pick image from gallery
  Future pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _pickedImage = File(image.path);
        notifyListeners();

        debugPrint("Image picked: ${_pickedImage!.path}");
      } else {
        debugPrint("No image selected.");
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  ///Pick image from camera

  Future pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _pickedImage = File(image.path);
        notifyListeners();

        debugPrint("Image picked: ${_pickedImage!.path}");
      } else {
        debugPrint("No image selected.");
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  ///Register Api
  Future<void> registerApi(
    BuildContext context,
    Map<String, dynamic> fields,
    File? avatarFile,
  ) async {
    loading = true;
    try {
      debugPrint("Registering user with data: $fields");
      debugPrint("Avatar file: ${avatarFile?.path}");

      final response = await authRepository.registerUser(
        fields: fields,
        avatarFile: avatarFile,
      );

      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"] ?? "SignUp Successfully");

        // Navigator.pushNamed(context, RoutesName.login);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Utils.toastMessage(response["message"] ?? "Registration failed");
      }

      if (kDebugMode) {
        debugPrint("Register API Response: $response");
      }
    } catch (e) {
      debugPrint("Registration error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  ///Login Api
  Future<void> loginApi(BuildContext context, dynamic data) async {
    loading = true;
    try {
      debugPrint("login user with data: $data");

      // ✅ Step 1: Get FCM device token
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      debugPrint("Device Token: $deviceToken");

      // ✅ Step 2: Add token to your API data
      data["device_token"] = deviceToken;

      // ✅ Step 3: Send request
      final response = await authRepository.loginUser(data);

      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"]);

        // await NotificationService.showNotification(
        //   title: "Login Successful",
        //   body: "Welcome back, ${response["data"]["user"]["full_name"] ?? "User"}!",
        // );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        _user = LoginModel.fromJson(response).data.user;
        await getProfileApi(context);
      } else {
        Utils.toastMessage(response["message"] ?? "Login failed");
      }

      if (kDebugMode) {
        debugPrint("Login API Response: $response");
      }
    } catch (e) {
      debugPrint("Login error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  Future<void> storedDeviceTokenApi(String deviceToken) async {
    loading = true;
    notifyListeners();

    try {
      final data = {
        "device_token": deviceToken,
      };

      final response = await authRepository.storedDeviceTokenRepo(data);

      debugPrint("✅ Device token stored response: $response");
      Utils.toastMessage(response["message"] ?? "Token stored");
    } catch (e, stackTrace) {
      debugPrint("⚠️ store device token error: $e\n$stackTrace");
      Utils.toastMessage("Failed to store device token");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  ///Forgot Password Api
  Future<void> forgotPasswordApi(BuildContext context, dynamic data) async {
    loading = true;
    try {
      debugPrint("Registering user with data: $data");

      final response = await authRepository.forgotPassword(data);
      final String email = data['email'];

      if (response["status"].toString() == "1") {
        Utils.toastMessage("Email Verified");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(email: email),
          ),
        );
      } else {
        Utils.toastMessage(response["message"] ?? "Otp failed");
      }

      if (kDebugMode) {
        debugPrint("ForgotPassword API Response: $response");
      }
    } catch (e) {
      debugPrint("ForgotPassword error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  ///Verify Otp Api
  Future<void> verifyOtpApi(BuildContext context, dynamic data) async {
    loading = true;
    try {
      debugPrint("verify otp with data: $data");

      final response = await authRepository.verifyOtp(data);
      final String email = data['email'];

      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"]);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email),
          ),
        );
      } else {
        Utils.toastMessage(response["message"] ?? "Otp failed");
      }

      if (kDebugMode) {
        debugPrint("VerifyOtp API Response: $response");
      }
    } catch (e) {
      debugPrint("VerifyOtp error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  ///Resend Otp Api
  Future<void> resendOtpApi(BuildContext context, dynamic data) async {
    resend = true;
    try {
      debugPrint("resend otp with data: $data");

      final response = await authRepository.resendOtp(data);

      if (response["status"].toString() == "1") {
        Utils.toastMessage(response['message']);
      } else {
        Utils.toastMessage(response["message"] ?? "Resend Otp failed");
      }

      if (kDebugMode) {
        debugPrint("ResendOtp API Response: $response");
      }
    } catch (e) {
      debugPrint("ResendOtp error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      resend = false;
    }
  }

  ///Reset Password Api

  Future<void> resetPasswordApi(BuildContext context, dynamic data) async {
    loading = true;
    try {
      debugPrint("Reset Password user with data: $data");

      final response = await authRepository.resetPassword(data);

      // Check API-level status (e.g., "status": "1" or "0")
      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"]);

        // Navigator.pushNamed(context, RoutesName.login);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Utils.toastMessage(response["message"]);
      }

      if (kDebugMode) {
        debugPrint("ResetPassword API Response: $response");
      }
    } catch (e) {
      debugPrint("ResetPassword error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  ///Update Password Api

  Future<void> updatePasswordApi(BuildContext context, dynamic data) async {
    loading = true;
    try {
      debugPrint("Update Password with data: $data");

      final response = await authRepository.updatePassword(data);

      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"]);

        // Navigator.pushNamed(context, RoutesName.login);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Utils.toastMessage(response["message"]);
      }

      if (kDebugMode) {
        debugPrint("update password API Response: $response");
      }
    } catch (e, stackTrace) {
      debugPrint("update password error: $e $stackTrace");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  ///Update Profile Api
  Future<void> updateProfileApi(
    BuildContext context,
    Map<String, dynamic> fields,
    File? avatarFile,
  ) async {
    loading = true;
    try {
      // Convert DOB from dd/MM/yyyy to yyyy-MM-dd if it exists
      if (fields.containsKey('dob') &&
          fields['dob'] != null &&
          fields['dob'].toString().isNotEmpty) {
        try {
          DateTime parsedDob = DateFormat('dd/MM/yyyy').parse(fields['dob']);
          fields['dob'] = DateFormat('yyyy-MM-dd').format(parsedDob);
        } catch (e) {
          Utils.toastMessage("Invalid date format for DOB");
          loading = false;
          return;
        }
      }

      debugPrint("Update Profile user with data: $fields");

      final response = await authRepository.updateProfile(
        fields: fields,
        avatarFile: avatarFile,
      );

      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"]);
      } else {
        Utils.toastMessage(response["message"]);
      }

      if (kDebugMode) {
        debugPrint("UpdateProfile API Response: $response");
      }
    } catch (e) {
      debugPrint("UpdateProfile error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  ///Delete Account Api

  Future<void> deleteAccountApi(BuildContext context) async {
    loading = true;
    try {
      final response = await authRepository.deleteAccount();

      // Check API-level status (e.g., "status": "1" or "0")
      if (response["status"].toString() == "1") {
        Utils.toastMessage(response["message"]);

        // Navigator.pushNamed(context, RoutesName.login);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Utils.toastMessage(response["message"]);
      }

      if (kDebugMode) {
        debugPrint("Delete Account API Response: $response");
      }
    } catch (e) {
      debugPrint("Delete Account error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }

  /// Get Profile Api
  Future<void> getProfileApi(BuildContext context) async {
    profileLoading = true;
    try {
      final response = await authRepository.getProfile();

      if (response.status == "1") {
        _userModel = response.data?.user;
        Utils.toastMessage(response.message ?? '');
      } else {
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Get Profile API Response: $response");
      }
    } catch (e, stackTrace) {
      debugPrint("Get Profile error: $e $stackTrace");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      profileLoading = false;
    }
  }

  ///Register Event Api
  Future<void> registerEvent(BuildContext context, dynamic requestData) async {
    loading = true;
    try {
      debugPrint("Registering event with data: $requestData");

      final response = await authRepository.registerEvent(requestData);

      // ✅ Case 1: Registration successful and event data exists
      if (response.status == "1" && response.data?.event != null) {
        final event = response.data!.event!;

        final registeredEventId = event.id?.toString() ?? '';
        final registeredEventName = event.name ?? '';

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("event_id", registeredEventId);
        await prefs.setString("event_name", registeredEventName);

        Utils.toastMessage(response.message ?? "Event registered successfully");

        // Navigate to LogTimeScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LogTimeScreen(
              initialEventId: registeredEventId,
              initialEventName: registeredEventName,
            ),
          ),
        );
      }
      // ✅ Case 2: API returned status = 0 or empty data
      else {
        // Prefer message from server
        final message = response.message ?? "You have already registered for this event";

        // Show toast
        Utils.toastMessage(message);

        debugPrint("RegisterEvent notice: $message");

        // Optionally, if you want to navigate even on "already registered", you can handle here
      }

      if (kDebugMode) debugPrint("Register Event API Response: $response");
    } catch (e) {
      debugPrint("RegisterEvent error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      loading = false;
    }
  }
  ///Handle session
  Future<void> checkLoginStatus(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2)); // Splash delay

    // final prefs = await SharedPreferences.getInstance();
    final token = await NetworkApiService().getToken();

    if (token != null && token.isNotEmpty) {
      // Navigate to Home if token exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Navigate to Register if no token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
    }
  }

  Future<void> getProfileApiWithoutContext() async {
    profileLoading = true;
    try {
      final response = await authRepository.getProfile();

      if (response.status == "1") {
        _userModel = response.data?.user;
      }
    } catch (e) {
      debugPrint("Silent profile fetch failed: $e");
    } finally {
      profileLoading = false;
      notifyListeners(); // ✅ Important to update UI
    }
  }

  ///Logout Method

  Future<void> logoutUser(BuildContext context) async {
    if (_userModel == null) {
      Utils.toastMessage("Please login first");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove("event_id");
    await prefs.remove("event_name");

    _userModel = null;
    notifyListeners(); // 👈 Optional, if you want UI to respond

    Utils.toastMessage("Logged out successfully");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> initUser() async {
    final token = await NetworkApiService().getToken();

    if (token != null && token.isNotEmpty) {
      // Token exists – restore profile
      await getProfileApiWithoutContext();
    } else {
      _userModel = null;
      notifyListeners(); // Explicitly update
    }
  }

  Future<void> initFCMToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission();

      // Small delay to avoid SERVICE_NOT_AVAILABLE
      await Future.delayed(const Duration(seconds: 2));

      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("✅ FCM Token: $token");

      if (token != null) {
        await storedDeviceTokenApi(token);
      }
    } catch (e) {
      debugPrint("❌ FCM token error: $e");
    }
  }

}
