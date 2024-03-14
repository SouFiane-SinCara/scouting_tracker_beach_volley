import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/tournaments_cubit/tournaments_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/my_field.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/picker_time_date.dart';

class TournamentGetinfo extends StatefulWidget {
  final Map data;

  const TournamentGetinfo({super.key, required this.data});

  @override
  State<TournamentGetinfo> createState() => _TournamentGetinfoState();
}

class _TournamentGetinfoState extends State<TournamentGetinfo> {
  TextEditingController location = TextEditingController();
  bool emptiylocation = false;
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = device(context);
    ThemeData theme = themeDevice(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    String timeAdateForm = DateFormat("y/MM/dd").format(dateTime);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            lang!.selectdateandLocation,
            style: TextStyle(color: theme.primaryColor),
          )),
      body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              emptiylocation
                  ? AutoSizeText(
                      lang.add + ' ' + lang.location,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: size.height * 0.02,
              ),
              Myfield(
                  textInputAction: TextInputAction.done,
                  controller: location,
                  text: lang.location,
                  enable: true,
                  icon: Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                  )),
              SizedBox(
                height: size.height * 0.05,
              ),
              InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                onTap: () async {
                  dateTime = await showPicker(dateTime, context);
                  
                  setState(() {});
                },
                child: Myfield(
                  textInputAction: TextInputAction.none,
                  controller: TextEditingController(),
                  text: "${lang.date}    $timeAdateForm",
                  enable: false,
                  icon: Icon(
                    Icons.calendar_month,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                onTap: () async {
                  if (location.text.isEmpty) {
                    emptiylocation = true;
                    setState(() {});
                  } else {
                    await BlocProvider.of<TournamentsCubit>(context)
                        .createLocationDate(
                            date: timeAdateForm,
                            location: location.text,
                            account: widget.data['account'],
                            tournamentTitle: widget.data['title']);
                    await BlocProvider.of<TournamentsCubit>(context)
                        .getlocationDate(
                            account: widget.data['account'],
                            tournamentTitle: widget.data['title']);
                    Navigator.pop(context);
                  }
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
                  child: Container(
                    height: size.height * 0.1,
                    alignment: Alignment.center,
                    width: size.width * 0.22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          lang.add,
                          style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.add)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
