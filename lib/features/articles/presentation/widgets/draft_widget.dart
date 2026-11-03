import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/articles/domain/entities/article_draft.dart';

const _actionPaneRatio = 0.25;
const _titleMaxLines = 2;
const _previewMaxLines = 4;
const _menuAnchorSize = 1.0;

class DraftWidget extends StatefulWidget {
  const new({
    super.key,
    required this.draft,
    required this.onTap,
    required this.onPublish,
    required this.onDelete,
  });

  final ArticleDraft draft;
  final VoidCallback onTap;
  final VoidCallback onPublish;
  final VoidCallback onDelete;

  @override
  State<DraftWidget> createState() => _DraftWidgetState();
}

class _DraftWidgetState extends State<DraftWidget> {
  final _menu = GlassMenuController();
  Offset _anchor = Offset.zero;

  void _openMenuAt(Offset position) {
    HapticFeedback.mediumImpact();
    setState(() => _anchor = position);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _menu.open();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final radius = BorderRadius.circular(context.radiuses.m);
    final draft = widget.draft;
    final text = draft.plainText;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.m,
        vertical: spacing.xs,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: _actionPaneRatio,
          children: [
            SlidableAction(
              onPressed: (_) {
                Haptics.medium();
                widget.onDelete();
              },
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
              icon: Icons.delete_outline,
              borderRadius: radius,
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              GestureDetector(
                onLongPressStart: (d) => _openMenuAt(d.localPosition),
                child: GlassContainer(
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: radius,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.m,
                        vertical: spacing.l,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            draft.title.trim().isEmpty
                                ? context.l10n.untitledArticle
                                : draft.title,
                            maxLines: _titleMaxLines,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                          SizedBox(height: spacing.s),
                          Text(
                            text.isEmpty ? context.l10n.noContentYet : text,
                            maxLines: _previewMaxLines,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: spacing.m),
                          Text(
                            _formatUpdatedAt(context.l10n, draft.updatedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: _anchor.dx,
                top: _anchor.dy,
                child: GlassMenu(
                  controller: _menu,
                  trigger: const SizedBox.square(dimension: _menuAnchorSize),
                  items: [
                    GlassMenuItem(
                      title: context.l10n.quickPublish,
                      icon: const Icon(Icons.publish),
                      onTap: widget.onPublish,
                    ),
                    GlassMenuItem(
                      title: context.l10n.delete,
                      icon: const Icon(Icons.delete_outline),
                      isDestructive: true,
                      onTap: () {
                        Haptics.medium();
                        widget.onDelete();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatUpdatedAt(AppLocalizations l10n, DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);

  if (diff < const Duration(minutes: 1)) return l10n.editedJustNow;
  if (diff < const Duration(hours: 1)) {
    return l10n.editedMinutesAgo(diff.inMinutes);
  }
  if (diff < const Duration(days: 1)) return l10n.editedHoursAgo(diff.inHours);
  if (diff < const Duration(days: 2)) return l10n.editedYesterday;
  if (diff < const Duration(days: 7)) return l10n.editedDaysAgo(diff.inDays);

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return l10n.editedOn(
    '${twoDigits(dateTime.day)}.'
    '${twoDigits(dateTime.month)}.${dateTime.year}',
  );
}