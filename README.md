# SpaceX (Orange Systems Technical Task)

This repository contains my implementation of the **Orange Systems** iOS technical task.  
The app lists SpaceX launches, shows a details screen with an embedded YouTube player, and lets users favorite launches (persisted locally).

## Tech & Architecture
- **SwiftUI**, **Combine**
- **MVVM** + lightweight **Coordinator** + **DI** via `ViewModelFactory`
- **Core Data** for favorites (`FavoriteLaunch` with unique `id`)
- Cached images with `NSCache` + `URLCache`
- Unified loading/empty/error UI via `StateView`
- **YouTubePlayerKit** (SPM) for video playback

## Endpoints (SpaceX v4)
- `GET /v4/launches/past`
- `GET /v4/launches/{id}`
- `GET /v4/rockets/{id}`
- `GET /v4/payloads/{id}`

## Requirements
- Xcode 15.4+ • iOS 17+
- No API keys required. Dependencies resolved via **Swift Package Manager**.

## Running
1. Clone the repo and open `SpaceX.xcodeproj` in Xcode.
2. Select an iOS 17+ simulator (or device).
3. Build & Run.

## Notes
- Details VM is created with `@StateObject` to avoid recreation and keep scroll/player stable.
- Favorites are synced across screens via a single `FavoritesStore`.
- Tests include stubs/mocks for repository and favorites store.

## Screenshots

### Main Screens (Light / Dark)

| Screen        | Light                                                                 | Dark                                                                  |
|---------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------|
| **Launches**  | <img src="Docs/Launches_light.png" width="280" alt="Launches Light"> | <img src="Docs/Launches_dark.png"  width="280" alt="Launches Dark">  |
| **Details**   | <img src="Docs/Details_light.png"   width="280" alt="Details Light">  | <img src="Docs/Details_dark.png"    width="280" alt="Details Dark">   |
| **Favorites** | <img src="Docs/Favorites_light.png" width="280" alt="Favorites Light">| <img src="Docs/Favorites_dark.png"   width="280" alt="Favorites Dark">|
| **No Favorites** | <img src="Docs/No_favorites_light.png" width="280" alt="No Favorites Light"> | <img src="Docs/No_favorites_dark.png"  width="280" alt="No Favorites Dark"> |

---

### Actions

| Action                    | Dark                                                                 | Light                                                                 |
|---------------------------|----------------------------------------------------------------------|-----------------------------------------------------------------------|
| **Add to Favorites**      | <img src="Docs/Add_to_favorites_dark.png" width="280" alt="Add Favorite Dark"> | — |
| **Remove from Favorites** | <img src="Docs/Remove_from_favorites_dark.png" width="280" alt="Remove Favorite Dark"> | <img src="Docs/Remove_from_favorites_light.png" width="280" alt="Remove Favorite Light"> |

---

### Landscape

| Launches (Landscape)                                                   | Details (Landscape)                                                   | No Favorites (Landscape)                                                  |
|------------------------------------------------------------------------|------------------------------------------------------------------------|---------------------------------------------------------------------------|
| <img src="Docs/Lanscape_launches.png" width="320" alt="Launches Landscape"> | <img src="Docs/Landscape_details.png" width="320" alt="Details Landscape"> | <img src="Docs/Lanscape_no_favorites.png" width="320" alt="No Favorites Landscape"> |

---

### Extras

| Details (with picture)                                                  | Wikipedia Link                                                        |
|-------------------------------------------------------------------------|-----------------------------------------------------------------------|
| <img src="Docs/Details_picture_dark.png" width="300" alt="Details Picture Dark"> | <img src="Docs/wiki.png" width="300" alt="Wikipedia">                 |


---

© Orange Systems technical task • 2025
