import 'package:ayubolife/bloc/step_challange/step_challenge_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_state.dart';
import 'package:ayubolife/bloc/navigation/navigation_bloc.dart';
import 'package:ayubolife/bloc/wellness/wellness_bloc.dart';
import 'package:ayubolife/bloc/profile/profile_bloc.dart';
import 'package:ayubolife/bloc/programs/programs_bloc.dart';
import 'package:ayubolife/data/repositories/auth_repository.dart';
import 'package:ayubolife/data/repositories/user_repository.dart';
import 'package:ayubolife/data/repositories/google_fit_repository.dart';
import 'package:ayubolife/data/services/google_sign_in_service.dart';
import 'package:ayubolife/presentation/screens/auth/login_screen.dart';
import 'package:ayubolife/presentation/screens/main/main_screen.dart';

class AyuboLifeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<GoogleFitRepository>(
          create: (context) => GoogleFitRepository(
            googleSignInService: GoogleSignInService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'AyuboLife',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<WellnessBloc>(
                    create: (context) => WellnessBloc(
                      userRepository: RepositoryProvider.of<UserRepository>(context),
                      googleFitRepository: RepositoryProvider.of<GoogleFitRepository>(context),
                    ),
                  ),
                  BlocProvider<StepChallengeBloc>(
                    create: (context) => StepChallengeBloc(
                      googleFitRepository: RepositoryProvider.of<GoogleFitRepository>(context),
                      userRepository: RepositoryProvider.of<UserRepository>(context),
                    ),
                  ),
                  BlocProvider<ProfileBloc>(
                    create: (context) => ProfileBloc(
                      userRepository: RepositoryProvider.of<UserRepository>(context),
                    ),
                  ),
                  BlocProvider<ProgramsBloc>(
                    create: (context) => ProgramsBloc(
                      userRepository: RepositoryProvider.of<UserRepository>(context),
                    ),
                  ),
                  BlocProvider<NavigationBloc>(
                    create: (context) => NavigationBloc(),
                  ),
                ],
                child: MainScreen(),
              );
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}