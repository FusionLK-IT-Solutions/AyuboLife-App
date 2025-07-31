import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_event.dart';
import 'package:ayubolife/bloc/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.health_and_safety,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'AyuboLife',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your Health Companion',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 48),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error signing in: ${state.message}')),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      }
                      
                      return ElevatedButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(SignInWithGoogleRequested());
                        },
                        icon: Icon(Icons.login, color: Colors.blue),
                        label: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}