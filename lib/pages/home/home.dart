import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutor/pages/home/widgets/session_list.dart';

import '../../providers/user_provider.dart';
import '../create.dart';
import '../settings.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

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
                    return SessionList(
                        sessions: data.data ?? [], forCurrentUser: true);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16),
                  child: Text(
                    "Other Sessions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                FutureBuilder(
                  future: ref.read(userProvider.notifier).getAllOtherSessions(),
                  builder: (context, data) {
                    return SessionList(
                      sessions: (data.data != null)
                          ? data.data!
                              .where((element) =>
                                  element.session.isLecture ||
                                  (element.session.students.isEmpty))
                              .toList()
                          : [],
                      forCurrentUser: false,
                    );
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
