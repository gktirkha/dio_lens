import 'package:dio/dio.dart' show DioExceptionType;
import 'package:flutter/material.dart';

import '../../../../core/utils/clipboard_utils.dart';
import '../../../../core/utils/ltr_content.dart';
import '../../../../theme/dio_lens_theme.dart';
import 'collapsible_section.dart';

/// Card describing why a request failed without a response.
class ErrorCard extends StatelessWidget {
  /// Creates the error card.
  const ErrorCard({super.key, required this.type, required this.message});

  /// The Dio exception type; unknown when null.
  final DioExceptionType? type;

  /// The error message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final type = this.type;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.dangerBackground,
        border: Border.all(color: theme.danger),
        borderRadius: BorderRadius.circular(theme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline_rounded, size: 16, color: theme.danger),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  type == null
                      ? 'Request failed'
                      : 'DioExceptionType.${type.name}',
                  textDirection: LtrContent.direction,
                  textAlign: LtrContent.align(context),
                  style: theme.monoTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: theme.danger,
                  ),
                ),
              ),
            ],
          ),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: TextStyle(fontSize: 13, height: 1.5, color: theme.text),
            ),
          ],
        ],
      ),
    );
  }
}

/// Collapsible stack trace of a failed request, with a copy button.
class StackTraceSection extends StatelessWidget {
  /// Creates the section.
  const StackTraceSection({super.key, required this.stackTrace});

  /// The stack trace text.
  final String stackTrace;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final lines = '\n'.allMatches(stackTrace).length + 1;
    return CollapsibleSection(
      title: 'Stack trace',
      trailingLabel: '$lines ${lines == 1 ? 'line' : 'lines'}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.surface,
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(theme.radiusMedium),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  stackTrace,
                  style: theme.monoTextStyle.copyWith(
                    fontSize: 11.5,
                    height: 1.7,
                    color: theme.textMuted,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () =>
                  copyToClipboard(context, stackTrace, label: 'Stack trace'),
              icon: const Icon(Icons.content_copy_rounded, size: 14),
              label: const Text('Copy stack trace'),
              style: TextButton.styleFrom(
                foregroundColor: theme.textMuted,
                textStyle: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
