/// API-related constants
class ApiConstant {
  // Headers
  static const String contentType = 'content-type';
  static const String accept = 'accept';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String applicationJson = 'application/json';

  // Error messages
  static const String noInternetConnection = 'No internet connection';
  static const String errorDuringCommunication = 'Error during communication';
  static const String invalidRequest = 'Invalid request';
  static const String resourceNotFound = 'Resource not found';
  static const String unauthorized = 'Unauthorized access';
  static const String invalidInput = 'Invalid input';
  static const String internalServerError = 'Internal server error';
  static const String badRequest = 'Bad request';
  static const String unableToProcessData = 'Unable to process the data';
  static const String sessionTimeout = 'Session timeout, please login again';
  static const String tooManyRequests = 'Too many requests, try again later';
  static const String somethingWentWrong = 'Something went wrong';
  static const String requestCancelled = 'Request cancelled';
  static const String connectionTimeout = 'Connection timeout';
  static const String receiveTimeout = 'Receive timeout';
  static const String sendTimeout = 'Send timeout';
  static const String unAuthorized = 'Unauthorized';
  static const String errorOccurredWhileFetchingData =
      'Error occurred while fetching data';

  // Status codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusAccepted = 202;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusConflict = 409;
  static const int statusUnprocessableEntity = 422;
  static const int statusTooManyRequests = 429;
  static const int statusInternalServerError = 500;
  static const int statusNoInternet = 1000;
}
