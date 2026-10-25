import 'package:flutter/foundation.dart';

enum DioLensMode {
  hide(inDebug: false, inProfile: false, inRelease: false),

  show(inDebug: true, inProfile: true, inRelease: true),

  debug(inDebug: true, inProfile: false, inRelease: false),

  profile(inDebug: false, inProfile: true, inRelease: false),

  release(inDebug: false, inProfile: false, inRelease: true),

  debugProfile(inDebug: true, inProfile: true, inRelease: false),

  debugRelease(inDebug: true, inProfile: false, inRelease: true),

  profileRelease(inDebug: false, inProfile: true, inRelease: true),

  debugProfileRelease(inDebug: true, inProfile: true, inRelease: true);

  const DioLensMode({
    required this.inDebug,
    required this.inProfile,
    required this.inRelease,
  });

  final bool inDebug;

  final bool inProfile;

  final bool inRelease;

  bool get isEnabled => kDebugMode
      ? inDebug
      : kProfileMode
      ? inProfile
      : inRelease;
}
