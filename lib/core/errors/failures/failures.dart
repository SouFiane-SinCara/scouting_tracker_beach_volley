abstract class SignUpFailure {}

class CharactersPasswordFailure extends SignUpFailure {}

class EmailFormFailure extends SignUpFailure {}

class EmailAlreadyExistedFailure extends SignUpFailure {}

class PasswordSizeFailure extends SignUpFailure {}

class ServerFailure extends SignUpFailure {}

class EmpityEmailFailure extends SignUpFailure {}

class UsernameWithSpaceFailure extends SignUpFailure {}

class EmpityUserNameFailure extends SignUpFailure {}



abstract class SharedPereferenceFailure {}

class EmpitySharedPereferenceFailure extends SharedPereferenceFailure {}

abstract class LoginFailure {}

class WorngPasswordFailure extends LoginFailure {}

class UserNotFoundFailure extends LoginFailure {}

class UserDisabledFailure extends LoginFailure {}

class InvalidEmailFailure extends LoginFailure {}

class LoginServerFailure extends LoginFailure {}

class NewClientFailure extends LoginFailure {}

abstract class FireStoreFailure {}

class FirestoreGeneralFailure extends FireStoreFailure {}

abstract class LastMatchFailure {}

class NoMatchStartedFailure extends LastMatchFailure {}

class MatchFireStoreFailure extends LastMatchFailure {}
