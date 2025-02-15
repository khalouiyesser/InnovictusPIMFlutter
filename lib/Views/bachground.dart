/*import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredRadialBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final List<double> stops;
  final double radius;
  final double blurSigma;

  const BlurredRadialBackground({
    super.key,
    required this.child,
    this.colors = const [Color(0xFF0A140C), Color(0xFF0D0F0D)],
    this.stops = const [0.2, 1.0],
    this.radius = 1.2,
    this.blurSigma = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: radius,
          colors: colors,
          stops: stops,
        ),
      ),
      child: Stack(
        children: [
          // Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigma,
                sigmaY: blurSigma,
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Content
          child,
        ],
      ),
    );
  }
}*/
import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredRadialBackground extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blurSigma;

  const BlurredRadialBackground({
    super.key,
    required this.child,
    this.radius = 1.2,
    this.blurSigma = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // Gradient différent selon le mode
        gradient: isDarkMode
            ? RadialGradient(
                center: Alignment.center,
                radius: radius,
                colors: [Color(0xFF0A140C), Color(0xFF0D0F0D)],
                stops: [0.2, 1.0],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF93DAB2).withOpacity(0.8),
                  Colors.white.withOpacity(0.5),
                ],
              ),
      ),
      child: Stack(
        children: [
          // Effet de flou
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigma,
                sigmaY: blurSigma,
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Contenu
          child,
        ],
      ),
    );
  }
}
