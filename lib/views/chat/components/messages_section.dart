import 'package:flutter/material.dart';

class MessagesSection extends StatelessWidget {
  const MessagesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ...List.generate(
            10,
            (index) => Column(
              children: const [
                Text(
                  ("Heeeee"),
                ),
                Text("10:00 am")
              ],
            ),
          )
        ],
      ),
    );
  }
}
