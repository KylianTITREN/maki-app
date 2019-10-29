import 'package:json_annotation/json_annotation.dart';

part 'AutoUpdate.g.dart';

@JsonSerializable()
class AutoUpdate {
  @JsonKey(name: 'version')
  String version;
  @JsonKey(name: 'build_number')
  int buildNumber;
  @JsonKey(name: 'last_force_update_build_number')
  int lastForcedBuildNumber;
  @JsonKey(name: 'build_location')
  String buildLocation;

  AutoUpdate(this.version, this.buildNumber, this.lastForcedBuildNumber, this.buildLocation);

  factory AutoUpdate.fromJson(Map<String, dynamic> json) => _$AutoUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$AutoUpdateToJson(this);

  @override
  String toString() {
    return '$version ($buildNumber)';
  }
}
