import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JanashakthiGameScreen extends StatefulWidget {
  @override
  _JanashakthiGameScreenState createState() => _JanashakthiGameScreenState();
}

class _JanashakthiGameScreenState extends State<JanashakthiGameScreen> {
  bool isLoading = false;
  bool isEnrolled = false;
  Map<String, dynamic>? gameData;

  @override
  void initState() {
    super.initState();
    _checkEnrollmentStatus();
  }

  Future<void> _checkEnrollmentStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userRepository = RepositoryProvider.of<UserRepository>(context);
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        final enrolled = await userRepository.isUserEnrolledInProgram('janashakthi_challenge', user.uid);
        if (enrolled) {
          final data = await userRepository.getJanashakthiParticipantData(user.uid);
          setState(() {
            isEnrolled = true;
            gameData = data;
          });
        }
      }
    } catch (e) {
      print('Error checking enrollment: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _startGame() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userRepository = RepositoryProvider.of<UserRepository>(context);
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        await userRepository.enrollUserInProgram('janashakthi_challenge', user.uid);
        final data = await userRepository.getJanashakthiParticipantData(user.uid);
        
        setState(() {
          isEnrolled = true;
          gameData = data;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to Janashakthi Challenge!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start game: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade400,
              Colors.orange.shade600,
              Colors.deepOrange.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Janashakthi Challenge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: isLoading 
                      ? Center(child: CircularProgressIndicator())
                      : _buildGameContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    if (!isEnrolled) {
      return _buildWelcomeScreen();
    } else {
      return _buildGameDashboard();
    }
  }

  Widget _buildWelcomeScreen() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_walk,
                    size: 60,
                    color: Colors.orange.shade600,
                  ),
                ),
                SizedBox(height: 32),
                
                // Game Title
                Text(
                  'Janashakthi Challenge',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                
                // Game Description
                Text(
                  'Join the ultimate fitness adventure! Walk your way to better health while competing with friends and unlocking amazing rewards.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                
                // Features List
                Column(
                  children: [
                    _buildFeatureItem(Icons.timeline, 'Track your daily steps'),
                    _buildFeatureItem(Icons.emoji_events, 'Earn rewards and badges'),
                    _buildFeatureItem(Icons.people, 'Compete with friends'),
                    _buildFeatureItem(Icons.health_and_safety, 'Improve your wellness'),
                  ],
                ),
              ],
            ),
          ),
          
          // Start Game Button
          Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _startGame,
              child: Text(
                'Start The Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.orange.shade600,
            size: 24,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameDashboard() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Back Message
          Text(
            'Welcome back, ${gameData?['userName'] ?? 'Challenger'}!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Keep up the great work on your fitness journey!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          
          // Stats Cards
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  'Total Steps',
                  '${gameData?['totalSteps'] ?? 0}',
                  Icons.directions_walk,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Current Level',
                  '${gameData?['currentLevel'] ?? 1}',
                  Icons.grade,
                  Colors.amber,
                ),
                _buildStatCard(
                  'Rewards Earned',
                  '${gameData?['rewardsEarned'] ?? 0}',
                  Icons.emoji_events,
                  Colors.green,
                ),
                _buildStatCard(
                  'Days Active',
                  '${gameData?['daysActive'] ?? 1}',
                  Icons.calendar_today,
                  Colors.purple,
                ),
              ],
            ),
          ),
          
          // Continue Game Button
          Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to actual game interface
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Game interface coming soon!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: Text(
                'Continue Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}