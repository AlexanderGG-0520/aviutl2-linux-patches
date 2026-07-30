# AviUtl2 on Linux — 最終進捗サマリー

最終確認日: 2026-07-31

関連リポジトリ:

- https://github.com/AlexanderGG-0520/aviutl2-linux-patches

## 結論

CachyOS 上で、GE-Proton 11-1、DXVK 2.7.1、NVIDIA NVDEC、Fcitx5/Mozc を組み合わせ、AviUtl2 を実用可能な状態まで動作させた。

今回解決した範囲は、単なる起動だけではない。

- AviUtl2 の起動
- AV1 動画の読み込み
- AV1 の再生
- シーク
- NVIDIA NVDEC を使ったハードウェアデコード
- テキスト編集状態への移行
- IME を有効にした状態での編集
- AviUtl2 Catalog の同一 Wine prefix 内での利用
- Catalog 更新後に消えた独自 L-SMASH Works の復旧

パッチ、設定例、導入補助スクリプト、技術メモは次のリポジトリへ整理した。

- `AlexanderGG-0520/aviutl2-linux-patches`

## 検証環境

| 項目 | 検証値 |
| --- | --- |
| OS | CachyOS |
| GPU | NVIDIA GeForce RTX 4060 Ti 8 GB |
| NVIDIA Driver | 610.43.3 |
| Wine/Proton | GE-Proton 11-1 / wine-staging 11.0 |
| DXVK | 2.7.1 |
| 入力メソッド | Fcitx5 + Mozc |
| AviUtl2 prefix | `~/Games/aviutl2/prefix-ge-nvdec-test` |
| パッチ済み GE-Proton | `~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test` |
| AviUtl2 | `C:\AviUtl2` |
| プラグインデータ | `C:\ProgramData\aviutl2` |

別の Wine、GE-Proton、DXVK、GPU、ドライバ、IME、デスクトップ環境で同じ結果になることまでは確認していない。

## 最終構成

```text
Lutris
└── Linux Runner
    └── 起動ラッパー
        ├── GE-Proton11-1-aviutl2-test
        ├── prefix-ge-nvdec-test
        ├── patched DXVK
        ├── patched Wine DWrite
        ├── patched L-SMASH Works
        └── AviUtl2 / AviUtl2 Catalog
```

Lutris の Wine Runner に Wine や DXVK の選択を任せず、Linux Runner から固定した GE-Proton と prefix を起動する構成にした。これにより、Lutris や UMU の自動更新・自動選択で検証済み環境から外れることを避ける。

## 解決した問題

### 1. DXVK の D3D11 format 69 判定で AviUtl2 が停止

AviUtl2 は D3D11 の `CheckFormatSupport()` で DXGI format ID 69 を照会する。

DXVK 側の応答を AviUtl2 が受け入れられず、起動処理が停止したため、次のパッチを作成した。

```text
patches/dxvk/0001-aviutl2-format-support.patch
```

このパッチにより、対象フォーマットの問い合わせを AviUtl2 が処理可能な形へ調整した。

### 2. NVDEC のハードウェアフレームをそのまま出力できない

FFmpeg の `av1_cuvid` が返すフレームは GPU 側のハードウェアフレームだった。

既存の L-SMASH Works 出力処理は CPU から参照できる通常フレームを前提としていたため、出力前に次を実行するパッチを追加した。

```c
av_hwframe_transfer_data()
```

パッチ:

```text
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

最終設定では LW-Libav 経路を使い、AV1 の優先デコーダを `av1_cuvid` にした。

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

### 3. テキスト選択時に `HitTestTextRange()` が `E_NOTIMPL`

AviUtl2 の選択範囲描画処理が DirectWrite の次のメソッドを呼び出した。

```text
IDWriteTextLayout::HitTestTextRange()
```

GE-Proton 11-1 の Wine 実装は `E_NOTIMPL` を返し、AviUtl2 はこれを致命的エラーとして停止した。

Wine DWrite へ実装を追加して、この段階を通過させた。

### 4. 編集開始時に `HitTestPoint()` が `E_NOTIMPL`

`HitTestTextRange()` を実装した後、次は編集状態へ入るときに停止した。

```text
IDWriteTextLayout::HitTestPoint()
```

最終実装では、Wine 側で動作していた `HitTestTextPosition()` を利用し、各テキストメトリクスから最寄りクラスタを選択する形で `HitTestPoint()` を実装した。

Wine パッチ:

```text
patches/wine/0001-implement-dwrite-hit-testing.patch
```

これにより、AviUtl2 のテキスト編集状態へ入れるようになった。

### 5. IME が原因に見えたが、実際は DirectWrite の未実装

次の経路を比較した。

- Fcitx5/Mozc + Wine XIM
- `XMODIFIERS=@im=none`
- XIM `overthespot`
- Wine native Wayland

XIM を無効化するとクラッシュしなかったため、当初は IME 経路が原因に見えた。

しかし、X11 と native Wayland の両方で同じ DirectWrite エラーへ到達した。根本原因は XIM ではなく、AviUtl2 が呼び出す DWrite ヒットテストメソッドが Wine で未実装だったことだった。

## ビルド時に判明した重要事項

### `make dlls/dwrite` は再ビルドにならない場合がある

`dlls/dwrite` は実在するディレクトリでもあるため、Make が完了済みターゲットとして扱い、何も行わないことがある。

### `make -B` は使用しない

`-B` は Wine の configure まで強制的に再実行し、今回の変更と無関係な依存関係で停止した。

### 正しい DWrite 再ビルド

対象オブジェクトと DLL を削除し、PE DLL の完全なターゲット名を指定する。

```fish
rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

## AviUtl2 Catalog

AviUtl2 Catalog は同じ Wine prefix へインストールし、次の設定で管理した。

```text
AviUtl2 root:
C:\AviUtl2

Portable mode:
無効
```

非ポータブルモードでは、プラグインとスクリプトは次へ配置される。

```text
C:\ProgramData\aviutl2
```

Linux 側では次に対応する。

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/ProgramData/aviutl2
```

## Catalog 更新で L-SMASH Works が消えた件

AviUtl2 Catalog で L-SMASH Works を更新すると、独自ビルドの `lwinput.aui2` が公式配布版で上書きされた。

その結果、NVDEC ハードウェアフレーム転送パッチが消えた。

復旧時は次を行った。

1. Catalog から公式 L-SMASH Works をインストール
2. 独自ビルド済み `lwinput.aui2` で上書き
3. `lsmash.ini` を NVDEC 用設定へ復元
4. AV1 の読み込み、再生、シークを再確認

今後 Catalog で L-SMASH Works を更新した場合も、同じ復旧が必要になる。更新を止められる場合は、L-SMASH Works を更新対象外または一時停止にする。

## 最終的に確認できた機能

- AviUtl2 が起動する
- DXVK の format 69 問題を通過する
- AV1 を読み込める
- AV1 を再生できる
- シークできる
- `av1_cuvid` を使用できる
- NVDEC のハードウェアフレームを CPU 側フレームへ転送できる
- テキスト選択処理が `E_NOTIMPL` で停止しない
- テキスト編集状態へ入れる
- Fcitx5/Mozc を有効にした状態で編集できる
- AviUtl2 Catalog を同じ prefix で利用できる
- Catalog 更新後に独自 L-SMASH Works を復旧できる

## 未検証・保証外

- AMD GPU
- Intel GPU
- GE-Proton 11-1 以外
- DXVK 2.7.1 以外
- NVIDIA driver 610.43.3 以外
- すべての動画コーデックとピクセルフォーマット
- すべての IME
- すべてのデスクトップ環境
- Windows ネイティブ環境との完全な挙動一致

## 成果物

リポジトリには次を収録している。

```text
patches/dxvk/0001-aviutl2-format-support.patch
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
patches/wine/0001-implement-dwrite-hit-testing.patch
config/nvidia-dxvk.conf
config/lsmash.ini
scripts/install-dwrite.fish
scripts/launch-aviutl2.example.fish
docs/STATUS.md
docs/TECHNICAL-NOTES.md
docs/TROUBLESHOOTING.md
```

AviUtl2、Wine、GE-Proton、DXVK、L-SMASH Works、FFmpeg、NVIDIA のバイナリ本体は配布していない。

## 完了判定

このプロジェクトは、2026-07-31 時点の検証環境について「完了」とする。

今後の作業は、新機能の追加ではなく、上流更新への追従、別環境への移植、再現手順の改善として扱う。
