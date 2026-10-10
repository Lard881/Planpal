import 'package:flutter/material.dart';

/// PlanPal color palette
class AppColors {
  AppColors._();

  // Light Theme Colors
  static const primary = Color(0xFF3B82F6);
  static const onPrimary = Color(0xFFFFFFFF);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const violet = Color(0xFF8B5CF6);
  static const danger = Color(0xFFEF4444);
  static const error = Color(0xFFEF4444); // Alias for danger
  static const info = Color(0xFF3B82F6); // Alias for primary
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF1F5F9);
  static const sidebar = Color(0xFF0F172A);
  static const textPrimary = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);
  static const textSecondary = textMuted;
  static const border = Color(0xFFE2E8F0);
  static const white = Color(0xFFFFFFFF);
  static const transparent = Colors.transparent;
  
  // Grey scale (Tailwind-inspired)
  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF3F4F6);
  static const grey200 = Color(0xFFE5E7EB);
  static const grey300 = Color(0xFFD1D5DB);
  static const grey400 = Color(0xFF9CA3AF);
  static const grey500 = Color(0xFF6B7280);
  static const grey600 = Color(0xFF4B5563);
  static const grey700 = Color(0xFF374151);
  static const grey800 = Color(0xFF1F2937);
  static const grey900 = Color(0xFF111827);

  // Dark Theme Colors
  static const primaryDark = Color(0xFF60A5FA);
  static const onPrimaryDark = Color(0xFF0B1220);
  static const successDark = Color(0xFF34D399);
  static const warningDark = Color(0xFFFBBF24);
  static const violetDark = Color(0xFFA78BFA);
  static const dangerDark = Color(0xFFF87171);
  static const backgroundDark = Color(0xFF0B1220);
  static const surfaceDark = Color(0xFF111827);
  static const surfaceAltDark = Color(0xFF1F2937);
  static const sidebarDark = Color(0xFF020617);
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textMutedDark = Color(0xFF94A3B8);
  static const borderDark = Color(0xFF1F2937);

  // Priority Colors
  static const priorityHigh = danger;
  static const priorityHighDark = dangerDark;
  static const priorityMedium = warning;
  static const priorityMediumDark = warningDark;
  static const priorityLow = success;
  static const priorityLowDark = successDark;

  // Status Colors
  static const statusTodo = Color(0xFF94A3B8);
  static const statusInProgress = primary;
  static const statusInProgressDark = primaryDark;
  static const statusCompleted = success;
  static const statusCompletedDark = successDark;
  static const statusOverdue = danger;
  static const statusOverdueDark = dangerDark;
}
