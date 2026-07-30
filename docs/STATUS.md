# Status

最終更新日: 2026-07-31

## 結論

AviUtl2 は、元の CachyOS 環境では次の構成で実用可能な状態まで動作している。

- GE-Proton 11-1 / wine-staging 11.0
- DXVK 2.7.1 の AviUtl2 format 69 対策
- Wine DirectWrite のヒットテスト実装
- NVIDIA NVDEC
- L-SMASH Works の hardware frame transfer
- Fcitx5 + Mozc
- AviUtl2 Catalog

ただし、2026-07-31 時点では、**別ユーザーのクリーン環境でソースから最後まで再現できた状態ではない**。
そのため、このリポジトリを「完全に再現確認済み」とは扱わない。

## 元環境で確認済み

| 項目 | 結果 |
| --- | --- |
| AviUtl2 起動 | 確認済み |
| DXVK format 69 回避 | 確認済み |
| AV1 読み込み | 確認済み |
| AV1 再生 | 確認済み |
| シーク | 確認済み |
| `av1_cuvid` | 確認済み |
| NVDEC hardware frame transfer | 確認済み |
| テキスト選択 | 確認済み |
| テキスト編集状態への移行 | 確認済み |
| Fcitx5 / Mozc 入力・変換・確定 | 確認済み |
| AviUtl2 Catalog | 確認済み |
| Catalog 更新後の L-SMASH Works 復旧 | 確認済み |

## 元環境の固定値

| 項目 | 値 |
| --- | --- |
| OS | CachyOS |
| GPU | NVIDIA GeForce RTX 4060 Ti 8 GB |
| NVIDIA Driver | 610.43.3 |
| GE-Proton | 11-1 |
| Wine | wine-staging 11.0 |
| DXVK | 2.7.1 |
| AviUtl2 | 2.1.2 |
| IME | Fcitx5 + Mozc |
| Prefix | `~/Games/aviutl2/prefix-ge-nvdec-test` |
| Patched GE-Proton | `~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test` |
| L-SMASH Works base | `a47764915f06fcd472e26ba2fbf25aff4b9d252e` |
| L-SMASH patch commit | `393df5ef669707f776261e4ac1bcc7e9a9a227ab` |
| DXVK base | `c3dd74be6baec53786d4e064a572185b70347a17` (`v2.7.1`) |
| Wine source base | `31af7f983b2e345d11340b120ae3a39d88c9338a` |

## 別環境での再現状況

対象:

```text
/home/nanashi/Games/aviutl2
```

2026-07-31 時点の状態:

| 項目 | 状態 |
| --- | --- |
| リポジトリ取得 | 実施中または完了 |
| GE-Proton 複製 | 手順確認中 |
| AviUtl2 ZIP 直接配置 | 手順は作成済み、最終確認未完了 |
| DXVK パッチ適用 | 失敗 |
| DXVK Meson configure | `Missing Vulkan-Headers` で失敗 |
| DXVK DLL 生成 | 未実施 |
| Prefix への DXVK 導入 | 未実施 |
| Wine DWrite ビルド・導入 | 未実施 |
| L-SMASH Works NVDEC 導入 | 未実施 |
| AviUtl2 起動確認 | 未実施 |
| AV1 / テキスト / Mozc 最終確認 | 未実施 |

現在の独立したブロッカーは2つある。

1. `0001-aviutl2-format-support.patch` が別環境の DXVK ソースへ適用できない
2. MinGW クロスコンパイラから `vulkan/vulkan.h` が見えない

この2つを混同しない。

## 未検証・保証外

- AMD GPU
- Intel GPU
- GE-Proton 11-1 以外
- DXVK 2.7.1 以外
- NVIDIA Driver 610.43.3 以外
- 別の Wine ソーススナップショット
- すべてのコーデックとピクセルフォーマット
- すべての IME
- すべてのデスクトップ環境
- Windows ネイティブ環境との完全な互換性
