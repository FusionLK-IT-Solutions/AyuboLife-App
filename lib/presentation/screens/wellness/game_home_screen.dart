// import 'package:ayubolife/bloc/step_challange/step_challenge_bloc.dart';
// import 'package:ayubolife/presentation/screens/wellness/leaderboard_widget.dart';
// import 'package:ayubolife/presentation/screens/wellness/treasures_dashboard.dart';
// import 'package:ayubolife/presentation/widgets/common/loading_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';

// import 'package:audioplayers/audioplayers.dart';

// class GameHomeScreen extends StatelessWidget {
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => StepChallengeBloc(
//         googleFitRepository: RepositoryProvider.of(context),
//         userRepository: RepositoryProvider.of(context),
//       )..add(InitializeStepChallenge()),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Step Challenge Map'),
//           backgroundColor: Colors.blue[800],
//           foregroundColor: Colors.white,
//           actions: [
//             IconButton(
//               icon: Icon(Icons.card_giftcard),
//               onPressed: () {
//                 final state = context.read<StepChallengeBloc>().state;
//                 if (state is StepChallengeLoaded) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => TreasuresDashboard(
//                         collectedTreasures: state.collectedTreasures,
//                         treasures: {
//                           5000: {
//                             'gift': 'Free Toothbrush',
//                             'position': 0.1,
//                             'icon': BitmapDescriptor.hueRed,
//                             'description': 'Premium electric toothbrush',
//                           },
//                           10000: {
//                             'gift': 'Skin Cream',
//                             'position': 0.25,
//                             'icon': BitmapDescriptor.hueYellow,
//                             'description': 'Hydrating skin cream',
//                           },
//                           20000: {
//                             'gift': 'Fitness Band',
//                             'position': 0.5,
//                             'icon': BitmapDescriptor.hueGreen,
//                             'description': 'Smart fitness tracker',
//                           },
//                           50000: {
//                             'gift': 'Spa Voucher',
//                             'position': 0.9,
//                             'icon': BitmapDescriptor.hueMagenta,
//                             'description': 'Luxury spa treatment voucher',
//                           },
//                         },
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.leaderboard),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LeaderboardWidget()),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: BlocConsumer<StepChallengeBloc, StepChallengeState>(
//           listener: (context, state) {
//             if (state is StepChallengeLoaded && state.collectedTreasures.isNotEmpty) {
//               final newTreasure = state.collectedTreasures.last;
//               final treasures = {
//                 5000: {
//                   'gift': 'Free Toothbrush',
//                   'position': 0.1,
//                   'icon': BitmapDescriptor.hueRed,
//                   'description': 'Premium electric toothbrush',
//                 },
//                 10000: {
//                   'gift': 'Skin Cream',
//                   'position': 0.25,
//                   'icon': BitmapDescriptor.hueYellow,
//                   'description': 'Hydrating skin cream',
//                 },
//                 20000: {
//                   'gift': 'Fitness Band',
//                   'position': 0.5,
//                   'icon': BitmapDescriptor.hueGreen,
//                   'description': 'Smart fitness tracker',
//                 },
//                 50000: {
//                   'gift': 'Spa Voucher',
//                   'position': 0.9,
//                   'icon': BitmapDescriptor.hueMagenta,
//                   'description': 'Luxury spa treatment voucher',
//                 },
//               };
//               final treasure = treasures[newTreasure];
//               if (treasure != null) {
//                 _audioPlayer.play(AssetSource('sounds/treasure_open.mp3'));
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           'assets/treasure_box.gif',
//                           height: 100,
//                           width: 100,
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           'Congratulations!',
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text('You found: ${treasure['gift'] ?? 'Unknown Treasure'}'),
//                         Text(treasure['description']?.toString() ?? 'No description available'),
//                         SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => TreasuresDashboard(
//                                   collectedTreasures: state.collectedTreasures,
//                                   treasures: treasures,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Text('View Treasures'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue[800],
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//             }
//           },
//           builder: (context, state) {
//             if (state is StepChallengeLoading) {
//               return LoadingWidget();
//             } else if (state is StepChallengeError) {
//               return Center(
//     child: Text(
//       state.message,
//       style: TextStyle(color: Colors.red, fontSize: 16),
//     ),
//   );
//             } else if (state is StepChallengeLoaded) {
//               return Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     color: Colors.blue[50],
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Column(
//                           children: [
//                             Text(
//                               'Your Steps',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               NumberFormat('#,###').format(state.steps),
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue[800],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Text(
//                               'Progress',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               '${state.position.toStringAsFixed(1)}%',
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: GoogleMap(
//                       initialCameraPosition: CameraPosition(
//                         target: LatLng(6.933950, 79.850870),
//                         zoom: 9,
//                       ),
//                       markers: state.markers,
//                       polylines: state.polylines,
//                       mapType: MapType.normal,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: LeaderboardWidget(),
//                   ),
//                 ],
//               );
//             }
//             return Container();
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             context.read<StepChallengeBloc>().add(RefreshStepChallenge());
//           },
//           child: Icon(Icons.refresh),
//           backgroundColor: Colors.blue[800],
//         ),
//       ),
//     );
//   }
// }









import 'package:ayubolife/bloc/step_challange/step_challenge_bloc.dart';
import 'package:ayubolife/presentation/screens/wellness/leaderboard_widget.dart';
import 'package:ayubolife/presentation/screens/wellness/treasures_dashboard.dart';
import 'package:ayubolife/presentation/widgets/common/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class GameHomeScreen extends StatefulWidget {
  @override
  _GameHomeScreenState createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> 
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _refreshAnimationController;
  late AnimationController _rewardAnimationController;
  late Animation<double> _refreshAnimation;
  late Animation<double> _rewardAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _rewardAnimationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _refreshAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize animations
    _rewardAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _rewardAnimationController,
      curve: Curves.elasticInOut,
    ));

    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rewardAnimationController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  void _refreshSteps() {
    _refreshAnimationController.forward().then((_) {
      _refreshAnimationController.reverse();
    });
    context.read<StepChallengeBloc>().add(RefreshStepChallenge());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StepChallengeBloc(
        googleFitRepository: RepositoryProvider.of(context),
        userRepository: RepositoryProvider.of(context),
      )..add(InitializeStepChallenge()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Step Challenge Map'),
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocConsumer<StepChallengeBloc, StepChallengeState>(
          listener: (context, state) {
            if (state is StepChallengeLoaded && state.collectedTreasures.isNotEmpty) {
              final newTreasure = state.collectedTreasures.last;
              final treasures = {
                5000: {
                  'gift': 'Free Toothbrush',
                  'position': 0.1,
                  'icon': BitmapDescriptor.hueRed,
                  'description': 'Premium electric toothbrush',
                },
                10000: {
                  'gift': 'Skin Cream',
                  'position': 0.25,
                  'icon': BitmapDescriptor.hueYellow,
                  'description': 'Hydrating skin cream',
                },
                20000: {
                  'gift': 'Fitness Band',
                  'position': 0.5,
                  'icon': BitmapDescriptor.hueGreen,
                  'description': 'Smart fitness tracker',
                },
                50000: {
                  'gift': 'Spa Voucher',
                  'position': 0.9,
                  'icon': BitmapDescriptor.hueMagenta,
                  'description': 'Luxury spa treatment voucher',
                },
              };
              final treasure = treasures[newTreasure];
              if (treasure != null) {
                _audioPlayer.play(AssetSource('sounds/treasure_open.mp3'));
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/treasure_box.gif',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Congratulations!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('You found: ${treasure['gift'] ?? 'Unknown Treasure'}'),
                        Text(treasure['description']?.toString() ?? 'No description available'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TreasuresDashboard(
                                  collectedTreasures: state.collectedTreasures,
                                  treasures: treasures,
                                ),
                              ),
                            );
                          },
                          child: Text('View Treasures'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is StepChallengeLoading) {
              return LoadingWidget();
            } else if (state is StepChallengeError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is StepChallengeLoaded) {
              return Stack(
                children: [
                  // Full screen Google Map
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(6.933950, 79.850870),
                      zoom: 9,
                    ),
                    markers: state.markers,
                    polylines: state.polylines,
                    mapType: MapType.normal,
                  ),
                  
                  // More transparent overlay card for step count and progress
                  Positioned(
                    top: 20,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4), // Increased transparency
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Your Steps',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                NumberFormat('#,###').format(state.steps),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[300],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          Column(
                            children: [
                              Text(
                                'Progress',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${state.position.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[300],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Leaderboard Button (Bottom Left, No Animation, Transparent)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeaderboardWidget(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6), // Transparent background
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.leaderboard,
                              color: Colors.orange,
                              size: 30,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Leaderboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Sync Button (Bottom Right, Animated, Transparent)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: _refreshSteps,
                      child: AnimatedBuilder(
                        animation: _refreshAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _refreshAnimation.value * 2 * 3.14159,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6), // Transparent background
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sync,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Sync',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Rewards Button (Right Edge, Middle, Animated, Transparent)
                  Positioned(
                    right: 20,
                    top: MediaQuery.of(context).size.height / 2 - 60,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TreasuresDashboard(
                              collectedTreasures: state.collectedTreasures,
                              treasures: {
                                5000: {
                                  'gift': 'Free Toothbrush',
                                  'position': 0.1,
                                  'icon': BitmapDescriptor.hueRed,
                                  'description': 'Premium electric toothbrush',
                                },
                                10000: {
                                  'gift': 'Skin Cream',
                                  'position': 0.25,
                                  'icon': BitmapDescriptor.hueYellow,
                                  'description': 'Hydrating skin cream',
                                },
                                20000: {
                                  'gift': 'Fitness Band',
                                  'position': 0.5,
                                  'icon': BitmapDescriptor.hueGreen,
                                  'description': 'Smart fitness tracker',
                                },
                                50000: {
                                  'gift': 'Spa Voucher',
                                  'position': 0.9,
                                  'icon': BitmapDescriptor.hueMagenta,
                                  'description': 'Luxury spa treatment voucher',
                                },
                              },
                            ),
                          ),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _rewardAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _rewardAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.3), // Transparent background
                                borderRadius: BorderRadius.circular(15),
                                // border: Border.all(
                                //   color: Colors.purple,
                                //   width: 3,
                                // ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.card_giftcard,
                                    color: const Color.fromARGB(255, 153, 115, 20),
                                    size: 30,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Rewards',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 104, 82, 11),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}