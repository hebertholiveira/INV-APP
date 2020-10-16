import 'dart:convert';

mConfig configFromJson(String str) {
  final jsonData = json.decode(str);
  return mConfig.fromMap(jsonData);
}

String configToJson(mConfig data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class mConfig {

  String url1;
  String url2;

  mConfig({
    this.url1,
    this.url2
  });

  factory mConfig.fromMap(Map<String, dynamic> json) => new mConfig(
    url1: json["url1"],
    url2: json["url2"],

  );

  Map<String, dynamic> toMap() => {
    "url1": url1,
    "url2": url2
  };
}