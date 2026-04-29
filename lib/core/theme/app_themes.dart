import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum AppSeasonalTheme {
  spring('themes.spring'),
  summer('themes.summer'),
  autumn('themes.autumn'),
  winter('themes.winter');

  final String localizationKey;
  const AppSeasonalTheme(this.localizationKey);
}

extension ShadColorSchemeExtension on ShadColorScheme {
  ShadColorScheme copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? selection,
  }) {
    return ShadColorScheme(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground: destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      selection: selection ?? this.selection,
    );
  }
}

class AppThemes {
  static ShadColorScheme getLightColorScheme(AppSeasonalTheme season) {
    switch (season) {
      case AppSeasonalTheme.spring:
        return const ShadGreenColorScheme.light().copyWith(
          background: const Color(0xFFF2FFF5),
          card: const Color(0xFFE6F9E6),
          popover: const Color(0xFFE6F9E6),
          primary: const Color(0xFF22C55E),
        );
      case AppSeasonalTheme.summer:
        return const ShadZincColorScheme.light().copyWith(
          background: const Color(0xFFFFF9F2),
          card: const Color(0xFFFFF1E6),
          popover: const Color(0xFFFFF1E6),
          primary: const Color(0xFFF97316),
          primaryForeground: Colors.white,
        );
      case AppSeasonalTheme.autumn:
        return const ShadZincColorScheme.light().copyWith(
          background: const Color(0xFFFAF6F0),
          card: const Color(0xFFF0E6D8),
          popover: const Color(0xFFF0E6D8),
          primary: const Color(0xFFB45309),
          primaryForeground: Colors.white,
        );
      case AppSeasonalTheme.winter:
        return const ShadBlueColorScheme.light().copyWith(
          background: const Color(0xFFF0F8FF),
          card: const Color(0xFFE6F0FA),
          popover: const Color(0xFFE6F0FA),
          primary: const Color(0xFF3B82F6),
        );
    }
  }

  static ShadColorScheme getDarkColorScheme(AppSeasonalTheme season) {
    switch (season) {
      case AppSeasonalTheme.spring:
        return const ShadGreenColorScheme.dark();
      case AppSeasonalTheme.summer:
        return const ShadZincColorScheme.dark().copyWith(
          primary: const Color(0xFFF97316),
          primaryForeground: Colors.white,
        );
      case AppSeasonalTheme.autumn:
        return const ShadZincColorScheme.dark().copyWith(
          primary: const Color(0xFFD97706),
          primaryForeground: Colors.white,
        );
      case AppSeasonalTheme.winter:
        return const ShadBlueColorScheme.dark();
    }
  }
}
