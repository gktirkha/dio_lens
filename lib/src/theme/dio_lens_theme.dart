import 'package:flutter/material.dart';

/// Design tokens for the Dio Lens inspector UI.
///
/// Mirrors the `--dl-*` / `--m-*` custom properties in `res/design.html`.
///
/// Internal to the package: the host app never applies this theme. Dio Lens
/// screens wrap themselves in `DioLensThemeScope`, which installs
/// [toFlutterTheme] for that subtree only. Inside it, read the tokens with
/// [DioLensTheme.of].
@immutable
class DioLensTheme extends ThemeExtension<DioLensTheme> {
  const DioLensTheme({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.border,
    required this.borderStrong,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.accent,
    required this.accentStrong,
    required this.onAccent,
    required this.success,
    required this.successBackground,
    required this.redirect,
    required this.redirectBackground,
    required this.warning,
    required this.warningBackground,
    required this.danger,
    required this.dangerBackground,
    required this.pending,
    required this.pendingBackground,
    required this.methodGet,
    required this.methodGetBackground,
    required this.methodPost,
    required this.methodPostBackground,
    required this.methodPut,
    required this.methodPutBackground,
    required this.methodPatch,
    required this.methodPatchBackground,
    required this.methodDelete,
    required this.methodDeleteBackground,
    required this.jsonKey,
    required this.jsonString,
    required this.jsonNumber,
    required this.jsonBoolNull,
    required this.jsonPunctuation,
    required this.shadow,
    this.radiusSmall = 8,
    this.radiusMedium = 12,
    this.radiusLarge = 20,
  });

  final Brightness brightness;

  // Surfaces
  final Color background;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color border;
  final Color borderStrong;

  // Text
  final Color text;
  final Color textMuted;
  final Color textFaint;

  // Accent
  final Color accent;
  final Color accentStrong;
  final Color onAccent;

  // Status classes: 2xx / 3xx / 4xx / 5xx & errors / pending
  final Color success;
  final Color successBackground;
  final Color redirect;
  final Color redirectBackground;
  final Color warning;
  final Color warningBackground;
  final Color danger;
  final Color dangerBackground;
  final Color pending;
  final Color pendingBackground;

  // HTTP method chips
  final Color methodGet;
  final Color methodGetBackground;
  final Color methodPost;
  final Color methodPostBackground;
  final Color methodPut;
  final Color methodPutBackground;
  final Color methodPatch;
  final Color methodPatchBackground;
  final Color methodDelete;
  final Color methodDeleteBackground;

  // JSON tree syntax colors
  final Color jsonKey;
  final Color jsonString;
  final Color jsonNumber;
  final Color jsonBoolNull;
  final Color jsonPunctuation;

  final BoxShadow shadow;

  // Typography: device fonts only, nothing is bundled with the package.
  // UI text uses the platform default (Roboto, San Francisco, Segoe UI…).
  // Monospace: Android resolves 'monospace'; the fallbacks cover iOS/macOS,
  // Windows and Linux.
  static const String monoFontFamily = 'monospace';
  static const List<String> monoFontFamilyFallback = [
    'Menlo',
    'SF Mono',
    'Courier',
    'Consolas',
    'DejaVu Sans Mono',
  ];

  // Radii
  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;

  /// The tokens of the nearest `DioLensThemeScope`.
  static DioLensTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<DioLensTheme>();
    assert(theme != null, 'No DioLensThemeScope found above this widget.');
    return theme!;
  }

  /// Text style for URLs, headers, bodies and other code-like content.
  TextStyle get monoTextStyle => TextStyle(
    fontFamily: monoFontFamily,
    fontFamilyFallback: monoFontFamilyFallback,
    color: text,
  );

  /// Converts these tokens into a Material 3 [ThemeData].
  ThemeData toFlutterTheme() {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: onAccent,
      primaryContainer: accent.withValues(alpha: 0.16),
      onPrimaryContainer: accentStrong,
      secondary: accentStrong,
      onSecondary: onAccent,
      tertiary: redirect,
      onTertiary: onAccent,
      error: danger,
      onError: onAccent,
      errorContainer: dangerBackground,
      onErrorContainer: danger,
      surface: surface,
      onSurface: text,
      onSurfaceVariant: textMuted,
      surfaceContainerLowest: background,
      surfaceContainerLow: surface,
      surfaceContainer: surface2,
      surfaceContainerHigh: surface3,
      surfaceContainerHighest: surface3,
      outline: borderStrong,
      outlineVariant: border,
      shadow: shadow.color,
      surfaceTint: Colors.transparent,
    );

    final baseTextTheme = brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final textTheme = baseTextTheme
        .apply(bodyColor: text, displayColor: text)
        .copyWith(
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.17,
            color: text,
          ),
          bodySmall: baseTextTheme.bodySmall?.copyWith(color: textMuted),
        );

    final smallShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusSmall),
    );
    final mediumShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: BorderSide(color: border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      textTheme: textTheme,
      dividerColor: border,
      extensions: [this],
      iconTheme: IconThemeData(color: textMuted, size: 19),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: textMuted, size: 19),
        actionsIconTheme: IconThemeData(color: textMuted, size: 19),
        shape: Border(bottom: BorderSide(color: border)),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: mediumShape.copyWith(side: BorderSide(color: border)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: textMuted,
        textColor: text,
        subtitleTextStyle: TextStyle(color: textMuted, fontSize: 12.5),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        selectedColor: accent,
        side: BorderSide(color: border),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          color: textMuted,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: onAccent,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
        checkmarkColor: onAccent,
        showCheckmark: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        isDense: true,
        hintStyle: TextStyle(color: textFaint),
        prefixIconColor: textFaint,
        suffixIconColor: textFaint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: danger),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: danger, width: 1.5),
        ),
        errorStyle: TextStyle(
          color: danger,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: TextStyle(color: textFaint, fontSize: 11.5),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: textMuted,
        indicatorColor: accent,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: border,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? accent : textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: states.contains(WidgetState.selected) ? accent : textMuted,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        showDragHandle: true,
        dragHandleColor: borderStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusLarge),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface2,
        surfaceTintColor: Colors.transparent,
        shape: mediumShape.copyWith(side: BorderSide(color: border)),
        textStyle: TextStyle(color: text, fontSize: 14),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface3,
        contentTextStyle: TextStyle(color: text, fontSize: 13),
        actionTextColor: accent,
        behavior: SnackBarBehavior.floating,
        shape: mediumShape,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? onAccent : textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? accent : surface3,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : borderStrong,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? accent.withValues(alpha: 0.16)
                : surface2,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? accent : textMuted,
          ),
          side: WidgetStatePropertyAll(BorderSide(color: border)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          shape: mediumShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          backgroundColor: surface2,
          side: BorderSide(color: border),
          shape: mediumShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accent, shape: smallShape),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textMuted,
          highlightColor: surface3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: surface3,
        circularTrackColor: Colors.transparent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surface3,
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        textStyle: TextStyle(color: text, fontSize: 12),
      ),
    );
  }

  @override
  DioLensTheme copyWith({
    Brightness? brightness,
    Color? background,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? border,
    Color? borderStrong,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? accent,
    Color? accentStrong,
    Color? onAccent,
    Color? success,
    Color? successBackground,
    Color? redirect,
    Color? redirectBackground,
    Color? warning,
    Color? warningBackground,
    Color? danger,
    Color? dangerBackground,
    Color? pending,
    Color? pendingBackground,
    Color? methodGet,
    Color? methodGetBackground,
    Color? methodPost,
    Color? methodPostBackground,
    Color? methodPut,
    Color? methodPutBackground,
    Color? methodPatch,
    Color? methodPatchBackground,
    Color? methodDelete,
    Color? methodDeleteBackground,
    Color? jsonKey,
    Color? jsonString,
    Color? jsonNumber,
    Color? jsonBoolNull,
    Color? jsonPunctuation,
    BoxShadow? shadow,
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
  }) {
    return DioLensTheme(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      successBackground: successBackground ?? this.successBackground,
      redirect: redirect ?? this.redirect,
      redirectBackground: redirectBackground ?? this.redirectBackground,
      warning: warning ?? this.warning,
      warningBackground: warningBackground ?? this.warningBackground,
      danger: danger ?? this.danger,
      dangerBackground: dangerBackground ?? this.dangerBackground,
      pending: pending ?? this.pending,
      pendingBackground: pendingBackground ?? this.pendingBackground,
      methodGet: methodGet ?? this.methodGet,
      methodGetBackground: methodGetBackground ?? this.methodGetBackground,
      methodPost: methodPost ?? this.methodPost,
      methodPostBackground: methodPostBackground ?? this.methodPostBackground,
      methodPut: methodPut ?? this.methodPut,
      methodPutBackground: methodPutBackground ?? this.methodPutBackground,
      methodPatch: methodPatch ?? this.methodPatch,
      methodPatchBackground:
          methodPatchBackground ?? this.methodPatchBackground,
      methodDelete: methodDelete ?? this.methodDelete,
      methodDeleteBackground:
          methodDeleteBackground ?? this.methodDeleteBackground,
      jsonKey: jsonKey ?? this.jsonKey,
      jsonString: jsonString ?? this.jsonString,
      jsonNumber: jsonNumber ?? this.jsonNumber,
      jsonBoolNull: jsonBoolNull ?? this.jsonBoolNull,
      jsonPunctuation: jsonPunctuation ?? this.jsonPunctuation,
      shadow: shadow ?? this.shadow,
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
    );
  }

  @override
  DioLensTheme lerp(covariant DioLensTheme? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    double d(double a, double b) => a + (b - a) * t;
    final pickOther = t >= 0.5;

    return DioLensTheme(
      brightness: pickOther ? other.brightness : brightness,
      background: c(background, other.background),
      surface: c(surface, other.surface),
      surface2: c(surface2, other.surface2),
      surface3: c(surface3, other.surface3),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      text: c(text, other.text),
      textMuted: c(textMuted, other.textMuted),
      textFaint: c(textFaint, other.textFaint),
      accent: c(accent, other.accent),
      accentStrong: c(accentStrong, other.accentStrong),
      onAccent: c(onAccent, other.onAccent),
      success: c(success, other.success),
      successBackground: c(successBackground, other.successBackground),
      redirect: c(redirect, other.redirect),
      redirectBackground: c(redirectBackground, other.redirectBackground),
      warning: c(warning, other.warning),
      warningBackground: c(warningBackground, other.warningBackground),
      danger: c(danger, other.danger),
      dangerBackground: c(dangerBackground, other.dangerBackground),
      pending: c(pending, other.pending),
      pendingBackground: c(pendingBackground, other.pendingBackground),
      methodGet: c(methodGet, other.methodGet),
      methodGetBackground: c(methodGetBackground, other.methodGetBackground),
      methodPost: c(methodPost, other.methodPost),
      methodPostBackground: c(methodPostBackground, other.methodPostBackground),
      methodPut: c(methodPut, other.methodPut),
      methodPutBackground: c(methodPutBackground, other.methodPutBackground),
      methodPatch: c(methodPatch, other.methodPatch),
      methodPatchBackground: c(
        methodPatchBackground,
        other.methodPatchBackground,
      ),
      methodDelete: c(methodDelete, other.methodDelete),
      methodDeleteBackground: c(
        methodDeleteBackground,
        other.methodDeleteBackground,
      ),
      jsonKey: c(jsonKey, other.jsonKey),
      jsonString: c(jsonString, other.jsonString),
      jsonNumber: c(jsonNumber, other.jsonNumber),
      jsonBoolNull: c(jsonBoolNull, other.jsonBoolNull),
      jsonPunctuation: c(jsonPunctuation, other.jsonPunctuation),
      shadow: BoxShadow.lerp(shadow, other.shadow, t)!,
      radiusSmall: d(radiusSmall, other.radiusSmall),
      radiusMedium: d(radiusMedium, other.radiusMedium),
      radiusLarge: d(radiusLarge, other.radiusLarge),
    );
  }
}
