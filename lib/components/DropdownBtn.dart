import 'package:c_valide/res/Colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ValueChangedCallback = void Function(dynamic newValue);

class DropdownBtn<T> extends StatefulWidget {
  DropdownBtn(this.arrayValues, {key, @required this.value, this.onValueChanged}) : super(key: key);

  final T value;
  final List<DropdownValue> arrayValues;
  final ValueChangedCallback onValueChanged;

  @override
  DropdownBtnState createState() => DropdownBtnState<T>();
}

class DropdownBtnState<T> extends State<DropdownBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 215.0,
      height: 30.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colours.primaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          minWidth: double.infinity,
          alignedDropdown: true,
          child: DropdownButton<T>(
            isDense: true,
            isExpanded: true,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            value: widget.value,
            items: widget.arrayValues.map((DropdownValue value) {
              return DropdownMenuItem<T>(
                value: value.value,
                child: Text(value.display),
              );
            }).toList(),
            onChanged: (T newValue) {
              if (widget.onValueChanged != null) {
                widget.onValueChanged(newValue);
              }
            },
          ),
        ),
      ),
    );
  }
}

class DropdownValue<T> {
  DropdownValue(this._value, this._display);

  T _value;
  String _display;

  T get value => _value;

  String get display => _display;

  @override
  String toString() {
    return '$value : $display';
  }
}
