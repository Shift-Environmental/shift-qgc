#!/bin/bash

set -e

QT_VERSION=5.15.2
INSTALL_DIR="$HOME/Qt$QT_VERSION"
SRC_DIR="$HOME/dev/qt5src"
QT5_REPO_DIR="$SRC_DIR/qt5"
BUILD_DIR="$HOME/dev/qt5-build"

echo ">>> [WSL] Installing required dependencies..."
sudo apt update
sudo apt install -y build-essential perl python-is-python3 git \
  '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev \
  libxi-dev libxrandr-dev libxext-dev libxcursor-dev libxfixes-dev \
  libxinerama-dev libxkbcommon-dev libfontconfig1-dev libfreetype6-dev \
  libssl-dev libpng-dev libjpeg-dev libglib2.0-dev libdbus-1-dev

echo ">>> Cleaning old Qt build..."
rm -rf "$INSTALL_DIR" "$BUILD_DIR" "$SRC_DIR"

echo ">>> Cloning Qt $QT_VERSION from source..."
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"
git clone https://code.qt.io/qt/qt5.git
cd qt5
git checkout "v$QT_VERSION"

echo ">>> Initializing submodules..."
perl init-repository --module-subset=default,qtlocation,qtserialport,qtwebsockets

echo ">>> Patching for GCC compatibility..."
QFLOAT_HEADER="$QT5_REPO_DIR/qtbase/src/corelib/global/qfloat16.h"
if ! grep -q "#include <limits>" "$QFLOAT_HEADER"; then
  echo ">>> Patching qfloat16.h"
  sed -i '1i #include <limits>' "$QFLOAT_HEADER"
fi

QBYTEARRAY_MATCHER_HEADER="$QT5_REPO_DIR/qtbase/src/corelib/text/qbytearraymatcher.h"
if ! grep -q "#include <limits>" "$QBYTEARRAY_MATCHER_HEADER"; then
  echo ">>> Patching qbytearraymatcher.h"
  sed -i '1i #include <limits>' "$QBYTEARRAY_MATCHER_HEADER"
fi

echo ">>> Creating native WSL build directory..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo ">>> Configuring Qt (out-of-source build, WSL-safe)..."
"$QT5_REPO_DIR/configure" -top-level -prefix "$INSTALL_DIR" \
  -opensource -confirm-license -c++std c++11 \
  -platform linux-g++-64 \
  -nomake tests -nomake examples \
  -skip qt3d -skip qtcanvas3d -skip qtdatavis3d -skip qtvirtualkeyboard \
  -skip qtwebengine -skip qtwebview -skip qtpurchasing

echo ">>> Building Qt $QT_VERSION..."
make -j"$(nproc)"

echo ">>> Installing Qt to $INSTALL_DIR..."
make install

# Add to shell
SHELL_RC="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
fi

if ! grep -q "Qt$QT_VERSION" "$SHELL_RC"; then
  echo ">>> Adding Qt to $SHELL_RC"
  {
    echo ""
    echo "# Qt $QT_VERSION"
    echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\""
    echo "export LD_LIBRARY_PATH=\"$INSTALL_DIR/lib:\$LD_LIBRARY_PATH\""
  } >> "$SHELL_RC"
fi

echo ""
echo "✅ Qt $QT_VERSION installed to: $INSTALL_DIR"
echo "🔁 Run: source $SHELL_RC"
echo "🔍 Test with: $INSTALL_DIR/bin/qmake --version"
