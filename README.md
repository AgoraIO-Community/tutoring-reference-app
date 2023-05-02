# Build your own Tutoring Application with Agora

This guide will walk you through building your own tutoring application. This will be a complete application including authentication, user management, payment, and tons of real time features.

- [Getting Started](#getting-started)
- [Overview](#overview)
- [File Structure](#file-structure)
- [Architecture Diagram](#architecture-diagram)
- [User Flow Diagram](#user-flow-diagram)
- [App Screens](#app-screens)
- [Agora Overview](#agora-overview)
- [Agora Features](#agora-features)
  - [Video Call](#video-call)
  - [Cloud Recording](#cloud-recording)
    - [Start Recording](#start-recording)
    - [Stop Recording](#stop-recording)
  - [View Recorded Lessons](#view-recorded-lessons)
  - [Real Time Transcription](#real-time-transcription)
    - [Start Transcribing](#start-transcribing)
    - [Custom Actions from Agora Events](#custom-actions-from-agora-events)
    - [Stop Transcription](#stop-transcription)
- [Other Key Features](#other-key-features)
  - [Apple Pay Integration](#apple-pay-integration)

## Getting Started
The tools we will be using for this are:

* Flutter
* Agora
* Firebase
* Riverpod
* Apple Pay with `pay` package
* Other Flutter Packages Including: `image_picker`, `video_player`b and `intl`
* Custom Backend built with Python & Flask

The code for the Flutter app can be found [here](https://github.com/tadaspetra/tutor) and the backend code can be found [here](https://github.com/tadaspetra/agora-server). In this blog we will talk about the general structure of the application, and I want to dive a little deeper on the Cloud Recording and Real Time Transcription feature. These are the parts 

## Overview
The `tutor` app will have users login or sign up using Firebase Auth, and have the state of the user managed updated and managed using Riverpod and Cloud Firestore. You can change the account between a teacher or student account using a toggle in the user settings. Both accounts have the ability to pay and join sessions, but the teacher account has a special ability to create sessions as well. 

Once the session is started, users 

## File Structure
```
lib
├── models
│   ├── recording
│   ├── session
│   └── user
├── pages
│   ├── home
│   ├── recordings
│   ├── class
│   ├── create
│   ├── settings
│   ├── signin
│   └── signup
├── protobuf
├── providers
│   └── user_provider
├── consts
└── main
```

## Architecture Diagram
![Architecture Diagram](assets/architecture.png)

## User Flow Diagram
![User Flow Diagram](assets/userflow.png)

## App Screens
<div>
<img src="assets/IMG_0419.PNG" width="200" />
<img src="assets/IMG_0420.PNG" width="200" />
</div>
Login and Sign Up Screens

<div>
<img src="assets/IMG_0418.PNG" width="200" />
<img src="assets/IMG_0423.PNG" width="200" />
</div>
Teacher vs Student Home Screen

<div>
<img src="assets/IMG_0421.PNG" width="200" />
<img src="assets/IMG_0422.PNG" width="200" />
</div>
Navigation and Setting Screen

<div>
<img src="assets/IMG_0426.PNG" width="200" />
<img src="assets/IMG_0427.PNG" width="200" />
</div>
Live Classroom Session

<div>
<img src="assets/IMG_0429.PNG" width="200" />
</div>
Apple Pay

<div>
<img src="assets/IMG_0432.PNG" width="200" />
<img src="assets/IMG_0431.PNG" width="200" />
</div>
Recordings

## Agora Overview
The main feature of the `tutor` app is the ability to have video call lessons between teacher and students. We will be using Agora for this. Agora is a real time communication platform that allows you to build video calls, voice calls, and live streaming into your application, and it can handle all the real time communication that will be needed for this application

## Agora Features
### Video Call
The video call is the most important part of the application, since this is where the video call is going to be happening. For this we used the `agora_uikit` package to build the video call screen. This package is a wrapper around the Agora SDK, and comes with a prebuilt UI so we don't need to define it all ourselves.

You will need an agora account to use this package. And you can create one at [console.agora.io](https://console.agora.io). Once you have an account, you will need to create a project and get the `App ID` for the project. This is needed in order to connect to the Agora SDK.

Make sure to add the [following permissions](https://pub.dev/packages/agora_uikit#device-permission) for both iOS and Android

To add the package run
```
flutter pub add agora_uikit
```

In order to have your video calls be secure, you will need to create a token server. And then we can link to it without our UI Kit. You can find more information about token servers [here](https://www.agora.io/en/blog/how-to-build-a-token-server-using-golang/).

Once all the set up is complete we can create a `class.dart` file, and add the following code to it
```dart
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class ClassCall extends StatefulWidget {
  const ClassCall({Key? key}) : super(key: key);

  @override
  State<ClassCall> createState() => _ClassCallState();
}

class _ClassCallState extends State<ClassCall> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "<--Add your App Id here-->",
      channelName: "test",
      username: "user",
      tokenUrl: "<--Add your token server url here-->",
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
    return Scaffold(
        appBar: AppBar(
            title: const Text('Classroom'),
        ),
        body: SafeArea(
            child: Stack(
            children: [
                AgoraVideoViewer(
                    client: client,
                    layoutType: Layout.floating,
                ),
                AgoraVideoButtons(
                    client: client,
                ),
            ],
            ),
        ),
    );
  }
}
```

I want to only allow users to leave this screen when they press the end call button. I don't want them to be able to swipe backwards, or have a back button in the app bar. To do this, I first removed the `AppBar()` widget, and added a the `onDisconnect` function to the `AgoraVideoButtons` widget. This function will be called when the end call button is pressed. Inside this function I just call `Navigator.pop(context)`. This will pop the current screen off the stack, and take the user back to the previous screen.

So that will allow the user to not see a back button at the top, and jump back when they press the end call button. However there are system back buttons. For both iOS and Android you can either press a system back button or swipe back. To remove this capablility we will use a `WillPopScope` widget. When we wrap it around our `Scaffold`, this widget will allow us to override the default behavior of the back button. And we can do this by returning a `Future<bool>` from the `onWillPop` function. If we return `true` then the back button will work as normal, and if we return `false` then the back button will not work. You can customize this to work under different conditions, but for our use case we will just set it to always return `false`.

### Cloud Recording
Cloud Recording is a feature where you can connect your own database and can record lessons in you app, which then saves a file within the database you connected. For this we will need to use Agora's RESTful API with our own backend service.

The reason for the backend service is for security reasons. We don't want to be storing our Agora customer key and secret on our actual application. This server was built with Python and Flask, and you can find the code [here](https://github.com/tadaspetra/agora-server). We will only cover the Agora API side of this server, but if you want to learn more about building a server from scratch with Flask I recommend [this video](https://www.youtube.com/watch?v=xeuW-IitQTQ).

There are two functions that we will implement on our backend server: `start-recording` and `stop-recording`.

#### Start Recording
Our `start-recording` endpoint will need a channel in order for our backend to know which channel this recording should be started on. Once it is started, we need to provide caller of the endpoint, the SID and the Resource ID, so that the caller knows exactly where this recording will be stored.

We cannot start the recording right away. The first step of cloud recording is to create a resource for cloud recording. And in order to create a resource we need a credential. In order to be able to generate a credential we need a Customer Key and Customer Secret. You can create these within the Agora Console.

![RESTful API](https://web-cdn.agora.io/docs-files/1637661003647)

```python
def generate_credential():
    # Generate encoded token based on customer key and secret
    credentials = CUSTOMER_KEY + ":" + CUSTOMER_SECRET

    base64_credentials = base64.b64encode(credentials.encode("utf8"))
    credential = base64_credentials.decode("utf8")
    return credential
```

Using our credential we then need to generate that resource using [`acquire`](https://documenter.getpostman.com/view/6319646/SVSLr9AM#6e47859b-5ab5-47b0-8095-5a3ec3dba54c). This method will return a Resource ID that corresponds to the resource that was created. We will use this to start our recording.

```python
def generate_resource(channel):

    payload = {
        "cname": channel,
        "uid": str(UID),
        "clientRequest": {}
    }

    headers = {}

    headers['Authorization'] = 'basic ' + credential

    headers['Content-Type'] = 'application/json'
    headers['Access-Control-Allow-Origin'] = '*'

    url = f"https://api.agora.io/v1/apps/{APP_ID}/cloud_recording/acquire"
    res = requests.post(url, headers=headers, data=json.dumps(payload))

    data = res.json()
    resourceId = data["resourceId"]

    return resourceId
```

Then we are ready to start the recording. You can find more details about all the configurations that you should set up [here](https://docs.agora.io/en/cloud-recording/reference/rest-api/start).

Here are some key features for our configuration

* We record in `mix` mode, so videos get combined into one file.
* We save this into an `agora` folder on AWS.
* We save an `mp4` file.

```python
def start_cloud_recording(channel):
    resource_id = generate_resource(channel)
    url = f"https://api.agora.io/v1/apps/{APP_ID}/cloud_recording/resourceid/{resource_id}/mode/mix/start"
    payload = {
        "cname": channel,
        "uid": str(UID),
        "clientRequest": {
            "token": TEMP_TOKEN,
            "recordingConfig": {
                "maxIdleTime": 3,
            },

            "storageConfig": {
                "secretKey": SECRET_KEY,
                "vendor": 1,  # 1 is for AWS
                "region": 1,
                "bucket": BUCKET_NAME,
                "accessKey": ACCESS_KEY,
                "fileNamePrefix": [
                    "agora",
                ]
            },

            "recordingFileConfig": {
                "avFileType": [
                    "hls",
                    "mp4"
                ]
            },
        },
    }

    headers = {}

    headers['Authorization'] = 'basic ' + credential

    headers['Content-Type'] = 'application/json'
    headers['Access-Control-Allow-Origin'] = '*'

    res = requests.post(url, headers=headers, data=json.dumps(payload))
    data = res.json()
    sid = data["sid"]

    return resource_id, sid
```

With the backend service, complete we can actually implement the cloud recording within our application. To do this we need to add our link to the `cloudRecordingUrl` argument within our `AgoraClient`, and set `cloudRecordingEnabled: true` on our `AgoraVideoButtons` widget.

#### Stop Recording
To stop the recording we need to implement another function on the backend. Nothing else needs to be done on the front end side, since that is taken care of by the UI Kit. We just need a working endpoint that follows the `/stop-recording/<--Channel Name-->/<--SID-->/<--Resource ID-->` format.

The key part here is we need to return the information to the end user, specifically the mp4 link.

```python
def stop_cloud_recording(channel, resource_id, sid):
    url = f"https://api.agora.io/v1/apps/{APP_ID}/cloud_recording/resourceid/{resource_id}/sid/{sid}/mode/mix/stop"

    headers = {}

    headers['Authorization'] = 'basic ' + credential

    headers['Content-Type'] = 'application/json;charset=utf-8'
    headers['Access-Control-Allow-Origin'] = '*'

    payload = {
        "cname": channel,
        "uid": str(UID),
        "clientRequest": {
        }
    }

    res = requests.post(url, headers=headers, data=json.dumps(payload))
    data = res.json()
    resource_id = data['resourceId']
    sid = data['sid']
    server_response = data['serverResponse']
    mp4_link = server_response['fileList'][0]['fileName']
    m3u8_link = server_response['fileList'][1]['fileName']

    formatted_data = {'resource_id': resource_id, 'sid': sid,
                      'server_response': server_response, 'mp4_link': mp4_link, 'm3u8_link': m3u8_link}

    return formatted_data
```

### View Recorded Lessons
In order to view the recordings at any moment after the video call, we need to store a link to where the file is located first. Our app was built with Firebase Authentication and Firestore storage, so it makes sense to store it in Firestore. 

To do this, there is a `cloudRecordingCallback` function on the `AgoraClient` which returns the mp4 link for us.

First we create a data class to hold all the information we need when it comes to the recording.

```dart
class Recording {
  final String url;
  final String sessionId;
  final String date;

  Recording({
    required this.url,
    required this.sessionId,
    required this.date,
  });
}
```

Then since our app is built around the `UserProvider`, we will set up a function in the `StateNotifier` to store the recording.

```dart
Future<void> storeRecording(Recording recording) {
  return _firestore
      .collection("users")
      .doc(state.id)
      .collection("recordings")
      .add(
        recording.toMap(),
      );
}
```

And lastly we can call this function within our `cloudRecordingCallback`.

```dart
ref.read(userProvider.notifier).storeRecording(
      Recording(
        url: mp4,
        sessionId: widget.sessionId,
        date:
            "${DateFormat.yMMMMd('en_US').format(DateTime.now())}\n${DateFormat("hh:mm a").format(DateTime.now())}",
      ),
    );
```

The way we display these recordings is by showing a list of all the recordings for the user, and they can click in on each recording to actually view the playback for it. To do that we will add another function to our user provider to retrieve all the data that's needed.

```dart
Future<List<Recording>> getRecordings() async {
  QuerySnapshot response = await _firestore
      .collection("users")
      .doc(state.id)
      .collection("recordings")
      .get();
  List<Recording> recordings = [];
  for (DocumentSnapshot snapshot in response.docs) {
    recordings
        .add(Recording.fromMap(snapshot.data() as Map<String, dynamic>));
  }
  return recordings;
}
```

Then display a list view of the recordings that can be accessed through the `Drawer` Widget. 

```dart
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
```

And then lastly using the `video_player` package display the video on a new screen.

```dart
class Recording extends StatefulWidget {
  final String url;
  const Recording({super.key, required this.url});

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      "https://agora-server.s3.us-east-2.amazonaws.com/${widget.url}",
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
```

### Real Time Transcription
Real Time Transcription follows a similar process as Cloud Recording. We will again need to use Agora's RESTful API with our own backend service.

The reason for the backend service is for security reasons. We don't want to be storing our Agora customer key and secret on our actual application. This server was built with Python and Flask, and you can find the code [here](https://github.com/tadaspetra/agora-server). We will only cover the Agora API side of this server, but if you want to learn more about building a server from scratch with Flask I recommend [this video](https://www.youtube.com/watch?v=xeuW-IitQTQ).

There are two functions that we will implement on our backend server: `start-transcribing` and `stop-transcribing`.

#### Start Transcribing
Our `start-transcribing` endpoint will need a channel in order for our backend to know which channel this transcription should be started on. Once it is started, we need to provide caller of the endpoint, the Task ID and the Builder Token, so that the caller knows exactly where this transcription will be stored.

We cannot start the transcribing right away. The first step of real time transcription is to create a resource for transcribing. And in order to create a resource we need a credential. In order to be able to generate a credential we need a Customer Key and Customer Secret. You can create these within the Agora Console.

![RESTful API](https://web-cdn.agora.io/docs-files/1637661003647)

```python
def generate_credential():
    # Generate encoded token based on customer key and secret
    credentials = CUSTOMER_KEY + ":" + CUSTOMER_SECRET

    base64_credentials = base64.b64encode(credentials.encode("utf8"))
    credential = base64_credentials.decode("utf8")
    return credential
```

Using our credential we then need to generate that resource using [`acquire`](https://documenter.getpostman.com/view/6319646/SVSLr9AM#89043c3d-ae8a-4180-a5f4-ede8de441fd4). This method will return a tokenName that corresponds to the resource that was created. We will use this to start our transcribing.

```python
def rtt_generate_resource(channel):

    payload = {
        "instanceId": channel,
    }

    headers = {}

    headers['Authorization'] = 'basic ' + credential

    headers['Content-Type'] = 'application/json'
    headers['Access-Control-Allow-Origin'] = '*'

    url = f"https://api.agora.io/v1/projects/{APP_ID}/rtsc/speech-to-text/builderTokens"
    res = requests.post(url, headers=headers, data=json.dumps(payload))

    data = res.json()
    tokenName = data["tokenName"]

    return tokenName
```

Then we are ready to start the transcribing. You can find more details about all the configurations that you should set up [here](https://documenter.getpostman.com/view/6319646/SVSLr9AM#92041cab-1f45-4ff3-83a5-601fa06a0427).

Here are some key features for our configuration

* We can transcribe in English and Spanish
* Store in a folder called rtt

```python
def start_transcription(channel):
    tokenName = rtt_generate_resource(channel)
    url = f"https://api.agora.io/v1/projects/{APP_ID}/rtsc/speech-to-text/tasks?builderToken={tokenName}"
    payload = {
        "audio": {
            "subscribeSource": "AGORARTC",
            "agoraRtcConfig": {
                "channelName": channel,
                "uid": "101",
                "token": "{{channelToken}}",
                "channelType": "LIVE_TYPE",
                "subscribeConfig": {
                    "subscribeMode": "CHANNEL_MODE"
                },
                "maxIdleTime": 60
            }
        },
        "config": {
            "features": [
                "RECOGNIZE"
            ],
            "recognizeConfig": {
                "language": "en-US,es-ES",
                "model": "Model",
                "output": {
                    "destinations": [
                        "AgoraRTCDataStream",
                        "Storage"
                    ],
                    "agoraRTCDataStream": {
                        "channelName": channel,
                        "uid": "101",
                        "token": "{{channelToken}}"
                    },
                    "cloudStorage": [
                        {
                            "format": "HLS",
                            "storageConfig": {
                                "accessKey": ACCESS_KEY,
                                "secretKey": SECRET_KEY,
                                "bucket": BUCKET_NAME,
                                "vendor": 1,
                                "region": 1,
                                "fileNamePrefix": [
                                    "rtt"
                                ]
                            }
                        }
                    ]
                }
            }
        }
    }

    headers = {}

    headers['Authorization'] = 'basic ' + credential

    headers['Content-Type'] = 'application/json'

    res = requests.post(url, headers=headers, data=json.dumps(payload))
    data = res.json()
    taskID = data["taskId"]

    return taskID, tokenName
```

To start this process we will add this call to the `initState` of our `StatefulWidget`.

```dart
 final response = await http.post(
  Uri.parse(
      'https://agora-server-hr4b.onrender.com/start-transcribing/main'),
);
taskId = jsonDecode(response.body)['taskId'];
builderToken = jsonDecode(response.body)['builderToken'];
```
#### Custom Actions from Agora Events
But this doesn't actually show anything within our application. In order to do that we need to set up a [Protobuf for our project](https://protobuf.dev/getting-started/darttutorial/). 

Here is a template for Agora's Real Time Transcription
```
syntax = "proto3";

package agora.audio2text;
option java_package = "io.agora.rtc.audio2text";
option java_outer_classname = "Audio2TextProtobuffer";

message Text {
  int32 vendor = 1;
  int32 version = 2;
  int32 seqnum = 3;
  int32 uid = 4;
  int32 flag = 5;
  int64 time = 6;
  int32 lang = 7;
  int32 starttime = 8;
  int32 offtime = 9;
  repeated Word words = 10;
}
message Word {
  string text = 1;
  int32 start_ms = 2;
  int32 duration_ms = 3;
  bool is_final = 4;
  double confidence = 5;
}
```

Once the protobuf is set up, we retrieve the transcribed message from the `onStreamMessage` callback. We can take this message, run it through our protobuf, and add the text into a list.

```dart
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
)
```

Then add this view on top of our stack, and we can see the transcription happening live.

```dart
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
```

#### Stop Transcription
The last step is to stop the transcription after the call is complete. We need a working endpoint that follows the `/stop-transcribing/<--Channel Name-->/<--Task ID-->/<--Builder Token-->` format.

```python
def stop_transcription(task_id, builder_token):
    url = f"https://api.agora.io/v1/projects/{APP_ID}/rtsc/speech-to-text/tasks/{task_id}?builderToken={builder_token}"

    headers = {}

    headers['Authorization'] = 'basic ' + credential

    headers['Content-Type'] = 'application/json'

    payload = {}

    res = requests.delete(url, headers=headers, data=payload)
    data = res.json()
    return data
```

Then we call that endpoint from our Flutter application whenever the endCall button is pressed, and our Real Time Transcription will be  complete.
```dart
http.get(Uri.parse(
  'https://agora-server-hr4b.onrender.com/stop-transcribing/$taskId/$builderToken'));
```

## Other Key Features

### Apple Pay Integration

In order to have Apple Pay on your app, you need to be a valid merchant, and have that merchant ID connected to your application. You can find more information about that on this[Apple Pay Guide](https://www.hungrimind.com/flutter/apple_pay).

Once you have all that setup, on the `onPaymentResult` argument within the Apple Pay button, we will execute a `joinSession` function defined in our user provider. This function will add it to the current student's upcoming sessions list, as well as add that student's ID to the class's student list.

```dart
Future<void> joinSession(String sessionId, bool isLecture) async {
  await _firestore.collection("users").doc(state.id).update({
    'upcomingSessions': FieldValue.arrayUnion([sessionId])
  });

  if (!isLecture) {
    await _firestore.collection("sessions").doc(sessionId).update({
      'students': FieldValue.arrayUnion([state.id])
    });
  }
  state = state.copyWith(
      user: state.user.copyWith(
          upcomingSessions: [...state.user.upcomingSessions, sessionId]));
}
```