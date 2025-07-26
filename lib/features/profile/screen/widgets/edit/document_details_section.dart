import 'package:flutter/material.dart';
import 'document_card.dart';

class DocumentDetailsSection extends StatelessWidget {
  const DocumentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: DocumentCard(
            title: 'NPWP',
            subtitle: 'Upload Now',
            iconAsset: 'assets/logos/logo.png',
            uploaded: false,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: DocumentCard(
            title: 'e-KTP',
            subtitle: 'Uploaded',
            iconAsset: 'assets/logos/logo3.png',
            uploaded: true,
          ),
        ),
      ],
    );
  }
}
