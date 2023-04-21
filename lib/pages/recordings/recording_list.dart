import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutor/pages/recordings/recording.dart';
import 'package:tutor/providers/user_provider.dart';

class RecordingList extends ConsumerWidget {
  const RecordingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordings'),
      ),
      body: FutureBuilder(
          future: ref.watch(userProvider.notifier).getRecordings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].url),
                    subtitle: Text(snapshot.data![index].date),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Recording(
                            url: snapshot.data![index].url,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
