# Lutris で AviUtl2 Catalog を導入・管理する

この手順は、既存の AviUtl2 用 Wine prefix と、パッチ済み GE-Proton をそのまま維持したまま、AviUtl2 Catalog を Lutris のライブラリへ登録して管理するためのものです。

## 設計方針

Lutris の Wine runner に実行環境の選択を任せず、Lutris から Bash ラッパーを起動します。

ラッパーが次を固定します。

- 既存 prefix: `~/Games/aviutl2/prefix-ge-nvdec-test`
- パッチ済み GE-Proton: `GE-Proton11-1-aviutl2-test`
- カスタム DXVK 設定
- NVIDIA/CUDA、DXVK、DirectWrite の DLL override
- パッチ済み `dwrite.dll`

Lutris 側の runner は `linux` です。ただし、AviUtl2 Catalog 本体はラッパーから Wine で起動します。

この構成により、Lutris や UMU が Wine/Proton/DXVK を自動で切り替えて、検証済み環境から外れることを避けます。

## 前提

次のコマンドが必要です。

```fish
sudo pacman -S --needed lutris github-cli xdg-utils desktop-file-utils
```

GitHub CLI は public release の取得に使用します。

```fish
gh auth status
```

既定パスは次の通りです。

```text
AviUtl2 root:
  ~/Games/aviutl2

Wine prefix:
  ~/Games/aviutl2/prefix-ge-nvdec-test

Patched GE-Proton:
  ~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test
```

別の場所を使う場合は、環境変数で上書きできます。

```fish
set -x AVIUTL2_ROOT "/path/to/aviutl2"
set -x AVIUTL2_PREFIX "/path/to/prefix"
set -x GE_PROTON_ROOT "/path/to/patched-ge-proton"
```

## 初回導入

スクリプトを実行可能にします。

```fish
chmod +x scripts/manage-aviutl2-catalog-lutris.sh
```

Lutris のローカルインストーラーを起動します。

```fish
scripts/manage-aviutl2-catalog-lutris.sh lutris-install
```

このコマンドは次を行います。

1. GitHub Releases から AviUtl2 Catalog の最新版 x64 setup EXE を取得
2. 既存のパッチ済み prefix で公式インストーラーを起動
3. Lutris に「AviUtl2 Catalog」を登録
4. Linux 側へ `aviutl2-catalog://` の URL handler を登録

インストーラーは対話式です。画面に従ってインストールしてください。

## AviUtl2 Catalog の初期設定

Catalog のセットアップでは、既存の AviUtl2 を使用します。

```text
AviUtl2:
  インストール済み

AviUtl2 root:
  C:\AviUtl2

Portable mode:
  無効
```

この prefix では AviUtl2 本体が `C:\AviUtl2` にあり、プラグインとスクリプトは非ポータブル構成の次の場所にあります。

```text
C:\ProgramData\aviutl2\Plugin
C:\ProgramData\aviutl2\Script
```

Portable mode を有効にすると `C:\AviUtl2\data` が管理対象になり、現在の構成と分離してしまいます。

## 重要: カスタム版 L-SMASH Works を上書きしない

現在の `lwinput.aui2` は NVDEC hardware frame transfer を追加したカスタムビルドです。

Catalog から通常版 L-SMASH Works をインストールまたは更新すると、カスタム版が上書きされ、AV1/NVDEC の検証済み動作を失う可能性があります。

Catalog のアップデートセンターで L-SMASH Works の更新を一時停止するか、L-SMASH Works を Catalog の管理対象から外してください。

次のものは Catalog の管理対象ではありません。

- パッチ済み GE-Proton
- パッチ済み Wine DirectWrite
- カスタム DXVK
- カスタム L-SMASH Works build

Catalog は、それ以外の通常の AviUtl2 プラグインやスクリプトの検索・導入・更新に使用します。

## 起動

Lutris のライブラリから「AviUtl2 Catalog」を起動できます。

CLI から直接起動する場合:

```fish
scripts/manage-aviutl2-catalog-lutris.sh launch
```

## Deep Link

Linux のブラウザから次の形式を開くと、Wine 上の Catalog を起動できます。

```text
aviutl2-catalog://
aviutl2-catalog://updates
aviutl2-catalog://package/<package-id>
aviutl2-catalog://package/<package-id>?install=true
```

URL handler を再登録する場合:

```fish
scripts/manage-aviutl2-catalog-lutris.sh register-url-handler
```

## Catalog の更新

AviUtl2 Catalog 自身は、起動時に利用可能な更新を案内します。

Wine 上の自動更新に問題がある場合は、最新版インストーラーを再実行します。

```fish
scripts/manage-aviutl2-catalog-lutris.sh update
```

`update` は先にバックアップを作成し、prefix 内の Wine プロセスを停止してから最新版をインストールします。AviUtl2 と Catalog を閉じてから実行してください。

Lutris の起動構成から「Update or reinstall Catalog」を選ぶこともできます。

## バックアップ

Catalog でパッケージを大量更新する前に実行します。

```fish
scripts/manage-aviutl2-catalog-lutris.sh backup
```

既定の保存先:

```text
~/Backups/aviutl2-catalog/
```

バックアップには次が含まれます。

- `C:\ProgramData\aviutl2`
- AviUtl2 Catalog の `settings.json`

prefix 全体の完全バックアップではありません。

## 状態確認

```fish
scripts/manage-aviutl2-catalog-lutris.sh status
```

表示項目:

- 使用中の prefix
- 使用中のパッチ済み GE-Proton
- Catalog EXE の検出結果
- Catalog の設定ファイル
- 設定された AviUtl2 root
- Portable mode
- インストール済み Catalog version
- upstream latest release

## アンインストール

Catalog のみをアンインストールします。

```fish
scripts/manage-aviutl2-catalog-lutris.sh uninstall
```

実行前に `C:\ProgramData\aviutl2` と Catalog 設定のバックアップを作成します。

AviUtl2 本体、prefix、プラグイン、スクリプトは自動削除しません。

Lutris のライブラリエントリは Lutris 側から削除してください。

## 生成される Lutris installer

次のコマンドは、ローカル Lutris installer YAML だけを再生成します。

```fish
scripts/manage-aviutl2-catalog-lutris.sh write-lutris-yaml
```

生成先:

```text
lutris/aviutl2-catalog-local.yml
```

手動で読み込む場合:

```fish
lutris -i lutris/aviutl2-catalog-local.yml
```

## コマンド一覧

```text
lutris-install        Lutris 経由で初回インストールと登録
install-only          Catalog installer のみ実行
launch                Catalog を起動
open-url URL          Deep Link を Catalog へ渡す
update                バックアップ後に最新版を再インストール
backup                ProgramData と Catalog 設定を保存
status                現在の構成と version を表示
register-url-handler  Linux の Deep Link handler を登録
write-lutris-yaml     ローカル Lutris installer を生成
uninstall             Catalog の uninstaller を実行
```

## 参照した upstream 仕様

- `Neosku/aviutl2-catalog` README
- AviUtl2 Catalog v0.3.3 release
- `Neosku/aviutl2-catalog` の Tauri 設定と path 管理実装
- `lutris/lutris` の local installer documentation
