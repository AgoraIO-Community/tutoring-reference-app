import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutor/models/session.dart';

import '../models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  const LocalUser({required this.id, required this.user});

  final String id;
  final FirebaseUser user;

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(
          const LocalUser(
            id: "error",
            user: FirebaseUser(
                email: "error",
                name: "error",
                profilePic: "error",
                teacher: false,
                upcomingSessions: []),
          ),
        );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> login(String email) async {
    QuerySnapshot response = await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    if (response.docs.isEmpty) {
      print("No firestore user associated to authenticated email $email");
      return;
    }
    if (response.docs.length != 1) {
      print("More than one firestore user associate with email: $email");
      return;
    }
    state = LocalUser(
        id: response.docs[0].id,
        user: FirebaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));
  }

  Future<void> signUp(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(
              email: email,
              name: "No Name",
              profilePic: "http://www.gravatar.com/avatar/?d=mp",
              teacher: false,
              upcomingSessions: []).toMap(),
        );
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
        id: response.id,
        user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  Future<void> updateName(String name) async {
    await _firestore.collection("users").doc(state.id).update({'name': name});
    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  Future<void> updateTeacherStatus(bool teacherStatus) async {
    await _firestore
        .collection("users")
        .doc(state.id)
        .update({'teacher': teacherStatus});
    state = state.copyWith(user: state.user.copyWith(teacher: teacherStatus));
  }

  Future<void> updateImage(File image) async {
    Reference ref = _storage.ref().child("users").child(state.id);
    TaskSnapshot snapshot = await ref.putFile(image);
    String profilePicUrl = await snapshot.ref.getDownloadURL();

    await _firestore
        .collection("users")
        .doc(state.id)
        .update({'profilePic': profilePicUrl});
    state =
        state.copyWith(user: state.user.copyWith(profilePic: profilePicUrl));
  }

  void logout() {
    state = const LocalUser(
      id: "error",
      user: FirebaseUser(
          email: "error",
          name: "error",
          profilePic: "error",
          teacher: false,
          upcomingSessions: []),
    );
  }

  Future<void> scheduleSession(Session session) async {
    DocumentReference docRef =
        await _firestore.collection("sessions").add(session.toMap());
    await _firestore.collection("users").doc(state.id).update({
      'upcomingSessions': FieldValue.arrayUnion([docRef.id])
    });
    state = state.copyWith(
        user: state.user.copyWith(
            upcomingSessions: [...state.user.upcomingSessions, docRef.id]));
  }

  Future<void> joinSession(String sessionId) async {
    await _firestore.collection("users").doc(state.id).update({
      'upcomingSessions': FieldValue.arrayUnion([sessionId])
    });
    state = state.copyWith(
        user: state.user.copyWith(
            upcomingSessions: [...state.user.upcomingSessions, sessionId]));
  }

  Future<List<SessionWithId>> getUpcomingUserSessions() async {
    List<SessionWithId> sessions = [];
    for (String sessionId in state.user.upcomingSessions) {
      DocumentSnapshot snapshot =
          await _firestore.collection("sessions").doc(sessionId).get();
      sessions.add(SessionWithId(
          id: snapshot.id,
          session: Session.fromMap(snapshot.data() as Map<String, dynamic>)));
    }
    return sessions;
  }

  Future<Session> getSession(String sessionId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection("sessions").doc(sessionId).get();
    Session session = Session.fromMap(snapshot.data() as Map<String, dynamic>);
    return session;
  }

  Future<List<SessionWithId>> getAllOtherSessions() async {
    QuerySnapshot response = await _firestore.collection("sessions").get();
    List<SessionWithId> sessions = [];
    if (state.id == "error") return [];
    for (DocumentSnapshot snapshot in response.docs) {
      if (state.user.upcomingSessions.contains(snapshot.id)) continue;
      sessions.add(SessionWithId(
          id: snapshot.id,
          session: Session.fromMap(snapshot.data() as Map<String, dynamic>)));
    }
    return sessions;
  }
}
