import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/remote/contacts/contact_service_interface.dart';
import '../../../utils/app_logger.dart';

IContactService _contactService = locator();

class AllContactsViewModel extends ChangeNotifier {
  final _logger = const AppLogger(AllContactsViewModel);
  // final Ref ref;
  AllContactsViewModel() {
    _contactService.getContactsAsStream().listen((event) {
      _contactStream.add(event);
      // _logger.i("New contact :: ${event.toString()}");
    }, onError: (e) {
      _logger.e("Error Receiving contacts as stream :: ", error: e);
    });
  }

  final BehaviorSubject<List<ContactModel>> _contactStream =
      BehaviorSubject<List<ContactModel>>();

  Stream<List<ContactModel>> get contactStream => _contactStream;
}

final allContactsViewModel =
    ChangeNotifierProvider<AllContactsViewModel>((ref) {
  return AllContactsViewModel();
});
