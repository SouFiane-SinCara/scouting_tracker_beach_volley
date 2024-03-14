import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';

Future DialogError(String error, BuildContext context) {
  Size size = device(context);
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            actions: [
              Container(
                height: size.height * 0.2,
                width: size.width,
                decoration: BoxDecoration(
                    color: themeDevice(context).colorScheme.primary,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.5,
                      height: size.height * 0.1,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ));
}
