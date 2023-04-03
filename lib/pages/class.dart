import 'dart:convert';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tutor/providers/user_provider.dart';

import '../consts.dart';
import '../protobuf/stt.pb.dart' as protoText;

class ClassCall extends ConsumerStatefulWidget {
  final String sessionId;
  final String username;
  const ClassCall({Key? key, required this.sessionId, required this.username})
      : super(key: key);

  @override
  ConsumerState<ClassCall> createState() => _ClassCallState();
}

class _ClassCallState extends ConsumerState<ClassCall> {
  String? taskId;
  String? builderToken;
  List<String> conversation = [];
  late AgoraClient client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: appId,
        channelName: "main",
        username: "tadas",
        tokenUrl: tokenUrl,
        cloudRecordingUrl: cloudRecordingUrl,

        // screenSharingEnabled: true,
      ),
      agoraEventHandlers: AgoraRtcEventHandlers(
        onStreamMessage:
            (connection, remoteUid, streamId, data, length, sentTs) {
          protoText.Text sttText = protoText.Text.fromBuffer(data);
          if (sttText.words.isNotEmpty) {
            sttText.words.last.isFinal
                ? updateConversation(sttText.words.last.text)
                : null;
          }
        },
        onStreamMessageError:
            (connection, remoteUid, streamId, code, missed, cached) {
          print("error $code");
        },
      ));

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
    final response = await http.post(
      Uri.parse('https://agora-server-hr4b.onrender.com/start-transcribe'),
    );

    taskId = jsonDecode(response.body)['data']['taskId'];
    builderToken = jsonDecode(response.body)['builderToken'];
    print("STT -- TASK ID: $taskId --- BUILDER TOKEN: $builderToken");
  }

  void updateConversation(String text) {
    print("STT -- FINAL TEXT: $text");
    setState(() {
      conversation.add(text);
      if (conversation.length > 7) _scrollDown();
    });
  }

  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.jumpTo(
      _controller.position.maxScrollExtent + 50,
    );
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
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0, top: 200),
                child: ListView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        conversation[index],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  itemCount: conversation.length,
                ),
              ),
              AgoraVideoButtons(
                client: client,
                onDisconnect: () {
                  http.delete(
                    Uri.parse(
                        'https://agora-server-hr4b.onrender.com/stop-transcribe/$taskId/$builderToken'),
                  );
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
