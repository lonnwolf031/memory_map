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
  late String id;
  late String lat;
  late String lon;
  late String title;
  late String description;

  Location({
    required this.lat,
    required this.lon,
    required this.title,
    required this.description });

  Location.fromMap(Map<String, dynamic> item):
        id=item[LocationColumn.id],
        lat=item[LocationColumn.lat],
        lon=item[LocationColumn.lon],
        title = item[LocationColumn.title],
        description = item[LocationColumn.description];

  Map<String, Object> toMap(){
    var map = <String, Object>{
      LocationColumn.lat:lat,
      LocationColumn.lon:lon,
      LocationColumn.title: title,
    };
    if (id != null) {
      map[LocationColumn.id] = id;
    }
    return map;

    return {
      LocationColumn.id:id,
      LocationColumn.lat:lat,
      LocationColumn.lon:lon,
      LocationColumn.title: title,
      LocationColumn.description: description,
    };
  }
}