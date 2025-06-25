import 'dart:ui';
import 'package:chime/core/common/custom_app.dart';
import 'package:chime/core/common/my_snackbar.dart';
import 'package:chime/features/home/presentation/view_model/home_state.dart';
import 'package:chime/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<IconData> icons = [Icons.videocam, Icons.person];
  final List<String> labels = ["Video", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(
        title: "Chime",
        actions: [
          IconButton(
            onPressed: () {
              myDialog(
                context,
                title: "Logout",
                content: "Are you sure you want to logout?",
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Close dialog (No)
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Close dialog (Yes)
                      showMySnackBar(
                        context: context,
                        message: "Logging out...",
                        color: Colors.red,
                      );
                      context.read<HomeViewModel>().logout(context);
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return state.views[state.selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF191833),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white70,
                    currentIndex: state.selectedIndex,
                    showUnselectedLabels: true,
                    selectedFontSize: 13,
                    unselectedFontSize: 13,
                    type: BottomNavigationBarType.fixed,
                    items: List.generate(
                      icons.length,
                      (index) => BottomNavigationBarItem(
                        icon: Icon(
                          icons[index],
                          size: state.selectedIndex == index ? 30 : 24,
                        ),
                        label: labels[index],
                      ),
                    ),
                    onTap: (index) {
                      context.read<HomeViewModel>().onTabTapped(index);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// The myDialog function - you can put this in my_dialog.dart or directly here
Future<bool?> myDialog(
  BuildContext context, {
  required String title,
  required String content,
  required List<Widget> actions,
}) {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        ),
  );
}
