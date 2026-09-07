import 'package:shopnepal/core/network/http.dart';

class MediaRemoteDataSource {
  final ApiProvider apiProvider;
  final String basePath = 'media';

  MediaRemoteDataSource({required this.apiProvider});

  Future<dynamic> uploadMedia(dynamic body) async {
    return await apiProvider.post('$basePath/upload', body);
  }
}
