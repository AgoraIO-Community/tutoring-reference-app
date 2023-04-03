# Build your own Tutoring Application

This guide will walk you through building your own tutoring application. Some key features it includes are:
* Authentication
* Modifying your profile
* Creating 1 on 1 sessions or general lectures
* Paying for access to a session
* Ability to record the sessions
* Real Time Transcription 

The tools we will be using for this are:
* Flutter
* Agora
* Firebase
* Riverpod
* Apple Pay
* Other Flutter Packages Including: `image_picker` and `intl`
* Backend built with Python & Flask

The code for the Flutter app can be found [here](https://github.com/tadaspetra/tutor) and the backend code can be found [here](https://github.com/tadaspetra/agora-server). In this blog we will talk about the general structure of the application, and I want to dive a little deeper on the Cloud Recording and Real Time Transcription feature. These are the parts 