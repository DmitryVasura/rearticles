import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_state.dart';

class PublishTagsSection extends StatelessWidget {
  final TextEditingController controller;
  final Set<String> selected;
  final ValueChanged<String> onRemove;
  final void Function(String name, bool selected) onToggle;
  final ValueChanged<String> onCreate;

  const new({
    super.key,
    required this.controller,
    required this.selected,
    required this.onRemove,
    required this.onToggle,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassSearchBar(controller: controller, placeholder: context.l10n.searchTags),
        SizedBox(height: spacing.m),
        if (selected.isNotEmpty) ...[
          Text(context.l10n.selected, style: theme.textTheme.titleSmall),
          SizedBox(height: spacing.s),
          Wrap(
            spacing: spacing.s,
            runSpacing: spacing.s,
            children: [
              for (final tag in selected)
                GlassChip(
                  label: tag,
                  selected: true,
                  onTap: () => onRemove(tag),
                ),
            ],
          ),
          SizedBox(height: spacing.l),
        ],
        Text(context.l10n.allTags, style: theme.textTheme.titleSmall),
        SizedBox(height: spacing.s),
        BlocBuilder<TagBloc, TagState>(
          builder: (context, state) {
            final textStyle = theme.textTheme.bodyMedium;

            if (state is TagsLoading || state is TagsInitial) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is TagsError) {
              return Center(
                child: Column(
                  children: [
                    Text(context.l10n.failedLoadTags, style: textStyle),
                    SizedBox(height: spacing.s),
                    TextButton(
                      onPressed: () =>
                          context.read<TagBloc>().add(const LoadTags()),
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is TagsLoaded) {
              return ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final raw = controller.text.trim();
                  final query = raw.toLowerCase();
                  final tags = state.tags
                      .where((t) => t.name.toLowerCase().contains(query))
                      .toList();

                  final canCreate = raw.isNotEmpty &&
                      raw.length <= 50 &&
                      !state.tags.any((t) => t.name.toLowerCase() == query);

                  if (tags.isEmpty && !canCreate) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing.l),
                      child: Center(child: Text(context.l10n.noTagsFound, style: textStyle)),
                    );
                  }

                  return Wrap(
                    spacing: spacing.s,
                    runSpacing: spacing.s,
                    children: [
                      if (canCreate)
                        GlassChip(
                          label: '+ Create "$raw"',
                          onTap: () => onCreate(raw),
                        ),
                      for (final tag in tags)
                        GlassChip(
                          label: tag.name,
                          selected: selected.contains(tag.name),
                          onTap: () => onToggle(tag.name, !selected.contains(tag.name)),
                        ),
                    ],
                  );
                }
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}