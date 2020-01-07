import 'dart:io';

import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/models/ActiveMessage.dart';
import 'package:c_valide/models/AllShop.dart';
import 'package:c_valide/models/Anomalies.dart';
import 'package:c_valide/models/Availability.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'RestClient.g.dart';

@RestApi()
abstract class RestClient {
  static RestClient instance([Dio dio]) => _RestClient(dio);
  static RestClient service = initialize(60000, 'application/x-www-form-urlencoded');
  static RestClient jsonService = initialize(60000, 'application/json');
  static RestClient fastTimeout = initialize(2000);

  static RestClient initialize(int timeout, [String contentType]) {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.apiBaseUrl;
    if (contentType != null) {
      dio.options.contentType = contentType;
    }
    dio.options.connectTimeout = timeout;
    dio.options.receiveTimeout = timeout;
    final client = RestClient.instance(dio);

    return client;
  }

  @GET("mobile-folders/{uid}")
  @Header("Accept: application/json")
  @Header("Host: c-visite.fr")
  Future<Anomalies> getAnomalies(
    @Path('uid') String uid,
  );

  @FormUrlEncoded()
  @POST("mobile-folders/{uid}/anomalie-types/{anomalieTypeId}/upload-document")
  @Header("Accept : application/json")
  @Header("Host : c-visite.fr")
  @Header("Content-Type : multipart/form-data")
  Future<void> sendDocument(
    @Query('token') String token,
    @Path('uid') String uid,
    @Path('anomalieTypeId') String anomalieTypeId,
    @Field('document') File file,
  );

  @POST("mobile-folders/{uid}/satisfaction")
  @Header("Accept : application/json")
  @Header("Host : c-visite.fr")
  @Header("Content-Type : application/json")
  Future<void> sendSatisfactionResult(
    @Query('token') String token,
    @Path('uid') String uid,
    @Field('score') int score,
    @Field('score_comment') String scoreComment,
  );

  @GET("advisers/is-available")
  Future<Availability> areServicesAvailable(
    @Query('token') String token,
  );

  @GET("magasins")
  Future<AllShop> getShop(
    @Query('token') String token,
    @Query('enseigne_id') int enseigneId,
  );

  @GET("chat/is-active")
  Future<ActiveMessage> isChatAvailable();
}
