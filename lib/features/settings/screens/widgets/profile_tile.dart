import 'package:flutter/material.dart';
import 'package:foody/features/profile/screen/profile.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class ProfileTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String avatarUrl;
  final VoidCallback? onTap;

  const ProfileTile({
    Key? key,
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final avatarRadius = size.width * 0.09;
    final titleFontSize = size.width * 0.05;
    final subtitleFontSize = size.width * 0.035;
    final verticalPadding = size.height * 0.01;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.034,
          vertical: verticalPadding,
        ),
        leading: CircleAvatar(
          radius: avatarRadius,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: subtitleFontSize)),
        trailing: Icon(Icons.arrow_forward_ios, size: size.width * 0.05),
        onTap:
            () => THelperFunctions.navigateToScreen(context, ProfileScreen()),
      ),
    );
  }
}
