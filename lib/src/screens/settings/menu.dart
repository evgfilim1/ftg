import 'package:flutter/material.dart';

import './theme.dart';
import '../../components/settings_tiles.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {},
            enabled: false,
          ),
          SettingsTile(
            icon: Icons.storage,
            title: "Data and storage",
            onTap: () {},
            enabled: false,
          ),
          SettingsTile(
            icon: Icons.lock,
            title: "Privacy and security",
            onTap: () {},
            enabled: false,
          ),
          SettingsTile(
            icon: Icons.color_lens,
            title: "Theme",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ThemeSettingsScreen()),
            ),
          ),
          SettingsTile(
            icon: Icons.language,
            title: "Language",
            onTap: () {},
            enabled: false,
          ),
          SettingsTile(
            icon: Icons.developer_board,
            title: "Other",
            onTap: () {},
            enabled: false,
          ),
          SettingsAboutTile(
            icon: Icons.info,
            context: context,
            title: "About",
          ),
        ],
      ),
    );
  }
}
