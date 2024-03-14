import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scouting_tracker_beach_volley/core/errors/exeptions/exeptions.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';

abstract class RemoteData {
  Future createTournament({required String title, required Account account});
  Future addPlayer({required Player player});
  Future addMatch({required AMatch match});
  Future<List<AMatch>> getMatches(
      {required String title,
      required String date,
      required String location,
      required Account account});
  Future createLoctionDate(
      {required Account account,
      required String location,
      required String date,
      required String titleTournament});
  Future<List<String>> getTournaments({required Account account});
  Future<List<Player>> getPlayers({required Player player});
  Future<List<Map>> getlocationdate({
    required Account account,
    required String tournamentTitle,
  });
}

class RemoteFB extends RemoteData {
  FirebaseFirestore ff = FirebaseFirestore.instance;
  @override
  Future createTournament(
      {required String title, required Account account}) async {
    try {
      QuerySnapshot user = await ff
          .collection("users")
          .where("email", isEqualTo: account.email)
          .get();

      await user.docs.first.reference
          .collection("tournaments")
          .add({"title": title});
    } catch (e) {
      throw FirestoreGeneralExeption();
    }
  }

  @override
  Future<List<String>> getTournaments({required Account account}) async {
    List<String> tournaments = [];
    try {
      QuerySnapshot user = await ff
          .collection("users")
          .where("email", isEqualTo: account.email)
          .get();
      QuerySnapshot? docsTournament =
          await user.docs.first.reference.collection("tournaments").get();

      for (var element in docsTournament.docs) {
        tournaments.add(element['title']);
      }
      return tournaments;
    } catch (e) {
      throw FirestoreGeneralExeption();
    }
  }

  @override
  Future createLoctionDate(
      {required Account account,
      required String location,
      required String date,
      required String titleTournament}) async {
    try {
      QuerySnapshot user = await ff
          .collection("users")
          .where("email", isEqualTo: account.email)
          .get();

      QuerySnapshot tournament = await user.docs.first.reference
          .collection("tournaments")
          .where("title", isEqualTo: titleTournament)
          .get();
      await tournament.docs.first.reference
          .collection("locationDate")
          .add({"location": location, "date": date});
    } catch (e) {
      throw FirestoreGeneralExeption();
    }
  }

  @override
  Future<List<Map>> getlocationdate(
      {required Account account, required String tournamentTitle}) async {
    List<Map> locationDate = [];
    try {
      QuerySnapshot user = await ff
          .collection("users")
          .where("email", isEqualTo: account.email)
          .get();
      QuerySnapshot? tournament = await user.docs.first.reference
          .collection("tournaments")
          .where("title", isEqualTo: tournamentTitle)
          .get();

      QuerySnapshot lds = await tournament.docs.first.reference
          .collection("locationDate")
          .get();

      for (var element in lds.docs) {
        locationDate
            .add({"location": element['location'], "date": element['date']});
      }
      return locationDate;
    } catch (e) {
      throw FirestoreGeneralExeption();
    }
  }

  @override
  Future addPlayer({required Player player}) async {
    try {
      QuerySnapshot user = await ff
          .collection("users")
          .where("email", isEqualTo: player.account.email)
          .get();
      await user.docs.first.reference.collection("players").add({
        "name": player.name,
        "surname": player.surname,
        "gender": player.gender,
        "strongHand": player.strongHand,
        "image": player.image,
        'note': player.note
      });
    } catch (e) {
      throw FirestoreGeneralExeption();
    }
  }

  @override
  Future<List<Player>> getPlayers({required Player player}) async {
    List<Player> players = [];
    try {
      QuerySnapshot user = await ff
          .collection("users")
          .where("email", isEqualTo: player.account.email)
          .get();
      QuerySnapshot? docsTournament =
          await user.docs.first.reference.collection("players").get();

      for (var element in docsTournament.docs) {
        players.add(Player(
            name: element['name'],
            surname: element['surname'],
            image: element['image'],
            gender: element['gender'],
            strongHand: element['strongHand'],
            tournamentTitle: '',
            dateLocation: '',
            team: '',
            player: '',
            account: player.account,
            note: element['note']));
      }
      return players;
    } catch (e) {
      throw FirestoreGeneralExeption();
    }
  }

  @override
  Future addMatch({required AMatch match}) async {
    QuerySnapshot user = await ff
        .collection("users")
        .where("email", isEqualTo: match.account.email)
        .get();
    QuerySnapshot tournament = await user.docs.first.reference
        .collection("tournaments")
        .where("title", isEqualTo: match.title)
        .get();
    QuerySnapshot locationDate = await tournament.docs.first.reference
        .collection('locationDate')
        .where(
          'date',
          isEqualTo: match.date,
        )
        .where('location', isEqualTo: match.location)
        .get();

    await locationDate.docs.first.reference.collection('matches').add({
      'matchesDetails': match.description,
      'finished': false,
      'wind':0,
      'rouands': [
        {
          'rouandSet': match.rouands![0].roundSet,
          'state': match.rouands![0].state,
          'home': match.rouands![0].home,
          'away': match.rouands![0].away,
        },
        {
          'rouandSet': match.rouands![1].roundSet,
          'state': match.rouands![1].state,
          'home': match.rouands![1].home,
          'away': match.rouands![1].away,
        },
        {
          'rouandSet': match.rouands![2].roundSet,
          'state': match.rouands![2].state,
          'home': match.rouands![2].home,
          'away': match.rouands![2].away,
        }
      ],
      'player1': {
        "gender": match.player1.gender,
        "name": match.player1.name,
        "surname": match.player1.surname,
        "image": match.player1.image,
        'strongHand': match.player1.strongHand,
        'team': match.player1.team,
        'player': match.player1.player,
        'note': match.player1.note,
      },
      'player2': {
        "gender": match.player2.gender,
        "name": match.player2.name,
        "surname": match.player2.surname,
        "image": match.player2.image,
        'strongHand': match.player2.strongHand,
        'team': match.player2.team,
        'player': match.player2.player,
        'note': match.player2.note,
      },
      'player3': {
        "gender": match.player3.gender,
        "name": match.player3.name,
        "surname": match.player3.surname,
        "image": match.player3.image,
        'strongHand': match.player3.strongHand,
        'team': match.player3.team,
        'player': match.player3.player,
        'note': match.player3.note,
      },
      'player4': {
        "gender": match.player4.gender,
        "name": match.player4.name,
        "surname": match.player4.surname,
        "image": match.player4.image,
        'strongHand': match.player4.strongHand,
        'team': match.player4.team,
        'player': match.player4.player,
        'note': match.player4.note,
      }
    });
  }

  @override
  Future<List<AMatch>> getMatches(
      {required String title,
      required String date,
      required String location,
      required Account account}) async {
    List<AMatch> matches = [];

    try {
      QuerySnapshot user = await ff
          .collection('users')
          .where('email', isEqualTo: account.email)
          .get();
      QuerySnapshot tournaments = await user.docs.first.reference
          .collection('tournaments')
          .where('title', isEqualTo: title)
          .get();
      QuerySnapshot locationDate = await tournaments.docs.first.reference
          .collection('locationDate')
          .where("date", isEqualTo: date)
          .where("location", isEqualTo: location)
          .get();
      QuerySnapshot allmatches =
          await locationDate.docs.first.reference.collection('matches').get();
     

      for (var element in allmatches.docs) {
        matches.add(AMatch(
            date: date,
            description: element['matchesDetails'],
            location: location,
            title: title,
            player1: Player(
                name: element['player1']['name'],
                surname: element['player1']['surname'],
                image: element['player1']['image'],
                gender: element['player1']['gender'],
                strongHand: element['player1']['strongHand'],
                tournamentTitle: title,
                dateLocation: date,
                team: element['player1']['team'],
                player: element['player1']['player'],
                account: account,
                note: ''),
            player2: Player(
                name: element['player2']['name'],
                surname: element['player2']['surname'],
                image: element['player2']['image'],
                gender: element['player2']['gender'],
                strongHand: element['player2']['strongHand'],
                tournamentTitle: title,
                dateLocation: date,
                team: element['player2']['team'],
                player: element['player2']['player'],
                account: account,
                note: ''),
            player3: Player(
                name: element['player3']['name'],
                surname: element['player3']['surname'],
                image: element['player3']['image'],
                gender: element['player3']['gender'],
                strongHand: element['player3']['strongHand'],
                tournamentTitle: title,
                dateLocation: date,
                team: element['player3']['team'],
                player: element['player3']['player'],
                account: account,
                note: ''),
            player4: Player(
                name: element['player4']['name'],
                surname: element['player4']['surname'],
                image: element['player4']['image'],
                gender: element['player4']['gender'],
                strongHand: element['player4']['strongHand'],
                tournamentTitle: title,
                dateLocation: date,
                team: element['player4']['team'],
                player: element['player4']['player'],
                account: account,
                note: ''),
            account: account));
      }

      return matches;
    } catch (e) {
      throw FirestoreGeneralExeption();
    }
  }
}
