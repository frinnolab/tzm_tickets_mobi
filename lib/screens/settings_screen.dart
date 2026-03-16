import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFF1D364A),
        foregroundColor: Colors.white,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSettingCard(
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  title: const Text(
                    'Enable AI Suggestions',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  secondary: const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFF105B5C),
                  ),
                  activeTrackColor: const Color(0xFF105B5C).withAlpha(100),
                  activeThumbColor: const Color(0xFF105B5C),
                  value: settings.enableAi,
                  onChanged: (value) => settings.toggleAi(value),
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingCard(
                child: const ListTile(
                  title: Text(
                    'Account',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingCard(
                child: const ListTile(
                  title: Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
