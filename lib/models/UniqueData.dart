import 'package:c_valide/models/Agence.dart';
import 'package:c_valide/models/Magasin.dart';
import 'package:c_valide/models/Marche.dart';
import 'package:c_valide/models/Region.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UniqueData.g.dart';

@JsonSerializable()
class UniqueData {
  @JsonKey(name: 'regions')
  List<Region> regions;
  @JsonKey(name: 'agences')
  List<Agence> agences;
  @JsonKey(name: 'marches')
  List<Marche> marches;
  @JsonKey(name: 'magasins')
  List<Magasin> magasins;

  UniqueData({
    this.regions,
    this.agences,
    this.marches,
    this.magasins,
  });

  factory UniqueData.fromJson(Map<String, dynamic> json) => _$UniqueDataFromJson(json);

  Map<String, dynamic> toJson() => _$UniqueDataToJson(this);

  @override
  String toString() {
    return "[UniqueData]";
  }
}
