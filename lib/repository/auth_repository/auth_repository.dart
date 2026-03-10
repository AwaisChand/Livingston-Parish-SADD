import 'dart:io';

import 'package:dp_sad/data/network/network_api_service.dart';
import 'package:dp_sad/models/register_event_model/register_event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../data/network/base_api_service.dart';
import '../../models/user_model/user_model.dart';
import '../../res/app_url/app_url.dart';

class AuthRepository {
  BaseApiServices baseApiServices = NetworkApiService();

  ///Register
  Future<dynamic> registerUser({
    required Map<String, dynamic> fields,
    File? avatarFile,
  }) async {
    try {
      debugPrint("Register User====:  $fields");
      var response = await baseApiServices.multipartPostRequest(
        fields: fields,
        AppUrl.registerEndPoint,
        files: avatarFile != null ? {'image': avatarFile} : null,
      );
      debugPrint("  Response Register Api:$response");
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Login
  Future<dynamic> loginUser(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postLoginRequest(
        AppUrl.loginEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.loginEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///stored device token
  Future<dynamic> storedDeviceTokenRepo(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postSignUpRequest(
        AppUrl.deviceTokenStoredApiEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.deviceTokenStoredApiEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Forgot Password
  Future<dynamic> forgotPassword(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postSignUpRequest(
        AppUrl.forgotPasswordEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.forgotPasswordEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Verify Otp
  Future<dynamic> verifyOtp(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postSignUpRequest(
        AppUrl.verifyOtpEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.verifyOtpEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Resend Otp
  Future<dynamic> resendOtp(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postSignUpRequest(
        AppUrl.resendOtpEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.resendOtpEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Reset Password
  Future<dynamic> resetPassword(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postSignUpRequest(
        AppUrl.resetPasswordEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.resetPasswordEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Update Password
  Future<dynamic> updatePassword(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postRequest(
        AppUrl.updatePasswordEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.updatePasswordEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 60,
      format: CompressFormat.jpeg,
    );

    final compressed = File("${file.path}_compressed.jpg");
    return compressed.writeAsBytes(result!);
  }


  ///Update Profile
  Future<dynamic> updateProfile({
    required Map<String, dynamic> fields,
    File? avatarFile,
  }) async {
    try {
      debugPrint("update profile User====:  $fields");

      File? finalFile;

      if (avatarFile != null) {
        // 🔥 1. COMPRESS IMAGE HERE
        finalFile = await compressImage(avatarFile);
      }

      var response = await baseApiServices.multipartPostRequest(
        AppUrl.updateProfileEndPoint,
        fields: fields,
        files: finalFile != null ? {'image': finalFile} : null,
      );

      debugPrint("Response update profile Api: $response");
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }


  ///Delete Account
  Future<dynamic> deleteAccount() async {
    try {
      dynamic response = await baseApiServices.getRequest(
        AppUrl.deleteAccountEndPoint,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.deleteAccountEndPoint}");

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Get profile

  Future<UserModel> getProfile() async {
    try {
      dynamic response = await baseApiServices.getRequest(
        AppUrl.getProfileEndPoint,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.getProfileEndPoint}");

      return response = UserModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Register Event
  Future<RegisterEventModel> registerEvent(dynamic data) async {
    try {
      dynamic response = await baseApiServices.postRequest(
        AppUrl.registerEventEndPoint,
        data,
      );
      debugPrint("response$response");
      debugPrint("Api url: ${AppUrl.registerEventEndPoint}");

      return response = RegisterEventModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
