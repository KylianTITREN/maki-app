import 'package:c_valide/res/Strings.dart';
import 'package:intl/intl.dart';

class MonthYear {
  MonthYear([this._month, this._year]);

  int _month;
  int _year;

  String get monthStr => DateFormat('MMMM').format(DateTime(year, month));

  int get month => _month;

  int get year => _year;

  @override
  int get hashCode => _month.hashCode ^ _year.hashCode;

  bool get isNotNull => month != null && year != null;

  @override
  bool operator ==(o) => o is MonthYear && o.month == month && o.year == year;

  @override
  String toString() {
    return isNotNull ? '${month >= 0 ? monthStr + ' ' : ''}$year' : Strings.textSelect;
  }
}
