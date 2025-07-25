import 'package:chime/core/common/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomNavigationBar renders and responds to taps', (
    WidgetTester tester,
  ) async {
    int selectedIndex = 0;
    final onDestinationSelected = (int index) {
      selectedIndex = index;
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return CustomNavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    onDestinationSelected(index);
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    // Check initial selected index is 0 (Chat)
    final chatIcon = find.byIcon(Icons.chat);
    final videoIcon = find.byIcon(Icons.video_call);
    final profileIcon = find.byIcon(Icons.person);

    expect(chatIcon, findsOneWidget);
    expect(videoIcon, findsOneWidget);
    expect(profileIcon, findsOneWidget);

    // Check that Chat icon is selected color
    Icon chatIconWidget = tester.widget(chatIcon);
    expect(chatIconWidget.color, const Color(0xFF14FFEF));

    // Other icons should be white initially
    Icon videoIconWidget = tester.widget(videoIcon);
    Icon profileIconWidget = tester.widget(profileIcon);
    expect(videoIconWidget.color, Colors.white);
    expect(profileIconWidget.color, Colors.white);

    // Tap Video Call destination
    await tester.tap(find.text('Video Call'));
    await tester.pumpAndSettle();

    // selectedIndex should be updated to 1
    expect(selectedIndex, 1);

    // Video Call icon should now be selected color
    videoIconWidget = tester.widget(videoIcon);
    expect(videoIconWidget.color, const Color(0xFF14FFEF));

    // Chat and Profile icons should be white now
    chatIconWidget = tester.widget(chatIcon);
    profileIconWidget = tester.widget(profileIcon);
    expect(chatIconWidget.color, Colors.white);
    expect(profileIconWidget.color, Colors.white);

    // Tap Profile destination
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 2);

    // Profile icon should be selected color now
    profileIconWidget = tester.widget(profileIcon);
    expect(profileIconWidget.color, const Color(0xFF14FFEF));
  });
}
