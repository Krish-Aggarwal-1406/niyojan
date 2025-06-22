import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? hint;
  final bool? obsecureText;
  final Widget? widget;

  const InputField({
    required this.title,
    this.controller,
    this.hint,
    this.widget,
    this.obsecureText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    TextStyle subTitleStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey[600],
    );

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.only(left: 14.0),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: false,
                    obscureText: obsecureText ?? false,
                    cursorColor: Colors.grey[600],
                    readOnly: widget != null,
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint ?? '',
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 0),
                      ),
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
