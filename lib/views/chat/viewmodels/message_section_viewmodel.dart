import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageSectionViewModel extends ChangeNotifier {}

final messageSectionViewModel =
    ChangeNotifierProvider<MessageSectionViewModel>((ref) {
  return MessageSectionViewModel();
});
