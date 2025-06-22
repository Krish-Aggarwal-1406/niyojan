import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'controller/task_controller.dart';
import 'models/task_model.dart';
import 'widgets/button.dart';
import 'widgets/text_field.dart';

class AddTaskPage extends StatefulWidget {
  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final TaskController controller = Get.find<TaskController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);

  String selectedPriority = "Medium";
  int selectedRemind = 5;

  final List<String> priorities = ["High", "Medium", "Low"];
  final List<int> remindList = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final scrHeight = MediaQuery.of(context).size.height;
    final scrWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue[900]),
        title: Text(
          "Add Task",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: scrHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              title: "Title",
              hint: "Enter title here.",
              controller: titleController,
            ),
            SizedBox(height: 10),
            InputField(
              title: "Note",
              hint: "Enter note here.",
              controller: noteController,
            ),
            SizedBox(height: 10),
            InputField(
              title: "Date",
              hint: DateFormat.yMd().format(selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.grey[800]),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    title: "Start Time",
                    hint: startTime.format(context),
                    widget: IconButton(
                      icon: Icon(Icons.access_time, color: Colors.grey[800]),
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            startTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: scrWidth * 0.03),
                Expanded(
                  child: InputField(
                    title: "End Time",
                    hint: endTime.format(context),
                    widget: IconButton(
                      icon: Icon(Icons.access_time, color: Colors.grey[800]),
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            endTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            DropdownWidget<int>(
              title: "Remind",
              value: selectedRemind,
              items: remindList,
              textColor: Colors.black87,
              borderColor: Colors.grey[800]!,
              iconColor: Colors.grey[800]!,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedRemind = val;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            DropdownWidget<String>(
              title: "Priority",
              value: selectedPriority,
              items: priorities,
              textColor: Colors.black87,
              borderColor: Colors.grey[800]!,
              iconColor: Colors.grey[800]!,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedPriority = val;
                  });
                }
              },
            ),
            SizedBox(height: scrHeight * 0.03),
            Button(
              label: "Create Task",
              onTap: () {
                if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
                  final newTask = Task(
                    title: titleController.text,
                    note: noteController.text,
                    date: DateFormat.yMd().format(selectedDate),
                    startTime: startTime.format(context),
                    endTime: endTime.format(context),
                    remind: selectedRemind,
                    priority: selectedPriority,
                    status: "ToDo",
                  );
                  controller.addTask(newTask);
                  Get.back();
                } else {
                  Get.snackbar("Error", "Title and Note are required.");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownWidget<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;

  const DropdownWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.textColor,
    required this.borderColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          height: 52,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: SizedBox.shrink(),
            icon: Icon(Icons.keyboard_arrow_down, color: iconColor),
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString(), style: TextStyle(color: textColor)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
