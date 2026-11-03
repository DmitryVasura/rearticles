import 'package:flutter/material.dart';
import 'package:re_articles/core/themes/app_layouts.dart';

class ArticleTagWidget extends StatelessWidget {
  final String tag;
  const new({
    super.key,
    required this.tag
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return SizedBox(
      height: context.layouts.tagHeight,
      child: Text(
        tag,
        style: textStyle,
      ),
    );
  }
}