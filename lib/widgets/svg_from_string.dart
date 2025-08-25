import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgFromString extends StatelessWidget {
  final String svgString;
  final double? width;
  final double? height;
  final Color? color;

  const SvgFromString({
    super.key,
    required this.svgString,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    try {
      // Decodifica a string SVG (remove possíveis caracteres especiais)
      final cleanedSvg = svgString.replaceAll(
        '<?xml version="1.0" encoding="UTF-8" standalone="no"?>',
        '',
      );

      return SvgPicture.string(
        cleanedSvg,
        width: width,
        height: height,
        color: color,
        placeholderBuilder: (context) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.image, color: Colors.grey),
        ),
      );
    } catch (e) {
      print('Erro ao renderizar SVG: $e');
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }
}
