import 'package:cloud_firestore/cloud_firestore.dart';

class AnswersModel {
  DateTime? date;
  String? childId;
  Map<String, dynamic>? answers;

  AnswersModel({
    this.childId,
    this.answers,
    this.date,
  });

  factory AnswersModel.fromJson(Map<String, dynamic> json) {
    return AnswersModel(
      childId: json['childId'] as String?,
      answers: json['answers'] != null
          ? Map<String, dynamic>.from(json['answers'])
          : null,
      date: _parseDate(json['date']),
    );
  }

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is String) {
      return DateTime.parse(date);
    } else if (date is Timestamp) {
      return date.toDate();
    }
    throw FormatException('Invalid date format');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['childId'] = childId;
    if (answers != null) {
      data['answers'] = answers;
    }
    if (date != null) {
      data['date'] = date!.toIso8601String();
    }
    return data;
  }
}