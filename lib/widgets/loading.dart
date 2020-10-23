
import 'package:flutter/material.dart';

loading ({Color colorElement = Colors.black}) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorElement),),
          height: 50.0,
          width: 50.0,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Carregando dados...",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorElement),
        )
      ],
    ));