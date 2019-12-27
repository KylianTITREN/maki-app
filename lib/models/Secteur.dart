import 'package:json_annotation/json_annotation.dart';

part 'Secteur.g.dart';

@JsonSerializable()
class Secteur {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;

  Secteur({
    this.id,
    this.name,
  });

  factory Secteur.fromJson(Map<String, dynamic> json) => _$SecteurFromJson(json);

  Map<String, dynamic> toJson() => _$SecteurToJson(this);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(o) => o is Secteur && o.id == id;

  @override
  String toString() {
    return name;
  }
}
