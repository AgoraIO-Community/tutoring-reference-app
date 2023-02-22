import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/user_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text("Settings")),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? pickedImage = await picker.pickImage(
                            source: ImageSource.gallery,
                            requestFullMetadata: false);

                        if (pickedImage != null) {
                          ref
                              .read(userProvider.notifier)
                              .updateImage(File(pickedImage.path));
                        }
                      },
                      child: CircleAvatar(
                        radius: 100,
                        foregroundImage:
                            NetworkImage(currentUser.user.profilePic),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text("Tap Image to Change"),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Enter Your Name"),
                        controller: _nameController,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(userProvider.notifier)
                            .updateName(_nameController.text);
                      },
                      child: const Text("Update"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentUser.user.teacher
                            ? const Text(
                                "Toggle to change to a student account")
                            : const Text(
                                "Toggle to change to a teacher account"),
                        Switch(
                          value: currentUser.user.teacher,
                          onChanged: (newValue) {
                            ref
                                .read(userProvider.notifier)
                                .updateTeacherStatus(newValue);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
