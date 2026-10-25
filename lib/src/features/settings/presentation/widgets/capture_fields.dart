import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/dio_lens_settings.dart';
import '../../domain/enums/dio_lens_size_unit.dart';
import 'settings_widgets.dart';

class MaxRequestsField extends StatefulWidget {
  const MaxRequestsField({
    super.key,
    required this.value,
    required this.storedCount,
    required this.onChanged,
  });

  final int value;
  final int storedCount;
  final ValueChanged<int> onChanged;

  static const int step = 10;

  @override
  State<MaxRequestsField> createState() => _MaxRequestsFieldState();
}

class _MaxRequestsFieldState extends State<MaxRequestsField> {
  late final TextEditingController _text = TextEditingController(
    text: '${widget.value}',
  );
  final FocusNode _focus = FocusNode();

  int? get _draft => switch (int.tryParse(_text.text.trim())) {
    final n?
        when n >= DioLensSettings.minRequests &&
            n <= DioLensSettings.maxRequestsLimit =>
      n,
    _ => null,
  };

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus && _draft == null) _show(widget.value);
    });
  }

  @override
  void didUpdateWidget(MaxRequestsField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _draft != widget.value) {
      _show(widget.value);
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _show(int value) => setState(() => _text.text = '$value');

  void _apply(int value) {
    final clamped = value.clamp(
      DioLensSettings.minRequests,
      DioLensSettings.maxRequestsLimit,
    );
    _show(clamped);
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final current = _draft ?? widget.value;
    final invalid = _draft == null;
    final usage = (widget.storedCount / widget.value).clamp(0.0, 1.0);
    final percent = (usage * 100).round();

    return SettingsRow(
      title: 'Max stored requests',
      stacked: true,
      control: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SettingsStepButton(
                symbol: '−',
                size: 40,
                tooltip: 'Decrease max stored requests',
                onTap: current > DioLensSettings.minRequests
                    ? () => _apply(current - MaxRequestsField.step)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _text,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: theme.monoTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: invalid ? theme.danger : theme.text,
                  ),
                  decoration: settingsInputDecoration(theme, error: invalid),
                  onChanged: (_) {
                    setState(() {});
                    if (_draft case final n? when n != widget.value) {
                      widget.onChanged(n);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              SettingsStepButton(
                symbol: '+',
                size: 40,
                tooltip: 'Increase max stored requests',
                onTap: current < DioLensSettings.maxRequestsLimit
                    ? () => _apply(current + MaxRequestsField.step)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Oldest requests are removed once this limit is reached.',
            style: TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: theme.textFaint,
            ),
          ),
          if (invalid) ...[
            const SizedBox(height: 4),
            Text(
              'Enter a number between 10 and 10,000',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: theme.danger,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final preset in DioLensSettings.maxRequestsPresets)
                _PresetChip(
                  label: '$preset',
                  selected: widget.value == preset,
                  onTap: () => _apply(preset),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.storedCount} of ${widget.value} stored',
                  style: TextStyle(fontSize: 12, color: theme.textMuted),
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.textMuted,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: usage,
              minHeight: 5,
              backgroundColor: theme.surface3,
              color: percent >= 90 ? theme.warning : theme.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? theme.accent : theme.surface2,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? theme.accent : theme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: theme.monoTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? theme.onAccent : theme.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MaxBodySizeField extends StatefulWidget {
  const MaxBodySizeField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  State<MaxBodySizeField> createState() => _MaxBodySizeFieldState();
}

class _MaxBodySizeFieldState extends State<MaxBodySizeField> {
  DioLensSizeUnit? _unit;
  late final TextEditingController _text = TextEditingController();

  static const Map<DioLensSizeUnit, num> _defaults = {
    DioLensSizeUnit.bytes: 1024,
    DioLensSizeUnit.kilobytes: 256,
    DioLensSizeUnit.megabytes: 1,
  };

  @override
  void initState() {
    super.initState();
    _showValue(widget.value);
  }

  @override
  void didUpdateWidget(MaxBodySizeField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _bytes != widget.value) {
      _showValue(widget.value);
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _showValue(int? bytes) {
    if (bytes == null) {
      _unit = null;
      return;
    }
    final unit = DioLensSizeUnit.values.lastWhere(
      (u) => bytes % u.factor == 0,
      orElse: () => DioLensSizeUnit.bytes,
    );
    _unit = unit;
    _text.text = _format(unit.fromBytes(bytes));
  }

  static String _format(num value) =>
      value == value.roundToDouble() ? '${value.round()}' : '$value';

  int? get _bytes {
    final unit = _unit;
    final number = num.tryParse(_text.text.trim());
    if (unit == null || number == null || number <= 0) return null;
    final bytes = unit.toBytes(number);
    return bytes > 0 ? bytes : null;
  }

  void _selectUnit(DioLensSizeUnit? unit) {
    setState(() {
      _unit = unit;
      if (unit != null && num.tryParse(_text.text.trim()) == null) {
        _text.text = _format(_defaults[unit]!);
      }
    });
    widget.onChanged(unit == null ? null : _bytes);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final unit = _unit;
    final invalid = unit != null && _bytes == null;
    return SettingsRow(
      title: 'Max body size',
      description: unit == null
          ? 'Every body is kept whole'
          : invalid
          ? 'Enter a size above 0'
          : 'Larger bodies are stored truncated',
      control: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (unit != null) ...[
            SizedBox(
              width: 84,
              child: TextField(
                controller: _text,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: theme.monoTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: invalid ? theme.danger : theme.text,
                ),
                decoration: settingsInputDecoration(
                  theme,
                  error: invalid,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 9,
                  ),
                ),
                onChanged: (_) {
                  setState(() {});
                  if (_bytes case final bytes? when bytes != widget.value) {
                    widget.onChanged(bytes);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
          ],
          SettingsSelect<DioLensSizeUnit?>(
            value: unit,
            options: const [...DioLensSizeUnit.values, null],
            labelOf: (u) => u?.label ?? 'Unlimited',
            onChanged: _selectUnit,
            semanticLabel: 'Max body size unit',
          ),
        ],
      ),
    );
  }
}
