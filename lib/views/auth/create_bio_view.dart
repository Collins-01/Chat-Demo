import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/utils/utils.dart';
import 'package:harmony_chat_demo/views/auth/viewmodels/create_bio_viewmodel.dart';
import 'package:harmony_chat_demo/views/widgets/widgets.dart';

class CreateBioView extends ConsumerStatefulWidget {
  const CreateBioView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateBioViewState();
}

class _CreateBioViewState extends ConsumerState<CreateBioView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  String? _selectedGender;
  @override
  Widget build(BuildContext context) {
    var model = ref.watch(createBioViewModel);
    return LoaderPage(
      busy: model.isBusy,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    model.pickImage();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: model.selectedImage == null
                        ? const Icon(Icons.camera_alt_outlined)
                        : Image.file(model.selectedImage!),
                  ),
                ),
                AuthTextField(
                  controller: firstNameController,
                  labelText: "FirstName",
                  hintText: "John",
                  validator: (v) => FieldValidators.string(v, 'FirstName'),
                ),
                AuthTextField(
                  controller: lastNameController,
                  labelText: "LastName",
                  hintText: "Doe",
                  validator: (v) => FieldValidators.string(v, 'LastName'),
                ),
                AuthTextField(
                  controller: firstNameController,
                  labelText: "Occupation",
                  hintText: "Teacher",
                  validator: (v) => FieldValidators.string(v, 'Occupation'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                AppLongButton(
                  title: 'Create',
                  onTap: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
