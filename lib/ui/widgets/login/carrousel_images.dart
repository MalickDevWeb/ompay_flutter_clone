// Widget pour afficher le carrousel d'images en haut de la page de connexion
import 'package:flutter/material.dart';
import 'dart:async';

class CarrouselImages extends StatefulWidget {
  const CarrouselImages({super.key});

  @override
  State<CarrouselImages> createState() => _CarrouselImagesState();
}

class _CarrouselImagesState extends State<CarrouselImages> {
  // Contrôleur pour le carrousel d'images
  final PageController _pageController = PageController();
  // Timer pour avancer automatiquement le carrousel
  Timer? _timer;
  // Index de la page actuelle
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Démarrer le timer pour changer d'image toutes les 3 secondes
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 290,
      color: const Color(0xFF0A0A0A),
      child: Stack(
        children: [
          // Fond bleu pour le PageView
          Container(color: const Color(0xFF0A0A0A)),
          SizedBox.expand(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQy-2mKzunreZ3bHZUciD4cuqmyj7s7jHVSMA&s',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg1OjstnvrXRwwqk3d1Z6MVlyHxFHvKlmtmQ&s',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg1OjstnvrXRwwqk3d1Z6MVlyHxFHvKlmtmQ&s',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ],
            ),
          ),
          // Indicateurs de page en bas
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? const Color(0xFFFF7900) // Actif : orange
                        : Colors.grey, // Inactif : gris
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
