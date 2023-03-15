import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        width: 340,
        child: TextField(
          decoration: InputDecoration(
            hintText: "abv@gmail.com",
            prefixIcon: Image.asset("assets/images/Mail.png"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ));
  }
}
