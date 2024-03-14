// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';

class Playercard extends StatelessWidget {
  final Player player;
  final bool? taped;

  const Playercard({
    Key? key,
    this.taped,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);

    AppLocalizations? lang = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
            width: size.width * 0.4,
            alignment: Alignment.center,
            height: size.height * 0.2,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 5, color: theme.shadowColor)],
                border: Border.all(
                    color: taped == null || taped == false
                        ? theme.primaryColor
                        : theme.primaryColor,
                    width: taped == null || taped == false ? 1 : 2),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SizedBox(
              height: size.height * 0.2,
              width: size.width * 0.4,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: CachedNetworkImage(
                    imageUrl: player.image,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            )),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: taped == null || taped == false
                      ? theme.primaryColor
                      : theme.primaryColor,
                  width: taped == null || taped == false ? 1 : 2),
              color: taped == null
                  ? theme.colorScheme.secondary
                  : taped!
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.primary,
              boxShadow: [BoxShadow(blurRadius: 5, color: theme.shadowColor)],
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          width: size.width * 0.4,
          height: size.height * 0.06,
          child: Stack(
            children: [
              Positioned(
                top: 03,
                left: 5,
                child: Container(
                  height: size.height*0.03,
                  width: size.width*0.25,
                  padding: EdgeInsets.only(left: size.width*0.01),

                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      player.name,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 5,
                child:  Container(
                  height: size.height*0.03,
                  width: size.width*0.25,
                  padding: EdgeInsets.only(left: size.width*0.01),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      player.surname,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 01,
                  right: 04,
                  child: player.gender == "f"
                      ? const Icon(
                          Icons.female,
                          color: Colors.pink,
                        )
                      : const Icon(
                          Icons.male,
                          color: Colors.blue,
                        )),
              Positioned(
                top: 0,
                right: 02,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.025,
                      child: Transform.scale(
                        scaleX: -1,
                        child: SvgPicture.asset(
                          "lib/core/assets/icons/hand-icon.svg",
                          color: player.strongHand == "r"
                              ? Colors.black
                              : Colors.black26,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.0005,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.025,
                      child: SvgPicture.asset(
                        'lib/core/assets/icons/hand-icon.svg',
                        color: player.strongHand == "l"
                            ? Colors.black
                            : Colors.black45,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
