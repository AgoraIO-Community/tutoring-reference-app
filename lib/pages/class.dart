import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutor/providers/user_provider.dart';

import '../consts.dart';

class ClassCall extends ConsumerStatefulWidget {
  final String sessionId;
  final String username;
  const ClassCall({Key? key, required this.sessionId, required this.username})
      : super(key: key);

  @override
  ConsumerState<ClassCall> createState() => _ClassCallState();
}

class _ClassCallState extends ConsumerState<ClassCall> {
  AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: "test",
      username: "tadas",
      tokenUrl: tokenUrl,
      cloudRecordingUrl: cloudRecordingUrl,
      // screenSharingEnabled: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora VideoUIKit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                client: client,
                onDisconnect: () {
                  ref
                      .read(userProvider.notifier)
                      .checkToRemoveSession(widget.sessionId);
                  Navigator.pop(context);
                },
                cloudRecordingEnabled: true,
                // addScreenSharing: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
