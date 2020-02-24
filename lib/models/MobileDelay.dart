import 'package:json_annotation/json_annotation.dart';

part 'MobileDelay.g.dart';

@JsonSerializable()
class MobileDelay {
  @JsonKey(name: 'delay')
  int delay;

  MobileDelay({
    this.delay,
  });

  factory MobileDelay.fromJson(Map<String, dynamic> json) => _$MobileDelayFromJson(json);

  Map<String, dynamic> toJson() => _$MobileDelayToJson(this);

  @override
  String toString() {
    return '$delay';
  }
}
