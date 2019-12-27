import 'package:c_valide/models/DataAnnually.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DataMonthly.g.dart';

@JsonSerializable()
class DataMonthly extends DataAnnually {
  @JsonKey(name: 'month')
  int month;

  DataMonthly({
    this.month,
  });

  factory DataMonthly.fromJson(Map<String, dynamic> json) => _$DataMonthlyFromJson(json);

  Map<String, dynamic> toJson() => _$DataMonthlyToJson(this);

  @override
  String toString() {
    return "[DataMonthly]";
  }
}
