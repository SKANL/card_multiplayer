import 'package:flutter/material.dart';

/// Clase con degradados y estilos visuales mejorados para el juego
class AppGradients {
  // Degradados principales
  static const mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667eea), // Púrpura azulado
      Color(0xFF764ba2), // Púrpura oscuro
    ],
  );

  static const menuGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1e3c72), // Azul oscuro
      Color(0xFF2a5298), // Azul medio
    ],
  );

  static const playSessionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF134e5e), // Verde azulado oscuro
      Color(0xFF16a085), // Verde azulado claro
    ],
  );

  static const debugGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0f0c29), // Negro azulado
      Color(0xFF302b63), // Púrpura oscuro
      Color(0xFF24243e), // Gris oscuro
    ],
  );

  static const firebaseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B6B), // Rojo Firebase
      Color(0xFFFF8E53), // Naranja
    ],
  );

  // Gradientes secundarios
  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
  );

  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
  );

  static const settingsGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1a237e), // Azul muy oscuro
      Color(0xFF283593), // Azul oscuro
    ],
  );

  // Colores base
  static const primaryColor = Color(0xFF667eea);
  static const secondaryColor = Color(0xFF764ba2);
  static const accentColor = Color(0xFFFF6B6B);
  static const backgroundColor = Color(0xFF0f0f1e);

  // Métodos auxiliares
  static BoxDecoration getGradientDecoration(LinearGradient gradient) {
    return BoxDecoration(gradient: gradient);
  }

  static BoxDecoration getGradientDecorationWithBorder(
    LinearGradient gradient, {
    Color borderColor = const Color(0xFF667eea),
    double borderWidth = 2.0,
    double borderRadius = 12.0,
  }) {
    return BoxDecoration(
      gradient: gradient,
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
