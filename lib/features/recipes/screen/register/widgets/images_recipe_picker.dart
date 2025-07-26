import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foody/data/services/cloudinary_service.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:image_picker/image_picker.dart';

class RecipeImagePicker extends StatefulWidget {
  final Color color;
  final Function(String?) onImageUploaded;
  // final String? text;
  // final String? text_2;

  const RecipeImagePicker({
    super.key,
    required this.color,
    required this.onImageUploaded,
    // this.text,
    // this.text_2,
  });

  @override
  State<RecipeImagePicker> createState() => _RecipeImagePickerState();
}

class _RecipeImagePickerState extends State<RecipeImagePicker> {
  String? _uploadedImageUrl;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final cloudinaryService = CloudinaryService();
      final uploadedUrl = await cloudinaryService.uploadImage(
        File(pickedFile.path),
      );
      if (uploadedUrl != null) {
        setState(() {
          _uploadedImageUrl = uploadedUrl;
        });
        widget.onImageUploaded(uploadedUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al subir la imagen a Cloudinary'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagen de la receta *',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: widget.color),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona una imagen para tu receta',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: widget.color.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              color: CColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
              image:
                  _uploadedImageUrl != null
                      ? DecorationImage(
                        image: NetworkImage(_uploadedImageUrl!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                _uploadedImageUrl == null
                    ? const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 40),
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
