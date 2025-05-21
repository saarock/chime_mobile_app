import 'package:chime/viewmodels/auth_view_model.dart';
import 'package:chime/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:chime/common/custom_app.dart';
import 'package:chime/models/user_model.dart';
import 'package:chime/utils/token_storage.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<UserModel?> _userFuture;
  bool isEditing = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userFuture = TokenStorage.getUser();
  }

  void toggleEdit(UserModel user) {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        _nameController.text = user.fullName;
        _emailController.text = user.email;
      }
    });
  }

  // logout function
  Future<void> _logout(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.logout();
    if (mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user data found."));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage:
                        user.profilePicture.isNotEmpty
                            ? NetworkImage(user.profilePicture)
                            : null,
                    child:
                        user.profilePicture.isEmpty
                            ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                            : null,
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => toggleEdit(user),
                    icon: Icon(
                      isEditing ? Icons.close : Icons.edit,
                      color: Colors.blue,
                    ),
                    label: Text(isEditing ? 'Cancel' : 'Edit Profile'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Full Name"),
                        isEditing
                            ? _buildEditableField(_nameController)
                            : _buildDisplayText(user.fullName),
                        const SizedBox(height: 16),
                        _buildLabel("Email"),
                        isEditing
                            ? _buildEditableField(_emailController)
                            : _buildDisplayText(user.email),
                        const SizedBox(height: 16),
                        _buildLabel("Status"),
                        Row(
                          children: [
                            Icon(
                              user.active
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: user.active ? Colors.green : Colors.red,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.active ? "Active" : "Inactive",
                              style: TextStyle(
                                color: user.active ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (isEditing)
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Save logic goes here
                                setState(() => isEditing = false);
                              },
                              icon: const Icon(Icons.save),
                              label: const Text("Save Changes"),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDisplayText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildEditableField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
