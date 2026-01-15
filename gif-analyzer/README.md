# GIF Analyzer Plugin

Analyze animated GIF files by extracting frames and viewing them as sequential video.

## Overview

This Claude Code plugin enables analysis of animated GIFs by extracting individual frames with timing metadata. It interprets GIF animations as video sequences, allowing Claude to understand motion, changes, and temporal content in screen recordings and animations.

## Features

- **Frame Extraction**: Extract all frames from animated GIFs as PNG images
- **Temporal Metadata**: Track frame timing for accurate analysis
- **Video Interpretation**: Treat frame sequences as continuous video
- **Flexible Sampling**: Skip frames or limit extraction for long GIFs
- **Screen Recording Analysis**: Perfect for analyzing UI demos and screen captures

## Installation

Install this plugin from the Laststance marketplace:

```bash
# Add marketplace (first time only)
/plugin marketplace add https://github.com/laststance/claude-code-marketplace

# Install plugin
/plugin install gif-analyzer@laststance
```

## Usage

### Basic Analysis

```bash
/gif ./animation.gif
```

### With Specific Question

```bash
/gif ./demo.gif describe what happens step by step
/gif ./screen.gif what buttons are clicked?
/gif ./ui-flow.gif summarize this screen recording
```

### Script Options

For direct script usage:

```bash
# Basic extraction
python3 scripts/extract_gif_frames.py animation.gif --output-dir ./frames

# Long GIF (skip frames)
python3 scripts/extract_gif_frames.py long_video.gif --skip 3 --max-frames 30
```

| Option | Description | Default |
|--------|-------------|---------|
| `--output-dir`, `-o` | Output directory for frames | `./gif_frames_<timestamp>` |
| `--max-frames`, `-m` | Maximum frames to extract | 50 |
| `--skip`, `-s` | Extract every Nth frame | 1 (all frames) |

## Output

### Extracted Files

```
output-directory/
├── frame_001.png
├── frame_002.png
├── frame_003.png
├── ...
└── gif_metadata.json
```

### Metadata JSON

The `gif_metadata.json` file contains:

```json
{
  "source_filename": "demo.gif",
  "resolution": { "width": 800, "height": 600 },
  "total_frames_in_gif": 120,
  "extracted_frames_count": 50,
  "total_duration_s": 5.0,
  "frames": [
    {
      "frame_number": 1,
      "filename": "frame_001.png",
      "duration_ms": 100,
      "timestamp_display": "0.00s"
    }
  ]
}
```

## Use Cases

### Screen Recordings
Analyze UI demos, bug reproductions, and feature demonstrations captured as GIFs.

### Animation Review
Understand frame-by-frame content of animated graphics and illustrations.

### Motion Analysis
Track movement, transitions, and changes over time in animated content.

### Tutorial Analysis
Extract key steps from animated tutorials or how-to guides.

## Requirements

- Python 3.6 or higher
- Pillow library (`pip install Pillow`)

## Troubleshooting

### Pillow Not Found
```bash
pip install Pillow
```

### Too Many Frames
Use frame skipping for long GIFs:
```bash
python3 scripts/extract_gif_frames.py long.gif --skip 3
```

### Large Output Size
Limit maximum frames:
```bash
python3 scripts/extract_gif_frames.py huge.gif --max-frames 20
```

### Memory Issues
Combine skip and max-frames for very large GIFs:
```bash
python3 scripts/extract_gif_frames.py massive.gif --skip 5 --max-frames 30
```

## How It Works

1. **Frame Extraction**: Uses Pillow to read GIF frames
2. **RGBA Conversion**: Converts all frames to consistent RGBA format
3. **Timing Capture**: Records frame duration and cumulative timestamps
4. **Sequential Naming**: Names frames in chronological order (001, 002, ...)
5. **Metadata Generation**: Creates JSON with complete timing information

## Contributing

Found a bug or have a feature request? Please open an issue on the [repository](https://github.com/laststance/claude-code-marketplace/issues).

## License

MIT License - See LICENSE file for details

## Author

**Laststance**
- Email: ryota.murakami@laststance.io
- GitHub: [@laststance](https://github.com/laststance)

## Related Resources

- [Pillow Documentation](https://pillow.readthedocs.io/)
- [GIF Format Specification](https://www.w3.org/Graphics/GIF/spec-gif89a.txt)
