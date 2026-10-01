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
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF1F5F9);
  static const sidebar = Color(0xFF0F172A);
  static const textPrimary = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);

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
