import 'dart:io';

abstract class BaseApiServices {
  Future<dynamic> getRequest(String url);

  Future<dynamic> postLoginRequest(String url, dynamic data);
  Future<dynamic> postApiResponse(String url);
  Future<dynamic> postSignUpRequest(String url, dynamic data);
  Future<dynamic> postRequest(String url, dynamic data);
  Future<dynamic> multipartPostRequest(
      String url, {
        Map<String, dynamic>? fields,
        Map<String, File>? files,
      });

}
