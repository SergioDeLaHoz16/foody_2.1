import 'package:flutter/material.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;
  final VoidCallback? onEdit;

  const ProfileHeader({super.key, required this.user, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Fondo decorativo superior
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/logos/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Card blanca con nombre, username y bio
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                  decoration: BoxDecoration(
                    color: isDark ? CColors.darkContainer : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.bio,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Avatar centrado
            Positioned(
              top: 20,
              child: CircleAvatar(
                radius: 45,
                backgroundImage:
                    (user.avatarUrl.isNotEmpty &&
                            user.avatarUrl.startsWith('http'))
                        ? NetworkImage(user.avatarUrl)
                        : const AssetImage('assets/icons/avatar.png'),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 80), // para que la card no quede pegada
      ],
    );
  }
}
