class Utilities {
  static String appInfo = "This app uses OpenStreetMap maps.";
  static String copyrightInfo = "OpenStreetMap® is open data, licensed under the Open Data Commons Open Database License (ODbL) by the OpenStreetMap Foundation (OSMF).";

  static T? castOrNull<T>(dynamic x) => x is T ? x : null;

}