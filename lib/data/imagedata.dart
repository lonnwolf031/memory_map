import 'dart:typed_data';

class ImageColumns {
  static final List<String> values = [
    id, data, locationId
  ];

  static const String id = 'id';
  static const String data = 'data';
  static const String locationId = 'location_id';
}

class ImageData{
  late int? id;
  late Uint8List data;
  late int locationId;

  ImageData({
    this.id,
    required this.data,
    required this.locationId });

  ImageData.fromMap(Map<String, dynamic> item):
        id=item[ImageColumns.id]?.toInt() ?? 0,
        data=item[ImageColumns.data] ?? '',
        locationId = item[ImageColumns.locationId] ?? '';

  Map<String, Object> update(){
    return {
      ImageColumns.id:id ?? -1,
      ImageColumns.data:data,
      ImageColumns.locationId:locationId,
    };
  }

  Map<String, Object> insert(){
    return {
      ImageColumns.id:id ?? -1,
      ImageColumns.data:data,
      ImageColumns.locationId:locationId,
    };
  }
}