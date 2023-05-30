import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/views/chat/chat_view.dart';
import 'package:harmony_chat_demo/views/home/viewmodel/home_viewmodel.dart';

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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      snapshot.data!.length,
                      (index) => ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChatView(
                                    contactModel: ContactModel(
                                        id: 'id',
                                        lastName: 'lastName',
                                        firstName: 'firstName',
                                        avatarUrl: 'avatarUrl'),
                                  )));
                        },
                        title: const Text("John Doe"),
                        subtitle: const Text("Heyyyyy man"),
                        trailing: const Text("9:00 am"),
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
