import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/models/models.dart';
import 'package:harmony_chat_demo/extensions/extensions.dart';
import 'package:harmony_chat_demo/views/home/all_contacts_view.dart';
import 'package:harmony_chat_demo/views/home/components/message_tile.dart';
import 'package:harmony_chat_demo/views/home/viewmodel/home_viewmodel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double roundedRadius = 8;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(homeViewModel);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(model.user!.firstName!),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.showBottomSheet(
                (context) => Container(
                  height: context.deviceHeightPercentage(percentage: 80),
                  width: context.getDeviceWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(roundedRadius),
                      topRight: Radius.circular(roundedRadius),
                    ),
                  ),
                  child: const AllContactsView(),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(roundedRadius),
                    topRight: Radius.circular(roundedRadius),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.people_outline_outlined),
          ),
        ],
      ),
      body: StreamBuilder<List<MessageInfoModel>>(
        initialData: const [],
        stream: model.messagesStream,
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
              MessageInfoModel messageInfo = snapshot.data![index];
              return MessageTile(messageInfo: messageInfo);
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
