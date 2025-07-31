import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Inbox Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}