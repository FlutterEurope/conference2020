import 'package:flutter/material.dart';

class SettingsToggle extends StatelessWidget {
  const SettingsToggle({
    Key key,
    this.title,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final String title;
  final Function(bool) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}
