class LocationColumn {
  static final List<String> values = [
    /// Add all fields
    id, title, description
  ];

  static const String id = 'id';
  static const String title = 'title';
  static const String description ='description';
}

class Location{
  late String id;
  late String title;
  late String description;

  Location({
    required this.id,
    required this.title,
    required this.description });

  Location.fromMap(Map<String, dynamic> item):
        id=item[LocationColumn.id],
        title = item[LocationColumn.title],
        description = item[LocationColumn.description];

  Map<String, Object> toMap(){
    return {
      LocationColumn.id:id,
      LocationColumn.title: title,
      LocationColumn.description: description,
    };
  }
}