# Little Market

A simple Flutter e-commerce demo with eight local dummy products. No backend, API keys, network access, or extra packages are needed.

Features:
- Responsive product grid with category filters and search
- Product details with add-to-cart
- Cart quantities, item removal, and calculated totals
- Demo checkout with confirmation (no real payments)

## Run

```sh
flutter pub get
flutter run
```

For the browser, run `flutter run -d chrome`.

## Validate

```sh
flutter analyze
flutter test
```

Product data lives in `lib/data/products.dart`, the product model in `lib/models/product.dart`, and the UI in `lib/main.dart`. Illustrations use built-in Material icons so the app works offline. Cart state is kept in memory and resets when the app restarts.
