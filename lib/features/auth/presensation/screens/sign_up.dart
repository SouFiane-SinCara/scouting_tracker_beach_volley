import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/language_card_change.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/my_field.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/auth_cubit.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({
    super.key,
  });

  final String errorMessage = '';

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);

    AppLocalizations? lang = AppLocalizations.of(context);
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterState) {
            Navigator.pushNamedAndRemoveUntil(
                context, choosePageName, (route) => false,
                arguments: state.account);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.secondary,
            title: AutoSizeText(
              lang!.signUp,
              style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              LanguageChangerCard(),
              SizedBox(
                width: size.width * 0.05,
              )
            ],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(

              width: size.width,
              height: size.height,
              color: theme.colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    theme.brightness == Brightness.dark
                        ? 'lib/core/assets/images/dark_signup.svg'
                        : "lib/core/assets/images/light_signup.svg",
                    height: size.height * 0.2,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is ErrorStateAuth) {
                        return Container(
                          width: size.width,
                          height: size.height * 0.045,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05),
                          child: AutoSizeText(
                            state.error,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[200],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Myfield(
                      textInputAction: TextInputAction.next,
                      controller: username,
                      text: lang.username,
                      maxLetters: 10,
                      enable: true,
                      icon: Icon(
                        Icons.person,
                        color: theme.primaryColor,
                      )),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Myfield(
                      textInputAction: TextInputAction.next,
                      controller: email,
                      text: lang.email,
                      enable: true,
                      icon: Icon(
                        Icons.mail_rounded,
                        color: theme.primaryColor,
                      )),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Myfield(
                      textInputAction: TextInputAction.done,
                      controller: password,
                      ispass: true,
                      text: lang.password,
                      enable: true,
                      icon: Icon(
                        Icons.lock_rounded,
                        color: theme.primaryColor,
                      )),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                    onTap: () async {
                      await BlocProvider.of<AuthCubit>(context).signUp(
                        context: context,
                        account: Account(
                            username: username.text,
                            email: email.text,
                            password: password.text),
                      );
                    },
                    child: Container(
                      width: size.width * 0.35,
                      decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: theme.shadowColor)
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      height: size.height * 0.065,
                      padding: EdgeInsets.only(left: size.width * 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.22,
                            height: size.height * 0.1,
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              lang.signUp,
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Icon(
                            Icons.login_rounded,
                            color: theme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        '${lang.alreadyamember}  ',
                        style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w400),
                      ),
                      InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        child: AutoSizeText(
                          lang.loginhere,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
