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
  List<Task> taskList = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    QuerySnapshot snapshot = await firestore.collection('tasks').get();
    taskList = snapshot.docs.map((doc) {
      Task task = Task.fromDocument(doc);
      task.id = doc.id;
      return task;
    }).toList();
    setState(() {});
  }

  Future<void> addTaskToFirestore(Task task) async {
    DocumentReference docRef = await firestore.collection('tasks').add(task.toMap());
    task.id = docRef.id;
    taskList.add(task);
    setState(() {});
  }

  void bottomsheet(Task task, int index) {
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
                taskList[index].status = 'Completed';
                setState(() {});
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text('Mark as In Progress'),
              onTap: () async {
                await firestore.collection('tasks').doc(task.id).update({'status': 'In Progress'});
                taskList[index].status = 'In Progress';
                setState(() {});
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Task'),
              onTap: () async {
                await firestore.collection('tasks').doc(task.id).delete();
                taskList.removeAt(index);
                setState(() {});
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
    final scrheight = MediaQuery.of(context).size.height;
    final scrwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage:
            AssetImage("assets/download-removebg-preview (21).png"),
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
            child: taskList.isEmpty
                ? emptylist()
                : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return GestureDetector(
                  onTap: () => bottomsheet(task, index),
                  child: Card(
                    margin:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.grey[100],
                    child: ListTile(
                      title: Text(task.title,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(task.note),
                      trailing: Text(task.status,
                          style:
                          TextStyle(color: statuscolor(task.status))),
                    ),
                  ),
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
          textStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
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
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
              Text("Today",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
          Button(
            label: "+ Add Task",
            onTap: () async {
              final Task? newTask = await Get.to(() => AddTaskPage());
              if (newTask != null) {
                await addTaskToFirestore(newTask);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget emptylist() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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

