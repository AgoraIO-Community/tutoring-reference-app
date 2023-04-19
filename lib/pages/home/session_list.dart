import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';

import '../../consts.dart';
import '../../models/session.dart';
import '../../providers/user_provider.dart';
import '../class.dart';

class SessionList extends ConsumerWidget {
  final List<SessionWithId> sessions;
  final bool forCurrentUser;
  const SessionList(
      {required this.sessions, required this.forCurrentUser, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    // ListView sessionList(List<SessionWithId> sessions,
    //     {required bool forCurrentUser}) {
    if (sessions.isEmpty) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20.0, left: 16, right: 16),
            child: forCurrentUser
                ? const Text(
                    "No upcoming sessions, join one of the sessions below",
                  )
                : const Text(
                    "No other sessions available, please wait for a teacher to create a session",
                  ),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: sessions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      sessions[index].session.teacherPic,
                    ),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                  const SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessions[index].session.className,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Taught by: ",
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: sessions[index].session.teacherName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  Chip(
                    labelStyle: const TextStyle(fontSize: 12),
                    label: Text(sessions[index].session.subject),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  (sessions[index].session.isLecture)
                      ? Chip(
                          labelStyle: const TextStyle(fontSize: 12),
                          label: const Text("Lecture"),
                          backgroundColor: Colors.green.shade100,
                        )
                      : Chip(
                          labelStyle: const TextStyle(fontSize: 12),
                          label: const Text("1-1 session"),
                          backgroundColor: Colors.blue.shade100,
                        ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("When: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${DateFormat.yMMMMd('en_US').format(sessions[index].session.time)}\n${DateFormat("hh:mm a").format(sessions[index].session.time)}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (forCurrentUser)
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 8)),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.lightGreen.shade400),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Text("Join "),
                          Icon(Icons.phone),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            // use `upcomingSessions` instead of `sessions` to get the clubId
                            //the `sessions` doesn't hold the clubId
                            return ClassCall(
                              sessionId: sessions[index].id,
                              username: currentUser.user.name,
                            );
                          }),
                        );
                      },
                    )
                  else
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black,
                          ),
                          height: 40,
                          width: 110,
                          margin: const EdgeInsets.only(top: 15),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: ApplePayButton(
                            paymentConfiguration:
                                PaymentConfiguration.fromJsonString(
                                    defaultApplePay),
                            paymentItems: const [
                              PaymentItem(
                                label: 'Total',
                                amount: '0.01',
                                status: PaymentItemStatus.final_price,
                              )
                            ],
                            style: ApplePayButtonStyle.black,
                            type: ApplePayButtonType.book,
                            margin: const EdgeInsets.only(top: 15.0),
                            onPaymentResult: (result) {
                              ref.read(userProvider.notifier).joinSession(
                                    sessions[index].id,
                                    sessions[index].session.isLecture,
                                  );
                            },
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
