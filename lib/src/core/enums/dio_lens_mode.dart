import 'package:flutter/foundation.dart';

/// Build modes in which Dio Lens records requests. Dio Lens shows captured
/// headers and bodies, tokens included, so keep release builds out unless they
/// never reach real users.
enum DioLensMode {
  /// Never enabled.
  hide(inDebug: false, inProfile: false, inRelease: false),

  /// Enabled in every build mode; same as [debugProfileRelease].
  show(inDebug: true, inProfile: true, inRelease: true),

  /// Debug builds only.
  debug(inDebug: true, inProfile: false, inRelease: false),

  /// Profile builds only.
  profile(inDebug: false, inProfile: true, inRelease: false),

  /// Release builds only.
  release(inDebug: false, inProfile: false, inRelease: true),

  /// Debug and profile builds.
  debugProfile(inDebug: true, inProfile: true, inRelease: false),

  /// Debug and release builds.
  debugRelease(inDebug: true, inProfile: false, inRelease: true),

  /// Profile and release builds.
  profileRelease(inDebug: false, inProfile: true, inRelease: true),

  /// Debug, profile and release builds.
  debugProfileRelease(inDebug: true, inProfile: true, inRelease: true);

  const DioLensMode({
    required this.inDebug,
    required this.inProfile,
    required this.inRelease,
  });

  /// Whether Dio Lens is enabled in debug builds.
  final bool inDebug;

  /// Whether Dio Lens is enabled in profile builds.
  final bool inProfile;

  /// Whether Dio Lens is enabled in release builds.
  final bool inRelease;

  /// Whether Dio Lens is enabled in the current build mode.
  bool get isEnabled => kDebugMode
      ? inDebug
      : kProfileMode
      ? inProfile
      : inRelease;
}
