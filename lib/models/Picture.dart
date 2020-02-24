import 'package:json_annotation/json_annotation.dart';

part 'Picture.g.dart';

@JsonSerializable()
class Picture {
  @JsonKey(name: 'asset')
  String asset;
  @JsonKey(name: 'added_at')
  String addedAt;

  Picture({
    this.asset,
    this.addedAt,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);

  @override
  String toString() {
    return asset;
  }
}
