import 'package:c_valide/models/Magasin.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AllShop.g.dart';

@JsonSerializable()
class AllShop {
  @JsonKey(name: 'magasins')
  List<Magasin> magasins;

  AllShop({
    this.magasins,
  });

  factory AllShop.fromJson(Map<String, dynamic> json) => _$AllShopFromJson(json);

  Map<String, dynamic> toJson() => _$AllShopToJson(this);

  @override
  String toString() {
    return '';
  }
}
