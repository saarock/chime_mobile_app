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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Chime",
        actions: [
          IconButton(
            onPressed: () {
              showMySnackBar(
                context: context,
                message: "Logging out...",
                color: Colors.red,
              );
              context.read<HomeViewModel>().logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ), // Replace with your brand if needed
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return state.views[state.selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFF191833),
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 0.3),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.shade600,
              type: BottomNavigationBarType.fixed,
              currentIndex: state.selectedIndex,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              selectedFontSize: 14,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.videocam_outlined),
                  activeIcon: Icon(Icons.videocam),
                  label: 'Video',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              onTap: (index) {
                context.read<HomeViewModel>().onTabTapped(index);
              },
            ),
          );
        },
      ),
    );
  }
}
