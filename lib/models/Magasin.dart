import 'package:json_annotation/json_annotation.dart';

part 'Magasin.g.dart';

@JsonSerializable()
class Magasin {
  @JsonKey(name: 'ma_id_magasin')
  String id;
  @JsonKey(name: 'ma_id_enseigne')
  String enseigneId;
  @JsonKey(name: 'ma_cod_apporteur')
  String codeApporteur;
  @JsonKey(name: 'ma_nom')
  String name;
  @JsonKey(name: 'ma_ville')
  String ville;

  Magasin({
    this.id,
    this.enseigneId,
    this.codeApporteur,
    this.name,
    this.ville
  });

  factory Magasin.fromJson(Map<String, dynamic> json) => _$MagasinFromJson(json);

  Map<String, dynamic> toJson() => _$MagasinToJson(this);

  @override
  int get hashCode => codeApporteur.hashCode;

  @override
  bool operator ==(o) => o is Magasin && o.codeApporteur == codeApporteur;

  @override
  String toString() {
    return name;
  }
}
