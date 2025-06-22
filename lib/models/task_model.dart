import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String note;
  String date;
  String startTime;
  String endTime;
  int remind;
  String repeat;
  String priority;
  String status;

  Task({
    this.id = '',
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'priority': priority,
      'status': status,
    };
  }

  factory Task.fromDocument(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: map['title'],
      note: map['note'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      remind: map['remind'],
      repeat: map['repeat'],
      priority: map['priority'],
      status: map['status'],
    );
  }
}
