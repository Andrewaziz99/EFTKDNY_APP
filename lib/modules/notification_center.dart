import 'package:flutter/material.dart';

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center'),
      ),
      body: const Center(
        child: Text(
          'No notifications yet.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

