import 'package:flutter/material.dart';

Future showDialogBase(context, String message, textButton,
        {icon = Icons.info_outline,
        colorIcon = const Color.fromRGBO(81, 37, 103, 1),
        String title,
        bool barrierDismissible = false}) async =>
    await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => barrierDismissible,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                  Text(
                    title,
                  ),
                ],
              ),
              content: Text(
                message,
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: OutlineButton(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        textButton,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context)),
                )
              ],
            ),
          );
        });
