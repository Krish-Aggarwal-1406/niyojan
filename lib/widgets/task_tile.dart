import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFF7E57C2), // purple shade
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task Title",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      "High",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Colors.grey.shade200,
                      size: 15,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "9:00 AM - 10:00 AM",
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 13, color: Colors.grey.shade100),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "This is a sample note for the task.",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 12, color: Colors.grey.shade100),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey.shade200.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              "TODO",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
