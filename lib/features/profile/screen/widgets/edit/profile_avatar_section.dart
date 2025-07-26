import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';

class ProfileAvatarSection extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;

  const ProfileAvatarSection({
    Key? key,
    required this.onTap,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                imageUrl.startsWith('http') || imageUrl.startsWith('assets')
                    ? NetworkImage(imageUrl) as ImageProvider
                    : FileImage(File(imageUrl)),
            backgroundColor: Colors.grey[200],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: CColors.primaryColor,
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
