import 'package:flutter/material.dart';
import 'package:skeleton_app/common/config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(Config.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch, size: 64),
            const SizedBox(height: 16),
            Text(
              'Welcome to ${Config.appName}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              Config.isProduction ? 'Production' : 'Development',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Config.isProduction ? Colors.red : Colors.green,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
