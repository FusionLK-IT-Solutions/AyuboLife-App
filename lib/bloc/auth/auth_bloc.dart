import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_event.dart';
import 'package:ayubolife/bloc/auth/auth_state.dart';
import 'package:ayubolife/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onSignInWithGoogleRequested(SignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(message: 'Sign in failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}