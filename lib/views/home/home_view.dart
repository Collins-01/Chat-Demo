import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/views/home/viewmodel/home_viewmodel.dart';

import '../chat/chat_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(homeViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: model.contactStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Center(
              child: Text("NO Data"),
            );
          }
          if (snapshot.data!.isEmpty) {
            const Center(
              child: Text("Data is empty"),
            );
          }
          return ListView.separated(
              itemBuilder: (context, index) {
                final contact = snapshot.data![index];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatView(
                          contactModel: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 35,
                    child: Image.network(contact.avatarUrl),
                  ),
                  title: Text("${contact.lastName} ${contact.firstName}"),
                  subtitle: const Text("Heyyyyy man"),
                  trailing: const Text("9:00 am"),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data?.length ?? 0);
        },
      ),
    );
  }
}
