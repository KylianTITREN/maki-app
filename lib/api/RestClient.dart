import 'dart:io';

import 'package:c_valide/models/Anomalies.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'RestClient.g.dart';

@RestApi(baseUrl: "https://c-visite.fr/c-anomalie-add-on-r7/public/index.php/")
abstract class RestClient {
  static RestClient instance([Dio dio]) => _RestClient(dio);
  static RestClient service = initialize();

  static RestClient initialize() {
    final dio = Dio();
    dio.options.baseUrl = "https://c-visite.fr/c-anomalie-add-on-r7/public/index.php/";
    dio.options.contentType = ContentType.parse("application / x-www-form-urlencoded");
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    final client = RestClient.instance(dio);

    return client;
  }

  @GET("mobile-folders/{uid}")
  @Headers({
    "Accept": "application/json",
    "Host": "c-visite.fr",
  })
  Future<Anomalies> getAnomalies(
    @Path('uid') String uid,
  );

  @FormUrlEncoded()
  @POST("mobile-folders/{uid}/anomalie-types/{anomalieTypeId}/upload-document")
  @Headers({
    "Accept": "application/json",
    "Host": "c-visite.fr",
    "Content-Type": "multipart/form-data",
  })
  Future<void> sendDocument(
    @Query('token') String token,
    @Path('uid') String uid,
    @Path('anomalieTypeId') String anomalieTypeId,
    @Field('document') File file,
  );
}
