
import 'package:flutter/material.dart';

class TestReminderPage extends StatelessWidget {
  const TestReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text('სატესტო შეტყობინება', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'ეს არის სატესტო შეტყობინება',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
