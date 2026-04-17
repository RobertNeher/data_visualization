# 📈 Market Visualizer: Bar Chart Race

A high-performance, visually stunning Flutter application that transforms static data into dynamic, animated "Bar Chart Race" visualizations. Built with glassmorphism aesthetics and smooth reordering logic.

![Premium Design Focus](https://img.shields.io/badge/Design-Premium-blueviolet?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Material 3](https://img.shields.io/badge/Material%203-M3-green?style=for-the-badge)

## ✨ Key Features

- **🚀 Dynamic Bar Chart Race**: Smooth reordering and value-based resizing animations using `AnimatedPositioned` and `AnimatedContainer`.
- **💎 Premium Glassmorphic UI**: Modern design language featuring backdrop filters, sophisticated blurs, and vibrant gradients.
- **⚡ Real-time Stream Support**: Leverages `StreamBuilder` for fluid, real-time data updates without UI stutter.
- **📁 Asset-Driven Config**: Easily customizable through `assets/data.json` for different visualization scenarios.
- **🎨 Rich Media**: Full SVG support for high-quality branding and icons.

## 🛠️ Tech Stack

- **Flutter / Dart**: Core framework.
- **Material 3**: For a modern, native look and feel.
- **flutter_svg**: Vector graphics rendering.
- **flutter_markdown_plus**: Professional text formatting for titles and subtitles.
- **gen_data**: Proprietary data generation layer for logic consistency.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code with Flutter extension

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo/data_viz.git
   cd data_viz
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

## ⚙️ Configuration

You can customize the visualization by editing `assets/data.json`. The structure supports:

- `title`: Main visualization title (HTML/Markdown supported).
- `subtitle`: Descriptive subtitle.
- `dataStrips`: Array of bar configurations including:
  - `title`: Name of the entity.
  - `startValue` / `endValue`: Data range.
  - `color`: Hex color for the theme.
  - `iconUrl`: SVG URL for the entity logo.

---

*Developed with ❤️ using Flutter.*
