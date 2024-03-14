import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/models/az_players.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/players_cubit/getplayer_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/my_field.dart';

class AddPlayerPage extends StatefulWidget {
  final Map data;
  AddPlayerPage({super.key, required this.data});

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  bool righhand = false;
  bool isloading = false;
  String? error;
  bool lefthand = false;
  bool male = false;
  ImagePicker imagePicker = ImagePicker();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController note = TextEditingController();
  bool female = false;
  bool imagepicked = false;
  File? img;
  String? urlImg;

  Future _uploadimg({required File file}) async {
    FirebaseStorage fs = FirebaseStorage.instance;
    String imagename = path.basename(file.path);

    try {
      Random random = Random();
      int randomNum = random.nextInt(9999999);

      final pathimg = "images/$randomNum$imagename";

      await fs
          .ref()
          .child(pathimg)
          .putFile(
            file,
          )
          .then((p0) async => urlImg = await p0.ref.getDownloadURL());
    } on FirebaseStorage catch (e) {
      print("Error uploading the image");
    } 
  }
  
  _getFromGallery() async {
    try {
      // ignore: deprecated_member_use
      var pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
      );

      if (pickedFile == null) {
        return;
      } else {
        img = File(pickedFile.path);
        imagepicked = true;
        setState(() {});
      }
    } catch (e) {}
  }

  _getFromCamera() async {
    try {
      // ignore: deprecated_member_use
      var pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile == null) {
        return;
      } else {
        img = File(pickedFile.path);
        imagepicked = true;

        setState(() {});
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);

    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);

    return isloading == false
        ? Scaffold(
            backgroundColor: theme.colorScheme.primary,
            appBar: AppBar(
              backgroundColor: theme.colorScheme.primary,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.primaryColor,
                  )),
              centerTitle: true,
              elevation: 0,
              title: AutoSizeText(
                lang!.playerinformation,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      height: size.height * 0.25,
                      child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                alignment: Alignment.bottomCenter,
                                backgroundColor: Colors.transparent,
                                actions: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.025),
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    width: size.width,
                                    height: size.height * 0.35,
                                    child: Column(children: [
                                      AutoSizeText(
                                        lang.pictureoptions + ' :',
                                        style: TextStyle(
                                            color: theme.primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Divider(
                                        color: theme.primaryColor,
                                        endIndent: size.width * 0.1,
                                        indent: size.width * 0.1,
                                        height: size.height * 0.05,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                        onTap: () {
                                          _getFromGallery();
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  theme.colorScheme.secondary,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          width: size.width * 0.6,
                                          height: size.height * 0.08,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image_rounded,
                                                color: theme.primaryColor,
                                              ),
                                              SizedBox(
                                                width: size.width * 0.03,
                                              ),
                                              AutoSizeText(
                                                lang.chooseaPicture,
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.021,
                                      ),
                                      InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                        onTap: () async {
                                          _getFromCamera();
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  theme.colorScheme.secondary,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          width: size.width * 0.6,
                                          height: size.height * 0.08,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera,
                                                color: theme.primaryColor,
                                              ),
                                              SizedBox(
                                                width: size.width * 0.03,
                                              ),
                                              AutoSizeText(
                                                lang.takeapicture,
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            );
                          },
                          child: imagepicked == false
                              ? CircleAvatar(
                                  backgroundColor: theme.colorScheme.primary,
                                  backgroundImage: AssetImage(
                                    male || male == false && female == false
                                        ? 'lib/core/assets/images/man.png'
                                        : "lib/core/assets/images/female.png",
                                  ))
                              : CircleAvatar(
                                  backgroundColor: theme.colorScheme.primary,
                                  backgroundImage: FileImage(img!))),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    error != null
                        ? AutoSizeText(
                            error!,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          )
                        : SizedBox(),
                    error != null
                        ? SizedBox(
                            height: size.height * 0.02,
                          )
                        : SizedBox(),
                    Myfield(
                        textInputAction: TextInputAction.next,
                        controller: name,
                        text: lang.name,
                        maxLetters: 16,
                        enable: true,
                        icon: Icon(
                          Icons.person,
                          color: theme.primaryColor,
                        )),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Myfield(
                        textInputAction: TextInputAction.done,
                        controller: surname,
                        text: lang.surname,
                        enable: true,
                        icon: Icon(
                          Icons.family_restroom,
                          color: theme.primaryColor,
                        )),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      height: size.height * 0.1,
                      decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: theme.shadowColor)
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: righhand == false
                                    ? size.width * 0.07
                                    : size.width * 0.08,
                                height: righhand == false &&
                                        !(righhand == false &&
                                            lefthand == false)
                                    ? size.height * 0.06
                                    : size.height * 0.07,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: IconButton(
                                    onPressed: () {
                                      lefthand = true;
                                      righhand = false;
                                      setState(() {});
                                    },
                                    icon: Transform.scale(
                                      scaleX: -1,
                                      child: SvgPicture.asset(
                                        lefthand == true
                                            ? "lib/core/assets/icons/hand-icon.svg"
                                            : "lib/core/assets/icons/left_hand.svg",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.05,
                                height: size.height * 0.03,
                                alignment: Alignment.center,
                                child: FittedBox(child: Text(lang.sx)),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: lefthand == false
                                    ? size.width * 0.07
                                    : size.width * 0.08,
                                height: lefthand == false &&
                                        !(righhand == false &&
                                            lefthand == false)
                                    ? size.height * 0.06
                                    : size.height * 0.07,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: IconButton(
                                    onPressed: () {
                                      righhand = true;
                                      lefthand = false;
                                      setState(() {});
                                    },
                                    icon: SvgPicture.asset(
                                      righhand == true
                                          ? "lib/core/assets/icons/hand-icon.svg"
                                          : "lib/core/assets/icons/left_hand.svg",
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  width: size.width * 0.05,
                                  height: size.height * 0.03,
                                  alignment: Alignment.center,
                                  child: FittedBox(child: Text(lang.dx)))
                            ],
                          ),
                          VerticalDivider(
                            color: theme.primaryColor,
                            endIndent: size.height * 0.02,
                            width: size.width * 0.05,
                            indent: size.height * 0.02,
                          ),
                          Container(
                            height: size.height * 0.08,
                            width: size.width * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.05,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: IconButton(
                                      onPressed: () {
                                        male = true;
                                        female = false;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.male,
                                        color: male
                                            ? theme.brightness ==
                                                    Brightness.light
                                                ? Colors.blue
                                                : Colors.blue
                                            : theme.brightness ==
                                                    Brightness.light
                                                ? Colors.black45
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.03,
                                  width: size.width * 0.04,
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    child: Text(
                                      "M",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: size.height * 0.08,
                            width: size.width * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.05,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: IconButton(
                                      onPressed: () {
                                        female = true;
                                        male = false;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.female,
                                        color: female
                                            ? theme.brightness ==
                                                    Brightness.light
                                                ? Colors.pink
                                                : Colors.pink
                                            : theme.brightness ==
                                                    Brightness.light
                                                ? Colors.black45
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.03,
                                  width: size.width * 0.04,
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    child: Text(
                                      "F",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Myfield(
                        textInputAction: TextInputAction.done,
                        controller: note,
                        text: lang.note,
                        isNote: true,
                        enable: true,
                        icon: Icon(
                          Icons.edit,
                          color: theme.primaryColor,
                        )),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool playerExesit = false;
                        List<AZPlayers> f = widget.data['allPlayers'];
              
                        for (int i = 0; i < f.length; i++) {
                          String gender = male == true ? 'm' : 'f';
                          String hand = righhand == true ? 'r' : 'l';
                          if (f[i].player.name == name.text &&
                              f[i].player.surname == surname.text &&
                              f[i].player.gender == gender &&
                              f[i].player.strongHand == hand) {
                            playerExesit = true;
                          }
                        }
              
                        if (playerExesit == true) {
                          error = lang.playerAlready;
                          setState(() {});
                        } else if (name.text.isEmpty) {
                          error = lang.add + ' ' + lang.name;
                          setState(() {});
                        } else if (name.text.contains(' ') ||
                            RegExp(r'[0-9!@#$%^&*(),.?":{}|<> ]')
                                .hasMatch(name.text)) {
                          error = lang.nospacename;
                          setState(() {});
                        } else if (surname.text.isEmpty) {
                          error = lang.add + ' ' + lang.surname;
                          setState(() {});
                        } else if (surname.text.contains(" ") ||
                            RegExp(r'[0-9!@#$%^&*(),.?":{}|<> ]')
                                .hasMatch(surname.text)) {
                          error = lang.nospacesurname;
                          setState(() {});
                        } else if (male == false && female == false) {
                          error = lang.nogender;
                          setState(() {});
                        } else if (lefthand == false && righhand == false) {
                          error = lang.noHand;
                          setState(() {});
                        } else {
                          isloading = true;
                          setState(() {});
                          if (img != null) {
                            await _uploadimg(file: img!);
                          }
              
                          await BlocProvider.of<GetplayerCubit>(context).addPlayer(
                              player: Player(
                                  name: name.text,
                                  surname: surname.text,
                                  image: urlImg == null
                                      ? male
                                          ? 'https://firebasestorage.googleapis.com/v0/b/scouting-tracker-beach-v-808cc.appspot.com/o/3850025.png?alt=media&token=d857e2d2-8276-4195-ba81-82b7696e6699'
                                          : 'https://firebasestorage.googleapis.com/v0/b/scouting-tracker-beach-v-808cc.appspot.com/o/3850019.png?alt=media&token=f9c1c5af-73df-4051-be38-dfaf84c66e29'
                                      : urlImg!,
                                  gender: male == false && female == false
                                      ? "m"
                                      : male
                                          ? "m"
                                          : "f",
                                  strongHand: lefthand ? 'l' : 'r',
                                  tournamentTitle: '',
                                  dateLocation: '',
                                  team: '',
                                  player: '',
                                  account: widget.data['account'],
                                  note: note.text));
              
                          isloading = false;
                          setState(() {});
                          Navigator.pop(context);
              
                          await BlocProvider.of<GetplayerCubit>(context)
                              .getPlayers(
                                  player: Player(
                                      name: name.text,
                                      surname: surname.text,
                                      image: urlImg == null &&
                                              male == false &&
                                              female == false
                                          ? 'https://firebasestorage.googleapis.com/v0/b/scouting-tracker-beach-v-808cc.appspot.com/o/3850025.png?alt=media&token=d857e2d2-8276-4195-ba81-82b7696e6699'
                                          : 'https://firebasestorage.googleapis.com/v0/b/scouting-tracker-beach-v-808cc.appspot.com/o/3850019.png?alt=media&token=f9c1c5af-73df-4051-be38-dfaf84c66e29',
                                      gender: male == false && female == false
                                          ? "m"
                                          : male
                                              ? "m"
                                              : "f",
                                      strongHand: lefthand ? 'l' : 'r',
                                      tournamentTitle: '',
                                      dateLocation: '',
                                      team: '',
                                      player: '',
                                      account: widget.data['account'],
                                      note: note.text));
                        }
                      },
                      child: Container(
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5, color: theme.shadowColor)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        height: size.height * 0.065,
                        padding: EdgeInsets.only(left: size.width * 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              lang.add,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.add,
                              color: theme.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: theme.colorScheme.primary,
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Container(
                width: size.width * 0.5,
                height: size.height * 0.2,
                alignment: Alignment.center,
                color: theme.colorScheme.primary,
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              ),
            ),
          );
  }
}
