import 'package:json_annotation/json_annotation.dart';

part 'AdvisorAvailability.g.dart';

@JsonSerializable()
class AdvisorAvailability {
  @JsonKey(name: 'isAvailable')
  bool isAvailable;

  AdvisorAvailability({
    this.isAvailable,
  });

  factory AdvisorAvailability.fromJson(Map<String, dynamic> json) => _$AdvisorAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorAvailabilityToJson(this);

  @override
  String toString() {
    return isAvailable ? 'Success' : 'Failed';
  }
}
