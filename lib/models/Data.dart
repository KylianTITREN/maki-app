import 'package:c_valide/res/Strings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Data.g.dart';

@JsonSerializable()
class Data {
  @JsonKey(name: 'nb_vac')
  int nbVAC;
  @JsonKey(name: 'nb_credit')
  int nbCredits;
  @JsonKey(name: 'taux_se')
  double tauxSE;
  @JsonKey(name: 'nb_vac_requested')
  int nbVACRequested;
  @JsonKey(name: 'nb_credit_requested')
  int nbCreditsRequested;
  @JsonKey(name: 'taux_ade')
  double tauxAde;
  @JsonKey(name: 'prod')
  int production;

  int get accepted => (nbVAC ?? 0) + (nbCredits ?? 0);

  double get tauxAcc {
    var tauxAccTmp = ((nbCreditsRequested ?? 0) > 0 ? (accepted / nbRequested) : 0.0) * 100;
    return tauxAccTmp >= 0 && tauxAccTmp <= 100 ? tauxAccTmp : null;
  }

  int get nbRequested => (nbCreditsRequested ?? 0) + (nbVACRequested ?? 0);

  Data({
    this.nbVAC,
    this.nbCredits,
    this.tauxSE,
    this.tauxAde,
    this.nbVACRequested,
    this.production,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  dynamic rightData(String t) {
    switch (t) {
      case 'VAC':
        {
          return nbVAC;
        }
      case 'CREDITS':
        {
          return nbCredits;
        }
      case 'TAUXSE':
        {
          return (tauxSE?.toStringAsFixed(2) ?? Strings.textNA);
        }
      case 'TAUXADE':
        {
          return (tauxAde?.toStringAsFixed(2) ?? Strings.textNA);
        }
      case 'DEMANDES':
        {
          return nbCreditsRequested;
        }
      case 'TAUXACC':
        {
          return (tauxAcc?.toStringAsFixed(2) ?? Strings.textNA);
        }
      case 'PRODUCTION':
        {
          return production;
        }
      default:
        {
          return Strings.textNA;
        }
    }
  }

  @override
  String toString() {
    return "[Data]";
  }
}
