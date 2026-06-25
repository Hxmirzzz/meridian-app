import 'package:flutter/material.dart';

/// Paleta de colores de Meridian.
class AppColors {
  AppColors._();

  // ── Primarios ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFD32F2F);       // Rojo Transmilenio
  static const Color primaryDark = Color(0xFF9A0007);
  static const Color primaryLight = Color(0xFFFF6659);

  // ── Fondo y superficies (dark mode) ────────────────────────────────────────
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2C2C2C);
  static const Color cardColor = Color(0xFF252525);

  // ── Acento ─────────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFFFC107);        // Ámbar — alertas
  static const Color accentGreen = Color(0xFF4CAF50);   // Verde — activo
  static const Color accentRed = Color(0xFFEF5350);     // Rojo suave — inactivo

  // ── Texto ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textDisabled = Color(0xFF616161);

  // ── Divisores y bordes ─────────────────────────────────────────────────────
  static const Color divider = Color(0xFF303030);
  static const Color border = Color(0xFF424242);

  // ── Mapa ───────────────────────────────────────────────────────────────────
  static const Color geofenceCircle = Color(0x33D32F2F);     // Rojo 20% opacidad
  static const Color geofenceBorder = Color(0xFFD32F2F);
  static const Color markerActive = Color(0xFFD32F2F);
  static const Color markerInactive = Color(0xFF757575);
}