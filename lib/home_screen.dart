import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';

import '../widgets/button.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  bool isSyncing = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addTaskBar(),
          dateBar(),
          noTaskMsg(),
        ],
      ),
    );
  }

  Widget dateBar() {
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
              Text(DateFormat.yMMMMd().format(DateTime.now()), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
              Text("Today", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: Icon(
        Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: Get.isDarkMode ? Colors.white : Color(0xFF2E2E2E),
      ),
      actions: [
        CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage("images/girl.jpg"),
        ),
        SizedBox(width: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: isSyncing
              ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Color(0xFF4169E1),
              strokeWidth: 3,
            ),
          )
              : IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              setState(() {
                isSyncing = true;
              });
              await Future.delayed(Duration(seconds: 3));
              setState(() {
                isSyncing = false;
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.view_compact),
      ],
    );
  }

  Widget noTaskMsg() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Placeholder(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "You do not have any tasks yet!\nAdd new tasks to make your days productive.",
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
