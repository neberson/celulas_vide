
import 'package:celulas_vide/widgets/margin.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final String hint;
  final Function validator;

  TextFieldCustom(this.controller, this.label, this.hint, {this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginStart,
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),

        ),
      ),
    );
  }
}
