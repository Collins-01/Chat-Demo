import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/input_section_viewmodel.dart';

final IFileService _fileService = locator();

class InputSection extends ConsumerStatefulWidget {
  final ContactModel contactModel;
  const InputSection(this.contactModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputSectionState();
}

class _InputSectionState extends ConsumerState<InputSection> {
  final TextEditingController controller = TextEditingController();
  bool _showMic = true;
  @override
  void initState() {
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        setState(() {
          _showMic = false;
        });
      } else {
        setState(() {
          _showMic = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(inputSectionViewModel);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 13, top: 10),
                  hintText: "Send a message...",
                  suffixIcon: IconButton(
                    onPressed: () => model.sendMessage(
                      widget.contactModel,
                      controller.text.trim(),
                    ),
                    icon: const Icon(Icons.attach_file),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              if (controller.text.isNotEmpty) {
                model.sendMessage(widget.contactModel, controller.text.trim());
                controller.clear();
              }

              if (_showMic) {}
              return;
            },
            child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: !_showMic
                    ? const Icon(
                        Icons.send,
                        color: Colors.white,
                      )
                    : StreamBuilder(
                        stream: model.isRecording,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final isRecording = snapshot.data!;
                            return Icon(
                              isRecording ? Icons.stop_rounded : Icons.mic,
                              color: isRecording ? Colors.red : Colors.white,
                            );
                          } else {
                            return const Icon(
                              Icons.mic,
                              color: Colors.white,
                            );
                          }
                        },
                      )),
          )
        ],
      ),
    );
  }
}
