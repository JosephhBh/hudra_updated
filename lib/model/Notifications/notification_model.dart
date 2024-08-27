import 'dart:convert';

class NotificationModel {
  String notificationId = '';
  String notificationTitle = '';
  String notificationMessage = '';

  NotificationModel({
    required this.notificationId,
    required this.notificationTitle,
    required this.notificationMessage,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = (json['notificationId'] ?? '').toString();
    notificationTitle = (json['notificationTitle'] ?? '').toString();
    notificationMessage = (json['notificationMessage'] ?? '').toString();
  }

  NotificationModel.fromString(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    notificationId = (json['notificationId'] ?? '').toString();
    notificationTitle = (json['notificationTitle'] ?? '').toString();
    notificationMessage = (json['notificationMessage'] ?? '').toString();
  }

  NotificationModel.fromList(List<dynamic> data) {
    notificationId = (data[0] ?? '').toString();
    notificationTitle = (data[1] ?? '').toString();
    notificationMessage = (data[2] ?? '').toString();
  }

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "notificationTitle": notificationTitle,
        "notificationMessage": notificationMessage,
      };

  @override
  String toString() {
    return '{"notificationId":"$notificationId"'
        ',"notificationTitle":"${notificationTitle ?? ''}"}'
        ',"notificationMessage":"${notificationMessage ?? ''}"}'
        '}';
  }
}
