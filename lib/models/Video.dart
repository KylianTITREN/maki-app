import 'package:json_annotation/json_annotation.dart';

part 'Video.g.dart';

@JsonSerializable()
class Video {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'icon')
  String icon;
  @JsonKey(name: 'url')
  String url;

  Video({
    this.icon,
    this.name,
    this.url,
  });

  Video.fromAJson(Map data) {
    icon = data['icon'];
    name = data['name'];
    url = data['url'];
  }

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);

  @override
  String toString() {
    return name;
  }
}
