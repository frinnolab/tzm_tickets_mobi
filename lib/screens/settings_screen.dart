import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Application Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable AI Suggestions'),
              subtitle: const Text(
                'Allow ChatGPT to suggest ticket resolutions automatically.',
              ),
              value: settings.enableAi,
              onChanged: (value) {
                settings.toggleAi(value);
              },
            ),
          ],
        );
      },
    );
  }
}
