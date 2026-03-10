// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/login_model/login_model.dart';
import '../app_exception.dart';
import 'base_api_service.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getRequest(String url) async {
    dynamic responseJson;
    String? token = await NetworkApiService().getToken();
    debugPrint("Get Token===$token");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      responseJson = returnResponse(response);
      debugPrint("Raw response body: ${response.body}"); // Add this line
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future postApiResponse(String url) async {
    dynamic responseJson;

    try {
      final response = await http.post(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future postLoginRequest(String url, dynamic data) async {
    dynamic responseJson;

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("login url === $url");
      debugPrint("login raw response === ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);

        if (responseBody["status"].toString() == "1") {
          final loginData = LoginModel.fromJson(responseBody).data;
          final token = loginData.token;
          final userId = loginData.user.id;
          final email = loginData.user.email;
          final phone = loginData.user.phoneNumber;

          NetworkApiService().setToken(token);
          debugPrint("login token === $token");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", token);
          await prefs.setString("userId", userId.toString());
          await prefs.setString("email", email);
          await prefs.setString("phone", phone);

          debugPrint("User info saved in SharedPreferences");
        }

        responseJson = responseBody;
      } else {
        responseJson = returnResponse(response); // Handle HTTP error
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }

    return responseJson;
  }

  @override
  Future<dynamic> postSignUpRequest(String url, dynamic data) async {
    try {
      // String? token = await NetworkApiService().getToken();
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));
      debugPrint("volunteer url === $url");
      // debugPrint("volunteer token === $token");

      // Check HTTP status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);

        // Check API-level status from JSON
        if (responseJson["status"].toString() == "0") {
          throw BadRequestException(responseJson["message"].toString());
        }

        return responseJson;
      } else {
        // Handle all other HTTP errors via custom handler
        return returnResponse(response); // this throws internally
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      rethrow; // Rethrow for higher-level error handling
    }
  }

  @override
  Future<dynamic> postRequest(String url, dynamic data) async {
    try {
      String? token = await NetworkApiService().getToken();
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("Url === $url");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // ✅ return directly
      } else {
        return returnResponse(response); // ❌ Throws if not 200/201
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> multipartPostRequest(
    String url, {
    Map<String, dynamic>? fields,
    Map<String, File>? files,
  }) async {
    try {
      String? token = await getToken();
      final uri = Uri.parse(url);

      final request = http.MultipartRequest('POST', uri);

      // Headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // ---------- Add Fields ----------
      if (fields != null) {
        fields.forEach((key, value) {
          request.fields[key] = value?.toString() ?? '';
        });
      }

      // ---------- Add Files (FIXED) ----------
      if (files != null) {
        for (final entry in files.entries) {
          final fieldName = entry.key;
          final file = entry.value;

          if (!await file.exists()) {
            debugPrint("⚠️ File not found: ${file.path}");
            continue;
          }

          final filePath = file.path;
          final fileName = basename(filePath);

          // Detect content type
          final ext = fileName.split('.').last.toLowerCase();
          MediaType contentType;

          if (ext == 'pdf') {
            contentType = MediaType('application', 'pdf');
          } else if (ext == 'png') {
            contentType = MediaType('image', 'png');
          } else if (ext == 'jpg' || ext == 'jpeg') {
            contentType = MediaType('image', 'jpeg');
          } else if (ext == 'gif') {
            contentType = MediaType('image', 'gif');
          } else {
            contentType = MediaType('application', 'octet-stream');
          }

          // ----------- THE FIX -----------
          // Read file fully into memory
          final fileBytes = await file.readAsBytes();

          final multipartFile = http.MultipartFile.fromBytes(
            fieldName,
            fileBytes,
            filename: fileName,
            contentType: contentType,
          );

          request.files.add(multipartFile);

          debugPrint(
            "📤 Added file → field='$fieldName', file='$fileName', type='$contentType'",
          );
        }
      }

      // ---------- Send Request ----------
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📡 Multipart POST → ${uri.toString()}");
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("❌ Failed: ${response.statusCode} ${response.body}");
      }
    } catch (e, st) {
      debugPrint("❌ Multipart error: $e\n$st");
      rethrow;
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException("Bad Request");
      case 401:
        throw UnAuthorizedException("Unauthorized");
      case 403:
        throw UnAuthorizedException("Forbidden");
      case 404:
        throw FetchDataException("URL Not Found");
      case 500:
        throw FetchDataException("Internal Server Error");
      default:
        throw FetchDataException(
          "Error with status code: ${response.statusCode}",
        );
    }
  }

  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
