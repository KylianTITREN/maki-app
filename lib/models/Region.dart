import 'package:json_annotation/json_annotation.dart';

part 'Region.g.dart';

@JsonSerializable()
class Region {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;

  Region({
    this.id,
    this.name,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(o) => o is Region && o.id == id;

  @override
  String toString() {
    return name;
  }
}
