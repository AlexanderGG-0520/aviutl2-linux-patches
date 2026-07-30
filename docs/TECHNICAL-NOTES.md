# Technical Notes

最終更新日: 2026-07-31

## DXVK: D3D11 format 69

AviUtl2 は `ID3D11Device::CheckFormatSupport()` を通じて、次のフォーマットを照会する。

```text
DXGI_FORMAT_G8R8_G8B8_UNORM
format ID: 69
```

DXVK 側で対応する Vulkan format が `VK_FORMAT_UNDEFINED` となる環境では、AviUtl2 が起動処理を継続できなかった。

パッチは、少なくとも次の条件へ限定する設計である。

- 実行ファイル名が `aviutl2.exe`
- 問い合わせ対象が format 69
- Vulkan mapping が `VK_FORMAT_UNDEFINED`

正常な Vulkan mapping が存在する場合や、他アプリでは通常処理を維持する。

パッチ:

```text
patches/dxvk/0001-aviutl2-format-support.patch
```

注意:

元環境では変更済み `d3d11.dll` の動作を確認しているが、2026-07-31 の別環境では配布パッチがクリーンソースへ適用できていない。
パッチの実装意図と、パッチファイルの再現性は別に評価する。

## Wine DirectWrite

AviUtl2 のテキスト操作では、次のメソッドが必要になる。

```text
IDWriteTextLayout::HitTestTextRange()
IDWriteTextLayout::HitTestPoint()
IDWriteTextLayout::HitTestTextPosition()
```

### `HitTestTextRange()`

テキスト選択範囲の描画時に呼び出される。
Wine が `E_NOTIMPL` を返すと、AviUtl2 は処理を継続できなかった。

### `HitTestPoint()`

編集状態へ入る際の座標から文字位置への変換で使用される。
元の Wine 実装では `E_NOTIMPL` だった。

最終実装では、既存の `HitTestTextPosition()` を利用し、テキストメトリクスと距離から適切な位置を選択する。

### `HitTestTextPosition()` の失敗位置

一部の位置で `E_FAIL` が返る場合、その位置を無条件に採用すると AviUtl2 側の処理が停止する。
追加安定化では、失敗位置をスキップする。

パッチ:

```text
patches/wine/0001-implement-dwrite-hit-testing.patch
```

## IME の切り分け

比較した経路:

- Fcitx5/Mozc + Wine XIM
- `XMODIFIERS=@im=none`
- XIM `overthespot`
- Wine native Wayland

XIM を無効化すると症状が変化したため、当初は IME が原因に見えた。
しかし、X11 と native Wayland の両方で DirectWrite の未実装へ到達した。

元環境での結論:

```text
根本原因: Wine DirectWrite のヒットテスト未実装
IME: クラッシュ経路を表面化させたが、根本原因ではない
```

## L-SMASH Works / NVDEC

FFmpeg の `av1_cuvid` が返すフレームは、GPU 側の hardware frame である。
既存の L-SMASH Works 出力処理は、CPU から直接参照できる通常フレームを前提としていた。

そのため、出力前に次を使用して CPU 側フレームへ転送する。

```c
av_hwframe_transfer_data()
```

パッチ:

```text
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

設定:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

## DLL override

元環境の値:

```text
nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b
```

意味:

- NVIDIA CUDA / NVDEC / NVENC DLL は native
- DXVK の D3D DLL は native 優先、builtin fallback
- `dwrite` は patched builtin を使用

## 非ポータブル構成

AviUtl2 本体:

```text
C:\AviUtl2
```

プラグイン・設定:

```text
C:\ProgramData\aviutl2
```

本体ディレクトリ内の `data` を使用しない。
この分離により、本体 ZIP の更新とプラグイン管理を分ける。

## 再現性上の問題

現時点で、次の3点は完全自動化されていない。

1. DXVK パッチがクリーンな DXVK 2.7.1 へ確実に適用できることの CI 検証
2. MinGW Vulkan-Headers の導入
3. L-SMASH Works 用 MinGW 静的依存関係一式の構築

これらが解決するまで、元環境での動作確認とクリーン環境での再現確認を区別する。
