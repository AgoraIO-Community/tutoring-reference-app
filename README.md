# Tutoring Reference Application

Reference app for a math tutoring use case.

# Summary

Tutoring is a very popular sector for Flutter applications. Tutoring is a real time interaction that is either 1-1 or 1-many, and in this case Agora is well suited to provide a reliable solution to any tutoring application. This reference app will be targeted at a Mathematics specific use case.

# Business Strategy

This reference app aims to provide a strong starting point for anybody looking to build a tutoring application. It will utilize the latest technologies so developers can take the code, have the foundation ready to go and are free to develop the fun part: which is building new features.

# Target Users

**Math Teachers -** Will use this application to host live interactive 1-1 classes, or larger lectures. They will also be able to make an income from this application as each student has to pay to attend.
**Student -** With an option for personal tutoring sessions or bigger live sessions, students can use this app to get help and dive deeper into the topics they are trying to learn.

# Tech Spec

- Built with Flutter 3.7
- Target Devices: Android, iOS
- Minimum Versions
  - Android SDK 32
  - iOS 16.0

# Structure Diagram

![Structure Diagram](diagram.png)

# Functional Requirements

| Req # | Use Case                | Feature Requirements                                                                                                                                                                                             |
| ----- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1     | 1-1 Video Call          | <ul><li>Join a Session</li><li>Leave a Session</li><li>Hear and see each other</li><li>Mute Microphone</li><li>Turn Video On/Off</li></ul>                                                                       |
| 2     | Lecture Group Call      | <ul><li>Join a Session</li><li>Leave a Session</li><li>Hear and see each other</li><li>Mute Microphone</li><li>Turn Video On/Off</li><li>Mute every participant</li><li>Participant count</li><li>Chat</li></ul> |
| 3     | Lesson Recordings       | <ul><li>Record lesson</li><li>View recorded lesson</li></ul>                                                                                                                                                     |
| 4     | Interactive Whiteboard  | <ul><li>Transfer either 1-1 or groupcall into a whiteboard session</li></ul>                                                                                                                                     |
| 5     | Screen Share            | <ul><li>Toggle Screen Share</li><li>Choose which screen/window to share</li></ul>                                                                                                                                |
| 6     | Schedule a Session      | <ul><li>Display available tutors with what they specialize in and their rating</li><li>Select Available time with chosen tutor</li><li>Pay for the session</li><li>As a tutor, create session</li></ul>          |
| 7     | Leave Feedback & Rating | <ul><li>Survey after tutoring session ends</li></ul>                                                                                                                                                             |

# Feature Specification

| Use Case                | Feature                      | Details                                                                                                    | Agora Tools        | External Tools       |
| ----------------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------ | -------------------- |
| 1-1 Video Call          | Join a Session               | Request permissions, create RTC Engine, join channel, publish and subscribe                                | RTC & Token Server |                      |
|                         | Leave a Session              | Leave the channel                                                                                          | RTC                |                      |
|                         | Hear and see each other      | Enable video before joining channel                                                                        | RTC                |                      |
|                         | Mute Microphone              | Toggle microphone on engine, and show in UI                                                                | RTC                |                      |
|                         | Turn Video On/Off            | Toggle video on engine and show in UI                                                                      | RTC                |                      |
| Lecture Group Call      | Join a Session               | Request permissions, create RTC Engine, join channel, publish and subscribe                                | RTC & Token Server |                      |
|                         | Leave a Session              | Leave the channel                                                                                          | RTC                |                      |
|                         | Hear and see each other      | Enable video before joining channel                                                                        | RTC                |                      |
|                         | Mute Microphone              | Toggle microphone on engine, and show in UI                                                                | RTC                |                      |
|                         | Turn Video On/Off            | Toggle video on engine and show in UI                                                                      | RTC                |                      |
|                         | Mute every participant       | Instructor has the ability to mute everybody so they don't interrupt                                       | RTC                |                      |
|                         | Participant count            | Small counter showing how many students have joined, so instructor knows when they can start               | RTC                |                      |
|                         | Chat                         | In call chat, that can be toggled on and off                                                               | Agora Chat         |                      |
| Lesson Recording        | Record Lesson                | Save a recording of the lesson to a dabase                                                                 | Cloud Recording    | AWS                  |
|                         | View Recorded Lesson         | Retrieve lesson, and show only to users who have paid for that session                                     |                    | AWS                  |
| Interactive Whiteboard  | Whiteboard Session           | Transfer either 1-1 or groupcall into a whiteboard session                                                 | Whiteboard         |                      |
| Screen Share            | Toggle Screen Share          | Toggle screen share on engine, and update UI                                                               | RTC                |                      |
|                         | Choose which screen to share | When screenshare gets toggled, show a UI of which screen user wants to share                               | RTC                |                      |
| Schedule a Session      | Display Tutors               | Show a list of tutors stored in the database with what they specialize and their ratings                   |                    | Supabase             |
|                         | Select Time                  | Can click into the tutor, and see available times for a session                                            |                    | Supabase             |
|                         | Pay for session              | Before students can join the session they have to pay using Stripe                                         |                    | GooglePay + ApplePay |
|                         | Create Session               | Tutors can create sessions that students can pay for and join                                              |                    | Supabase             |
| Leave Feedback & Rating | Post Call Survey             | After leaving the call, user sent to post call survey, which get's stored in the database for the teachers |                    | Supabase             |
