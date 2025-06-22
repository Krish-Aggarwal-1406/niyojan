import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niyojan/addtask_screen.dart';

import '../widgets/button.dart';
import 'login_screen.dart';
import 'models/task_model.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void bottomsheet(Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Mark as Completed'),
              onTap: () async {
                await firestore.collection('tasks').doc(task.id).update({'status': 'Completed'});
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text('Mark as In Progress'),
              onTap: () async {
                await firestore.collection('tasks').doc(task.id).update({'status': 'In Progress'});
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Task'),
              onTap: () async {
                await firestore.collection('tasks').doc(task.id).delete();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage("assets/download-removebg-preview (21).png"),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginPage());
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addTaskBar(),
          timeline(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('tasks').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return emptylist();
                }
                final tasks = docs.map((doc) {
                  final task = Task.fromDocument(doc);
                  task.id = doc.id;
                  return task;
                }).toList();

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return GestureDetector(
                      onTap: () => bottomsheet(task),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.grey[100],
                        child: ListTile(
                          title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(task.note),
                          trailing: Text(
                            task.status,
                            style: TextStyle(color: statuscolor(task.status)),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget timeline() {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: context.theme.scaffoldBackgroundColor,
        selectedTextColor: Color(0xFF4169E1),
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  Widget addTaskBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
              Text("Today", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          Button(
            label: "+ Add Task",
            onTap: () async {
              final Task? newTask = await Get.to(() => AddTaskPage());
              // Firestore stream auto updates UI; no manual update needed here
            },
          ),
        ],
      ),
    );
  }

  Widget emptylist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80),
          Image.asset("assets/4118823-removebg-preview.png", height: 100),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: Text(
              "You do not have any tasks yet!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

Color statuscolor(String status) {
  switch (status) {
    case "Completed":
      return Colors.green;
    case "In Progress":
      return Colors.orange;
    default:
      return Colors.red;
  }
}
