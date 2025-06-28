import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salamt_tifli/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('سلامة طفلي'), findsOneWidget);
    
    // Verify that the welcome message is displayed
    expect(find.text('مرحباً بك في سلامة طفلي'), findsOneWidget);
    
    // Verify that emergency section is displayed
    expect(find.text('حالات الطوارئ'), findsOneWidget);
    
    // Verify that main features section is displayed
    expect(find.text('الخدمات الرئيسية'), findsOneWidget);
    
    // Verify that feature cards are displayed
    expect(find.text('دليل الإسعافات الأولية'), findsOneWidget);
    expect(find.text('التقويم الصحي'), findsOneWidget);
    expect(find.text('المكتبة التعليمية'), findsOneWidget);
    expect(find.text('خدمات الطوارئ'), findsOneWidget);
    expect(find.text('المساعد الذكي'), findsOneWidget);
    expect(find.text('ملفات الأطفال'), findsOneWidget);
  });

  testWidgets('Emergency buttons are tappable', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
      ),
    );

    // Find and tap the emergency call button
    final emergencyButton = find.text('اتصال طوارئ');
    expect(emergencyButton, findsOneWidget);
    
    await tester.tap(emergencyButton);
    await tester.pumpAndSettle();
    
    // Verify that the emergency dialog appears
    expect(find.text('اتصال طوارئ'), findsWidgets);
  });
}
