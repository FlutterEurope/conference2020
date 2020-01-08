import 'package:flutter/material.dart';

class SettingsToggle extends StatelessWidget {
  const SettingsToggle({
    Key key,
    this.title,
    this.subtitle,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Function(bool) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}
