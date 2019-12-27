import 'package:c_valide/models/Secteur.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Agence.g.dart';

@JsonSerializable()
class Agence {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'secteurs')
  List<Secteur> secteurs;

  Agence({
    this.id,
    this.name,
  });

  factory Agence.fromJson(Map<String, dynamic> json) => _$AgenceFromJson(json);

  Map<String, dynamic> toJson() => _$AgenceToJson(this);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(o) => o is Agence && o.id == id;

  @override
  String toString() {
    return name;
  }
}
