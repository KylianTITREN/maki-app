import 'package:json_annotation/json_annotation.dart';

part 'Message.g.dart';

@JsonSerializable()
class Message {
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'content')
  String content;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'read')
  String read;
  

  Message({
    this.title,
    this.content,
    this.url,
    this.read
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return content;
  }
}
