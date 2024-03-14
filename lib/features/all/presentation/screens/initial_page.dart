import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/login_cubit.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, loginPageName);
      BlocProvider.of<LoginCubit>(context)
          .login(account: Account(username: "", email: "", password: ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: device(context).height * 0.4,
                width: device(context).width,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: device(context).width,
                height: device(context).height * 0.8,
                decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(40000))),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: device(context).height * 0.1,
              child: theme.brightness != Brightness.light
                  ? SizedBox(
                      height: device(context).height * 0.5,
                      width: device(context).width * 0.5,
                      child: Image.asset(
                        "lib/core/assets/images/dark_logo_without_bg.png",
                      ),
                    )
                  : SizedBox(
                      height: device(context).height * 0.5,
                      width: device(context).width * 0.5,
                      child: Image.asset(
                        "lib/core/assets/images/light_logo_without_bg.png", // Corrected path
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
