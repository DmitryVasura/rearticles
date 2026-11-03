import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/utils/haptics.dart';

const _actionPaneRatio = 0.4;

const _menuAnchorSize = 1.0;

class ManageableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const new({
    super.key,
    required this.child,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  State<ManageableCard> createState() => _ManageableCardState();
}

class _ManageableCardState extends State<ManageableCard> {
  final _menu = GlassMenuController();
  Offset _anchor = Offset.zero;

  void _openMenuAt(Offset position) {
    Haptics.medium();
    setState(() => _anchor = position);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _menu.open();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(context.radiuses.m);

    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: _actionPaneRatio,
        children: [
          SlidableAction(
            onPressed: (actionContext) {
              Slidable.of(actionContext)?.close();
              widget.onEdit();
            },
            backgroundColor: colors.secondary,
            foregroundColor: colors.onPrimary,
            icon: Icons.edit_outlined,
            borderRadius: radius,
          ),
          SlidableAction(
            onPressed: (actionContext) {
              Slidable.of(actionContext)?.close();
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
              onTap: widget.onTap,
              onLongPressStart: (d) => _openMenuAt(d.localPosition),
              child: widget.child,
            ),
            Positioned(
              left: _anchor.dx,
              top: _anchor.dy,
              child: GlassMenu(
                controller: _menu,
                trigger: const SizedBox.square(dimension: _menuAnchorSize),
                items: [
                  GlassMenuItem(
                    title: context.l10n.edit,
                    icon: const Icon(Icons.edit_outlined),
                    onTap: widget.onEdit,
                  ),
                  GlassMenuItem(
                    title: context.l10n.delete,
                    icon: const Icon(Icons.delete_outline),
                    isDestructive: true,
                    onTap: widget.onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}