# PWA Assets Generator Plugin

Generate a complete set of PWA-compliant assets from a single 1024x1024px source image.

## Overview

This Claude Code plugin provides an automated workflow for creating all necessary Progressive Web App (PWA) assets, including icons, favicons, splash screens, and more. It eliminates the manual work of creating multiple image sizes and formats required for modern PWA applications.

## Features

- 🎨 **Complete Asset Generation**: Creates all PWA-required assets from one source image
- 📱 **Multiple Icon Sizes**: Standard icons (144×144, 192×192, 512×512)
- 🎭 **Maskable Icons**: Safe area variants for adaptive icons
- 🍎 **iOS Support**: Apple touch icons for iOS devices
- 🌐 **Multi-Resolution Favicon**: Proper .ico file with 16×16, 32×32, 48×48 sizes
- 🔔 **Badge Icons**: Monochrome notification badges
- 📸 **Screenshot Placeholders**: Branded desktop and mobile placeholders
- ⚡ **Shortcut Icons**: Icons with symbolic overlays for app shortcuts
- 🚀 **Automatic Dependencies**: Installs required npm packages if needed

## Installation

Install this plugin from the Laststance marketplace:

```bash
# Add marketplace (first time only)
/plugin marketplace add https://github.com/laststance/claude-code-marketplace

# Install plugin
/plugin install pwa-assets-generator@laststance
```

## Usage

### Basic Usage

After installation, use the skill through Claude Code:

```bash
# Generate assets from your logo
node scripts/generate-pwa-assets.js ./logo.png ./public
```

### Parameters

- `<source-image>`: Path to your source image (must be 1024×1024px or larger)
- `<output-directory>`: Directory where assets will be generated

### Example Workflow

1. **Prepare Source Image**
   - Create a 1024×1024px PNG with transparency
   - Ensure your logo/icon is centered
   - Save as `logo.png` in your project

2. **Generate Assets**
   ```bash
   node scripts/generate-pwa-assets.js ./logo.png ./public
   ```

3. **Use in PWA Manifest**
   ```json
   {
     "icons": [
       { "src": "/icon-192x192.png", "sizes": "192x192", "type": "image/png" },
       { "src": "/icon-512x512.png", "sizes": "512x512", "type": "image/png" },
       { "src": "/icon-192x192-safe.png", "sizes": "192x192", "type": "image/png", "purpose": "maskable" }
     ]
   }
   ```

## Generated Assets

### App Icons (Standard)
- `icon-144x144.png` - Standard PWA icon
- `icon-192x192.png` - Android Chrome icon (required)
- `icon-512x512.png` - High-resolution PWA icon (required)

### Maskable Icons
- `icon-192x192-safe.png` - Maskable variant with 20% safe area padding

### iOS Support
- `apple-touch-icon.png` - 180×180px for iOS home screen

### Favicon
- `favicon.ico` - Multi-resolution icon (16×16, 32×32, 48×48)

### Badge Icon
- `badge.png` - 96×96px monochrome white badge for notifications

### Screenshot Placeholders
- `screenshots/desktop-wide.png` - 1280×720px desktop placeholder
- `screenshots/mobile-narrow.png` - 375×812px mobile placeholder

### Shortcut Icons
- `shortcuts/start.png` - 96×96px with play overlay
- `shortcuts/settings.png` - 96×96px with gear overlay

## Output Structure

```
public/
├── icon-144x144.png
├── icon-192x192.png
├── icon-512x512.png
├── icon-192x192-safe.png
├── apple-touch-icon.png
├── favicon.ico
├── badge.png
├── screenshots/
│   ├── desktop-wide.png
│   └── mobile-narrow.png
└── shortcuts/
    ├── start.png
    └── settings.png
```

## Requirements

- Node.js (v14 or higher)
- npm
- Source image: 1024×1024px or larger PNG (with transparency recommended)

## Dependencies

The script automatically installs these packages if not present:
- `sharp` - High-performance image processing
- `png-to-ico` - PNG to ICO conversion

## Customization

### Maskable Icon Padding

Adjust padding in the script by modifying the `MASKABLE_PADDING` constant (default: 0.2 for 20% padding):

```javascript
const MASKABLE_PADDING = 0.2; // 20% padding
```

### Screenshot Placeholders

Generated screenshots include instructional text. Replace these with actual app screenshots before deployment:

```bash
# Replace placeholders with real screenshots
cp my-desktop-screenshot.png public/screenshots/desktop-wide.png
cp my-mobile-screenshot.png public/screenshots/mobile-narrow.png
```

### Badge Color Scheme

The default badge is white monochrome. Edit the script's badge generation section to customize colors.

## Troubleshooting

### Image Too Small
**Error**: "Source image must be at least 1024x1024px"
- Ensure source image is 1024×1024px or larger
- Use PNG format for best results

### Transparency Issues
- Use PNG with alpha channel for icons
- JPEG not recommended (no transparency support)

### Favicon Not Showing
- Clear browser cache after replacing favicon.ico
- Wait for browser to fetch new favicon (may take time)

### Dependencies Installation Failed
If automatic installation fails:
```bash
npm install sharp png-to-ico
```

## Best Practices

1. **Source Image Quality**
   - Use high-resolution source (1024×1024px minimum)
   - PNG format with transparency
   - Center your logo/icon in the canvas

2. **Icon Design**
   - Keep designs simple and recognizable at small sizes
   - Test icons at various sizes (16×16 to 512×512)
   - Ensure sufficient contrast for visibility

3. **Maskable Icons**
   - Keep important content within safe area (80% of canvas)
   - The 20% padding prevents clipping on adaptive icons

4. **Screenshots**
   - Replace placeholder screenshots with actual app screenshots
   - Use screenshots that showcase key features
   - Follow PWA screenshot guidelines (aspect ratios, sizes)

## Contributing

Found a bug or have a feature request? Please open an issue on the [repository](https://github.com/laststance/claude-code-marketplace/issues).

## License

MIT License - See LICENSE file for details

## Author

**Laststance**
- Email: ryota.murakami@laststance.io
- GitHub: [@laststance](https://github.com/laststance)

## Related Resources

- [PWA Icons Guidelines](https://web.dev/add-manifest/#icons)
- [Maskable Icons](https://web.dev/maskable-icon/)
- [Web App Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)
