class ApiResponseModel {
  final int statusCode;
  final bool error;
  final String message;
  final dynamic data;

  ApiResponseModel({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      statusCode: json['statusCode'],
      error: json['error'],
      message: json['message'],
      data: json['data'],
    );
  }
}
