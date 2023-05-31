import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:harmony_chat_demo/views/chat/chat_view.dart';
import 'package:harmony_chat_demo/views/home/viewmodel/home_viewmodel.dart';
import 'package:uuid/uuid.dart';

final IContactService _contactService = locator();

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final faker = Faker();
  @override
  void initState() {
    // _contactService.insertAllContacts([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(homeViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              _contactService.insertContact(
                ContactModel(
                  lastName: faker.person.lastName(),
                  firstName: faker.person.firstName(),
                  avatarUrl: faker.image.image(),
                  createdAt: DateTime.now(),
                  occupation: faker.job.title(),
                  bio: faker.lorem.sentence(),
                  id: const Uuid().v4(),
                  serverId: const Uuid().v1(),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: StreamBuilder(
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
                    contact.id,
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.length);
        },
      ),
    );
  }
}
