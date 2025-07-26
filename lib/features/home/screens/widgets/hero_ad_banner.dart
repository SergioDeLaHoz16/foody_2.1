import 'package:flutter/material.dart';

class HeroAdBanner extends StatelessWidget {
  const HeroAdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.asset(
            'assets/anuncios/hero4.png',
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
          ),
          // Capa semitransparente para mejorar legibilidad del texto
          Container(color: Colors.black.withOpacity(0.25)),
          // Texto encima, alineado arriba a la izquierda
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'Gestiona tu inventario y recetas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Controla productos, evita desperdicios y descubre nuevas ideas culinarias.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
