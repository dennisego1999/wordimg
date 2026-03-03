# wordimg

A simple CLI tool to extract and resize images from Microsoft Word (.docx) files.

`wordimg` extracts all embedded images from a Word document and resizes them to a specified dimension using ImageMagick.

---

## ✨ Features

- Extracts all images from `.docx` files
- Resize using `contain` or `cover` fit modes
- Supports transparent backgrounds (`--background none`)
- Optional preservation of original extracted images
- Clean CLI output with colored status messages
- Fails safely with clear error messages

---

## 📦 Requirements

- macOS or Linux
- `unzip`
- ImageMagick (`magick` command)

Install ImageMagick on macOS:

```bash
brew install imagemagick
```

---

## 🚀 Installation

Clone the repository:

```bash
git clone git@github.com:dennisego1999/wordimg.git
cd wordimg
```

Make the script executable:

```bash
chmod +x wordimg
```

(Optional) Move it to your bin directory:

```bash
mv wordimg ~/bin/
```

Make sure `~/bin` is in your PATH.

---

## 🧰 Usage

```bash
wordimg --file FILE.docx --output OUTPUT_DIR [options]
```

### Options

| Flag | Description |
|------|-------------|
| `--file` | Source `.docx` file |
| `--output` | Output directory |
| `--size` | Target dimension in pixels (default: 1024) |
| `--background` | Background color (default: white, use `none` for transparency) |
| `--fit` | Resize mode: `contain` (default) or `cover` |
| `--keep` | Save extracted originals in `_originals` subfolder |
| `--help` | Show help message |

---

## 📐 Fit Modes

### `contain` (default)
Preserves full image content. Pads with background color if necessary.

Equivalent to CSS:
```css
object-fit: contain;
```

### `cover`
Fills the entire target size. Crops overflow if needed.

Equivalent to CSS:
```css
object-fit: cover;
```

---

## 🧪 Example

Resize all images to 1000x1000 while keeping transparency and originals:

```bash
wordimg \
  --file ./file.docx \
  --output ./processed \
  --size 1000 \
  --background none \
  --fit contain \
  --keep
```

Result:

```
processed/
├── image1.png
├── image2.jpg
└── _originals/
    ├── image1.png
    └── image2.jpg
```

---

## 🛑 Error Handling

If extraction or resizing fails, the script:

- Stops immediately
- Prints a clear red error message
- Does not continue to the next step
