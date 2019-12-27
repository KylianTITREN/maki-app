import 'package:c_valide/models/Data.dart';
import 'package:c_valide/models/DataAnnually.dart';
import 'package:c_valide/models/DataMonthly.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TotalData.g.dart';

@JsonSerializable()
class TotalData {
  @JsonKey(name: 'daily')
  Data daily;
  @JsonKey(name: 'monthly')
  List<DataMonthly> monthly;
  @JsonKey(name: 'annually')
  List<DataAnnually> annually;

  TotalData({
    this.daily,
    this.monthly,
    this.annually,
  });

  factory TotalData.fromJson(Map<String, dynamic> json) => _$TotalDataFromJson(json);

  Map<String, dynamic> toJson() => _$TotalDataToJson(this);

  @override
  String toString() {
    return "[TotalData]";
  }
}
