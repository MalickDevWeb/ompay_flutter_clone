// Classe pour créer un clipper ondulé pour la transition entre les sections
import 'package:flutter/material.dart';

class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Commencer à dessiner le chemin ondulé
    path.lineTo(0, 40);

    // Première courbe quadratique
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 40);

    // Deuxième courbe quadratique
    path.quadraticBezierTo(size.width * 0.75, 80, size.width, 40);

    // Fermer le chemin
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
