
import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/models/AllData.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'COuvertClient.g.dart';

@RestApi()
abstract class COuvertClient {
  static COuvertClient instance([Dio dio]) => _COuvertClient(dio);
  static COuvertClient service = _initialize();

  static COuvertClient _initialize() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.fnacApiBaseUrl;
//    dio.options.contentType = ContentType.parse("application / x-www-form-urlencoded");
    dio.options.contentType = "application/json";
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    final client = COuvertClient.instance(dio);

    return client;
  }

  @GET("data-export")
  Future<AllData> getAllData(
    @Query('enseigne_id') int enseigneId, {
    @Query('month') int month,
    @Query('year') int year,
    @Query('region_id') int regionId,
    @Query('agence_id') int agenceId,
    @Query('secteur_id') int secteurId,
  });
}
