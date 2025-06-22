import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:niyojan/widgets/button.dart';
import 'addtask_screen.dart';
import 'login_screen.dart';
import 'controller/task_controller.dart';
import 'models/task_model.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final TaskController controller = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    controller.fetchTasks();
  }

  void bottomSheet(Task task) {
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
                await controller.updateTaskStatus(task.id, 'Completed');
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text('Mark as In Progress'),
              onTap: () async {
                await controller.updateTaskStatus(task.id, 'In Progress');
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Task'),
              onTap: () async {
                await controller.deleteTask(task.id);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Task> getSortedTasks(List<Task> tasks) {
    final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};

    tasks.sort((a, b) {
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
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
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.taskList.isEmpty) {
                return emptyList();
              }

              final sortedTasks = getSortedTasks(controller.taskList.toList());

              return ListView.builder(
                itemCount: sortedTasks.length,
                itemBuilder: (context, index) {
                  final task = sortedTasks[index];
                  return GestureDetector(
                    onTap: () => bottomSheet(task),
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
                          style: TextStyle(color: statusColor(task.status)),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
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
              if (newTask != null) controller.fetchTasks();
            },
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

  Widget emptyList() {
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

  Color statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
