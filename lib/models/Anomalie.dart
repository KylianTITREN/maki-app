import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'Anomalie.g.dart';

@JsonSerializable()
class Anomalie {
  @JsonKey(name: 'ta_id_type')
  String idType;
  @JsonKey(name: 'ta_id_direction')
  String idDirection;
  @JsonKey(name: 'ta_nom')
  String nom;
  @JsonKey(name: 'ta_mail')
  String mail;
  @JsonKey(name: 'ta_mail_client')
  String mailClient;
  @JsonKey(name: 'ta_cas')
  String cas;
  @JsonKey(name: 'ta_ordre')
  String ordre;
  @JsonKey(name: 'ta_mail_addon')
  String mailAddon;
  @JsonKey(ignore: true)
  List<File> filesAssociated = List();

  Anomalie({
    this.idType,
    this.idDirection,
    this.nom,
    this.mail,
    this.mailClient,
    this.cas,
    this.ordre,
    this.mailAddon,
  });

  bool get isResolved => filesAssociated.length > 0;
  bool get pictureNeeded => nom == 'ANOMALIES' ? false : true;

  factory Anomalie.fromJson(Map<String, dynamic> json) => _$AnomalieFromJson(json);

  Map<String, dynamic> toJson() => _$AnomalieToJson(this);

  @override
  String toString() {
    return "Anomalie $idType";
  }
}
