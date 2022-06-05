import 'package:flutter/material.dart';

import '../../components/settings_tiles.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  bool? _themeMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
      ),
      body: ListView(
        children: [
          SettingsDialogTile(
            context: context,
            icon: Icons.color_lens,
            title: "Mode",
            subtitle: _themeMode == null
                ? "System"
                : _themeMode!
                    ? "Dark"
                    : "Light",
            options: [
              SettingsDialogOption(
                text: "System",
                onTap: () {
                  setState(() {
                    _themeMode = null;
                  });
                },
              ),
              SettingsDialogOption(
                text: "Dark",
                onTap: () {
                  setState(() {
                    _themeMode = true;
                  });
                },
              ),
              SettingsDialogOption(
                text: "Light",
                onTap: () {
                  setState(() {
                    _themeMode = false;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
