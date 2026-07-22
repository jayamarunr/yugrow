import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yugrow_mobile/main.dart';

void main() {
  testWidgets('Yugrow app launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: YugrowApp()));
    expect(find.text('Yugrow'), findsOneWidget);
  });
}
