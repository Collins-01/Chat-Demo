import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("John"),
      ),
      body: Column(
        children: [
          Column(
            children: [
              ...List.generate(
                10,
                (index) => Column(
                  children: [
                    Text(
                      ("Heeeee"),
                    ),
                    Text("10:00 am")
                  ],
                ),
              )
            ],
          ),
          TextField(
            decoration: InputDecoration(hintText: "Send a message..."),
          )
        ],
      ),
    );
  }
}
