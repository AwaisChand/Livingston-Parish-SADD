class AppUrl {
  /// Base Url
  static var baseUrl = 'https://applpsadd.com/';

  /// Auth End Point
  static var registerEndPoint = '${baseUrl}api/register';
  static var registerAsVolunteerEndPoint =
      '${baseUrl}api/volunteers/add_volunteer';
  static var loginEndPoint = '${baseUrl}api/login';
  static var forgotPasswordEndPoint = '${baseUrl}api/forget_password';
  static var verifyOtpEndPoint = '${baseUrl}api/submit_otp';
  static var resetPasswordEndPoint = '${baseUrl}api/reset_password';
  static var resendOtpEndPoint = '${baseUrl}api/resend_otp';
  static var updatePasswordEndPoint = '${baseUrl}api/change_password';
  static var updateProfileEndPoint = '${baseUrl}api/update_profile';
  static var deleteAccountEndPoint = '${baseUrl}api/delete_account';
  static var getProfileEndPoint = '${baseUrl}api/get_profile';

  ///Register Event
  static var registerEventEndPoint = '${baseUrl}api/register_event';

  ///Resource Detail End Point
  static var resourceDetailEndPoint = '${baseUrl}api/resources';

  ///All Events End Point
  static var allEventsEndPoint = '${baseUrl}api/all_events';

  ///My Events End Point
  static var myEventsEndPoint = '${baseUrl}api/my_events';

  ///Home End Point
  static var homeEndPoint = '${baseUrl}api/home';

  ///Dashboard End Point
  static var dashBoardEndPoint = '${baseUrl}api/dashboard';

  ///Time Log Start End Point
  static var timeLogStartEndPoint = '${baseUrl}api/time/start';

  ///Time Log Stop End Point
  static var timeLogStopEndPoint = '${baseUrl}api/time/stop';

  ///Get Log Time End Point
  static var getLogTimeEndPoint = '${baseUrl}api/time/log_time/';

  ///Save Time Log
  static var saveTimeLogEndPoint = '${baseUrl}api/time/save';

  ///Filter Api End Point
  static var resourceFilterEndPoint = '${baseUrl}api/resource_filter';
  static var eventFilterEndPoint = '${baseUrl}api/event_filter';
  static var filterTagApiEndPoint = '${baseUrl}api/searchByTag';

  ///Points Api End Point
  static var pointsApiEndPoint = '${baseUrl}api/points';

  ///Device Token Stored End Point

  static var deviceTokenStoredApiEndPoint = '${baseUrl}api/storeDeviceToken';


}
