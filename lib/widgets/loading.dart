
import 'package:flutter/material.dart';

loading () => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          height: 50.0,
          width: 50.0,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Carregando dados...",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    ));