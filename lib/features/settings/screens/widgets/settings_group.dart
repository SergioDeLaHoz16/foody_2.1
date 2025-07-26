// lib/features/settings/widgets/settings_group.dart
import 'package:flutter/material.dart';
import 'settings_section_title.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const SettingsGroup({required this.title, required this.tiles, super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final spacing = mq.size.height * 0.01;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionTitle(title: title),
          ...tiles.map(
            (tile) => Padding(
              padding: EdgeInsets.symmetric(vertical: spacing),
              child: tile,
            ),
          ),
        ],
      ),
    );
  }
}
