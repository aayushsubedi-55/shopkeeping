# ShopNepal Mobile App

Flutter customer app for **ShopNepal** — browse menus, order for delivery or pickup, track orders in real time, redeem loyalty/rewards, and manage profile.

| | |
|---|---|
| **Platforms** | iOS · Android |
| **Framework** | Flutter (Dart SDK `^3.10`) |
| **Version** | See `pubspec.yaml` (`version`) |
| **Repo** | [cliffByte/shopnepal-mobile-app](https://github.com/cliffByte/shopnepal-mobile-app) |

---

## Product overview

ShopNepal Mobile is a food-ordering client that connects customers to franchise locations. Core journeys:

1. **Discover** — country/franchise context, hero home, menu, product detail  
2. **Cart & checkout** — cart, promos, loyalty offers, delivery/pickup, place order  
3. **Fulfillment** — live order status on home, order history, track order, receipts  
4. **Engage** — loyalty coins, rewards, reviews, push notifications  
5. **Account** — auth (email / Google / Apple), profile, addresses, settings  

---

## Architecture

High-level structure follows **feature-first** modules with shared infrastructure.

```text
lib/
├── main.dart / main_dev.dart     # Entry, Firebase, env
├── common/                      # Cross-cutting (HTTP, theme, widgets, wrappers)
├── features/                    # Domain modules (UI + bloc + resource + model)
└── navigation/                  # auto_route router + AppNavigator
```

### Layers (per feature)

| Layer | Role |
|-------|------|
| **UI** | Screens / widgets |
| **Bloc / Cubit** | State (`flutter_bloc`) |
| **Repository** | Business + mapping |
| **ApiProvider** | Dio REST calls |
| **Model** | DTOs / domain models |
| **Service** (where needed) | Sockets, FCM, session sync |

### App shell

```text
MultiRepositoryWrapper  →  MultiBlocWrapper  →  AppRouter (auto_route)
         │                         │
    Auth, Order, Cart, …     Cubits registered app-wide
```

- **HTTP:** Dio + JWT, logging, custom exceptions (`common/http`)  
- **State:** Cubits / Bloc + shared `CommonState` patterns  
- **Realtime:** Socket.IO (`OrderRealtimeService`) — customer + order rooms  
- **Push:** Firebase Messaging + local notifications  
- **Navigation:** `auto_route` + `AppNavigator` helpers  
- **Storage:** Secure storage + shared preferences  
- **Theming:** Custom theme / Satoshi fonts / spacing tokens  

### Realtime orders (home + track)

```text
REST seed (GET /order/my-orders)
        │
        ▼
In-memory activeOrders[]  ◄── order:created / order:status_changed
        │
        ▼
Home live popup = newest non-terminal order
Track / receipt screens → join:order + detail refresh
```

Terminal for home popup: `COMPLETED` · `CANCELLED`.  
REST list refresh on resume / reconnect / offline poll (~30s) — not on every socket tick.

---

## Feature modules

| Module | Path | Responsibility |
|--------|------|----------------|
| **onboard** | `features/onboard` | Splash, onboarding, language |
| **auth** | `features/auth` | Login, signup, OTP, forgot password, Google / Apple, session |
| **home** | `features/home` | Dashboard tabs, hero, menu shell, settings, live order bar, country |
| **product** | `features/product` | Categories, menu, hero item, food detail, add to cart |
| **cart** | `features/cart` | Active cart, qty, combos, loyalty preview on lines |
| **checkout** | `features/checkout` | Franchise, fulfillment, schedule, place order |
| **order** | `features/order` | History, track, receipt / PDF, Socket.IO realtime |
| **review** | `features/review` | Overall + per-item reviews for completed orders |
| **promo** | `features/promo` | Promo codes / validation |
| **loyalty** | `features/loyalty` | Balance, offers, levels, redeem preview |
| **rewards** | `features/rewards` | Rewards catalog / redemption UI |
| **combo_offer** | `features/combo_offer` | Combo deals → cart |
| **shipping_address** | `features/shipping_address` | Saved addresses CRUD |
| **profile** | `features/profile` | Profile, preferences, business profile |
| **notification** | `features/notification` | FCM bootstrap, inbox, badge, preferences |
| **engagement** | `features/engagement` | Engagement / analytics events |
| **media** | `features/media` | Media helpers |
| **support** | `features/support` | Support contact flows |

---

## Major features (product)

### Ordering
- Browse menu by category; veg/non-veg indicators  
- Product detail → add to cart (auth-gated where required)  
- Cart quantity stepper, delete, combo lines  
- Checkout: delivery or pickup, franchise, scheduled time, taxes / fees  
- Promo codes and loyalty discounts on checkout / cart  

### Orders & tracking
- Order history (tabs: all / preparing / delivered / cancelled)  
- Track timeline (pickup vs delivery steps)  
- Receipt screen + download PDF  
- Live home order pill (collapsed by default; socket + REST seed)  
- Cancelled / completed UI on receipt & track  

### Reviews
- Rate completed orders (overall + optional per line item)  
- View submitted ratings (read-only)  
- Entry from history and receipt  

### Loyalty & rewards
- Loyalty balance and offers  
- Apply / remove offers on cart items  
- Rewards screen on dashboard  

### Account & platform
- Email auth + social (Google, Apple)  
- Guest prompts on cart / rewards  
- Profile, addresses, notification preferences  
- Country selection / currency symbol  
- In-app update / upgrader hooks  
- Push notifications  

---

## Tech stack (selected)

| Concern | Package / approach |
|---------|-------------------|
| Routing | `auto_route` |
| State | `flutter_bloc` |
| HTTP | `dio`, `pretty_dio_logger` |
| Images | `cached_network_image`, `flutter_svg` |
| Maps / location | `flutter_map`, `geolocator`, `geocoding` |
| Auth social | `google_sign_in`, `sign_in_with_apple`, `firebase_auth` |
| Push | `firebase_messaging`, `flutter_local_notifications` |
| Sockets | `socket_io_client` |
| PDF | `pdf`, `printing` |
| Secure storage | `flutter_secure_storage` |

---

## Project layout (quick)

```text
lib/
  common/           # config, http, theme, widgets, wrappers
  features/         # domain features (see table above)
  navigation/       # AppRouter, AppNavigator
  main.dart         # production-style entry
  main_dev.dart     # dev entry variant
docs/
  DEVELOPMENT_EFFORT_ANALYTICS.md
```

---

## Getting started

### Prerequisites
- Flutter SDK matching `pubspec.yaml` environment  
- Xcode (iOS) / Android Studio (Android)  
- Firebase project configured (`firebase_options.dart`)  

### Run

```bash
flutter pub get
flutter run
# or
flutter run -t lib/main_dev.dart
```

### Useful commands

```bash
flutter analyze
dart run build_runner build --delete-conflicting-outputs   # if regenerating routes
flutter build apk
flutter build ipa
```

Environment is set in code via `AppConfig.setEnvironment(...)` (see `main.dart` / `main_dev.dart`). Point API / socket URLs through app config for your backend.

---

## Related docs

| Doc | Purpose |
|-----|---------|
| [docs/DEVELOPMENT_EFFORT_ANALYTICS.md](docs/DEVELOPMENT_EFFORT_ANALYTICS.md) | Git-based effort / timeline analytics |
| Backend mobile docs (auth, sockets, checkout) | Contract for REST + Socket.IO |

---

## Contributing notes

- Prefer changes inside the owning `features/<name>/` module  
- Keep API calls in `*ApiProvider` / repositories — not in widgets  
- Order realtime: patch local state from socket; REST only for seed / reconnect / offline poll  
- Do not commit secrets (`.env`, tokens); use secure storage / CI secrets  

---

## License

Private package (`publish_to: 'none'`). All rights reserved by InfoCare / ShopNepal unless otherwise stated.
