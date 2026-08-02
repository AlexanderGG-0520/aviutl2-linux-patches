# AviUtl2 Linux Patches

AviUtl2 2.1.3をx86_64 Linux上で動かすための互換パッチ、build script、診断手順、対話式setupを収録しています。

主な構成は次のとおりです。

```text
AviUtl2 2.1.3
  + GE-Proton 11-1 / wine-staging 11.0
  + patched DXVK 2.7.1
  + patched Wine DirectWrite
  + custom L-SMASH Works r1284
  + Fcitx5 / Mozc
  + 公式AviUtl2 Catalog
```

AviUtl2本体や第三者製プラグインは再配布しません。setup時に公式配布物を取得し、必要な互換レイヤーをローカルでbuild・配置します。

## 現在の動作状況

CachyOS、NVIDIA GPU、GE-Proton 11-1の環境で次を実機確認しています。

- AviUtl2 2.1.3の起動
- DXVKの`DXGI_FORMAT_G8R8_G8B8_UNORM`（format 69）問い合わせ回避
- 日本語UIの表示
- Fcitx5 / Mozcによる日本語入力、変換、確定
- 同じtext objectへの再進入
- 2回目の編集状態での複数回のcaret移動
- 2回目の日本語入力、変換、確定
- 「プラグインを信頼する」操作後の継続動作
- L-SMASH WorksによるAV1入力、再生、シーク
- NVIDIA NVDECとhardware frame transfer
- 公式AviUtl2 Catalogの起動とプラグイン導入
- 固定wrapperを使ったLutris Linux Runnerからの起動

診断合格時は、使用したpatched DWriteと診断ログのSHA-256を含む`GUI-VERIFIED` markerを生成します。初回入力だけでは合格せず、同じtext objectの2回目再編集まで確認します。

## 重要な修正

### DXVK

AviUtl2がformat 69を照会し、対応するVulkan formatが`VK_FORMAT_UNDEFINED`となる場合の起動失敗を回避します。

パッチは次の条件へ限定しています。

- 実行ファイルが`aviutl2.exe`
- 問い合わせ対象がformat 69
- Vulkan mappingが`VK_FORMAT_UNDEFINED`

### Wine DirectWrite

AviUtl2のtext編集に必要な次のhit-test処理を実装・安定化しています。

- `IDWriteTextLayout::HitTestPoint()`
- `IDWriteTextLayout::HitTestTextPosition()`
- `IDWriteTextLayout::HitTestTextRange()`

文字位置に対応するeffective runやclusterが存在しない場合は、最寄りrunを使ったsynthetic caretへfallbackします。これにより、初回入力後に同じtext objectへ再進入してcaret位置を選択した際の`HRESULT 0x80004005`を回避します。

DWrite artifactの再利用時は、Wine commit、baseline blob、各patchのSHA-256、DLLのSHA-256、`PROVENANCE.txt`を照合します。古い中間buildを最新artifactとして再利用しません。

### L-SMASH Works / NVDEC

L-SMASH Works r1284を再現buildし、FFmpegのhardware frameを出力前にCPU側frameへ転送します。

```c
av_hwframe_transfer_data()
```

custom artifactはCatalogの一括更新で上書きされないよう、対象packageの更新停止と配置後の`cmp`検証を行います。

## 最短セットアップ

```bash
git clone https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git
cd aviutl2-linux-patches
fish scripts/setup-aviutl2-interactive.fish --mode full
```

対話式setupは次を順に処理します。

1. 依存関係の導入とcommand preflight
2. stock GE-Protonの取得
3. patched DWriteのclean build
4. AviUtl2専用runnerの作成
5. patched DXVKのbuild
6. font、NVIDIA wrapper、L-SMASH Worksの準備
7. Wine prefixの構築とpayload配置
8. registry、DLL override、IME設定
9. 診断起動
10. GUI、text再編集、Mozcの手動確認

stockの`GE-Proton11-1`は直接変更せず、AviUtl2専用runnerを別directoryへ作成します。置換対象はPE版の、

```text
files/lib/wine/x86_64-windows/dwrite.dll
```

だけです。`dwrite.so`は置換しません。

## 実行mode

| mode | 内容 |
| --- | --- |
| `full` | artifact build、prefix配置、診断起動 |
| `artifacts` | DWrite、DXVK、L-SMASH Worksなどのartifact作成 |
| `deploy` | 作成済みartifactをprefixへ配置 |
| `validate` | 現在のruntime、artifact、設定を検証 |
| `diagnose` | Section 13相当のログ付き診断起動 |
| `launch` | 検証済み環境を通常起動 |
| `catalog` | 公式AviUtl2 CatalogとLutrisの固定wrapperを設定 |

例:

```fish
fish scripts/setup-aviutl2-interactive.fish --mode diagnose
fish scripts/setup-aviutl2-interactive.fish --mode catalog
```

依存関係を手動導入済みの場合:

```fish
fish scripts/setup-aviutl2-interactive.fish \
    --mode full \
    --skip-dependencies
```

## 対応package manager

| distribution family | manager | 状態 |
| --- | --- | --- |
| CachyOS / Arch Linux | `pacman` | 実機検証済み |
| Debian / Ubuntu | `apt-get` | package mapping実装済み、実機完走待ち |
| Fedora | `dnf` / `dnf5` | package mapping実装済み、実機完走待ち |

NVIDIA driver本体やdistribution固有repositoryは自動変更しません。Arch以外では、既存driverが必要な64-bit / 32-bit Vulkan userspace libraryを提供していることを前提とします。

詳細は[`docs/PACKAGE-MANAGERS.md`](docs/PACKAGE-MANAGERS.md)を参照してください。

## 公式AviUtl2 CatalogとLutris

このprojectはCatalogをLinux向けに再実装せず、公式Windows版AviUtl2 Catalogを検証済みWine環境で動かします。

```text
Lutris Linux Runner
  -> 固定ローカルwrapper
    -> 検証済みprefix
    -> patched GE-Proton
    -> custom DXVK設定
```

LutrisにはWine runnerや新規prefixの作成を任せません。AviUtl2とCatalogのwrapper単体起動、Catalog GUI確認、URL handler再登録が成功した後だけLutris登録へ進みます。

```fish
fish scripts/setup-aviutl2-interactive.fish --mode catalog
```

詳細は[`docs/LUTRIS-CATALOG.md`](docs/LUTRIS-CATALOG.md)を参照してください。

## 検証範囲と注意

現在の主な実機確認対象はCachyOSとNVIDIA GPUです。次は未検証または限定的です。

- AMD GPU
- Intel GPU
- GE-Proton 11-1以外
- DXVK 2.7.1以外
- Debian / Ubuntu / Fedoraでのfull setup完走
- すべてのcodec、pixel format、IME、desktop environment

「元環境で動いたこと」と「すべての環境で再現できること」は区別しています。失敗を成功扱いせず、artifact、runtime、診断ログ、GUI確認を段階的にgateします。

## Documentation

| 文書 | 内容 |
| --- | --- |
| [`docs/INSTALLATION.md`](docs/INSTALLATION.md) | 現行の構築・配置・診断手順の正本 |
| [`docs/PACKAGE-MANAGERS.md`](docs/PACKAGE-MANAGERS.md) | package manager別の依存関係 |
| [`docs/DWRITE-CLEAN-BUILD.md`](docs/DWRITE-CLEAN-BUILD.md) | patched DWriteのclean build |
| [`docs/LUTRIS-CATALOG.md`](docs/LUTRIS-CATALOG.md) | 公式CatalogとLutris固定wrapper |
| [`docs/REPRODUCTION.md`](docs/REPRODUCTION.md) | 再現手順と停止条件 |
| [`docs/STATUS.md`](docs/STATUS.md) | 環境別の進捗記録 |
| [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) | 実際に発生した問題の切り分け |
| [`docs/TECHNICAL-NOTES.md`](docs/TECHNICAL-NOTES.md) | DXVK、DWrite、L-SMASH Worksの技術説明 |

主要な正本script:

```text
scripts/setup-aviutl2-interactive.fish
scripts/build-dwrite-clean.fish
scripts/launch-aviutl2.fish
scripts/manage-aviutl2-catalog-lutris.sh
scripts/install-l-smash-works-nvdec.fish
```

## License

このrepositoryのscript、patch、documentationは[`MIT License`](LICENSE)です。

AviUtl2本体、GE-Proton、Wine、DXVK、L-SMASH Works、AviUtl2 Catalog、各pluginの権利とlicenseは、それぞれの作者・projectに帰属します。
