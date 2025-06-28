import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Clean Architecture'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Flutter Clean Architecture',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'This is the home screen',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
