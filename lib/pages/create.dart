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
  final TextEditingController className = TextEditingController();
  String subject = "Math";

  DateTime totalDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final GlobalKey<FormState> _classKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Session"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
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
                  const Text("Select Subject:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 20),
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Date and Time:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${DateFormat.yMMMMd('en_US').format(totalDate)} \n${DateFormat.jm().format(totalDate)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              ) ??
                              DateTime.now();
                          totalDate = totalDate.copyWith(
                            year: selectedDate.year,
                            month: selectedDate.month,
                            day: selectedDate.day,
                          );
                          setState(() {});
                        },
                        child: const Text("Change Date"),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () async {
                          selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ) ??
                              TimeOfDay.now();
                          totalDate = totalDate.copyWith(
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
                    className: className.text,
                    subject: subject,
                    time: totalDate,
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
