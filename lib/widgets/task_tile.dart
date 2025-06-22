import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String note;
  final String timeRange;
  final String priority;
  final String status;

  const TaskTile({
    Key? key,
    required this.title,
    required this.note,
    required this.timeRange,
    required this.priority,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFF7E57C2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        priority,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.alarm, color: Colors.grey.shade200, size: 15),
                      SizedBox(width: 4),
                      Text(
                        timeRange,
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    note,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
