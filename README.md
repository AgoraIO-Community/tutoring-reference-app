# Tutoring Reference Application

Reference app for a tutoring use case.

# Summary

Tutoring is a very popular sector for Flutter applications. On Apptopia it ranks as the \_\_\_\_ biggest market. Tutoring is a real time interaction that is either 1-1 or 1-many, and in this case Agora is well suited to provide a reliable solution to any tutoring application.

# Business Strategy

This reference app aims to provide a strong starting point for anybody looking to build a tutoring application. It will utilize the latest technologies so developers can take the code, have the foundation ready to go and are free to develop the fun part: which is building new features.

# Functional Requirements

| Req # | Use Case                | Feature Requirements                                                                                                                       |
| ----- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| 1     | 1-1 Video Call          | <ul><li>Join a Session</li><li>Leave a Session</li><li>Hear and see each other</li><li>Mute Microphone</li><li>Turn Video On/Off</li></ul> |
| 2     | Screen Share            | <ul><li>Toggle Screen Share</li><li>Choose which screen to share</li></ul>                                                                 |
| 3     | Schedule a Session      | <ul><li>Display available tutors with what they specialize in and their rating</li><li>Select Available time with chosen tutor</li></ul>   |
| 4     | Leave Feedback & Rating | <ul><li>Survey after tutoring session ends</li></ul>                                                                                       |

# Feature Specification

| Use Case                | Feature                      | Details                                                                                                    | Agora Tools        | External Tools |
| ----------------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------ | -------------- |
| 1-1 Video Call          | Join a Session               | Request permissions, create RTC Engine, join channel, publish and subscribe                                | RTC & Token Server |                |
|                         | Leave a Session              | Leave the channel                                                                                          | RTC                |                |
|                         | Hear and see each other      | Enable video before joining channel                                                                        | RTC                |                |
|                         | Mute Microphone              | Toggle microphone on engine, and show in UI                                                                | RTC                |                |
|                         | Turn Video On/Off            | Toggle video on engine and show in UI                                                                      | RTC                |                |
| Screen Share            | Toggle Screen Share          | Toggle screen share on engine, and update UI                                                               | RTC                |                |
|                         | Choose which screen to share | When screenshare gets toggled, show a UI of which screen user wants to share                               | RTC                |                |
| Schedule a Session      | Display Tutors               | Show a list of tutors stored in the database with what they specialize and their ratings                   |                    | Supabase       |
|                         | Select Time                  | Can click into the tutor, and see available times for a session                                            |                    | Supabase       |
| Leave Feedback & Rating | Post Call Survey             | After leaving the call, user sent to post call survey, which get's stored in the database for the teachers |                    | Supabase       |
