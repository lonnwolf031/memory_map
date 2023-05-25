class LocationColumn {
  static final List<String> values = [
    /// Add all fields
    id, lat, lon, title, description
  ];

  static const String id = 'id';
  static const String lat = 'lat';
  static const String lon = 'lon';
  static const String title = 'title';
  static const String description ='description';
}

class Location{
  late int? id;
  late String lat;
  late String lon;
  late String title;
  late String description;

  Location({
    this.id,
    required this.lat,
    required this.lon,
    required this.title,
    required this.description });

  Location.fromMap(Map<String, dynamic> item):
        id=item[LocationColumn.id]?.toInt() ?? 0,
        lat=item[LocationColumn.lat] ?? '',
        lon=item[LocationColumn.lon] ?? '',
        title = item[LocationColumn.title] ?? '',
        description = item[LocationColumn.description] ?? '';

  Map<String, Object> toMap(){
    return {
      LocationColumn.id:id ?? 0,
      LocationColumn.lat:lat,
      LocationColumn.lon:lon,
      LocationColumn.title: title,
      LocationColumn.description: description,
    };
  }
}