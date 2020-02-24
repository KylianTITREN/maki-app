import 'package:json_annotation/json_annotation.dart';

part 'Dico.g.dart';

@JsonSerializable()
class Dico {
  @JsonKey(name: 'from')
  String from;
  @JsonKey(name: 'words')
  List<String> words;

  Dico({
    this.from,
    this.words,
  });

  factory Dico.fromJson(Map<String, dynamic> json) => _$DicoFromJson(json);

  Map<String, dynamic> toJson() => _$DicoToJson(this);

  @override
  String toString() {
    return from;
  }
}
