// common response type
// use to parse network data to cubit response
class DataResponse<T> {
  Status status;

  T? data;
  String? message;
  String? modelType;
  int? statusCode;
  String? code;

  DataResponse.loading(this.message) : status = Status.loading;
  DataResponse.success(this.data) : status = Status.success;
  DataResponse.error(this.message, [this.statusCode, this.code])
      : status = Status.error;
  DataResponse.connectivityError() : status = Status.connectivityError;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { loading, success, error, connectivityError }
