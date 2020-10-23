import 'package:flutter/material.dart';

Future<bool> showDialogDecision(
  context, {
  title,
  message,
  icon = Icons.info_outline,
  colorIcon = const Color.fromRGBO(81, 37, 103, 1),
}) async =>
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 40,
                    color: colorIcon,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(title)
                ],
              ),
              content: Text(
                message,
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Não',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () => Navigator.pop(context)),
                FlatButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Sim',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context, true))
              ],
            ),
          );
        });
