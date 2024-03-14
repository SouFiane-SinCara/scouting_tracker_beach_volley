import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

class Myfield extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final int? maxLetters;
  final bool? isNote;
  final Widget icon;
  final bool enable;
  final bool? ispass;

  final TextInputAction textInputAction;
  Myfield(
      {super.key,
      this.ispass,
      required this.textInputAction,
      this.maxLetters,
      required this.controller,
      required this.text,
      this.isNote,
      required this.enable,
      required this.icon});

  @override
  State<Myfield> createState() => _MyfieldState();
}

class _MyfieldState extends State<Myfield> {
  bool showpass = false;

  @override
  Widget build(BuildContext context) {
    Size size = device(context);
    ThemeData theme = Theme.of(context);
    return Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            boxShadow: [BoxShadow(blurRadius: 5, color: theme.shadowColor)],
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        height:
            widget.maxLetters == null ? size.height * 0.07 : size.height * 0.11,
        padding: widget.maxLetters == null
            ? EdgeInsets.only(
                right: widget.ispass == null ? size.width * 0.08 : 0,
              )
            : EdgeInsets.only(top: size.height * 0, right: size.width * 0.03),
        alignment: widget.maxLetters != null
            ? Alignment.bottomCenter
            : Alignment.center,
        child: TextField(
          maxLines: widget.isNote != null ? 10 : 1,
          textInputAction: widget.textInputAction,
          enabled: widget.enable,
          maxLength: widget.maxLetters,
          cursorColor: theme.primaryColor,
          obscureText:
              widget.ispass == true && showpass == false ? true : false,
          controller: widget.controller,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              suffixIcon: widget.ispass != null
                  ? IconButton(
                      onPressed: () {
                        showpass = !showpass;
                        setState(() {});
                      },
                      icon: showpass == false
                          ? Icon(
                              Icons.visibility,
                              color: theme.primaryColor,
                              size: 15,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: theme.primaryColor,
                            ))
                  : null,
              border: InputBorder.none,
              prefixIcon: widget.icon,

              //this hinttext is not responsive
              hintText: widget.text,
              hintStyle: TextStyle(
                fontWeight: widget.enable ? FontWeight.w400 : FontWeight.bold,
                color: theme.primaryColor,
              )),
        ));
  }
}
