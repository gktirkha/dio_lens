import 'package:flutter/material.dart';

import '../../../../core/enums/export_format.dart';
import '../../../../core/widgets/dio_lens_icon_button.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../../theme/dio_lens_theme_scope.dart';
import '../../domain/entities/dio_lens_settings.dart';
import '../../domain/enums/dio_lens_bubble_position.dart';
import '../../domain/enums/dio_lens_notification_position.dart';
import '../../domain/enums/dio_lens_redaction_mode.dart';
import '../../domain/enums/dio_lens_retention.dart';
import '../controllers/settings_controller.dart';
import '../widgets/capture_fields.dart';
import '../widgets/settings_widgets.dart';

/// Opens the settings sheet over the current Dio Lens page, sharing its theme
/// mode.
Future<void> showDioLensSettings(
  BuildContext context, {
  required SettingsController Function() createController,
  ValueChanged<DioLensExportFormat>? onExport,
}) {
  final themeController = DioLensThemeScope.controllerOf(context);
  final mode = DioLensThemeScope.modeOf(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x8C05060A),
    builder: (_) => DioLensThemeScope(
      controller: themeController,
      mode: mode,
      child: SettingsSheet(
        createController: createController,
        onExport: onExport,
      ),
    ),
  );
}

/// Every Dio Lens setting, grouped as Appearance, Capture, Entry point,
/// Privacy, Export and Reset. Changes apply as they are made.
class SettingsSheet extends StatefulWidget {
  /// Creates the sheet.
  const SettingsSheet({
    super.key,
    required this.createController,
    this.onExport,
  });

  /// Creates the sheet's controller; the sheet disposes it.
  final SettingsController Function() createController;

  /// Exports in the chosen format; null disables export.
  final ValueChanged<DioLensExportFormat>? onExport;

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late final SettingsController _controller = widget.createController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmReset() async {
    final themeController = DioLensThemeScope.controllerOf(context);
    final mode = DioLensThemeScope.modeOf(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DioLensThemeScope(
        controller: themeController,
        mode: mode,
        child: const _ResetDialog(),
      ),
    );
    if (confirmed ?? false) await _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final height = MediaQuery.sizeOf(context).height;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: keyboard > 0 ? height - keyboard : height * 0.86,
        ),
        child: Material(
          color: theme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: theme.border),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(top: 10, bottom: 2),
                  decoration: BoxDecoration(
                    color: theme.borderStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 8, 6),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: theme.text,
                        ),
                      ),
                    ),
                    DioLensIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Close settings',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    if (_controller.isLoading) {
                      return const SizedBox(height: 120);
                    }
                    return _SettingsBody(
                      settings: _controller.settings,
                      storedCount: _controller.storedCount,
                      onChanged: _controller.update,
                      onReset: _confirmReset,
                      onExport: widget.onExport,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.settings,
    required this.storedCount,
    required this.onChanged,
    required this.onReset,
    this.onExport,
  });

  final VoidCallback onReset;
  final DioLensSettings settings;
  final int storedCount;
  final Future<void> Function(
    DioLensSettings Function(DioLensSettings settings) change,
  )
  onChanged;
  final ValueChanged<DioLensExportFormat>? onExport;

  static const Map<DioLensRedactionMode, String> _redactionLabels = {
    DioLensRedactionMode.redact: 'Everywhere',
    DioLensRedactionMode.console: 'Console only',
    DioLensRedactionMode.ui: 'UI only',
    DioLensRedactionMode.off: 'Off',
  };

  static const Map<DioLensRetention, String> _retentionLabels = {
    DioLensRetention.session: 'This session',
    DioLensRetention.oneHour: '1 hour',
    DioLensRetention.oneDay: '24 hours',
    DioLensRetention.sevenDays: '7 days',
    DioLensRetention.always: 'Always',
  };

  @override
  Widget build(BuildContext context) {
    final s = settings;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    String side(bool start) => start != rtl ? 'left' : 'right';
    String bubbleLabel(DioLensBubblePosition p) => switch (p) {
      DioLensBubblePosition.topStart => 'Top-${side(true)}',
      DioLensBubblePosition.topEnd => 'Top-${side(false)}',
      DioLensBubblePosition.bottomStart => 'Bottom-${side(true)}',
      DioLensBubblePosition.bottomEnd => 'Bottom-${side(false)}',
    };
    final duration = s.notificationDuration.inSeconds;

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(
        16,
        14,
        16,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        SettingsSection(
          title: 'Appearance',
          children: [
            Row(
              children: [
                for (final (mode, label, icon) in const [
                  (ThemeMode.light, 'Light', Icons.light_mode_outlined),
                  (ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
                  (ThemeMode.system, 'System', Icons.desktop_windows_outlined),
                ]) ...[
                  if (mode != ThemeMode.light) const SizedBox(width: 8),
                  Expanded(
                    child: SettingsOption(
                      label: label,
                      icon: icon,
                      selected: s.themeMode == mode,
                      onTap: () =>
                          onChanged((s) => s.copyWith(themeMode: mode)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        SettingsSection(
          title: 'Capture',
          children: [
            MaxRequestsField(
              value: s.maxRequests,
              storedCount: storedCount,
              onChanged: (n) => onChanged((s) => s.copyWith(maxRequests: n)),
            ),
            SettingsRow(
              title: 'Retention',
              description: 'How long captured requests are kept on device',
              control: SettingsSelect<DioLensRetention>(
                value: s.retention,
                options: DioLensRetention.values,
                labelOf: (r) => _retentionLabels[r]!,
                onChanged: (r) => onChanged((s) => s.copyWith(retention: r)),
                semanticLabel: 'Retention period',
              ),
            ),
            MaxBodySizeField(
              value: s.maxBodyBytes,
              onChanged: (bytes) =>
                  onChanged((s) => s.copyWith(maxBodyBytes: bytes)),
            ),
          ],
        ),
        SettingsSection(
          title: 'Entry point',
          children: [
            SettingsRow(
              title: 'Show notification',
              description: 'Banner over your app when a request finishes',
              control: DioLensSwitch(
                value: s.showNotification,
                semanticLabel: 'Show notification',
                onChanged: (v) =>
                    onChanged((s) => s.copyWith(showNotification: v)),
              ),
            ),
            if (s.showNotification) ...[
              SettingsRow(
                title: 'Notification position',
                description: 'Top, center or bottom of screen',
                stacked: true,
                control: Row(
                  children: [
                    for (final (position, label, icon) in const [
                      (
                        DioLensNotificationPosition.top,
                        'Top',
                        Icons.arrow_upward_rounded,
                      ),
                      (
                        DioLensNotificationPosition.center,
                        'Center',
                        Icons.vertical_align_center_rounded,
                      ),
                      (
                        DioLensNotificationPosition.bottom,
                        'Bottom',
                        Icons.arrow_downward_rounded,
                      ),
                    ]) ...[
                      if (position != DioLensNotificationPosition.top)
                        const SizedBox(width: 8),
                      Expanded(
                        child: SettingsOption(
                          label: label,
                          icon: icon,
                          compact: true,
                          selected: s.notificationPosition == position,
                          onTap: () => onChanged(
                            (s) => s.copyWith(notificationPosition: position),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SettingsRow(
                title: 'Notification duration',
                description:
                    'How long the finished-request alert stays on '
                    'screen',
                control: SettingsMiniStepper(
                  label: '${duration}s',
                  semanticName: 'notification duration',
                  onDecrease:
                      duration >
                          DioLensSettings.minNotificationDuration.inSeconds
                      ? () => onChanged(
                          (s) => s.copyWith(
                            notificationDuration: Duration(
                              seconds: duration - 1,
                            ),
                          ),
                        )
                      : null,
                  onIncrease:
                      duration <
                          DioLensSettings.maxNotificationDuration.inSeconds
                      ? () => onChanged(
                          (s) => s.copyWith(
                            notificationDuration: Duration(
                              seconds: duration + 1,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
            SettingsRow(
              title: 'Show floating bubble',
              description: 'Tap-to-open bubble overlaid on your app',
              control: DioLensSwitch(
                value: s.showBubble,
                semanticLabel: 'Show floating bubble',
                onChanged: (v) => onChanged((s) => s.copyWith(showBubble: v)),
              ),
            ),
            if (s.showBubble)
              SettingsRow(
                title: 'Bubble position',
                description: 'Corner where the floating bubble starts',
                stacked: true,
                control: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 4,
                  children: [
                    for (final position in DioLensBubblePosition.values)
                      SettingsOption(
                        label: bubbleLabel(position),
                        compact: true,
                        selected: s.bubblePosition == position,
                        onTap: () => onChanged(
                          (s) => s.copyWith(bubblePosition: position),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
        SettingsSection(
          title: 'Privacy',
          children: [
            SettingsRow(
              title: 'Redact sensitive values',
              description: 'Where listed headers and query params are masked',
              control: SettingsSelect<DioLensRedactionMode>(
                value: s.redactionMode,
                options: DioLensRedactionMode.values,
                labelOf: (mode) => _redactionLabels[mode]!,
                onChanged: (mode) =>
                    onChanged((s) => s.copyWith(redactionMode: mode)),
                semanticLabel: 'Redaction mode',
              ),
            ),
            if (s.redactionMode != DioLensRedactionMode.off) ...[
              SettingsKeyListField(
                label: 'Header keys to redact',
                keys: s.redactedHeaders,
                hint: 'authorization, cookie, x-api-key',
                onChanged: (keys) =>
                    onChanged((s) => s.copyWith(redactedHeaders: keys)),
              ),
              SettingsKeyListField(
                label: 'Query keys to redact',
                keys: s.redactedQueryParams,
                hint: 'token, apikey, password',
                onChanged: (keys) =>
                    onChanged((s) => s.copyWith(redactedQueryParams: keys)),
              ),
            ],
          ],
        ),
        SettingsSection(
          title: 'Export',
          children: [
            Row(
              children: [
                for (final format in DioLensExportFormat.values) ...[
                  if (format != DioLensExportFormat.values.first)
                    const SizedBox(width: 8),
                  Expanded(
                    child: _ExportButton(
                      format: format,
                      onPressed: onExport == null
                          ? null
                          : () => onExport!(format),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        SettingsSection(
          title: 'Reset',
          children: [
            SettingsRow(
              title: 'Reset settings',
              description:
                  'Back to the starting values; captured requests '
                  'are kept',
              control: _ResetButton(onPressed: onReset),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.settings_backup_restore_rounded, size: 16),
      label: const Text('Reset'),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.danger,
        backgroundColor: theme.dangerBackground,
        side: BorderSide(color: theme.danger.withValues(alpha: 0.4)),
        minimumSize: const Size(0, 34),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        textStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ResetDialog extends StatelessWidget {
  const _ResetDialog();

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return AlertDialog(
      title: const Text('Reset settings?'),
      content: Text(
        'Every setting goes back to its starting value. Captured requests '
        'are kept.',
        style: TextStyle(fontSize: 13.5, height: 1.45, color: theme.textMuted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: theme.textMuted),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: theme.danger),
          child: const Text('Reset'),
        ),
      ],
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({required this.format, required this.onPressed});

  final DioLensExportFormat format;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.download_rounded, size: 16),
      label: Text(format.name.toUpperCase()),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.text,
        backgroundColor: theme.surface2,
        side: BorderSide(color: theme.border),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}
