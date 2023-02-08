import 'dart:convert';

import 'package:flutter/foundation.dart';

class FirebaseUser {
  final String email;
  final String name;
  final String profilePic;
  final bool teacher;
  final List<String> upcomingSessions;

  const FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.teacher,
    required this.upcomingSessions,
  });

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePic,
    bool? teacher,
    List<String>? upcomingSessions,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      teacher: teacher ?? this.teacher,
      upcomingSessions: upcomingSessions ?? this.upcomingSessions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'teacher': teacher,
      'upcomingSessions': upcomingSessions,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      teacher: map['teacher'] ?? false,
      upcomingSessions: List<String>.from(map['upcomingSessions'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUser.fromJson(String source) =>
      FirebaseUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FirebaseUser(email: $email, name: $name, profilePic: $profilePic, teacher: $teacher, upcomingSessions: $upcomingSessions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirebaseUser &&
        other.email == email &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.teacher == teacher &&
        listEquals(other.upcomingSessions, upcomingSessions);
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        teacher.hashCode ^
        upcomingSessions.hashCode;
  }
}
