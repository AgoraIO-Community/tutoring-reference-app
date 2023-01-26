import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tutor/models/session.dart';

class FirebaseUser {
  final String email;
  final String name;
  final String profilePic;
  final List<Session> upcomingSessions;

  const FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.upcomingSessions,
  });

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePic,
    List<Session>? upcomingSessions,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      upcomingSessions: upcomingSessions ?? this.upcomingSessions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'upcomingSessions': upcomingSessions.map((x) => x.toMap()).toList(),
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    List<Session> convertMaptoList(Map<String, dynamic> map) {
      List<Session> list = [];

      map.forEach((key, value) {
        list.add(Session.fromMap(value));
      });
      return list;
    }

    return FirebaseUser(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      upcomingSessions: List<Session>.from(map['upcomingSessions']?.map((x) {
            return Session.fromMap(x);
          }) ??
          []),
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUser.fromJson(String source) =>
      FirebaseUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FirebaseUser(email: $email, name: $name, profilePic: $profilePic, upcomingSessions: $upcomingSessions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirebaseUser &&
        other.email == email &&
        other.name == name &&
        other.profilePic == profilePic &&
        listEquals(other.upcomingSessions, upcomingSessions);
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        upcomingSessions.hashCode;
  }
}
