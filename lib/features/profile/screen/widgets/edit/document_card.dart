import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';

class DocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconAsset;
  final bool uploaded;

  const DocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.uploaded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: uploaded ? CColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CColors.borderPrimary),
      ),
      child: InkWell(
        onTap: () {
          /* TODO: manejar upload */
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.asset(iconAsset, width: 24, height: 24),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
