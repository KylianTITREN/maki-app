import 'package:c_valide/models/Enseigne.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Marche.g.dart';

@JsonSerializable()
class Marche {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'enseignes')
  List<Enseigne> enseignes;

  Marche({
    this.id,
    this.name,
    this.enseignes,
  });

  factory Marche.fromJson(Map<String, dynamic> json) => _$MarcheFromJson(json);

  Map<String, dynamic> toJson() => _$MarcheToJson(this);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(o) => o is Marche && o.id == id;

  @override
  String toString() {
    return name;
  }
}
