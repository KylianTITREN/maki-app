import 'package:json_annotation/json_annotation.dart';

part 'ActiveMessage.g.dart';

@JsonSerializable()
class ActiveMessage {
  @JsonKey(name: 'activated')
  bool activated;

  ActiveMessage({
    this.activated,
  });

  factory ActiveMessage.fromJson(Map<String, dynamic> json) => _$ActiveMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveMessageToJson(this);

  @override
  String toString() {
    return '$ActiveMessage';
  }
}
