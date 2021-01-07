

import 'package:flutter/material.dart';

import 'margin_setup.dart';

stateError(context, error, {icon = Icons.error}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
        child: Container(
          height: 80,
          width: 100,
          margin: EdgeInsets.only(bottom: 32, top: 16,),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(
              icon,
              size: 50,
              color: Colors.black54,
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          margin: marginFieldMiddle,
          child: Text(
            "Ocorreu um erro",
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Center(
        child: Container(
          margin: marginFieldMiddle,
          child: Text(error,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}