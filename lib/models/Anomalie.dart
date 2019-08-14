import 'package:json_annotation/json_annotation.dart';

part 'Anomalie.g.dart';

@JsonSerializable()
class Anomalie {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'text')
  String text;

  Anomalie({this.id, this.text});

  factory Anomalie.fromJson(Map<String, dynamic> json) => _$AnomalieFromJson(json);

  Map<String, dynamic> toJson() => _$AnomalieToJson(this);

  @override
  String toString() {
    return "Anomalie $id";
  }
}
