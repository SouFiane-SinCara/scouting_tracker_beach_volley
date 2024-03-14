import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/choose_page.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/language_card_change.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/my_field.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoginDoneState) {
          return ChoosePage(account: state.account);
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              actions: [
                LanguageChangerCard(),
                SizedBox(
                  width: size.width * 0.05,
                )
              ],
              backgroundColor: theme.colorScheme.secondary,
              title: AutoSizeText(
                lang!.login,
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                color: theme.colorScheme.primary,
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      theme.brightness == Brightness.dark
                          ? 'lib/core/assets/images/dark_login.svg'
                          : "lib/core/assets/images/light_login.svg",
                      height: size.height * 0.2,
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, loginState) {
                        if (loginState is ErrorLoginState) {
                          return Container(
                            width: size.width * 0.8,
                            height: size.height * 0.03,
                            child: AutoSizeText(
                              loginState.error,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.05,
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
                        textInputAction: TextInputAction.next,
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
                        await BlocProvider.of<LoginCubit>(context).login(
                            context: context,
                            account: Account(
                                username: "",
                                email: email.text.trim(),
                                password: password.text.trim()));
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
                              height: size.height * 0.1,
                              alignment: Alignment.center,
                              width: size.width * 0.22,
                              child: AutoSizeText(
                                lang.login,
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
                        Container(
                          child: AutoSizeText(
                            '${lang.donthaveanaccount}  ',
                            style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.pushNamed(context, signUpPageName);
                          },
                          child: AutoSizeText(
                            lang.signuphere,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
