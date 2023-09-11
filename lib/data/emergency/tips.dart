class Tips {
  Tips({
    this.imageUrl,
    this.shortDescription,
    this.longDescription,
  });

  Tips.fromJson(dynamic json) {
    imageUrl = json['image_url'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
  }

  String? imageUrl;
  String? shortDescription;
  String? longDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_url'] = imageUrl;
    map['short_description'] = shortDescription;
    map['long_description'] = longDescription;
    return map;
  }
}
