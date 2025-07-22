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

  late final TextEditingController userNameCtrl;
  late final TextEditingController ageCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController countryCtrl;

  String? gender;
  String? status;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> statusOptions = ['Single', 'Married', 'Complicated'];

  @override
  void initState() {
    super.initState();
    final user = context.read<LoginViewModel>().state.userApiModel!;
    userNameCtrl = TextEditingController(text: user.userName);
    ageCtrl = TextEditingController(text: user.age?.toString());
    phoneCtrl = TextEditingController(text: user.phoneNumber);
    countryCtrl = TextEditingController(text: user.country);

    // ✅ Prevent invalid values from crashing DropdownButton
    gender =
        genderOptions.contains(user.gender?.name) ? user.gender?.name : null;
    status =
        statusOptions.contains(user.relationShipStatus)
            ? user.relationShipStatus
            : null;
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
          final isLoading = state is ProfileLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEditableTextField("Username", userNameCtrl),
                    _buildEditableTextField("Age", ageCtrl, isNumber: true),
                    _buildEditableTextField("Phone Number", phoneCtrl),
                    _buildEditableTextField("Country", countryCtrl),

                    _buildDropdownField(
                      "Gender",
                      gender,
                      genderOptions,
                      (val) => setState(() => gender = val),
                    ),

                    _buildDropdownField(
                      "Status",
                      status,
                      statusOptions,
                      (val) => setState(() => status = val),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ProfileBloc>().add(
                                      SubmitProfileEvent(
                                        userId: user.id!,
                                        userName: userNameCtrl.text.trim(),
                                        age: ageCtrl.text.trim(),
                                        phoneNumber: phoneCtrl.text.trim(),
                                        country: countryCtrl.text.trim(),
                                        gender: gender,
                                        relationshipStatus: status,
                                        existingUser: user,
                                      ),
                                    );
                                  }
                                },
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Save Changes",
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
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

  Widget _buildEditableTextField(
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

  Widget _buildDropdownField(
    String label,
    String? currentValue,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    final safeValue = options.contains(currentValue) ? currentValue : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: safeValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items:
            options
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }
}
