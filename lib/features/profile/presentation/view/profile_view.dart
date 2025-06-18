import 'package:chime/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {
          final user = state.userApiModel;

          if (user == null) {
            return const Center(child: Text("No user data found."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user.profilePicture != null
                          ? NetworkImage(user.profilePicture!)
                          : null,
                  child:
                      user.profilePicture == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                ),
                const SizedBox(height: 16),

                // Name & Email
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 24),

                // Info Cards
                _infoCard("Username", user.userName ?? "-"),
                _infoCard("Country", user.country ?? "-"),
                _infoCard("Gender", user.gender?.name ?? "-"),
                _infoCard("Age", user.age?.toString() ?? "-"),
                _infoCard("Status", user.relationShipStatus?.name ?? "-"),
                _infoCard("Role", user.role),
                _infoCard("Account Active", user.active ? "Yes" : "No"),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
