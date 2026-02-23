# App Icon Setup Instructions

## Overview
The app logo system is configured to automatically generate icons for all platforms (Android, iOS, Web, Windows, macOS, Linux) from a single source image.

## How to Add Your Logo

1. **Find or create an image** of unloading goods (PNG, JPG, or SVG format)
   - Recommended: 1024x1024 pixels or larger
   - Square format works best
   - PNG format with transparency is ideal

2. **Place the image** in the `assets/` folder with the name `app_icon.png`
   - Path: `assets/app_icon.png`

3. **Generate icons** for all platforms by running:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

4. **Rebuild the app**:
   ```bash
   flutter run
   ```

## What Gets Updated
- Android app icon (all density variants: hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
- iOS app icon
- Web favicon and icons
- Windows app icon
- macOS app icon
- Linux app icon

## Important Notes
- The source image at `assets/app_icon.png` is only used by the flutter_launcher_icons tool during generation
- After running the command, the actual app icons are placed in platform-specific folders:
  - Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
  - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - Web: `web/icons/`
  - etc.

## Need an Icon?
If you don't have an image ready, you can:
- Create one using design tools like Canva, Figma, or GIMP
- Use online icon generators
- Find free icons on sites like Unsplash, Pexels, or Pixabay
- Search for "logistics icons" or "goods unloading illustrations"
