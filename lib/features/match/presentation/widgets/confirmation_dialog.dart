import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

void showDialogConfirmation(
    {required BuildContext context,
    required Function()? fun,
    Function()? redDelete,
    Function()? blueDelete,
    required String dialogmessage,
    bool? lastpointNull}) {
  ThemeData theme = Theme.of(context);
  Size size = device(context);

  AppLocalizations? lang = AppLocalizations.of(context);

  showDialog( 
      
    context: context,

    builder: (context) =>

        AlertDialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
            actions: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.primary,
        ),
        width: size.width,
        height: size.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.5,
              height: size.height * 0.05,
              child: FittedBox(
                child: Text(
                  dialogmessage,
                  style: TextStyle(
                      color: theme.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            lastpointNull == null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: size.width * 0.2,
                          height: size.height * 0.055,
                          child: Icon(
                            Icons.close,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.1,
                      ),
                      InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        onTap: fun,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: size.width * 0.2,
                          height: size.height * 0.055,
                          child: Icon(
                            Icons.done,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        onTap: blueDelete,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: size.width * 0.2,
                          height: size.height * 0.055,
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              "blue team",
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.1,
                      ),
                      InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        onTap: redDelete,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: size.width * 0.2,
                          height: size.height * 0.055,
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              "red team",
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
          ],
        ),
      )
    ]),
  );
}
