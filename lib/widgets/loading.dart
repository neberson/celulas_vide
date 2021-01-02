import 'package:flutter/material.dart';

loadingProgress(
        {Color colorElement = Colors.black, title = 'Carregando dados...'}) =>
    Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorElement),
          ),
          height: 50.0,
          width: 50.0,
        ),
        SizedBox(
          height: 30,
        ),
        Text(title)
      ],
    ));
