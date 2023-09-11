import 'tips.dart';

class EmergencyTips {
  EmergencyTips({
    this.category,
    this.tips,
  });

  EmergencyTips.fromJson(dynamic json) {
    category = json['category'];
    if (json['tips'] != null) {
      tips = [];
      json['tips'].forEach((v) {
        tips?.add(Tips.fromJson(v));
      });
    }
  }

  String? category;
  List<Tips>? tips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = category;
    if (tips != null) {
      map['tips'] = tips?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
