# iPhone App for MyDay Timetracker

This is a Turbo Native based iPhone application that wraps the MyDay Rails application.

## Prerequisites

- Xcode 14+
- iOS 15+
- CocoaPods (if adding dependencies)

## Setup Instructions

1.  Open Xcode.
2.  Create a new iOS App project named "MyDay".
3.  Add `Turbo` package dependency: `https://github.com/hotwired/turbo-ios`.
4.  Replace `SceneDelegate.swift` and `ContentView.swift` logic with the provided Turbo Native implementation.

## Features

- Native navigation bar and transitions.
- Authentication handled by the Rails app.
- Native-like feel using PWA features and Turbo Native.

## Core Files

- `mobile/ios-app/SceneDelegate.swift`: Main entry point for the Turbo Native app.
- `app/controllers/application_controller.rb`: Contains `turbo_native_app?` helper.
- `app/views/layouts/application.html.erb`: Adapts UI for the mobile app (hides web header/footer).
- `public/manifest.json`: Web App Manifest for PWA and mobile styling.

## Adapting the Web UI

The Rails app detects the mobile app via the User Agent `MyDayTurboNative`. You can use the `turbo_native_app?` helper in your views to hide elements that are handled by the native app (like navigation bars or tab bars).
