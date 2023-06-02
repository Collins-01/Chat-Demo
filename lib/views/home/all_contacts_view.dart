import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/views/chat/chat_view.dart';
import 'package:harmony_chat_demo/views/home/viewmodel/all_contacts_viewmodel.dart';

import '../../core/models/models.dart';

class AllContactsView extends ConsumerStatefulWidget {
  const AllContactsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllContactsViewState();
}

class _AllContactsViewState extends ConsumerState<AllContactsView> {
  @override
  Widget build(BuildContext context) {
    var model = ref.watch(allContactsViewModel);
    return StreamBuilder(
      initialData: const [],
      stream: model.contactStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Snapshot Error :: ${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return const Text("Snapshot has no data");
        }
        if (snapshot.data == null) {
          return const Text("Snapshot data is null");
        }
        if (snapshot.data!.isEmpty) {
          return const Text("Snapshot data is empty");
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            ContactModel contact = snapshot.data![index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatView(contactModel: contact),
                  ),
                );
              },
              leading: Container(
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  contact.avatarUrl,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text("${contact.lastName}  ${contact.firstName}"),
              subtitle: Text(
                contact.occupation,
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: snapshot.data!.length,
        );
      },
    );
  }
}
