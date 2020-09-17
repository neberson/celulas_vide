
import 'package:flutter/material.dart';

import 'margin_setup.dart';

emptyState(context, mensagem, icon) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
        child: Container(
          height: 50,
          width: 70,
          margin: EdgeInsets.only(bottom: 8, top: 16,),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(
              icon,
              color: Colors.black54,
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          margin: marginFieldMiddle,
          child: Text(
            "Nada por aqui",
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Center(
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(mensagem,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}