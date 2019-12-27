import 'package:c_valide/models/Data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DataAnnually.g.dart';

@JsonSerializable()
class DataAnnually extends Data {
  @JsonKey(name: 'year')
  var yearStr;

  DataAnnually({
    this.yearStr,
  });

  /// Récupère une année soit en integer soit en string
  /// et la converti en integer
  int get year => int.parse(yearStr.toString());

  factory DataAnnually.fromJson(Map<String, dynamic> json) => _$DataAnnuallyFromJson(json);

  Map<String, dynamic> toJson() => _$DataAnnuallyToJson(this);

  @override
  String toString() {
    return "[DataAnnually]";
  }
}
