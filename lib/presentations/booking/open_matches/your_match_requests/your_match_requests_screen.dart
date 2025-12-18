import 'package:flutter/material.dart';
class YourMatchRequestsScreen extends StatelessWidget {
  const YourMatchRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header()
        ],
      ),
    );
  }
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Your match requests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.close),
        ],
      ),
    );
  }
}
