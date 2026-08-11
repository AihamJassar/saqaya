# Saqaya — Water Delivery Flutter App

> A Firebase-enabled Flutter water-delivery application with account flows, order management, driver tracking, map support, and realtime service layers.

## Overview

This repository contains the source and supporting files for **Saqaya — Water Delivery Flutter App**. The documentation below was prepared from the current repository structure and implementation files so that setup expectations, project boundaries, and implemented capabilities are explicit.

## Technology

| Area | Implementation |
| --- | --- |
| Framework | Flutter |
| Authentication | Firebase Authentication |
| Data | Cloud Firestore and Firebase Realtime Database |
| Location | flutter_map, geolocator, and OpenStreetMap-oriented tooling |
| Notifications | Firebase Cloud Messaging dependency |

## Key capabilities

| Area | Current implementation |
| --- | --- |
| Order lifecycle | Includes user and order models with order-service support. |
| Driver visibility | Provides a dedicated driver-tracking screen. |
| Account foundation | Includes login, registration, and profile screens. |

## Getting started

Use the following workflow to work with the project locally.

```bash
git clone https://github.com/aihamjassar/saqaya.git
cd saqaya
flutter pub get
# Configure Firebase services for your own project
flutter run
```

## Project structure

| Path | Purpose |
| --- | --- |
| lib/models/ | Driver, order, and user models |
| lib/providers/ | Order, theme, and user state |
| lib/screens/ | Login, home, ordering, profile, and driver-tracking screens |
| lib/services/ | Auth, Firestore, order, and realtime services |

## Configuration notes

Set up Firebase rules, maps configuration, and notification credentials for your own environment. Do not publish production keys or unrestricted database rules.

## License

No license file is currently included. Confirm the intended licensing terms with the repository owner before reuse or distribution.

## Maintainer

Maintained by [Aiham Jassar](https://github.com/aihamjassar). Contributions, issue reports, and improvement suggestions are welcome through the repository.
