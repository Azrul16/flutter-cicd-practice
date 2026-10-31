import 'package:flutter/material.dart';

import 'data/products.dart';
import 'models/product.dart';

void main() {
  runApp(const MyApp());
}

String money(num value) => '\$${value.toStringAsFixed(2)}';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Little Market',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF325C4C)),
      scaffoldBackgroundColor: const Color(0xFFFAFAF7),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFAFAF7)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: const StorePage(),
  );
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final Map<Product, int> cart = {};
  String query = '';
  String category = 'All';
  bool showCart = false;

  int get itemCount => cart.values.fold(0, (sum, count) => sum + count);
  double get total =>
      cart.entries.fold(0, (sum, entry) => sum + entry.key.price * entry.value);

  void add(Product product) {
    setState(
      () => cart.update(product, (count) => count + 1, ifAbsent: () => 1),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void details(Product product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductArt(product: product, height: 200),
                const SizedBox(height: 20),
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(product.description),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    add(product);
                  },
                  child: Text('Add to cart • ${money(product.price)}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where(
          (p) =>
              (category == 'All' || p.category == category) &&
              p.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded),
            SizedBox(width: 10),
            Text(
              'little market',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () => setState(() => showCart = true),
            icon: Badge(
              label: Text('$itemCount'),
              isLabelVisible: itemCount > 0,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: showCart
              ? cartView()
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: const Color(0xFF244B3E),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'THE EVERYDAY COLLECTION',
                                    style: TextStyle(
                                      color: Color(0xFFBAD4BF),
                                      letterSpacing: 2,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Little things.\nBetter days.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      height: 1.1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    'Thoughtful finds for your everyday life.',
                                    style: TextStyle(color: Color(0xFFD6E4DB)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              onChanged: (value) =>
                                  setState(() => query = value),
                              decoration: const InputDecoration(
                                hintText: 'Search products',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    [
                                          'All',
                                          'Electronics',
                                          'Accessories',
                                          'Fashion',
                                          'Home',
                                        ]
                                        .map(
                                          (value) => Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: ChoiceChip(
                                              label: Text(value),
                                              selected: category == value,
                                              onSelected: (_) => setState(
                                                () => category = value,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discover your next favorite',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text('${filtered.length} items'),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    if (filtered.isEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              'No products found. Try another search.',
                            ),
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) => SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    constraints.crossAxisExtent > 850
                                    ? 4
                                    : constraints.crossAxisExtent > 550
                                    ? 3
                                    : constraints.crossAxisExtent < 340
                                    ? 1
                                    : 2,
                                mainAxisExtent: 285,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final p = filtered[index];
                            return Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => details(p),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ProductArt(product: p, height: 135),
                                      const SizedBox(height: 12),
                                      Text(
                                        p.category,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        p.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              money(p.price),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton.filledTonal(
                                            tooltip: 'Add ${p.name}',
                                            onPressed: () => add(p),
                                            icon: const Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }, childCount: filtered.length),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: showCart ? 1 : 0,
        onDestinationSelected: (index) => setState(() => showCart = index == 1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget cartView() {
    if (cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Color(0xFF325C4C),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is waiting',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Find something you love in the shop.'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => setState(() => showCart = false),
              child: const Text('Explore products'),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Your cart',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text('$itemCount items • a few good finds'),
        const SizedBox(height: 20),
        ...cart.entries.map(
          (entry) => Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: ProductArt(product: entry.key, height: 72),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(money(entry.key.price)),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Decrease ${entry.key.name}',
                              onPressed: () => setState(() {
                                if (entry.value == 1) {
                                  cart.remove(entry.key);
                                } else {
                                  cart[entry.key] = entry.value - 1;
                                }
                              }),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${entry.value}'),
                            IconButton(
                              tooltip: 'Increase ${entry.key.name}',
                              onPressed: () => setState(
                                () => cart[entry.key] = entry.value + 1,
                              ),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remove ${entry.key.name}',
                    onPressed: () => setState(() => cart.remove(entry.key)),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Shipping'),
          trailing: Text('Free'),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Total',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            money(total),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Place demo order?'),
                content: Text(
                  'Your total is ${money(total)}. This is a demo checkout; no payment is collected.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Place order'),
                  ),
                ],
              ),
            );
            if (confirmed == true && mounted) {
              setState(() {
                cart.clear();
                showCart = false;
              });
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thanks! Your demo order has been placed.'),
                ),
              );
            }
          },
          icon: const Icon(Icons.lock_outline),
          label: const Padding(
            padding: EdgeInsets.all(14),
            child: Text('Demo checkout'),
          ),
        ),
      ],
    );
  }
}

class ProductArt extends StatelessWidget {
  const ProductArt({super.key, required this.product, required this.height});
  final Product product;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color: product.color,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Center(
      child: Icon(
        product.icon,
        size: height * .55,
        color: const Color(0xFF344A42),
      ),
    ),
  );
}
