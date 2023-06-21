import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/input_section_viewmodel.dart';

class InputSection extends ConsumerStatefulWidget {
  final ContactModel contactModel;
  const InputSection(this.contactModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputSectionState();
}

class _InputSectionState extends ConsumerState<InputSection> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(inputSectionViewModel);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              model.pickImage(widget.contactModel);
            },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 10,
          ),
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
                    onPressed: () => model.pickImage(
                      widget.contactModel,
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
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
          controller.text.isNotEmpty
              ? const SizedBox.shrink()
              : ValueListenableBuilder(
                  valueListenable: model.isRecording,
                  builder: (context, isRecording, child) {
                    return IconButton(
                      onPressed: () {
                        if (isRecording) {
                          model.stopRecord(widget.contactModel);
                        } else {
                          model.recordAudio();
                        }
                      },
                      icon: Icon(
                        isRecording ? Icons.stop_rounded : Icons.mic,
                        color: isRecording ? Colors.red : Colors.blue,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
