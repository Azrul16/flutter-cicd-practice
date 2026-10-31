import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice/main.dart';

void main() {
  testWidgets('Search and categories filter the catalog', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), 'headphones');
    await tester.pumpAndSettle();
    expect(find.text('Studio headphones'), findsOneWidget);
    expect(find.text('1 items'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'not a product');
    await tester.pumpAndSettle();
    expect(find.text('No products found. Try another search.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Home'));
    await tester.pumpAndSettle();
    expect(find.text('Morning mug'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);
  });

  testWidgets('Cart quantities, removal and demo checkout work', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add Studio headphones'));
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    expect(find.text('\$89.00'), findsNWidgets(2));
    await tester.tap(find.byTooltip('Increase Studio headphones'));
    await tester.pumpAndSettle();
    expect(find.text('\$178.00'), findsOneWidget);
    await tester.tap(find.byTooltip('Decrease Studio headphones'));
    await tester.pumpAndSettle();
    expect(find.text('\$89.00'), findsNWidgets(2));
    await tester.tap(find.text('Demo checkout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is waiting'), findsOneWidget);
  });

  testWidgets('Product details can add an item', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Studio headphones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to cart • \$89.00'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove Studio headphones'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is waiting'), findsOneWidget);
  });
}
