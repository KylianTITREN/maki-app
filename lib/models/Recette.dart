import 'package:json_annotation/json_annotation.dart';

part 'Recette.g.dart';

@JsonSerializable()
class Recette {
  @JsonKey(name: 'uid')
  String uid;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'icon')
  String icon;
  @JsonKey(name: 'ingredients')
  String ingredients;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'preparation')
  String preparation;
  @JsonKey(name: 'time')
  String time;
  @JsonKey(name: 'hot')
  String hot;

  Recette({
    this.uid,
    this.icon,
    this.name,
    this.ingredients,
    this.preparation,
    this.time,
    this.hot,
    this.createdAt,
  });

  factory Recette.fromJson(Map<String, dynamic> json) => _$RecetteFromJson(json);

  Map<String, dynamic> toJson() => _$RecetteToJson(this);

  @override
  String toString() {
    return name;
  }
}
