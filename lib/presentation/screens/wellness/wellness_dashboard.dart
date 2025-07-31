import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ayubolife/bloc/wellness/wellness_bloc.dart';
import 'package:ayubolife/bloc/wellness/wellness_event.dart';
import 'package:ayubolife/bloc/wellness/wellness_state.dart';
import 'package:ayubolife/presentation/widgets/health_goals_widget.dart';
import 'package:ayubolife/presentation/widgets/weekly_progress_chart.dart';
import 'package:ayubolife/presentation/widgets/common/loading_widget.dart';
import 'package:ayubolife/presentation/widgets/common/error_widget.dart';

class WellnessDashboard extends StatefulWidget {
  @override
  _WellnessDashboardState createState() => _WellnessDashboardState();
}

class _WellnessDashboardState extends State<WellnessDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<WellnessBloc>().add(LoadWellnessData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          BlocBuilder<WellnessBloc, WellnessState>(
            builder: (context, state) {
              if (state is WellnessLoaded) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.user.credits} Life Points',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<WellnessBloc, WellnessState>(
        listener: (context, state) {
          if (state is WellnessError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WellnessLoading) {
            return LoadingWidget();
          } else if (state is WellnessError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<WellnessBloc>().add(LoadWellnessData()),
            );
          } else if (state is WellnessLoaded) {
            return _buildDashboard(context, state);
          }
          return Center(child: Text('Welcome to AyuboLife'));
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WellnessLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserProfile(context, state),
          SizedBox(height: 20),
          _buildHealthStatus(context, state),
          SizedBox(height: 20),
          HealthGoalsWidget(
            dailySteps: state.stepsCount,
            dailyCalories: state.caloriesCount,
          ),
          SizedBox(height: 20),
          _buildStepCountCard(context, state),
          SizedBox(height: 16),
          _buildStatsRow(context, state),
          SizedBox(height: 20),
          if (state.caloriesCount > 0) ...[
            _buildCaloriesCard(context, state),
            SizedBox(height: 20),
          ],
          if (state.weeklyHistory.isNotEmpty) ...[
            WeeklyProgressChart(weeklyData: state.weeklyHistory),
            SizedBox(height: 20),
          ],
          if (state.user.purchasedPrograms.isNotEmpty) ...[
            _buildMyPrograms(context, state),
            SizedBox(height: 20),
          ],
          _buildGoogleFitIntegration(context, state),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, WellnessLoaded state) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: state.user.photoURL?.isNotEmpty == true
                ? NetworkImage(state.user.photoURL!)
                : null,
            backgroundColor: Colors.blue,
            child: state.user.photoURL?.isEmpty != false
                ? Icon(Icons.person, color: Colors.white, size: 30)
                : null,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.user.fullName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  state.user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          _buildSyncButton(context, state),
          _buildRefreshButton(context, state),
        ],
      ),
    );
  }

  Widget _buildSyncButton(BuildContext context, WellnessLoaded state) {
    return Column(
      children: [
        IconButton(
          onPressed: state.isSyncing
              ? null
              : () => context.read<WellnessBloc>().add(SyncGoogleFitData()),
          icon: state.isSyncing
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.sync),
          tooltip: 'Sync Google Fit Data',
        ),
        Text(
          'Sync',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton(BuildContext context, WellnessLoaded state) {
    return Column(
      children: [
        IconButton(
          onPressed: () => context.read<WellnessBloc>().add(RefreshWellnessData()),
          icon: Icon(Icons.refresh),
          tooltip: 'Refresh Data',
        ),
        Text(
          'Refresh',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthStatus(BuildContext context, WellnessLoaded state) {
    final isSuccess = state.stepsCount > 0;
    final isLoading = state.isSyncing;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLoading
            ? Colors.orange.shade100  
            : (isSuccess ? Colors.green.shade100 : Colors.blue.shade100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLoading
              ? Colors.orange
              : (isSuccess ? Colors.green : Colors.blue),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isLoading
                ? Icons.sync
                : (isSuccess ? Icons.check_circle : Icons.fitness_center),
            color: isLoading
                ? Colors.orange
                : (isSuccess ? Colors.green : Colors.blue),
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              state.healthStatus,
              style: TextStyle(
                color: isLoading
                    ? Colors.orange.shade800
                    : (isSuccess ? Colors.green.shade800 : Colors.blue.shade800),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isLoading) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCountCard(BuildContext context, WellnessLoaded state) {
    return              Container(
               width: double.infinity,
               height: 210,
               decoration: BoxDecoration(
   borderRadius: BorderRadius.circular(20),
   image: DecorationImage(
     image: AssetImage('assets/images/Walk-Every-Day.jpg'), // <-- Add your image here
     fit: BoxFit.cover,
     colorFilter: ColorFilter.mode(
       Colors.orange.withOpacity(0.9), // Semi-transparent orange overlay
       BlendMode.darken, // Creates a shady effect
     ),
   ),
   gradient: LinearGradient(
     colors: [
       Colors.orange.withOpacity(0.8),
       Colors.orange.withOpacity(0.6),
     ],
     begin: Alignment.topLeft,
     end: Alignment.bottomRight,
   ),
 ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step Count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Google Fit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: state.stepsCount / 10000,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(height: 5),
                    Text(
                      state.stepsCount == 0 ? '0' : NumberFormat('#,###').format(state.stepsCount),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'steps',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              state.stepsCount == 0
                  ? 'Connect to Google Fit to view your steps'
                  : 'Daily Target: 10,000 • ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, WellnessLoaded state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '${DateFormat('h:mm a').format(state.lastSyncTime)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Last synced',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          Column(
            children: [
              Text(
                NumberFormat('#,###').format(state.monthlySteps),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Steps for ${DateFormat('MMMM').format(DateTime.now())}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          Column(
            children: [
              Text(
                NumberFormat('#,###').format(state.weeklySteps),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Steps this week',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard(BuildContext context, WellnessLoaded state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.8),
            Colors.red.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories Burned',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                '${state.caloriesCount.toInt()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Text(
                'cal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyPrograms(BuildContext context, WellnessLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Programs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ...state.user.purchasedPrograms.map((program) => _buildProgramCard(program)),
      ],
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.health_and_safety, color: Colors.white),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program['name'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  program['description'] ?? '',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleFitIntegration(BuildContext context, WellnessLoaded state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google Fit Integration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Automatically sync your fitness data',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: state.stepsCount > 0 ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  state.stepsCount > 0 ? 'Connected' : 'Sync Required',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}