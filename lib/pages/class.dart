import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import '../consts.dart';

class ClassCall extends StatefulWidget {
  final String sessionId;
  final String username;
  const ClassCall({Key? key, required this.sessionId, required this.username})
      : super(key: key);

  @override
  State<ClassCall> createState() => _ClassCallState();
}

class _ClassCallState extends State<ClassCall> {
  AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: "test",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
