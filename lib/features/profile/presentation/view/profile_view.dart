import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/profile/presentation/view_model/profile_event.dart';
import 'package:chime/features/profile/presentation/view_model/profile_state.dart';
import 'package:chime/features/profile/presentation/view_model/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController userNameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController countryCtrl;

  String? gender;
  String? status;

  @override
  void initState() {
    super.initState();
    final user = context.read<LoginViewModel>().state.userApiModel!;
    userNameCtrl = TextEditingController(text: user.userName);
    ageCtrl = TextEditingController(text: user.age?.toString());
    phoneCtrl = TextEditingController(text: user.phoneNumber);
    countryCtrl = TextEditingController(text: user.country);
    gender = user.gender?.name;
    status = user.relationShipStatus;
  }

  @override
  void dispose() {
    userNameCtrl.dispose();
    ageCtrl.dispose();
    phoneCtrl.dispose();
    countryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginViewModel>().state.userApiModel;

    if (user == null) {
      return const Center(child: Text("No user data found."));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            // ✅ Update LoginViewModel with new user info
            context.read<LoginViewModel>().updateUser(state.user);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _editableTextField("Username", userNameCtrl),
                    _editableTextField("Age", ageCtrl, isNumber: true),
                    _editableTextField("Phone Number", phoneCtrl),
                    _editableTextField("Country", countryCtrl),

                    _dropdownField("Gender", gender, [
                      "Male",
                      "Female",
                      "Other",
                    ], (val) => setState(() => gender = val)),
                    _dropdownField("Status", status, [
                      "Single",
                      "Married",
                      "Complicated",
                    ], (val) => setState(() => status = val)),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed:
                          state is ProfileLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ProfileBloc>().add(
                                    SubmitProfileEvent(
                                      userId: user.id!,
                                      userName: userNameCtrl.text,
                                      age: ageCtrl.text,
                                      phoneNumber: phoneCtrl.text,
                                      country: countryCtrl.text,
                                      gender: gender,
                                      relationshipStatus: status,
                                    ),
                                  );
                                }
                              },
                      child:
                          state is ProfileLoading
                              ? const CircularProgressIndicator()
                              : const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _editableTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label cannot be empty";
          }
          return null;
        },
      ),
    );
  }

  Widget _dropdownField(
    String label,
    String? value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items:
            options.map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
      ),
    );
  }
}
