import 'package:ayubolife/bloc/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_bloc.dart';
import 'package:ayubolife/bloc/auth/auth_event.dart';
import 'package:ayubolife/presentation/screens/profile/profile_page.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuItem(
            context,
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ProfileBloc(userRepository: context.read()),
                    child: ProfilePage(),
                  ),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              // Navigate to settings
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // Navigate to help
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // Show about dialog
            },
          ),
          Divider(),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Sign Out',
            onTap: () {
              _showSignOutDialog(context);
            },
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}