import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutor/models/session.dart';
import 'package:tutor/providers/user_provider.dart';

class CreateSession extends ConsumerStatefulWidget {
  const CreateSession({super.key});

  @override
  ConsumerState<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends ConsumerState<CreateSession> {
  bool value = false;
  final TextEditingController className = TextEditingController();
  String subject = "Math";

  DateTime lectureDate = DateTime.now();

  final GlobalKey<FormState> _classKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Session"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Form(
          key: _classKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Enter a class name" : null,
                controller: className,
                decoration: const InputDecoration(
                  hintText: "Class Name",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: value ? 14 : 16,
                      fontWeight: value ? FontWeight.normal : FontWeight.bold,
                      color: Colors.black,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: const Text("Lecture"),
                  ),
                  Switch(
                    value: value,
                    onChanged: (changedValue) {
                      setState(() {
                        value = changedValue;
                      });
                    },
                  ),
                  AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: value ? 16 : 14,
                      fontWeight: value ? FontWeight.bold : FontWeight.normal,
                      color: Colors.black,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: const Text("1-1"),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: subject,
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: "Math",
                        child: Text("Math"),
                      ),
                      DropdownMenuItem<String>(
                        value: "Science",
                        child: Text("Science"),
                      ),
                      DropdownMenuItem<String>(
                        value: "English",
                        child: Text("English"),
                      ),
                      DropdownMenuItem<String>(
                        value: "History",
                        child: Text("History"),
                      ),
                      DropdownMenuItem<String>(
                        value: "Computer Science",
                        child: Text("Computer Science"),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        subject = value!;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Date and Time:",
                style: TextStyle(fontSize: 16),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${DateFormat.yMMMMd('en_US').format(lectureDate)}    ${DateFormat.jm().format(lectureDate)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          DateTime selectedDate = DateTime.now();
                          selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              ) ??
                              DateTime.now();
                          lectureDate = lectureDate.copyWith(
                            year: selectedDate.year,
                            month: selectedDate.month,
                            day: selectedDate.day,
                          );
                          setState(() {});
                        },
                        child: const Text("Change Date"),
                      ),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay selectedTime = TimeOfDay.now();
                          selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ) ??
                              TimeOfDay.now();
                          lectureDate = lectureDate.copyWith(
                            hour: selectedTime.hour,
                            minute: selectedTime.minute,
                          );
                          setState(() {});
                        },
                        child: const Text("Change Time"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_classKey.currentState!.validate()) {
            //submit info
            ref.read(userProvider.notifier).scheduleSession(
                  Session(
                    isLecture: value,
                    className: className.text,
                    subject: subject,
                    students: [],
                    time: lectureDate,
                    teacherName: currentUser.user.name,
                    teacherPic: currentUser.user.profilePic,
                  ),
                );
            Navigator.pop(context);
          }
        },
        label: const Text("Create Session"),
      ),
    );
  }
}
