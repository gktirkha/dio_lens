import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/ltr_content.dart';
import '../../../../core/widgets/dio_lens_icon_button.dart';
import '../../../../core/widgets/method_chip.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/request_detail_entity.dart';

class RequestDetailHeader extends StatelessWidget {
  const RequestDetailHeader({
    super.key,
    required this.request,
    required this.onCopyCurl,
    this.onShare,
    this.onReplay,
    this.onOpenHome,
  });

  final RequestDetailEntity request;
  final VoidCallback onCopyCurl;
  final VoidCallback? onShare;
  final VoidCallback? onReplay;

  final VoidCallback? onOpenHome;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final mono = theme.monoTextStyle;
    final ltrAlign = LtrContent.align(context);
    final query = request.query;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(6, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DioLensIconButton(
                icon: Icons.chevron_left_rounded,
                tooltip: onOpenHome == null ? 'Back to request list' : 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          MethodChip(method: request.method),
                          const SizedBox(width: 7),
                          StatusBadge.fromState(
                            state: request.state,
                            statusCode: request.statusCode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        request.path,
                        textDirection: LtrContent.direction,
                        textAlign: ltrAlign,
                        style: mono.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        query == null ? request.host : '${request.host}?$query',
                        textDirection: LtrContent.direction,
                        textAlign: ltrAlign,
                        style: mono.copyWith(
                          fontSize: 12,
                          color: theme.textMuted,
                        ),
                        maxLines: 3,
                        overflow: .ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (onOpenHome case final onOpenHome?)
                DioLensIconButton(
                  icon: Icons.home_outlined,
                  tooltip: 'Open Dio Lens home',
                  onPressed: onOpenHome,
                ),
              const DioLensThemeToggleButton(),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 0, 12),
            child: Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                _Stat(
                  icon: Icons.schedule_rounded,
                  text: FormatUtils.duration(request.duration),
                ),
                if (request.responseSize != null)
                  _Stat(
                    icon: Icons.dns_outlined,
                    text: FormatUtils.bytes(request.responseSize),
                  ),
                if (request.protocol != null)
                  _Stat(icon: Icons.public_rounded, text: request.protocol!),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 12),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.ios_share_rounded,
                    label: 'Share',
                    onPressed: onShare,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.content_copy_rounded,
                    label: 'cURL',
                    onPressed: onCopyCurl,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.replay_rounded,
                    label: 'Replay',
                    onPressed: onReplay,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: theme.textMuted),
        const SizedBox(width: 3),
        Text(
          text,
          textDirection: LtrContent.direction,
          style: TextStyle(
            fontSize: 12,
            color: theme.textMuted,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 15),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        foregroundColor: theme.text,
        backgroundColor: theme.surface2,
        side: BorderSide(color: theme.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}
