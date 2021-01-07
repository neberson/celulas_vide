import 'package:celulas_vide/widgets/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Function validator;
  final bool readOnly;
  final Function onTap;
  final TextInputType textInputType;
  List<TextInputFormatter> inputFormaters;

  TextFieldCustom(this.controller, this.label,
      {this.validator,
      this.hint,
      this.readOnly = false,
      this.onTap,
      this.textInputType = TextInputType.text, this.inputFormaters});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginStart,
      child: TextFormField(
        controller: controller,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: textInputType,
        inputFormatters: inputFormaters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
