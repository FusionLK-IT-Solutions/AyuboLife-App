import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/app.dart';
import 'package:ayubolife/firebase_options.dart';
import 'package:ayubolife/data/repositories/auth_repository.dart';
import 'package:ayubolife/bloc/auth/auth_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AuthCheckRequested()),
        ),
      ],
      child: AyuboLifeApp(),
    );
  }
}