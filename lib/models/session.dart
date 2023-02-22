import 'dart:convert';

import 'package:flutter/foundation.dart';

class SessionWithId {
  final String id;
  final Session session;
  SessionWithId({
    required this.id,
    required this.session,
  });

  SessionWithId copyWith({
    String? id,
    Session? session,
  }) {
    return SessionWithId(
      id: id ?? this.id,
      session: session ?? this.session,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session': session.toMap(),
    };
  }

  factory SessionWithId.fromMap(Map<String, dynamic> map) {
    return SessionWithId(
      id: map['id'] ?? '',
      session: Session.fromMap(map['session']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionWithId.fromJson(String source) =>
      SessionWithId.fromMap(json.decode(source));

  @override
  String toString() => 'SessionWithId(id: $id, session: $session)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SessionWithId && other.id == id && other.session == session;
  }

  @override
  int get hashCode => id.hashCode ^ session.hashCode;
}

class Session {
  final bool isLecture;
  final String teacherName;
  final String teacherPic;
  final List<String> students;
  final String subject;
  final String className;
  final DateTime time;

  Session({
    required this.isLecture,
    required this.teacherName,
    required this.teacherPic,
    required this.students,
    required this.subject,
    required this.className,
    required this.time,
  });

  Session copyWith({
    bool? isLecture,
    String? teacherName,
    String? teacherPic,
    List<String>? students,
    String? subject,
    String? className,
    DateTime? time,
  }) {
    return Session(
      isLecture: isLecture ?? this.isLecture,
      teacherName: teacherName ?? this.teacherName,
      teacherPic: teacherPic ?? this.teacherPic,
      students: students ?? this.students,
      subject: subject ?? this.subject,
      className: className ?? this.className,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLecture': isLecture,
      'teacherName': teacherName,
      'teacherPic': teacherPic,
      'students': students,
      'subject': subject,
      'className': className,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      isLecture: map['isLecture'] ?? false,
      teacherName: map['teacherName'] ?? '',
      teacherPic: map['teacherPic'] ?? '',
      students: List<String>.from(map['students'] ?? []),
      subject: map['subject'] ?? '',
      className: map['className'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Session(isLecture: $isLecture, teacherName: $teacherName, teacherPic: $teacherPic, students: $students, subject: $subject, className: $className, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Session &&
        other.isLecture == isLecture &&
        other.teacherName == teacherName &&
        other.teacherPic == teacherPic &&
        listEquals(other.students, students) &&
        other.subject == subject &&
        other.className == className &&
        other.time == time;
  }

  @override
  int get hashCode {
    return isLecture.hashCode ^
        teacherName.hashCode ^
        teacherPic.hashCode ^
        students.hashCode ^
        subject.hashCode ^
        className.hashCode ^
        time.hashCode;
  }
}
