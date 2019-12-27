import 'package:c_valide/models/Data.dart';
import 'package:c_valide/models/DataAnnually.dart';
import 'package:c_valide/models/DataMonthly.dart';
import 'package:c_valide/models/MonthYear.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Magasin.g.dart';

@JsonSerializable()
class Magasin {
  @JsonKey(name: 'code_apporteur')
  String codeApporteur;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'derniere_visite')
  DateTime latestVisite;
  @JsonKey(name: 'region_id')
  int regionId;
  @JsonKey(name: 'data_daily')
  Data daily;
  @JsonKey(name: 'data_monthly')
  List<DataMonthly> monthly;
  @JsonKey(name: 'data_annually')
  List<DataAnnually> annually;

  Magasin({
    this.codeApporteur,
    this.name,
    this.latestVisite,
    this.regionId,
    this.daily,
    this.monthly,
    this.annually,
  });

  factory Magasin.fromJson(Map<String, dynamic> json) => _$MagasinFromJson(json);

  Map<String, dynamic> toJson() => _$MagasinToJson(this);

  Data rightFrequency(String frequencySelected, {MonthYear monthYearSelected}) {
    switch (frequencySelected) {
      case 'DAY':
        {
          return daily;
        }
      case 'MONTH':
        {
          return monthly.firstWhere(
            (e) => e.month == monthYearSelected?.month && e.year == monthYearSelected?.year,
            orElse: () => DataMonthly(month: monthYearSelected.month),
          );
        }
      case 'YEAR':
        {
          return annually.firstWhere(
            (e) => e.year == monthYearSelected?.year,
            orElse: () => DataAnnually(yearStr: monthYearSelected.year),
          );
        }
      default:
        return null;
    }
  }

  @override
  int get hashCode => codeApporteur.hashCode;

  @override
  bool operator ==(o) => o is Magasin && o.codeApporteur == codeApporteur;

  @override
  String toString() {
    return name;
  }
}
