abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class SignInWithGoogleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}