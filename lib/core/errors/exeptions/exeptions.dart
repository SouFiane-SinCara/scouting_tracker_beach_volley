abstract class SignUpExeption {}

class CharactersPasswordExeption extends SignUpExeption {}

class EmailFormExeption extends SignUpExeption {}

class UsernameWithSpaceExeption extends SignUpExeption {}

class EmailAlreadyExistedExeption extends SignUpExeption {}

class PasswordSizeExeption extends SignUpExeption {}

class ServerExpetion extends SignUpExeption {}

class EmpityEmailExeption extends SignUpExeption {}

class EmpityUserNameExeption extends SignUpExeption {}

abstract class SharedPereferenceExeption {}

class EmpitySharedPereferenceExeption extends SharedPereferenceExeption {}

abstract class LoginExeption {}

class WorngPasswordExeption extends LoginExeption {}

class UserDisabledExeption extends LoginExeption {}

class UserNotFoundExeption extends LoginExeption {}

class LoginServerExeption extends LoginExeption {}

class InvalidEmailExeption extends LoginExeption {}

class NewClientExeption extends LoginExeption {}

abstract class FireStoreExeption {}

class FirestoreGeneralExeption extends FireStoreExeption {}
abstract class LastMatchExeptions {
  
}
class NoMatchStartedExeptions extends LastMatchExeptions{

}
class MatchFireStoreExeptions extends LastMatchExeptions{
  
}