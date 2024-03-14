// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/errors/exeptions/exeptions.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/rouand.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RemoteDataSourceGetLastMatch {
  Future<AMatch> getLastMatch();
  Future removeLastPointFromStatics({bool ? isRemoveWithoutDelatable});
  Future deleteMAtch();
  Future<AMatch> getMatch({
    required String email,
    required String date,
    required String location,
    required String discription,
    required String tournamentTitle,
  });

  Future addBeatAction({required BeatAction beatAction});
  Future addPoint({
    required bool home,
    required int scoore,
    bool? isDelete,
    required int rouand,
  });
  Future nextSet({required int rouand});
  Future fineMatch();
  Future windUplaod({required int direction});
  Future<List<BeatAction>> getBeatsActions({required AMatch aMatch});
}

class RemoteDataSourceGetLastMatchFB extends RemoteDataSourceGetLastMatch {
  FirebaseFirestore ff = FirebaseFirestore.instance;
  @override
  Future<AMatch> getLastMatch() async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();
    if (data['email'] == null) {
      throw NoMatchStartedExeptions();
    } else {
      try {
        QuerySnapshot user = await ff
            .collection('users')
            .where('email', isEqualTo: data['email'])
            .get();
        QuerySnapshot tournament = await user.docs.first.reference
            .collection('tournaments')
            .where('title', isEqualTo: data['tournamentTitle'])
            .get();

        QuerySnapshot locationDate = await tournament.docs.first.reference
            .collection('locationDate')
            .where('date', isEqualTo: data['date'])
            .where('location', isEqualTo: data['location'])
            .get();

        QuerySnapshot match = await locationDate.docs.first.reference
            .collection('matches')
            .where('matchesDetails', isEqualTo: data['titleMatch'])
            .get();

        final amatch = match.docs.first;
        final player1 = match.docs.first['player1'];
        final player2 = match.docs.first['player2'];
        final player3 = match.docs.first['player3'];

        final player4 = match.docs.first['player4'];

        AMatch lastMatch = AMatch(
            finished: amatch['finished'],
            wind: amatch['wind'] ?? 0,
            rouands: [
              Rouand(
                  roundSet: amatch['rouands'][0]['rouandSet'],
                  state: amatch['rouands'][0]['state'],
                  home: amatch['rouands'][0]['home'],
                  away: amatch['rouands'][0]['away']),
              Rouand(
                  roundSet: amatch['rouands'][1]['rouandSet'],
                  state: amatch['rouands'][1]['state'],
                  home: amatch['rouands'][1]['home'],
                  away: amatch['rouands'][1]['away']),
              Rouand(
                  roundSet: amatch['rouands'][2]['rouandSet'],
                  state: amatch['rouands'][2]['state'],
                  home: amatch['rouands'][2]['home'],
                  away: amatch['rouands'][2]['away']),
            ],
            date: data['date'],
            description: amatch['matchesDetails'],
            location: data['location'],
            title: data['tournamentTitle'],
            player1: Player(
                name: player1['name'],
                surname: player1['surname'],
                image: player1['image'],
                gender: player1['gender'],
                strongHand: player1['strongHand'],
                tournamentTitle: data['tournamentTitle'],
                dateLocation: '',
                team: player1['team'],
                player: player1['player'],
                account: Account(
                  email: data['email'],
                  password: '',
                  username: '',
                ),
                note: player1['note'] ?? ''),
            player2: Player(
                name: player2['name'],
                surname: player2['surname'],
                image: player2['image'],
                gender: player2['gender'],
                strongHand: player2['strongHand'],
                tournamentTitle: data['tournamentTitle'],
                dateLocation: '',
                team: player2['team'],
                player: player2['player'],
                account: Account(
                  email: data['email'],
                  password: '',
                  username: '',
                ),
                note: player2['note'] ?? ''),
            player3: Player(
                name: player3['name'],
                surname: player3['surname'],
                image: player3['image'],
                gender: player3['gender'],
                strongHand: player3['strongHand'],
                tournamentTitle: data['tournamentTitle'],
                dateLocation: '',
                team: player3['team'],
                player: player3['player'],
                account: Account(
                  email: data['email'],
                  password: '',
                  username: '',
                ),
                note: player3['note'] ?? ''),
            player4: Player(
                name: player4['name'],
                surname: player4['surname'],
                image: player4['image'],
                gender: player4['gender'],
                strongHand: player4['strongHand'],
                tournamentTitle: data['tournamentTitle'],
                dateLocation: '',
                team: player4['team'],
                player: player4['player'],
                account: Account(
                  email: data['email'],
                  password: '',
                  username: '',
                ),
                note: player4['note'] ?? ''),
            account: Account(username: '', email: data['email'], password: ''));

        return lastMatch;
      } catch (e) {
        throw MatchFireStoreExeptions();
      }
    }
  }

  @override
  Future addPoint(
      {required bool home,
      required int scoore,
      required int rouand,
      bool? isDelete}) async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      QuerySnapshot user = await ff
          .collection('users')
          .where('email', isEqualTo: data['email'])
          .get();
      QuerySnapshot tournament = await user.docs.first.reference
          .collection('tournaments')
          .where('title', isEqualTo: data['tournamentTitle'])
          .get();

      QuerySnapshot locationDate = await tournament.docs.first.reference
          .collection('locationDate')
          .where('date', isEqualTo: data['date'])
          .where('location', isEqualTo: data['location'])
          .get();

      QuerySnapshot match = await locationDate.docs.first.reference
          .collection('matches')
          .where('matchesDetails', isEqualTo: data['titleMatch'])
          .get();
      if (match.docs.isNotEmpty) {
        Map<String, dynamic> thematch =
            match.docs.first.data() as Map<String, dynamic>;
        List rouands = thematch['rouands'];

        rouands[rouand - 1][home ? 'home' : 'away'] =
            isDelete != null ? scoore - 1 : scoore + 1;
        await match.docs.first.reference.update({'rouands': rouands});
      } else {
        throw FirestoreGeneralExeption();
      }
    }
  }

  @override
  Future nextSet({required int rouand}) async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      QuerySnapshot user = await ff
          .collection('users')
          .where('email', isEqualTo: data['email'])
          .get();
      QuerySnapshot tournament = await user.docs.first.reference
          .collection('tournaments')
          .where('title', isEqualTo: data['tournamentTitle'])
          .get();

      QuerySnapshot locationDate = await tournament.docs.first.reference
          .collection('locationDate')
          .where('date', isEqualTo: data['date'])
          .where('location', isEqualTo: data['location'])
          .get();

      QuerySnapshot match = await locationDate.docs.first.reference
          .collection('matches')
          .where('matchesDetails', isEqualTo: data['titleMatch'])
          .get();
      DocumentSnapshot theMatch = match.docs.first;
      rouand++;

      List<Map<String, dynamic>> rouands =
          List<Map<String, dynamic>>.from(theMatch['rouands']);

      rouands[0]['state'] = rouand == 1;
      rouands[1]['state'] = rouand == 2;
      rouands[2]['state'] = rouand == 3;

      print(rouands[1]['state']);
      match.docs.first.reference.update({"rouands": rouands});
    }
  }

  @override
  Future fineMatch() async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      QuerySnapshot user = await ff
          .collection('users')
          .where('email', isEqualTo: data['email'])
          .get();
      QuerySnapshot tournament = await user.docs.first.reference
          .collection('tournaments')
          .where('title', isEqualTo: data['tournamentTitle'])
          .get();

      QuerySnapshot locationDate = await tournament.docs.first.reference
          .collection('locationDate')
          .where('date', isEqualTo: data['date'])
          .where('location', isEqualTo: data['location'])
          .get();

      QuerySnapshot match = await locationDate.docs.first.reference
          .collection('matches')
          .where('matchesDetails', isEqualTo: data['titleMatch'])
          .get();
      DocumentSnapshot matchInfo = match.docs.first;
      matchInfo.reference.update({"finished": true});
    }
  }

  @override
  Future addBeatAction({required BeatAction beatAction}) async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      try {
        QuerySnapshot user = await ff
            .collection('users')
            .where('email', isEqualTo: data['email'])
            .get();
        QuerySnapshot tournament = await user.docs.first.reference
            .collection('tournaments')
            .where('title', isEqualTo: data['tournamentTitle'])
            .get();

        QuerySnapshot locationDate = await tournament.docs.first.reference
            .collection('locationDate')
            .where('date', isEqualTo: data['date'])
            .where('location', isEqualTo: data['location'])
            .get();

        QuerySnapshot match = await locationDate.docs.first.reference
            .collection('matches')
            .where('matchesDetails', isEqualTo: data['titleMatch'])
            .get();
        print('beat added');

        DocumentReference matchDocReference = match.docs.first.reference;
        final beatsData = match.docs.first.data() as Map<String, dynamic>;

        List beats = beatsData['beats'] ?? [];

        Map<String, dynamic> newBeatAction = {
          "state": beatAction.state,
          "p1x": beatAction.p1.dx,
          "p1y": beatAction.p1.dy,
          "p2x": beatAction.p2.dx,
          "p2y": beatAction.p2.dy,
          "continued": beatAction.continued,
          "type": beatAction.type,
          "deletable": beatAction.deletable,
          "playerName": beatAction.player.name,
          "playerSurname": beatAction.player.surname,
          "playerNumber": beatAction.playerNumber,
          'playerTeam': beatAction.playerTeam,
          "method": beatAction.method,
          "attackOption": beatAction.attackOption,
          "set": beatAction.currentSet,
          "breackPoint": beatAction.breackpointNum
        };

        beats.add(newBeatAction);
        matchDocReference.update({
          "beats": beats,
        });
      } catch (e) {
        print("error $e");
        throw FirestoreGeneralExeption();
      }
    }
  }

  @override
  Future<List<BeatAction>> getBeatsActions({required AMatch aMatch}) async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      try {
        QuerySnapshot user = await ff
            .collection('users')
            .where('email', isEqualTo: data['email'])
            .get();
        QuerySnapshot tournament = await user.docs.first.reference
            .collection('tournaments')
            .where('title', isEqualTo: data['tournamentTitle'])
            .get();

        QuerySnapshot locationDate = await tournament.docs.first.reference
            .collection('locationDate')
            .where('date', isEqualTo: data['date'])
            .where('location', isEqualTo: data['location'])
            .get();

        QuerySnapshot match = await locationDate.docs.first.reference
            .collection('matches')
            .where('matchesDetails', isEqualTo: data['titleMatch'])
            .get();
        Map matchData = match.docs.first.data() as Map;

        List beatsData = matchData['beats'] ?? [];
        List<BeatAction> beats = [];

        beatsData.forEach(
          (beat) {
            beats.add(BeatAction(
                state: beat['state'],
                currentSet: beat['set'],
                method: beat['method'],
                player: beat['playerTeam'] == 1
                    ? beat['playerNumber'] == 1
                        ? aMatch.player1
                        : aMatch.player2
                    : beat['playerNumber'] == 1
                        ? aMatch.player3
                        : aMatch.player4,
                breackpointNum: beat['breackPoint'],
                deletable: beat['deletable'],
                attackOption: beat['attackOption'],
                type: beat['type'], 
                p1: Offset(beat['p1x'], beat['p1y']),
                p2: Offset(beat['p2x'], beat['p2y']),
                continued: beat['continued'],
                playersurname: beat['playerSurname'],
                playerNumber: beat['playerNumber'],
                playerTeam: beat['playerTeam']));
          },
        );

        return beats;
      } catch (e) {
        throw FirestoreGeneralExeption();
      }
    }
  }

  @override
  Future windUplaod({required int direction}) async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      QuerySnapshot user = await ff
          .collection('users')
          .where('email', isEqualTo: data['email'])
          .get();
      QuerySnapshot tournament = await user.docs.first.reference
          .collection('tournaments')
          .where('title', isEqualTo: data['tournamentTitle'])
          .get();

      QuerySnapshot locationDate = await tournament.docs.first.reference
          .collection('locationDate')
          .where('date', isEqualTo: data['date'])
          .where('location', isEqualTo: data['location'])
          .get();

      QuerySnapshot match = await locationDate.docs.first.reference
          .collection('matches')
          .where('matchesDetails', isEqualTo: data['titleMatch'])
          .get();
      DocumentSnapshot matchInfo = match.docs.first;
      matchInfo.reference.update({"wind": direction});
    }
  }

  @override
  Future<AMatch> getMatch({
    required String email,
    required String date,
    required String location,
    required String discription,
    required String tournamentTitle,
  }) async {
    QuerySnapshot user =
        await ff.collection('users').where('email', isEqualTo: email).get();
    QuerySnapshot tournament = await user.docs.first.reference
        .collection('tournaments')
        .where('title', isEqualTo: tournamentTitle)
        .get();

    QuerySnapshot locationDate = await tournament.docs.first.reference
        .collection('locationDate')
        .where('date', isEqualTo: date)
        .where('location', isEqualTo: location)
        .get();

    QuerySnapshot match = await locationDate.docs.first.reference
        .collection('matches')
        .where('matchesDetails', isEqualTo: discription)
        .get();

    final amatch = match.docs.first;
    final player1 = match.docs.first['player1'];
    final player2 = match.docs.first['player2'];
    final player3 = match.docs.first['player3'];
    final player4 = match.docs.first['player4'];
    AMatch lastMatch = AMatch(
        finished: amatch['finished'],
        wind: amatch['wind'],
        rouands: [
          Rouand(
              roundSet: amatch['rouands'][0]['rouandSet'],
              state: amatch['rouands'][0]['state'],
              home: amatch['rouands'][0]['home'],
              away: amatch['rouands'][0]['away']),
          Rouand(
              roundSet: amatch['rouands'][1]['rouandSet'],
              state: amatch['rouands'][1]['state'],
              home: amatch['rouands'][1]['home'],
              away: amatch['rouands'][1]['away']),
          Rouand(
              roundSet: amatch['rouands'][2]['rouandSet'],
              state: amatch['rouands'][2]['state'],
              home: amatch['rouands'][2]['home'],
              away: amatch['rouands'][2]['away']),
        ],
        date: date,
        description: discription,
        location: location,
        title: tournamentTitle,
        player1: Player(
            name: player1['name'],
            surname: player1['surname'],
            image: player1['image'],
            gender: player1['gender'],
            strongHand: player1['strongHand'],
            tournamentTitle: tournamentTitle,
            dateLocation: '',
            team: player1['team'],
            player: player1['player'],
            account: Account(
              email: email,
              password: '',
              username: '',
            ),
            note: player1['note'] ?? ''),
        player2: Player(
            name: player2['name'],
            surname: player2['surname'],
            image: player2['image'],
            gender: player2['gender'],
            strongHand: player2['strongHand'],
            tournamentTitle: tournamentTitle,
            dateLocation: '',
            team: player2['team'],
            player: player2['player'],
            account: Account(
              email: email,
              password: '',
              username: '',
            ),
            note: player2['note'] ?? ''),
        player3: Player(
            name: player3['name'],
            surname: player3['surname'],
            image: player3['image'],
            gender: player3['gender'],
            strongHand: player3['strongHand'],
            tournamentTitle: tournamentTitle,
            dateLocation: '',
            team: player3['team'],
            player: player3['player'],
            account: Account(
              email: email,
              password: '',
              username: '',
            ),
            note: player3['note'] ?? ''),
        player4: Player(
            name: player4['name'],
            surname: player4['surname'],
            image: player4['image'],
            gender: player4['gender'],
            strongHand: player4['strongHand'],
            tournamentTitle: tournamentTitle,
            dateLocation: '',
            team: player4['team'],
            player: player4['player'],
            account: Account(
              email: email,
              password: '',
              username: '',
            ),
            note: player4['note'] ?? ''),
        account: Account(username: '', email: email, password: ''));

    return lastMatch;
  }

  @override
  Future deleteMAtch() async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      try {
        QuerySnapshot user = await ff
            .collection('users')
            .where('email', isEqualTo: data['email'])
            .get();
        QuerySnapshot tournament = await user.docs.first.reference
            .collection('tournaments')
            .where('title', isEqualTo: data['tournamentTitle'])
            .get();

        QuerySnapshot locationDate = await tournament.docs.first.reference
            .collection('locationDate')
            .where('date', isEqualTo: data['date'])
            .where('location', isEqualTo: data['location'])
            .get();

        QuerySnapshot match = await locationDate.docs.first.reference
            .collection('matches')
            .where('matchesDetails', isEqualTo: data['titleMatch'])
            .get();
        await match.docs.first.reference.delete();
      } catch (e) {
        print("error removeLastPointFromStatics: $e");
        throw FirestoreGeneralExeption();
      }
    }
  }

  @override
  Future removeLastPointFromStatics({bool ? isRemoveWithoutDelatable}) async {
    Map<String, dynamic> data = await LocalDataSourceMatchSharedPereference(
            sharedPreferences: await SharedPreferences.getInstance())
        .getLastMatch();

    if (data['email'] == null) {
      throw FirestoreGeneralExeption();
    } else {
      try {
        QuerySnapshot user = await ff
            .collection('users')
            .where('email', isEqualTo: data['email'])
            .get();
        QuerySnapshot tournament = await user.docs.first.reference
            .collection('tournaments')
            .where('title', isEqualTo: data['tournamentTitle'])
            .get();

        QuerySnapshot locationDate = await tournament.docs.first.reference
            .collection('locationDate')
            .where('date', isEqualTo: data['date'])
            .where('location', isEqualTo: data['location'])
            .get();

        QuerySnapshot match = await locationDate.docs.first.reference
            .collection('matches')
            .where('matchesDetails', isEqualTo: data['titleMatch'])
            .get();
        Map matchData = match.docs.first.data() as Map;
        List beatsData = matchData['beats'] ?? [];
        int firstDeletable = isRemoveWithoutDelatable != null ?1 : 0 ;
        print("array before: ${beatsData.length} }");
        if (beatsData.isNotEmpty) {
          int i = beatsData.length - 1;
          while (i >= 0) {
            print("Current index: $i");
            if (beatsData.isEmpty) {
              print("beatsData is empty, breaking the loop");
              break;
            }
            
              if (i < beatsData.length &&
                  beatsData[i]["deletable"] == null &&
                  firstDeletable == 1) {
                print("Removing non-deletable element at index $i");
                beatsData.removeAt(i);
              }
              if (i < beatsData.length && beatsData[i]["deletable"] == true) {
                firstDeletable++;
                if (firstDeletable > 1) {
                  print("First deletable count exceeded 1, breaking the loop");
                  break;
                }
                print("Removing deletable element at index $i");
                beatsData.removeAt(i);
              }
              
            i--;
          }
        }
        print("array after : ${beatsData.length} }");
        await match.docs.first.reference.update({
          "beats": beatsData.isEmpty ? [] : beatsData,
        });
      } catch (e) {
        print("error removeLastPointFromStatics: $e");
        throw FirestoreGeneralExeption();
      }
    }
  }
}
