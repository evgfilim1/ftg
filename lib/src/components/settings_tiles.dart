import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const SettingsTile({
    Key? key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon!) : const SizedBox(),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              softWrap: false,
              overflow: TextOverflow.fade,
            )
          : null,
      trailing: trailing,
      enabled: enabled,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

class SettingsSwitchTile extends SettingsTile {
  SettingsSwitchTile({
    Key? key,
    IconData? icon,
    required String title,
    String? subtitle,
    required bool value,
    bool enabled = true,
    required ValueChanged<bool> onTap,
  }) : super(
          key: key,
          icon: icon,
          title: title,
          subtitle: subtitle,
          trailing: Switch.adaptive(value: value, onChanged: onTap),
          enabled: enabled,
          onTap: () => onTap(!value),
        );
}

class SettingsDialogTile extends SettingsTile {
  SettingsDialogTile({
    required BuildContext context,
    Key? key,
    IconData? icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool enabled = true,
    required List<SettingsDialogOption> options,
  }) : super(
          key: key,
          icon: icon,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          enabled: enabled,
          onTap: () => showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text(title),
              children: [
                ...options,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}

class SettingsDialogOption extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SettingsDialogOption({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        onTap();
      },
      child: Text(text),
    );
  }
}

class SettingsAboutTile extends SettingsTile {
  SettingsAboutTile({
    required BuildContext context,
    Key? key,
    IconData? icon,
    required String title,
    String? subtitle,
    bool enabled = true,
    String? appName,
    String? appVersion,
    Widget? appIcon,
    List<Widget>? children,
    VoidCallback? onLongPress,
  }) : super(
          key: key,
          icon: icon,
          title: title,
          subtitle: subtitle,
          enabled: enabled,
          onTap: () => showAboutDialog(
            context: context,
            applicationName: appName,
            applicationVersion: appVersion,
            applicationIcon: appIcon,
            children: children,
          ),
          onLongPress: onLongPress,
        );
}
