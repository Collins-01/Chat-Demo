import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/views/chat_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              10,
              (index) => ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ChatView()));
                },
                title: Text("John Doe"),
                subtitle: Text("Heyyyyy man"),
                trailing: Text("9:00 am"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
