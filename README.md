# wordimg

A lightweight CLI tool to extract and resize images from Microsoft Word (.docx) files.

`wordimg` extracts embedded images from a Word document and resizes them using ImageMagick with support for `contain` and `cover` fit modes.

---

## Features

- Extract all images from `.docx` files
- Resize to any square or custom dimension
- `contain` and `cover` fit modes (like CSS `object-fit`)
- Optional background color (supports transparency)
- Optional preservation of original extracted images
- Clean CLI output with proper error handling
- Stops immediately on failure

---

## Requirements

- macOS or Linux
- `unzip`
- ImageMagick (`magick` command)

Install ImageMagick on macOS:

```bash
brew install imagemagick
```

---

## Installation

Clone the repository:

```bash
git clone git@github.com:dennisego1999/wordimg.git
cd wordimg
```

Run the installer:

```bash
./install.sh
```

If installing to a system directory such as `/usr/local/bin`

You may be prompted for your password.
If required, run:

```bash
sudo ./install.sh
```

### What the installer does

The `install.sh` script:

1. Locates the executable in `bin/`
2. Detects a suitable install location:
   - `~/.local/bin`
   - or `/usr/local/bin`
3. Copies the executable to the selected directory
4. Ensures it is executable
5. Checks whether the install directory is in your `PATH`
6. Prints instructions if you need to update your `PATH`

The installer **does not automatically modify your shell configuration**, following standard Unix CLI conventions.  
If the install directory is not in your PATH, add the following line to your `~/.zshrc` or `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

> **Note:** After installation, the cloned repository is no longer needed. You can safely delete the folder — the `wordimg` command will continue to work because the executable has been copied to a directory in your PATH.

---

After installation, you can verify:

```bash
wordimg --help
```

---

## Usage

```bash
wordimg --file FILE.docx --output OUTPUT_DIR [options]
```

### Options

| Flag | Description |
|------|-------------|
| `--file` | Source `.docx` file |
| `--output` | Output directory |
| `--size` | Target dimension in pixels. Can be a single number for square (e.g., 1000) or WxH for custom size (e.g., 1000x500) |
| `--background` | Background color (default: white, use `none` for transparency) |
| `--fit` | Resize mode: `contain` (default) or `cover` |
| `--keep` | Save extracted originals in `_originals` subfolder |
| `--help` | Show help message |

---

## 📐 Fit Modes

### contain (default)

Preserves full image content. Pads with background color if necessary.

Equivalent to:

```css
object-fit: contain;
```

---

### cover

Fills the entire target size. Crops overflow if necessary.

Equivalent to:

```css
object-fit: cover;
```

---

## Example

Resize images to 1000x1000, preserve transparency, and keep originals:

```bash
wordimg \
  --file ./file.docx \
  --output ./processed \
  --size 1000 \
  --background none \
  --fit contain \
  --keep
```

Output:

```
processed/
├── image1.png
├── image2.jpg
└── _originals/
    ├── image1.png
    └── image2.jpg
```

---

## Error Handling

If extraction or resizing fails:

- The script stops immediately
- A clear red error message is displayed
- No further steps are executed

---

## License

MIT License

---

## Author

Dennis Ego  
GitHub: https://github.com/dennisego1999
