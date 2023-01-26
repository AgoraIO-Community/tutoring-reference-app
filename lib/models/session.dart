import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String teacherName;
  final String teacherPic;
  final String? student;
  final String subject;
  final DateTime time;

  Session({
    required this.teacherName,
    required this.teacherPic,
    this.student,
    required this.subject,
    required this.time,
  });

  Session copyWith({
    String? teacherName,
    String? teacherPic,
    String? student,
    String? subject,
    DateTime? time,
  }) {
    return Session(
      teacherName: teacherName ?? this.teacherName,
      teacherPic: teacherPic ?? this.teacherPic,
      student: student ?? this.student,
      subject: subject ?? this.subject,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherName': teacherName,
      'teacherPic': teacherPic,
      'student': student,
      'subject': subject,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      teacherName: map['teacherName'] ?? '',
      teacherPic: map['teacherPic'] ?? '',
      student: map['student'],
      subject: map['subject'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(
          (map['time'] as Timestamp).millisecondsSinceEpoch),
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Session(teacherName: $teacherName, teacherPic: $teacherPic, student: $student, subject: $subject, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Session &&
        other.teacherName == teacherName &&
        other.teacherPic == teacherPic &&
        other.student == student &&
        other.subject == subject &&
        other.time == time;
  }

  @override
  int get hashCode {
    return teacherName.hashCode ^
        teacherPic.hashCode ^
        student.hashCode ^
        subject.hashCode ^
        time.hashCode;
  }
}
