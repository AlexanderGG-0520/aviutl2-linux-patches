# 対話式setupのpackage manager対応

最終更新: 2026-08-02

`scripts/setup-aviutl2-interactive.fish`の依存関係導入は、x86_64 Linux上で次を自動検出する。

| distribution family | command | 状態 |
| --- | --- | --- |
| CachyOS / Arch Linux | `pacman` | 検証済みの正本 |
| Debian / Ubuntu | `apt-get` | package mapping実装済み、実機検証待ち |
| Fedora | `dnf` / `dnf5` | package mapping実装済み、実機検証待ち |

上記以外のpackage managerでは、自動導入を行わない。必要packageを手動導入した後、`--skip-dependencies`を使用する。

```fish
fish \
    scripts/setup-aviutl2-interactive.fish \
    --mode full \
    --skip-dependencies
```

## 共通方針

- host architectureは`x86_64`を必須とする。
- package managerはcommandの存在から自動判定する。
- 依存導入を拒否した場合でも処理は継続できるが、その後のcommand preflightで不足を非0終了にする。
- NVIDIA driver本体は自動で変更しない。
- Debian / UbuntuおよびFedoraでは、既存driverが64-bitと32-bitのNVIDIA/Vulkan userspace libraryを提供していることを前提とする。
- GPU driverの導入・repository追加はdistributionやdriver versionに依存するため、このscriptの責務外とする。

## pacman

CachyOS / Arch Linuxで実際に成功したpackage名を使用する。

主なruntime package:

```text
fish
libarchive
python-fonttools
noto-fonts-cjk
fcitx5
fcitx5-mozc
nvidia-utils
lib32-nvidia-utils
vulkan-icd-loader
lib32-vulkan-icd-loader
vulkan-tools
```

主なbuild package:

```text
base-devel
cmake
meson
ninja
nasm
mingw-w64-binutils
mingw-w64-crt
mingw-w64-gcc
mingw-w64-headers
mingw-w64-winpthreads
```

## apt-get

Debian / UbuntuではWineとDXVKに必要な32-bit Vulkan loaderのため、`i386` architectureを確認する。未設定の場合は利用者の確認後に次を実行する。

```text
dpkg --add-architecture i386
apt-get update
```

主な対応package:

```text
libarchive-tools
python3-fonttools
fonts-noto-cjk
fcitx5
fcitx5-mozc
libvulkan1
libvulkan1:i386
vulkan-tools
build-essential
meson
ninja-build
binutils-mingw-w64-x86-64
gcc-mingw-w64-x86-64
g++-mingw-w64-x86-64
mingw-w64-x86-64-dev
```

UbuntuでUniverseが無効な場合など、必要packageが現在のAPT sourceに存在しないと導入は失敗する。scriptはrepositoryを勝手に追加せず、利用者へ有効化を要求する。

## dnf / dnf5

Fedoraでは64-bitとi686のVulkan loaderを導入する。

主な対応package:

```text
bsdtar
python3-fonttools
google-noto-sans-cjk-fonts
fcitx5
fcitx5-mozc
vulkan-loader
vulkan-loader.i686
vulkan-tools
meson
ninja-build
pkgconf-pkg-config
mingw64-binutils
mingw64-gcc
mingw64-gcc-c++
mingw64-headers
mingw64-crt
mingw64-winpthreads-static
```

NVIDIA proprietary driverをRPM Fusionなどから導入する処理は行わない。

## Catalog / Lutris

Catalog modeも同じpackage manager検出を使用する。

| manager | package |
| --- | --- |
| pacman | `lutris fish python xdg-utils desktop-file-utils github-cli` |
| apt-get | `lutris fish python3 xdg-utils desktop-file-utils gh` |
| dnf / dnf5 | `lutris fish python3 xdg-utils desktop-file-utils gh` |

`--skip-dependencies`はfull setupとCatalog modeの両方でpackage導入を無効化する。

## 検証基準

package install commandの成功だけでは合格にしない。導入後にsetup scriptのcommand preflightを実行し、`fish`、`bsdtar`、`python3`、`meson`、`ninja`、`nasm`、`pkg-config`、`x86_64-w64-mingw32-gcc`などの実commandが解決できることを確認する。

Arch以外はpackage mappingの静的監査後、各distributionの実機で`--mode full`を完走して初めて実機検証済みへ昇格させる。
