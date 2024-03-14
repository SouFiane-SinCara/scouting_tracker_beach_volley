// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scouting_tracker_beach_volley/core/errors/exeptions/exeptions.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/source/local.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

abstract class AuthRemoteData {
  Future<Account> login({required Account account});
  Future<UserCredential> signUp({required Account account});
}

class AuthRemoteDataFB extends AuthRemoteData {
  LocalDataAccount localDataAccount;
  AuthRemoteDataFB({
    required this.localDataAccount,
  });
  @override
  Future<Account> login({required Account account}) async {
    Either<SharedPereferenceExeption, Account> acc =
        await localDataAccount.getdata();
    
    return acc.fold((l) async {
      if (account.email == '') {
        throw NewClientExeption();
      } else {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: account.email, password: account.password);
          QuerySnapshot<Map<String, dynamic>>? data = await FirebaseFirestore
              .instance
              .collection("users")
              .where("email", isEqualTo: account.email)
              .get();

          localDataAccount.storageData(
              account: Account(
                  email: account.email,
                  password: account.password,
                  username: data.docs.first.data()['username']));
          return Account(
              email: account.email,
              password: account.password,
              username: data.docs.first.data()['username']);
        } on FirebaseAuthException catch (e) {
          if (e.code == "invalid-email") {
            throw InvalidEmailExeption();
          } else if (e.code == "wrong-password") {
            throw WorngPasswordExeption();
          } else if (e.code == "user-disabled") {
            throw UserDisabledExeption();
          } else if (e.code == "user-not-found") {
            throw UserNotFoundExeption();
          } else {
            throw LoginServerExeption();
          }
        }
      }
    }, (accountUser) {
      return accountUser;
    });
  }

  @override
  Future<UserCredential> signUp({required Account account}) async {
    if (!account.username.contains(' ')) {
      if (account.username.length < 1) {
        throw EmpityUserNameExeption();
      } else {
        if (account.email.length < 1) {
          throw EmpityEmailExeption();
        } else {
          if (account.password.length > 7) {
            if (RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$')
                .hasMatch(account.password)) {
              
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: account.email, password: account.password);
                
                await FirebaseFirestore.instance.collection("users").add({
                  "username": account.username,
                  "email": account.email,
                  "password": account.password
                });
                
                await localDataAccount.storageData(account: account);
                return userCredential;
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  throw EmailAlreadyExistedExeption();
                } else if (e.code == 'invalid-email') {
                  throw EmailFormExeption();
                } else if (e.code == "channel-error") {
                  throw EmpityEmailExeption();
                } else {
                  throw ServerExpetion();
                }
              }
            } else {
              throw CharactersPasswordExeption();
            }
          } else {
            throw PasswordSizeExeption();
          }
        }
      }
    } else {
      throw UsernameWithSpaceExeption();
    }
  }
}
