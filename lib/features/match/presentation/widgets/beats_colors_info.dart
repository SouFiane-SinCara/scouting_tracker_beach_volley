import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

class ColorTitle {
  Color color;
  String title;
  ColorTitle({required this.color, required this.title});
}
 
 
class BeatColorsInfo extends StatelessWidget {
  ColorTitle? info1;
  ColorTitle? info2;
  ColorTitle? info3;
  ColorTitle? info4;

  BeatColorsInfo({super.key, this.info1, this.info2, this.info3, this.info4});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    return SizedBox(
      height: size.height * 0.1,
      width: size.width * 0.5,
      child: Stack(
        children: [
          info1 == null
              ? const SizedBox()
              : Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                    width: size.width * 0.25,
                    height: size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: info1!.color, shape: BoxShape.circle),
                          height: size.height * 0.02,
                          width: size.width * 0.02,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Container(
                          width: size.width * 0.21,
                          height: size.height * 0.04,
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              info1!.title,
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
          info2 == null
              ? const SizedBox()
              : Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    color: theme.colorScheme.primary,
                    width: size.width * 0.25,
                    height: size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: info2!.color, shape: BoxShape.circle),
                          height: size.height * 0.02,
                          width: size.width * 0.02,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Container(
                          width: size.width * 0.21,
                          height: size.height * 0.04,
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              info2!.title,
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
          info3 == null
              ? const SizedBox()
              : Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    color: theme.colorScheme.primary,
                    width: size.width * 0.25,
                    height: size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: info3!.color, shape: BoxShape.circle),
                          height: size.height * 0.02,
                          width: size.width * 0.02,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Container(
                          width: size.width * 0.21,
                          height: size.height * 0.04,
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              info3!.title,
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
          info4 == null
              ? const SizedBox()
              : Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    color: theme.colorScheme.primary,
                    width: size.width * 0.25,
                    height: size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: info4!.color, shape: BoxShape.circle),
                          height: size.height * 0.02,
                          width: size.width * 0.02,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Container(
                          width: size.width * 0.21,
                          height: size.height * 0.04,
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              info4!.title,
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}
