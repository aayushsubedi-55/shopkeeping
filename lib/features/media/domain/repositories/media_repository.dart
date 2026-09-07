import 'dart:io';

import 'package:shopnepal/core/network/http.dart';

abstract class MediaRepository {
  Future<DataResponse<String>> uploadMedia({required File file});
}
