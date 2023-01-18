import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class Notificationdetails {
  final String text, date, time;
  final bool read;
  final Icon icon;

  Notificationdetails({
    required this.date,
    required this.time,
    required this.text,
    required this.read,
    required this.icon,
  });
}

List<Notificationdetails> notificationdetails = [
  Notificationdetails(
      date: "Jul 15 2022",
      time: "09:30 AM",
      text: "Great News! You have New order 1",
      read: true,
      icon: const Icon(
        Icons.location_on,
        color: iconcolors3,
      )),
  Notificationdetails(
      date: "Jul 12 2022",
      time: "05:30 AM",
      text: "Great News! You have New order",
      read: true,
      icon: const Icon(
        Icons.assessment,
        color: iconcolors1,
      )),
  Notificationdetails(
      date: "Jul 15 2022",
      time: "09:30 AM",
      text: "Great News! You have New order 1",
      read: false,
      icon: const Icon(
        Icons.location_on,
        color: iconcolors3,
      ))
];
