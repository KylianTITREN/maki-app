import 'package:json_annotation/json_annotation.dart';

part 'Availability.g.dart';

@JsonSerializable()
class Availability {
  @JsonKey(name: 'isAvailable')
  bool isAvailable;
  @JsonKey(name: 'isOpenHours')
  bool isOpenHours;

  Availability({
    this.isAvailable,
    this.isOpenHours,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => _$AvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityToJson(this);

  @override
  String toString() {
    return '$isAvailable && $isOpenHours';
  }
}
