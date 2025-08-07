// import 'package:ayubolife/bloc/programs/programs_bloc.dart';
// import 'package:ayubolife/presentation/screens/wellness/game_home_screen.dart';
// import 'package:ayubolife/presentation/widgets/common/loading_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class DiscoverPage extends StatelessWidget {
//   final List<Map<String, dynamic>> _carouselItems = [
//     {
//       'image': 'assets/images/Banner-6.jpg',
//       'title': 'Hemas Step Challenge',
//       'description': 'Start your health transformation',
//       'id': 'hemas_step_challenge',
//     },
//     {
//       'image': 'assets/images/Fitness-Revolution.jpg',
//       'title': 'Fitness Revolution',
//       'description': 'Join our fitness programs',
//       'id': 'fitness_revolution',
//     },
//     {
//       'image': 'assets/images/Mental-Wellness.jpg',
//       'title': 'Mental Wellness',
//       'description': 'Embrace mental clarity',
//       'id': 'mental_wellness',
//     },
//     {
//       'image': 'assets/images/Nutrition-Guide.jpg',
//       'title': 'Nutrition Guide',
//       'description': 'Healthy eating made simple',
//       'id': 'nutrition_guide',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProgramsBloc(
//         userRepository: RepositoryProvider.of(context),
//       )..add(InitializeSamplePrograms()),
//       child: Scaffold(
//         body: BlocBuilder<ProgramsBloc, ProgramsState>(
//           builder: (context, state) {
//             if (state is ProgramsLoading) {
//               return LoadingWidget();
//             } else if (state is ProgramsError) {
//               return Center(
//                 child: Text(
//                   state.message,
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               );
//             } else if (state is ProgramsLoaded) {
//               return CustomScrollView(
//                 slivers: [
//                   SliverAppBar(
//                     pinned: true,
//                     title: Text(
//                       'Discover',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     backgroundColor: Colors.white,
//                     actions: [
//                       IconButton(
//                         icon: Icon(Icons.search, color: Colors.black),
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                   SliverToBoxAdapter(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildCarouselSlider(context),
//                         SizedBox(height: 20),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildSectionHeader('Recommended'),
//                               SizedBox(height: 10),
//                               _buildProgramRow(context, state.recommendedPrograms),
//                               SizedBox(height: 20),
//                               _buildSectionHeader('Health Online'),
//                               SizedBox(height: 10),
//                               _buildProgramRow(context, state.healthOnlinePrograms),
//                               SizedBox(height: 20),
//                               _buildSectionHeader('Manage'),
//                               SizedBox(height: 10),
//                               _buildProgramRow(context, state.managePrograms),
//                               SizedBox(height: 20),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCarouselSlider(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 200,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         aspectRatio: 16 / 9,
//         viewportFraction: 1.0,
//       ),
//       items: _carouselItems.map((item) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(item['image']),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.black.withOpacity(0.4),
//                           Colors.black.withOpacity(0.2),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 20,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item['title'],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           item['description'],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         BlocBuilder<ProgramsBloc, ProgramsState>(
//                           builder: (context, state) {
//                             bool isJoined = false;
//                             if (state is ProgramsLoaded) {
//                               isJoined = state.joinedPrograms.contains(item['id']);
//                             }
//                             return ElevatedButton(
//                               onPressed: () {
//                                 if (item['id'] == 'hemas_step_challenge') {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => GameHomeScreen()),
//                                   );
//                                 } else {
//                                   _showProgramDetails(context, {
//                                     'id': item['id'],
//                                     'name': item['title'],
//                                     'description': item['description'],
//                                     'image': item['image'],
//                                   });
//                                 }
//                               },
//                               child: Text(
//                                 isJoined ? 'View' : 'Click to Join',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 foregroundColor: Colors.white,
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _buildProgramRow(BuildContext context, List<Map<String, dynamic>> programs) {
//     return Container(
//       height: 220,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: programs.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: 160,
//             margin: EdgeInsets.only(right: 10),
//             child: _buildProgramCard(context, programs[index]),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProgramCard(BuildContext context, Map<String, dynamic> program) {
//     return GestureDetector(
//       onTap: () => _showProgramDetails(context, program),
//       child: Container(
//         height: 140,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 6,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Stack(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(program['image']),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.black.withOpacity(0.4),
//                       Colors.black.withOpacity(0.2),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             program['category']?.toUpperCase() ?? 'HEALTH',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: _getCategoryColor(program['category']),
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.star_rounded,
//                                 color: Colors.amber.shade600,
//                                 size: 14,
//                               ),
//                               SizedBox(width: 2),
//                               Text(
//                                 '${program['rating']?.toStringAsFixed(1) ?? '0.0'}',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           program['name'] ?? 'Program Name',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Colors.white,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 offset: Offset(0, 1),
//                                 blurRadius: 2,
//                               ),
//                             ],
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           program['description'] ?? 'Program description here',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 12,
//                             height: 1.3,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 offset: Offset(0, 1),
//                                 blurRadius: 2,
//                               ),
//                             ],
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getCategoryColor(String? category) {
//     switch (category?.toLowerCase()) {
//       case 'health':
//         return Color(0xFF4CAF50);
//       case 'wellness':
//         return Color(0xFF9C27B0);
//       case 'fitness':
//         return Color(0xFFFF9800);
//       case 'mental':
//         return Color(0xFF2196F3);
//       case 'nutrition':
//         return Color(0xFFFF5722);
//       default:
//         return Color(0xFF42A5F5);
//     }
//   }

//   void _showProgramDetails(BuildContext context, Map<String, dynamic> program) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (newContext) => BlocProvider.value(
//         value: BlocProvider.of<ProgramsBloc>(context),
//         child: ProgramDetailsSheet(program: program),
//       ),
//     );
//   }
// }

// class ProgramDetailsSheet extends StatelessWidget {
//   final Map<String, dynamic> program;

//   const ProgramDetailsSheet({Key? key, required this.program}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 150,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: program['image'] != null
//                     ? DecorationImage(
//                         image: AssetImage(program['image']),
//                         fit: BoxFit.cover,
//                       )
//                     : null,
//                 gradient: program['image'] == null
//                     ? LinearGradient(
//                         colors: [Colors.blue.shade400, Colors.blue.shade600],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       )
//                     : null,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: program['image'] == null
//                   ? Icon(
//                       Icons.health_and_safety,
//                       color: Colors.white,
//                       size: 60,
//                     )
//                   : null,
//             ),
//             SizedBox(height: 20),
//             Text(
//               program['name'] ?? '',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               program['description'] ?? '',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Icon(Icons.star, color: Colors.amber),
//                 SizedBox(width: 5),
//                 Text(
//                   '${program['rating']?.toStringAsFixed(1) ?? '0.0'} (5.0)',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Reviews',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.blue,
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Sithum Anjana',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Row(
//                             children: List.generate(
//                               5,
//                               (index) => Icon(
//                                 Icons.star,
//                                 color: Colors.amber,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Great program! Really helped me improve my wellness routine. Highly recommended for anyone looking to start their health journey.',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.green,
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Manuja Ransara',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Row(
//                             children: [
//                               ...List.generate(
//                                 4,
//                                 (index) => Icon(
//                                   Icons.star,
//                                   color: Colors.amber,
//                                   size: 16,
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.star_border,
//                                 color: Colors.amber,
//                                 size: 16,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Good program with useful features. The interface is user-friendly and the content is well-structured.',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             if (program['id'] == 'hemas_step_challenge')
//               Container(
//                 width: double.infinity,
//                 height: 50,
//                 child: BlocBuilder<ProgramsBloc, ProgramsState>(
//                   builder: (context, state) {
//                     bool isJoined = false;
//                     if (state is ProgramsLoaded) {
//                       isJoined = state.joinedPrograms.contains(program['id']);
//                     }
//                     return ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => GameHomeScreen()),
//                         );
//                       },
//                       child: Text(
//                         isJoined ? 'View' : 'Click to Join',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }












// import 'package:ayubolife/bloc/programs/programs_bloc.dart';
// import 'package:ayubolife/presentation/screens/wellness/game_home_screen.dart';
// import 'package:ayubolife/presentation/widgets/common/loading_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class DiscoverPage extends StatelessWidget {
//   final List<Map<String, dynamic>> _carouselItems = [
//     {
//       'image': 'assets/images/Banner-6.jpg',
//       'title': 'Hemas Step Challenge',
//       'description': 'Walk, unlock rewards, and compete in a virtual fitness adventure!',
//       'id': 'hemas_step_challenge',
//     },
//     {
//     'image': 'assets/images/Janashakthi_logo.png', // Add unique image
//     'title': 'Janashakthi Challenge',
//     'description': 'Boost your vitality with fun fitness tasks and rewards!',
//     'id': 'janashakthi_challenge',
//   },
//     {
//       'image': 'assets/images/Mental-Wellness.jpg',
//       'title': 'Mental Wellness',
//       'description': 'Embrace mental clarity',
//       'id': 'mental_wellness',
//     },
//     {
//       'image': 'assets/images/Nutrition-Guide.jpg',
//       'title': 'Nutrition Guide',
//       'description': 'Healthy eating made simple',
//       'id': 'nutrition_guide',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProgramsBloc(
//         userRepository: RepositoryProvider.of(context),
//       )..add(InitializeSamplePrograms()),
//       child: Scaffold(
//         body: BlocBuilder<ProgramsBloc, ProgramsState>(
//           builder: (context, state) {
//             if (state is ProgramsLoading) {
//               return LoadingWidget();
//             } else if (state is ProgramsError) {
//               return Center(
//                 child: Text(
//                   state.message,
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               );
//             } else if (state is ProgramsLoaded) {
//               return CustomScrollView(
//                 slivers: [
//                   SliverAppBar(
//                     pinned: true,
//                     title: Text(
//                       'Discover',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     backgroundColor: Colors.white,
//                     actions: [
//                       IconButton(
//                         icon: Icon(Icons.search, color: Colors.black),
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                   SliverToBoxAdapter(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildCarouselSlider(context),
//                         SizedBox(height: 20),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildSectionHeader('Recommended'),
//                               SizedBox(height: 10),
//                               _buildProgramRow(context, state.recommendedPrograms),
//                               SizedBox(height: 20),
//                               _buildSectionHeader('Health Online'),
//                               SizedBox(height: 10),
//                               _buildProgramRow(context, state.healthOnlinePrograms),
//                               SizedBox(height: 20),
//                               _buildSectionHeader('Manage'),
//                               SizedBox(height: 10),
//                               _buildProgramRow(context, state.managePrograms),
//                               SizedBox(height: 20),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCarouselSlider(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 200,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         aspectRatio: 16 / 9,
//         viewportFraction: 1.0,
//       ),
//       items: _carouselItems.map((item) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(item['image']),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.black.withOpacity(0.4),
//                           Colors.black.withOpacity(0.2),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 20,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item['title'],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           item['description'],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         BlocBuilder<ProgramsBloc, ProgramsState>(
//                           builder: (context, state) {
//                             bool isJoined = false;
//                             if (state is ProgramsLoaded) {
//                               isJoined = state.joinedPrograms.contains(item['id']);
//                             }
//                             return ElevatedButton(
//                               onPressed: () {
//                                 if (item['id'] == 'hemas_step_challenge') {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => GameHomeScreen()),
//                                   );
//                                 } else {
//                                   _showProgramDetails(context, {
//                                     'id': item['id'],
//                                     'name': item['title'],
//                                     'description': item['description'],
//                                     'image': item['image'],
//                                   });
//                                 }
//                               },
//                               child: Text(
//                                 isJoined ? 'View' : 'Click to Join',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 foregroundColor: Colors.white,
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _buildProgramRow(BuildContext context, List<Map<String, dynamic>> programs) {
//     return Container(
//       height: 220,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: programs.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: 160,
//             margin: EdgeInsets.only(right: 10),
//             child: _buildProgramCard(context, programs[index]),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProgramCard(BuildContext context, Map<String, dynamic> program) {
//     return GestureDetector(
//       onTap: () => _showProgramDetails(context, program),
//       child: Container(
//         height: 140,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 6,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Stack(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(program['image']),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.black.withOpacity(0.4),
//                       Colors.black.withOpacity(0.2),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             program['category']?.toUpperCase() ?? 'HEALTH',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: _getCategoryColor(program['category']),
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.star_rounded,
//                                 color: Colors.amber.shade600,
//                                 size: 14,
//                               ),
//                               SizedBox(width: 2),
//                               Text(
//                                 '${program['rating']?.toStringAsFixed(1) ?? '0.0'}',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           program['name'] ?? 'Program Name',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Colors.white,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 offset: Offset(0, 1),
//                                 blurRadius: 2,
//                               ),
//                             ],
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           program['description'] ?? 'Program description here',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 12,
//                             height: 1.3,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 offset: Offset(0, 1),
//                                 blurRadius: 2,
//                               ),
//                             ],
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getCategoryColor(String? category) {
//     switch (category?.toLowerCase()) {
//       case 'health':
//         return Color(0xFF4CAF50);
//       case 'wellness':
//         return Color(0xFF9C27B0);
//       case 'fitness':
//         return Color(0xFFFF9800);
//       case 'mental':
//         return Color(0xFF2196F3);
//       case 'nutrition':
//         return Color(0xFFFF5722);
//       default:
//         return Color(0xFF42A5F5);
//     }
//   }

//   void _showProgramDetails(BuildContext context, Map<String, dynamic> program) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (newContext) => BlocProvider.value(
//         value: BlocProvider.of<ProgramsBloc>(context),
//         child: ProgramDetailsSheet(program: program),
//       ),
//     );
//   }
// }

// class ProgramDetailsSheet extends StatelessWidget {
//   final Map<String, dynamic> program;

//   const ProgramDetailsSheet({Key? key, required this.program}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final String description = program['id'] == 'hemas_step_challenge'
//         ? 'The Hemas Step Challenge is a location-based fitness adventure game that motivates users to stay active by walking and unlocking real-world rewards. Powered by Google Fit, Google Maps, and gamified treasure hunting, users compete to walk from Colombo Fort to Kandy on a virtual path while collecting health-themed treasures and climbing the leaderboard.'
//         : program['description'] ?? '';

//     return Container(
//       padding: EdgeInsets.all(20),
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 150,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: program['image'] != null
//                     ? DecorationImage(
//                         image: AssetImage(program['image']),
//                         fit: BoxFit.cover,
//                       )
//                     : null,
//                 gradient: program['image'] == null
//                     ? LinearGradient(
//                         colors: [Colors.blue.shade400, Colors.blue.shade600],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       )
//                     : null,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: program['image'] == null
//                   ? Icon(
//                       Icons.health_and_safety,
//                       color: Colors.white,
//                       size: 60,
//                     )
//                   : null,
//             ),
//             SizedBox(height: 20),
//             Text(
//               program['name'] ?? '',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               description,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Icon(Icons.star, color: Colors.amber),
//                 SizedBox(width: 5),
//                 Text(
//                   '${program['rating']?.toStringAsFixed(1) ?? '0.0'}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             if (program['id'] == 'hemas_step_challenge')
//               Container(
//                 width: double.infinity,
//                 height: 50,
//                 child: BlocBuilder<ProgramsBloc, ProgramsState>(
//                   builder: (context, state) {
//                     bool isJoined = false;
//                     if (state is ProgramsLoaded) {
//                       isJoined = state.joinedPrograms.contains(program['id']);
//                     }
//                     return ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => GameHomeScreen()),
//                         );
//                       },
//                       child: Text(
//                         isJoined ? 'View' : 'Click to Join',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'package:ayubolife/bloc/programs/programs_bloc.dart';
import 'package:ayubolife/presentation/screens/wellness/game_home_screen.dart';
import 'package:ayubolife/presentation/screens/wellness/janashakthi_game_home_screen.dart';
import 'package:ayubolife/presentation/widgets/common/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DiscoverPage extends StatelessWidget {
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'image': 'assets/images/Banner-6.jpg',
      'title': 'Hemas Step Challenge',
      'description': 'Walk, unlock rewards, and compete in a virtual fitness adventure!',
      'id': 'hemas_step_challenge',
    },
    {
      'image': 'assets/images/janashakthi_banner.jpg', // New unique background image
      'title': 'Janashakthi Challenge',
      'description': 'Join the ultimate fitness challenge and unlock exclusive rewards!',
      'id': 'janashakthi_challenge',
    },
    {
      'image': 'assets/images/Fitness-Revolution.jpg',
      'title': 'Fitness Revolution',
      'description': 'Join our fitness programs',
      'id': 'fitness_revolution',
    },
    {
      'image': 'assets/images/Mental-Wellness.jpg',
      'title': 'Mental Wellness',
      'description': 'Embrace mental clarity',
      'id': 'mental_wellness',
    },
    {
      'image': 'assets/images/Nutrition-Guide.jpg',
      'title': 'Nutrition Guide',
      'description': 'Healthy eating made simple',
      'id': 'nutrition_guide',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgramsBloc(
        userRepository: RepositoryProvider.of(context),
      )..add(InitializeSamplePrograms()),
      child: Scaffold(
        body: BlocBuilder<ProgramsBloc, ProgramsState>(
          builder: (context, state) {
            if (state is ProgramsLoading) {
              return LoadingWidget();
            } else if (state is ProgramsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is ProgramsLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text(
                      'Discover',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCarouselSlider(context),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader('Recommended'),
                              SizedBox(height: 10),
                              _buildProgramRow(context, state.recommendedPrograms),
                              SizedBox(height: 20),
                              _buildSectionHeader('Health Online'),
                              SizedBox(height: 10),
                              _buildProgramRow(context, state.healthOnlinePrograms),
                              SizedBox(height: 20),
                              _buildSectionHeader('Manage'),
                              SizedBox(height: 10),
                              _buildProgramRow(context, state.managePrograms),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildCarouselSlider(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0,
      ),
      items: _carouselItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item['description'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        BlocBuilder<ProgramsBloc, ProgramsState>(
                          builder: (context, state) {
                            bool isJoined = false;
                            if (state is ProgramsLoaded) {
                              isJoined = state.joinedPrograms.contains(item['id']);
                            }
                            return ElevatedButton(
                              onPressed: () {
                                if (item['id'] == 'hemas_step_challenge') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => GameHomeScreen()),
                                  );
                                } else if (item['id'] == 'janashakthi_challenge') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JanashakthiGameScreen()),
                                  );
                                } else {
                                  _showProgramDetails(context, {
                                    'id': item['id'],
                                    'name': item['title'],
                                    'description': item['description'],
                                    'image': item['image'],
                                  });
                                }
                              },
                              child: Text(
                                isJoined ? 'View' : 'Click to Join',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: item['id'] == 'janashakthi_challenge' 
                                    ? Colors.orange 
                                    : Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProgramRow(BuildContext context, List<Map<String, dynamic>> programs) {
    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: programs.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: EdgeInsets.only(right: 10),
            child: _buildProgramCard(context, programs[index]),
          );
        },
      ),
    );
  }

  Widget _buildProgramCard(BuildContext context, Map<String, dynamic> program) {
    return GestureDetector(
      onTap: () => _showProgramDetails(context, program),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(program['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            program['category']?.toUpperCase() ?? 'HEALTH',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(program['category']),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber.shade600,
                                size: 14,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${program['rating']?.toStringAsFixed(1) ?? '0.0'}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program['name'] ?? 'Program Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          program['description'] ?? 'Program description here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            height: 1.3,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'health':
        return Color(0xFF4CAF50);
      case 'wellness':
        return Color(0xFF9C27B0);
      case 'fitness':
        return Color(0xFFFF9800);
      case 'mental':
        return Color(0xFF2196F3);
      case 'nutrition':
        return Color(0xFFFF5722);
      default:
        return Color(0xFF42A5F5);
    }
  }

  void _showProgramDetails(BuildContext context, Map<String, dynamic> program) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (newContext) => BlocProvider.value(
        value: BlocProvider.of<ProgramsBloc>(context),
        child: ProgramDetailsSheet(program: program),
      ),
    );
  }
}

class ProgramDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> program;

  const ProgramDetailsSheet({Key? key, required this.program}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String description = '';
    
    if (program['id'] == 'hemas_step_challenge') {
      description = 'The Hemas Step Challenge is a location-based fitness adventure game that motivates users to stay active by walking and unlocking real-world rewards. Powered by Google Fit, Google Maps, and gamified treasure hunting, users compete to walk from Colombo Fort to Kandy on a virtual path while collecting health-themed treasures and climbing the leaderboard.';
    } else if (program['id'] == 'janashakthi_challenge') {
      description = 'The Janashakthi Challenge is an exciting fitness adventure that combines walking challenges with gamified rewards. Join thousands of participants in this unique wellness journey designed to promote healthy living and community engagement.';
    } else {
      description = program['description'] ?? '';
    }

    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.7,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                image: program['image'] != null
                    ? DecorationImage(
                        image: AssetImage(program['image']),
                        fit: BoxFit.cover,
                      )
                    : null,
                gradient: program['image'] == null
                    ? LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(15),
              ),
              child: program['image'] == null
                  ? Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 60,
                    )
                  : null,
            ),
            SizedBox(height: 20),
            Text(
              program['name'] ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 5),
                Text(
                  '${program['rating']?.toStringAsFixed(1) ?? '0.0'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (program['id'] == 'hemas_step_challenge' || program['id'] == 'janashakthi_challenge')
              Container(
                width: double.infinity,
                height: 50,
                child: BlocBuilder<ProgramsBloc, ProgramsState>(
                  builder: (context, state) {
                    bool isJoined = false;
                    if (state is ProgramsLoaded) {
                      isJoined = state.joinedPrograms.contains(program['id']);
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (program['id'] == 'hemas_step_challenge') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GameHomeScreen()),
                          );
                        } else if (program['id'] == 'janashakthi_challenge') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JanashakthiGameScreen()),
                          );
                        }
                      },
                      child: Text(
                        isJoined ? 'View' : 'Click to Join',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: program['id'] == 'janashakthi_challenge' 
                            ? Colors.orange 
                            : Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}