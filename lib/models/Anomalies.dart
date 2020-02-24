import 'package:c_valide/models/Anomalie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Anomalies.g.dart';

@JsonSerializable()
class Anomalies {
  @JsonKey(name: 'uid')
  String uid;
  @JsonKey(name: 'folder_number')
  String folderNumber;
  @JsonKey(name: 'state')
  String state;
  @JsonKey(name: 'id_advisor')
  String idAdvisor;
  @JsonKey(name: 'adviser_text')
  String advisorText;
  @JsonKey(name: 'id_enseigne')
  String idEnseigne;
  @JsonKey(name: 'comment')
  String comment;
  @JsonKey(name: 'start_study_at')
  DateTime startStudyAt;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  @JsonKey(name: 'anomalie_types')
  List<Anomalie> anomalieTypes;

  Anomalies({
    this.uid,
    this.folderNumber,
    this.state,
    this.idAdvisor,
    this.advisorText,
    this.idEnseigne,
    this.comment,
    this.startStudyAt,
    this.createdAt,
    this.updatedAt,
    this.anomalieTypes,
  });

  factory Anomalies.fromJson(Map<String, dynamic> json) => _$AnomaliesFromJson(json);

  Map<String, dynamic> toJson() => _$AnomaliesToJson(this);

  @override
  String toString() {
    return "Anomalies $uid";
  }
}
