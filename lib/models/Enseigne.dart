import 'package:json_annotation/json_annotation.dart';

part 'Enseigne.g.dart';

@JsonSerializable()
class Enseigne {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'last_update')
  DateTime lastUpdate;
  @JsonKey(name: 'last_monthly_update')
  DateTime lastMonthlyUpdate;
  @JsonKey(name: 'last_ouvertures_update')
  DateTime lastOuverturesUpdate;
  @JsonKey(name: 'year_record')
  int yearRecord;
  @JsonKey(name: 'nb_vac_record')
  int nbVACRecord;
  @JsonKey(name: 'nb_credit_record')
  int nbCreditRecord;
  @JsonKey(name: 'taux_se_record')
  double tauxSERecord;

  Enseigne({
    this.id,
    this.name,
    this.lastUpdate,
    this.lastMonthlyUpdate,
    this.lastOuverturesUpdate,
    this.yearRecord,
    this.nbVACRecord,
    this.nbCreditRecord,
    this.tauxSERecord,
  });

  factory Enseigne.fromJson(Map<String, dynamic> json) => _$EnseigneFromJson(json);

  Map<String, dynamic> toJson() => _$EnseigneToJson(this);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(o) => o is Enseigne && o.id == id;

  @override
  String toString() {
    return name;
  }
}
