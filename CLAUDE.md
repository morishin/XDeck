# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

XDeck is a native macOS desktop app — a TweetDeck-style X/Twitter client with ad-blocking. It renders X.com inside WKWebView columns and injects JavaScript to customize the UI (hide ads, detect themes, extract usernames).

## Build & Run

- **Open in Xcode**: `open XDeck.xcodeproj`
- **Build**: `xcodebuild -scheme XDeck -configuration Debug build` (or Cmd+B in Xcode)
- **Run**: Cmd+R in Xcode
- **Deployment target**: macOS 13.3+
- **No external dependencies** — uses only Apple frameworks (SwiftUI, WebKit, AppKit)
- **No test targets** exist in the project

## Architecture

MVVM pattern with JavaScript injection for web content manipulation.

### Key flows

1. **Login**: `XDeckApp` → `LoginView` (WKWebView on x.com/login) → on successful login, username is extracted via JS and stored in `@AppStorage`
2. **Main UI**: `ContentView` manages a horizontal `ScrollView` of `WebView` columns, each loading a different X.com URL based on `AppConfig`
3. **JS Injection**: `WebViewConfigurations` builds `WKWebViewConfiguration` with multiple `WKUserScript`s injected at document end — handles ad hiding, theme detection, UI element removal, and message passing back to Swift via `WKScriptMessageHandler`

### Important files

- `XDeck/XDeckApp.swift` — App entry point, loads config
- `XDeck/View/ContentView.swift` — Multi-column layout, keyboard shortcuts, toolbar
- `XDeck/View/WebView.swift` — `NSViewRepresentable` WKWebView wrapper with custom user agent
- `XDeck/WebViewConfigurations.swift` — All JavaScript injection logic (ad blocking, theme detection, username extraction)
- `XDeck/Config/AppConfig.swift` — JSON config model (`~/.config/XDeck/settings.json`)

### Configuration

User settings live at `~/.config/XDeck/settings.json`. Schema at `~/.config/XDeck/schema.json`. Column types: `forYou`, `following`, `notifications`, `profile`, `custom` (arbitrary URL).

## public/

Static landing page website — separate from the macOS app. Not part of the Xcode build.
