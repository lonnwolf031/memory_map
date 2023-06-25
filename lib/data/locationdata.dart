class LocationColumns {
  static final List<String> values = [
    id, lat, lon, title, description, tagIds
  ];

  static const String id = 'id';
  static const String lat = 'lat';
  static const String lon = 'lon';
  static const String title = 'title';
  static const String description ='description';
  static const String tagIds = 'tagIds';
}

class Location{
  late int? id;
  late String lat;
  late String lon;
  late String title;
  late String description;
  late String? tagIds;

  static const String separator = ';';

  Location({
    this.id,
    required this.lat,
    required this.lon,
    required this.title,
    required this.description,
    this.tagIds});

  Location.fromMap(Map<String, dynamic> item):
        id=item[LocationColumns.id]?.toInt() ?? 0,
        lat=item[LocationColumns.lat] ?? '',
        lon=item[LocationColumns.lon] ?? '',
        title = item[LocationColumns.title] ?? '',
        description = item[LocationColumns.description] ?? '',
        tagIds = item[LocationColumns.tagIds] ?? '';

  Map<String, Object> update(){
    return {
      LocationColumns.id:id ?? -1,
      LocationColumns.lat:lat,
      LocationColumns.lon:lon,
      LocationColumns.title:title,
      LocationColumns.description:description,
      LocationColumns.tagIds:tagIds ?? '',
    };
  }

  Map<String, Object> insert(){
    return {
      LocationColumns.lat:lat,
      LocationColumns.lon:lon,
      LocationColumns.title:title,
      LocationColumns.description:description,
      LocationColumns.tagIds:tagIds ?? '',
    };
  }

  void addTagId(int idToAdd) {
    if(tagIds == null) {
      tagIds = idToAdd.toString();
    } else {
      var newTagIds = tagIds! + separator + idToAdd.toString();
      tagIds = newTagIds;
    }
  }

  List getTagIds() {
    List<int> intIds = [];
    if(tagIds != null) {
      var stringArr = tagIds!.split(separator);
      for(int i = 0; i < stringArr.length; i++) {
        var integer = int.parse(stringArr[i]);
        if(integer != null) {
          intIds.add(integer);
        }
      }
    }
    return intIds;
  }
}