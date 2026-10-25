import 'package:flutter/material.dart';

import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/dio_lens_menu.dart';
import '../../../../theme/dio_lens_theme.dart';

/// Titled group of settings rows, e.g. "Capture".
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.55,
              color: theme.textFaint,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < children.length; i++)
            DecoratedBox(
              decoration: BoxDecoration(
                border: i == children.length - 1
                    ? null
                    : Border(bottom: BorderSide(color: theme.border)),
              ),
              child: children[i],
            ),
        ],
      ),
    );
  }
}

/// A setting: title, optional description, and its control.
///
/// [stacked] puts the control under the label instead of beside it.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.description,
    required this.control,
    this.stacked = false,
  });

  final String title;
  final String? description;
  final Widget control;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: theme.text,
          ),
        ),
        if (description case final description?) ...[
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(fontSize: 11.5, color: theme.textFaint),
          ),
        ],
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [label, const SizedBox(height: 8), control],
            )
          : Row(
              children: [
                Expanded(child: label),
                const SizedBox(width: 10),
                control,
              ],
            ),
    );
  }
}

/// On/off pill switch.
class DioLensSwitch extends StatelessWidget {
  const DioLensSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 26,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value ? theme.accent : theme.surface3,
            border: Border.all(color: value ? theme.accent : theme.border),
            borderRadius: BorderRadius.circular(99),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x4D000000),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Selectable card, e.g. a theme mode or a bubble corner. Accent border
/// and tint when [selected].
class SettingsOption extends StatelessWidget {
  const SettingsOption({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  /// Icon beside the label in a short pill instead of above it.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final color = selected ? theme.accent : theme.textMuted;
    final icon = this.icon;
    final text = Text(
      label,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? Color.alphaBlend(
                theme.accent.withValues(alpha: 0.12),
                theme.surface2,
              )
            : theme.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: selected ? theme.accent : theme.border),
          borderRadius: BorderRadius.circular(compact ? 10 : 12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: compact
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 7)
                : const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: compact
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 15, color: color),
                        const SizedBox(width: 5),
                      ],
                      text,
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: color),
                        const SizedBox(height: 6),
                      ],
                      text,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Compact dropdown showing the label of [value]; picks from [options].
class SettingsSelect<T> extends StatelessWidget {
  const SettingsSelect({
    super.key,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.semanticLabel,
  });

  final T value;
  final List<T> options;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final itemStyle = dioLensMenuItemStyle(context);
    return MenuAnchor(
      style: dioLensMenuStyle(theme, minWidth: 150),
      menuChildren: [
        for (final option in options)
          MenuItemButton(
            style: itemStyle,
            onPressed: () => onChanged(option),
            trailingIcon: option == value
                ? Icon(Icons.check_rounded, size: 16, color: theme.accent)
                : null,
            child: Text(labelOf(option)),
          ),
      ],
      builder: (context, menu, _) => Semantics(
        button: true,
        label: semanticLabel,
        child: Material(
          color: theme.surface2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: theme.border),
            borderRadius: BorderRadius.circular(9),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => menu.isOpen ? menu.close() : menu.open(),
            child: Container(
              height: 34,
              padding: const EdgeInsetsDirectional.only(start: 10, end: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labelOf(value),
                    style: TextStyle(fontSize: 12.5, color: theme.text),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.expand_more_rounded,
                    size: 18,
                    color: theme.textFaint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `−  value  +` stepper for small numbers.
class SettingsMiniStepper extends StatelessWidget {
  const SettingsMiniStepper({
    super.key,
    required this.label,
    required this.onDecrease,
    required this.onIncrease,
    this.semanticName = '',
  });

  final String label;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  /// Names the value for screen readers, e.g. "notification duration".
  final String semanticName;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    Widget step(String symbol, VoidCallback? onTap, String action) =>
        SettingsStepButton(
          symbol: symbol,
          onTap: onTap,
          size: 28,
          tooltip: '$action $semanticName'.trim(),
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        step('−', onDecrease, 'Decrease'),
        SizedBox(
          width: 40,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.monoTextStyle.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: theme.text,
            ),
          ),
        ),
        step('+', onIncrease, 'Increase'),
      ],
    );
  }
}

/// Square `−` / `+` button of a stepper.
class SettingsStepButton extends StatelessWidget {
  const SettingsStepButton({
    super.key,
    required this.symbol,
    required this.onTap,
    required this.size,
    required this.tooltip,
  });

  final String symbol;
  final VoidCallback? onTap;
  final double size;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: theme.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.border),
          borderRadius: BorderRadius.circular(size >= 40 ? 10 : 8),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                  fontSize: size >= 40 ? 18 : 15,
                  fontWeight: FontWeight.w600,
                  color: onTap == null ? theme.textFaint : theme.text,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Text input styled like the sheet's other controls.
InputDecoration settingsInputDecoration(
  DioLensTheme theme, {
  String? hint,
  bool error = false,
  EdgeInsetsGeometry? contentPadding,
}) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: TextStyle(color: theme.textFaint),
    filled: true,
    fillColor: theme.surface2,
    contentPadding:
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    enabledBorder: border(error ? theme.danger : theme.border),
    focusedBorder: border(error ? theme.danger : theme.accent),
    disabledBorder: border(theme.border),
  );
}

/// Comma-separated list of keys (e.g. header names), stored lower case.
/// Saves shortly after typing stops.
class SettingsKeyListField extends StatefulWidget {
  const SettingsKeyListField({
    super.key,
    required this.label,
    required this.keys,
    required this.hint,
    required this.onChanged,
  });

  final String label;
  final List<String> keys;
  final String hint;
  final ValueChanged<List<String>> onChanged;

  @override
  State<SettingsKeyListField> createState() => _SettingsKeyListFieldState();
}

class _SettingsKeyListFieldState extends State<SettingsKeyListField> {
  late final TextEditingController _text = TextEditingController(
    text: widget.keys.join(', '),
  );
  final Debouncer _debouncer = Debouncer(const Duration(milliseconds: 400));

  static List<String> _parse(String text) => [
    for (final part in text.split(','))
      if (part.trim().toLowerCase() case final key when key.isNotEmpty) key,
  ];

  @override
  void dispose() {
    // Save what was typed even if the sheet closes first.
    if (_debouncer.isPending) widget.onChanged(_parse(_text.text));
    _debouncer.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Padding(
      // Same rhythm as [SettingsRow], so the divider above has room.
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: theme.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _text,
            textDirection: TextDirection.ltr,
            autocorrect: false,
            enableSuggestions: false,
            style: theme.monoTextStyle.copyWith(
              fontSize: 12.5,
              color: theme.text,
            ),
            decoration: settingsInputDecoration(theme, hint: widget.hint),
            onChanged: (text) =>
                _debouncer(() => widget.onChanged(_parse(text))),
          ),
        ],
      ),
    );
  }
}
