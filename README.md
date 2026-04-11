# XDeck

[![license](https://img.shields.io/npm/l/svelte.svg)](LICENSE)

<img width="120" height="120" alt="XDeck-iOS-Default-1024x1024@1x" src="https://github.com/user-attachments/assets/b0076952-c7b4-4024-a337-8df37c05f88c" />

An 𝕏 client app for macOS as a TweetDeck alternative (with Ad-Blocking).

[Download](https://github.com/morishin/XDeck/releases/latest)

![スクリーンショット 2024-06-14 0 25 40](https://github.com/morishin/XDeck/assets/1413408/855cbc09-8b2e-4f68-8f7d-1952f3daf060)

## Configuration

`⌘,` and edit `settings.json`.

Example

```json
{
  "$schema": "./schema.json",
  "columnWidth": 450,
  "columns": [
    {
      "type": "following"
    },
    {
      "type": "forYou"
    },
    {
      "type": "notifications"
    },
    {
      "type": "profile"
    },
    {
      "type": "custom",
      "url": "https://x.com/i/lists/123456789"
    }
  ]
}
```
