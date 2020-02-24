import 'package:c_valide/autoupdate/AutoUpdate.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'VersionsClient.g.dart';

@RestApi()
abstract class VersionsClient {
  static VersionsClient instance([Dio dio]) => _VersionsClient(dio);
  static VersionsClient service = _initialize();

  static VersionsClient _initialize() {
    final dio = Dio();
    dio.options.baseUrl = "https://sn-prod4.com/versioning/api/";
    dio.options.contentType = "application/json";
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    final client = VersionsClient.instance(dio);

    return client;
  }

  @GET("versions/{autoUpdateId}")
  Future<AutoUpdate> autoUpdate(@Path('autoUpdateId') String autoUpdateId);
}
