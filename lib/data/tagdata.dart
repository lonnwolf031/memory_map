class TagColumns {
  static final List<String> values = [
    id, title, color
  ];

  static const String id = 'id';
  static const String title = 'title';
  static const String color = 'color';
}

class Tag{
  late int? id;
  late String title;
  late String color;

  Tag({
    this.id,
    required this.title,
    required this.color });

  Tag.fromMap(Map<String, dynamic> item):
        id=item[TagColumns.id]?.toInt() ?? 0,
        title=item[TagColumns.title] ?? '',
        color = item[TagColumns.color] ?? '';

}