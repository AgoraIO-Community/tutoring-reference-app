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
  - [View Recorded Lessons](#view-recorded-lessons)
  - [Real Time Transcription](#real-time-transcription)
  - [Custom Actions from Agora Events](#custom-actions-from-agora-events)
- [Other Key Features](#other-key-features)
  - [Apple Pay Integration](#apple-pay-integration)

## Getting Started
The tools we will be using for this are:

* Flutter
* Agora
* Firebase
* Riverpod
* Apple Pay with `pay` package
* Other Flutter Packages Including: `image_picker` and `intl`
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
<img src="assets/IMG_0419.png" width="200" />
<img src="assets/IMG_0420.png" width="200" />
</div>
Login and Sign Up Screens

<div>
<img src="assets/IMG_0418.png" width="200" />
<img src="assets/IMG_0423.png" width="200" />
</div>
Teacher vs Student Home Screen

<div>
<img src="assets/IMG_0421.png" width="200" />
<img src="assets/IMG_0422.png" width="200" />
</div>
Navigation and Setting Screen

<div>
<img src="assets/IMG_0426.png" width="200" />
<img src="assets/IMG_0427.png" width="200" />
</div>
Live Classroom Session

<div>
<img src="assets/IMG_0429.png" width="200" />
</div>
Apple Pay

<div>
<img src="assets/IMG_0432.png" width="200" />
<img src="assets/IMG_0431.png" width="200" />
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

### View Recorded Lessons

### Real Time Transcription

### Custom Actions from Agora Events

## Other Key Features

### Apple Pay Integration