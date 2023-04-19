# Build your own Tutoring Application
This guide will walk you through building your own tutoring application. This will be a complete application including authentication, user management, payment, and tons of real time features.

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
│   ├── recording.dart
│   ├── session.dart
│   └── user.dart
├── pages
│   ├── home
│       ├── home.dart
│       └── session_list.dart
│   ├── recordings
│       ├── recording.dart
│       └── recording_list.dart
│   ├── class.dart
│   ├── create.dart
│   ├── settings.dart
│   ├── signin.dart
│   └── signup.dart
├── protobuf
├── providers
│   └── user_provider.dart
├── consts.dart
├── main.dart
└── stt.proto
```

## Architecture Diagram

## User Flow Diagram
![Structure Diagram](diagram.png)

## Agora Overview

## Agora Features

### Video Call

### Cloud Recording

### View Recorded Lessons

### Real Time Transcription

### Custom Actions from Agora Events

## Other Key Features

### Apple Pay Integration