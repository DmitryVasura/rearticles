class TagModel {
  final String tag;

  const TagModel({
    required this.tag,
  });

  factory TagModel.fromJson(dynamic json) {
    if (json is String) {
      return TagModel(
        tag: json,
      );
    }

    if (json is Map<String, dynamic>) {
      return TagModel(
        tag: json['tag'] as String,
      );
    }

    throw FormatException(
      'Invalid tag format: $json',
    );
  }
}