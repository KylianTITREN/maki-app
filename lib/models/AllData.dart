import 'package:c_valide/models/TotalData.dart';
import 'package:c_valide/models/UniqueData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AllData.g.dart';

@JsonSerializable()
class AllData {
  @JsonKey(name: 'last_update')
  DateTime lastUpdate;
  @JsonKey(name: 'unique')
  UniqueData unique;
  @JsonKey(name: 'total')
  TotalData total;

  AllData({
    this.lastUpdate,
    this.unique,
    this.total,
  });

  factory AllData.fromJson(Map<String, dynamic> json) => _$AllDataFromJson(json);

  Map<String, dynamic> toJson() => _$AllDataToJson(this);

  @override
  String toString() {
    return "[AllData]";
  }
}
