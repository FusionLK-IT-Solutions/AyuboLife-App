import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class LeaderboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Refresh functionality can be added here
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('games')
              .doc('HemasGame')
              .collection('participants')
              .orderBy('totalSteps', descending: true)
              .limit(50)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading leaderboard...',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Error loading leaderboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No participants yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Be the first to join the challenge!',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            final isCurrentUserFirst = snapshot.data!.docs.isNotEmpty && 
                snapshot.data!.docs[0].id == currentUserId;

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Top Performers',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${snapshot.data!.docs.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            final isCurrentUser = doc.id == currentUserId;

                            return LeaderboardCard(
                              rank: index + 1,
                              userName: data['userName'] ?? 'Unknown',
                              totalSteps: data['totalSteps'] ?? 0,
                              progress: data['currentPosition']?.toDouble() ?? 0.0,
                              profileImageUrl: data['profileImageUrl'],
                              isCurrentUser: isCurrentUser,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Firecracker animation for first place
                if (isCurrentUserFirst) FirecrackerAnimation(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LeaderboardCard extends StatelessWidget {
  final int rank;
  final String userName;
  final int totalSteps;
  final double progress;
  final String? profileImageUrl;
  final bool isCurrentUser;

  const LeaderboardCard({
    Key? key,
    required this.rank,
    required this.userName,
    required this.totalSteps,
    required this.progress,
    this.profileImageUrl,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: isCurrentUser
            ? LinearGradient(
                colors: [Colors.green[50]!, Colors.green[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isCurrentUser ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isCurrentUser ? Colors.green.withOpacity(0.3) : Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: isCurrentUser
            ? Border.all(color: Colors.green[300]!, width: 2)
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Profile Picture
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getRankColor(rank),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? Image.network(
                        profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar();
                        },
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
            SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                            color: isCurrentUser ? Colors.green[800] : Colors.grey[800],
                          ),
                        ),
                      ),
                      if (isCurrentUser)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${NumberFormat('#,###').format(totalSteps)} steps',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${progress.toStringAsFixed(1)}% of route',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(rank).withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: rank <= 3
                    ? Icon(
                        rank == 1 ? Icons.emoji_events : Icons.workspace_premium,
                        color: Colors.white,
                        size: 20,
                      )
                    : Text(
                        '$rank',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.person,
        color: Colors.grey[600],
        size: 30,
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber[600]!; // Gold
      case 2:
        return Colors.grey[500]!; // Silver
      case 3:
        return Colors.brown[400]!; // Bronze
      default:
        return Colors.blue[600]!;
    }
  }
}

class FirecrackerAnimation extends StatefulWidget {
  @override
  _FirecrackerAnimationState createState() => _FirecrackerAnimationState();
}

class _FirecrackerAnimationState extends State<FirecrackerAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<FirecrackerParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _generateParticles();
    _animationController.forward();

    // Repeat animation every 5 seconds
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            _generateParticles();
            _animationController.reset();
            _animationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateParticles() {
    particles.clear();
    for (int i = 0; i < 20; i++) {
      particles.add(FirecrackerParticle());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: FirecrackerPainter(_animation.value, particles),
          size: Size.infinite,
        );
      },
    );
  }
}

class FirecrackerParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late Color color;
  late double size;

  FirecrackerParticle() {
    x = 0.5; // Center
    y = 0.3; // Top area
    vx = (0.5 - (0.5 + (0.5 - 1.0) * 0.5)) * 2;
    vy = (0.5 - (0.5 + (0.5 - 1.0) * 0.5)) * 2;
    color = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.pink,
      Colors.purple,
    ][(5 * 0.5).floor()];
    size = 3 + 2 * 0.5;
  }
}

class FirecrackerPainter extends CustomPainter {
  final double progress;
  final List<FirecrackerParticle> particles;

  FirecrackerPainter(this.progress, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      final x = particle.x * size.width + particle.vx * progress * 100;
      final y = particle.y * size.height + particle.vy * progress * 100 + 0.5 * 9.8 * progress * progress * 50;
      
      final opacity = (1 - progress).clamp(0.0, 1.0);
      paint.color = particle.color.withOpacity(opacity);
      
      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}