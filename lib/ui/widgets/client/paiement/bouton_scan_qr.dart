import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../theme/app_colors.dart';

class BoutonScanQR extends StatefulWidget {
  final bool isDarkMode;

  const BoutonScanQR({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<BoutonScanQR> createState() => _BoutonScanQRState();
}

class _BoutonScanQRState extends State<BoutonScanQR> {
  bool _isScanning = false;

  // Vérifier si la plateforme supporte le scan caméra
  bool get _supportsCameraScanning {
    // Mobile Scanner fonctionne sur Android, iOS et Web
    // Mais pas sur Linux desktop
    if (kIsWeb) return true;
    if (Platform.isAndroid || Platform.isIOS) return true;
    return false; // Desktop platforms like Linux, Windows, macOS
  }

  void _toggleScanner() {
    if (!_supportsCameraScanning) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scan QR non disponible sur cette plateforme'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isScanning = !_isScanning;
    });
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && mounted) {
        setState(() {
          _isScanning = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Code scanné: $code'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _isScanning ? 'Scanner de code QR actif' : 'Bouton pour scanner un code QR',
      child: GestureDetector(
        onTap: _toggleScanner,
        child: Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _isScanning
                ? AppColors.surface(widget.isDarkMode)
                : AppColors.card(widget.isDarkMode),
            border: _isScanning
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: _isScanning
              ? _buildScannerView()
              : _buildButtonView(),
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    if (!_supportsCameraScanning) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.card(widget.isDarkMode),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Scan non\ndisponible',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MobileScanner(
        onDetect: _onDetect,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
        ),
      ),
    );
  }

  Widget _buildButtonView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _supportsCameraScanning ? Icons.qr_code_scanner : Icons.qr_code_scanner_outlined,
          size: 40,
          color: _supportsCameraScanning
              ? AppColors.icon(widget.isDarkMode)
              : Colors.grey,
        ),
        const SizedBox(height: 8),
        Text(
          _supportsCameraScanning ? 'Cliquer et\nscanner' : 'Scan non\ndisponible',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: _supportsCameraScanning
                ? AppColors.textSecondary(widget.isDarkMode)
                : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
