class NotificationResponseModel {
  final bool isMuted; // Indicates whether the alarm should be muted
  final String? payload; // Other relevant data

  NotificationResponseModel({
    required this.isMuted,
    this.payload,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      isMuted: json['isMuted'] ?? false,
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isMuted': isMuted,
      'payload': payload,
    };
  }
}
