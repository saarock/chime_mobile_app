import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // No background color
      body: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {
          final user = state.userApiModel;

          if (user == null) {
            return const Center(
              child: Text(
                "No user data found.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Center(
                    child: Hero(
                      tag: 'profile-image',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            user.profilePicture != null
                                ? NetworkImage(user.profilePicture!)
                                : null,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child:
                            user.profilePicture == null
                                ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.email,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),

                  // Info Cards
                  _glassInfoCard("Username", user.userName ?? "-"),
                  _glassInfoCard("Country", user.country ?? "-"),
                  _glassInfoCard("Gender", user.gender?.name ?? "-"),
                  _glassInfoCard("Age", user.age?.toString() ?? "-"),
                  _glassInfoCard(
                    "Status",
                    user.relationShipStatus?.name ?? "-",
                  ),
                  _glassInfoCard("Role", user.role),
                  _glassInfoCard("Active", user.active ? "Yes" : "No"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Clean Glassmorphism Info Card
  Widget _glassInfoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
