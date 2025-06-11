import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onDestinationSelected;
  final int selectedIndex;

  const CustomNavigationBar({
    required this.onDestinationSelected,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFF14FFEF);
    const unselectedColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191833),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((
            states,
          ) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                color: selectedColor,
                fontWeight: FontWeight.bold,
              );
            }
            return const TextStyle(
              color: unselectedColor,
              fontWeight: FontWeight.normal,
            );
          }),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.transparent,
          indicatorColor: selectedColor.withOpacity(0.15),
          elevation: 0,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.chat,
                color: selectedIndex == 0 ? selectedColor : unselectedColor,
              ),
              label: "Chat",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.video_call,
                color: selectedIndex == 1 ? selectedColor : unselectedColor,
              ),
              label: "Video Call",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 2 ? selectedColor : unselectedColor,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
