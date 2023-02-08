import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session.dart';
import '../providers/user_provider.dart';
import 'create.dart';
import 'settings.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    ListView sessionList(List<Session> sessions,
        {required bool forCurrentUser}) {
      if (sessions.isEmpty) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 16, right: 16),
              child: forCurrentUser
                  ? const Text(
                      "No upcoming sessions, schedule a session using the button below",
                    )
                  : const Text(
                      "No other sessions available, please wait for a teacher to create a session",
                    ),
            ),
          ],
        );
      }
      return ListView.builder(
        itemCount: sessions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    sessions[index].teacherPic,
                  ),
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sessions[index].teacherName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      sessions[index].subject,
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/tutor.png",
          height: 25,
          color: Colors.black,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: Builder(builder: (context) {
              return GestureDetector(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      currentUser.user.profilePic,
                    ),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Image.network(
              currentUser.user.profilePic,
            ),
            ListTile(
              title: Text(
                "Hello, ${currentUser.user.name}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
            ),
            ListTile(
              title: const Text("Sign Out"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
              },
            )
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16),
                  child: Text(
                    "Your Upcoming Sessions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                FutureBuilder(
                  future:
                      ref.read(userProvider.notifier).getUpcomingUserSessions(),
                  builder: (context, data) {
                    return sessionList(data.data ?? [], forCurrentUser: true);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16),
                  child: Text(
                    "All Sessions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                FutureBuilder(
                  future: ref.read(userProvider.notifier).getAllOtherSessions(),
                  builder: (context, data) {
                    return sessionList(data.data ?? [], forCurrentUser: false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: currentUser.user.teacher
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const CreateSession();
                }));
              },
              label: const Text("Schedule Session"),
            )
          : Container(),
    );
  }
}
