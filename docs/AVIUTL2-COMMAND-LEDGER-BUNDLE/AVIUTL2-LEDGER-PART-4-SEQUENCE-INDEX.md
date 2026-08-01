# AviUtl2 on Linux 実行済みコマンド台帳

生成日: 2026-08-01

## 監査方針

- この台帳は、会話内に保存されたFish history、端末transcript、生成物audit、ユーザーの明示的な実操作報告を基礎にしている。
- コマンド本文は、保存された履歴または端末transcriptの文字列を原文のまま収録した。説明文内で誤りを指摘しても、コマンド本文は修正していない。
- 端末prompt、出力、ANSI由来の表示崩れはコマンド本文から分離した。
- 同一の読み取り専用監査ブロックが複数ファイルに重複していた場合、完全一致する先頭部分は一度だけ収録した。
- 生成されたREADMEやscript本文の中に「例」として埋め込まれただけのコマンドは、個別の実行コマンドには昇格していない。
- `成功`は後続のGUI動作、artifact、SHA、registry、load log、または明示出力で裏づけられたものに限定した。
- `実行確認不能`は記載またはFish historyがあっても、終了状態を断定できないもの。
- `失敗・旧手順`はエラー、誤path、診断実験、または後続で置換された構成。

## 最終成功環境の固定値

```text
ROOT=/home/alex/Games/aviutl2
REPO=/home/alex/projects/aviutl2-linux-patches
FINAL_PREFIX=/home/alex/Games/aviutl2/prefix-ge-nvdec-test
BASE_PREFIX=/home/alex/Games/aviutl2/prefix-ge
PATCHED_RUNNER=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348
KNOWN_GOOD_PREFIX=/home/alex/Games/aviutl2/prefix-ge-nvdec-test.backup-20260731-135410
L-SMASH_ARTIFACT=/home/alex/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output/lwinput.aui2
L-SMASH_SHA256=db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0
LSMASH_INI_SHA256=10620155d1470ea270121f67357f3da89cb8151ffac651c049e98238253a9a9f
CATALOG_VERSION=0.3.3
CATALOG_INSTALLER_SHA256=5591a5baa931f94322aff13096c63147126ca90d3844610ce7827b2f9b44d84e
```

# 実行順の復元

以下は成功・検証証拠があるIDのみを、端末transcriptの時系列と依存関係に従って並べたもの。コマンド本文は上の台帳項目を参照する。

## Phase 0: 変数とディレクトリ

- `S241-01` — 最終再構築で使用するroot、prefix、runner、override変数を設定する。（分類: 成功）
- `S243-01` — current prefix clone用のroot/runner変数を設定する。（分類: 成功）
- `S243-07` — NV prefixとknown-good runner変数を再設定する。（分類: 成功）
- `S243-12` — known-good backupのフォントを復旧するための変数を設定する。（分類: 成功）
- `S245-01` — Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。（分類: 成功）

## Phase 1: ソース・依存関係

- `S237-02` — L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。（分類: 成功）
- `S237-05` — 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。（分類: 成功）
- `S239-01` — full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。（分類: 成功）
- `S239-02` — 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。（分類: 成功）

## Phase 2: DXVK

- `S241-12` — DXVK source/output変数を設定する。（分類: 成功）
- `S241-13` — 既存DXVK build.w64を再コンパイルしruntime出力へインストールする。（分類: 成功）
- `V241-14` — 生成されたpatched d3d11.dllのmarkerを確認する。（分類: 検証専用）
- `S241-15` — 旧d3d11.dllをbackupし、patched d3d11.dllを`prefix-ge`へ配置する。（分類: 成功）
- `V241-16` — patched d3d11.dllとactive DLLのSHA・byte一致を確認する。（分類: 検証専用）

## Phase 3: Wine / DWrite

- `H167` — 対象ソースまたは依存ライブラリをビルド・インストールする。（分類: 成功）

## Phase 4: patched runner

- `H167` — 対象ソースまたは依存ライブラリをビルド・インストールする。（分類: 成功）

## Phase 5: ベースprefix

- `C241-06` — raw GE Wineで新しい64-bit `prefix-ge`を作成する。（分類: 失敗・旧手順）
- `S241-08` — AviUtl2本体ディレクトリをbase prefixから`prefix-ge`へコピーする。（分類: 成功）
- `S241-09` — ProgramDataのAviUtl2データをbase prefixから`prefix-ge`へコピーする。（分類: 成功）
- `S241-10` — base prefixのD3D/DXVK関連DLLを`prefix-ge/system32`へ配置する。（分類: 成功）
- `S242-04` — `prefix-ge`へD3D DLL overrideを登録する。（分類: 成功）
- `V242-05` — `prefix-ge`のDllOverridesを確認する。（分類: 検証専用）

`C241-06`はprefix作成自体は行ったがvkd3d系エラーを含む。したがって、クリーンなREPRODUCTION.mdではこのコマンドをそのまま成功手順へ採用できない。後続のDLLコピー・known-good状態の利用まで含めて再設計が必要。

## Phase 6: フォント

- `S243-12` — known-good backupのフォントを復旧するための変数を設定する。（分類: 成功）
- `V243-13` — 4つのknown-good fontファイルの存在を確認する。（分類: 検証専用）
- `S243-14` — base/NV prefix双方のWineプロセスを停止する。（分類: 成功）
- `S243-15` — Noto CJK TTCとTahoma-compatible OTFをbase/NV prefix双方へ配置する。（分類: 成功）
- `S243-16` — Fonts/FontSubstitutes registry key変数を設定する。（分類: 成功）
- `S243-17` — Noto Sans CJK JPとTahoma-compatible fontのFonts registry entriesを登録する。（分類: 成功）
- `S243-18` — 旧Tahoma FontSubstituteを削除する。（分類: 成功）
- `S243-19` — MS Shell Dlg系をTahomaへ、日本語font aliasesをNoto Sans CJK JPへ登録する。（分類: 成功）
- `S243-20` — フォント設定反映のため両prefixで`wineboot -u`し終了待ちする。（分類: 成功）
- `V243-22` — Tahoma/Noto font登録とFontSubstitutesをqueryする。（分類: 検証専用）

## Phase 7: NVDEC wrapper

- `S-E01` — known-good prefix内のNVIDIA wrapper symlinkとtargetを検証する。（分類: 検証専用）
- `S-E02` — NVIDIA wrapper復元前backup directoryを作成する。（分類: 成功）
- `S-E03` — known-good prefixのNVIDIA Wine wrapper symlinkをcurrent NV prefixへ復元する。（分類: 成功）
- `V-E04` — 復元されたNVIDIA wrapper symlinkとtargetを確認する。（分類: 検証専用）
- `S-E05` — NVIDIA wrapper DLLのnative overrideを再登録する。（分類: 成功）
- `V-E06` — NVIDIA wrapper override値をqueryする。（分類: 検証専用）

## Phase 8: L-SMASH Works

- `S239-02` — 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。（分類: 成功）
- `S243-25` — L-SMASH導入前のprefix checkpointを作成する。（分類: 成功）
- `V243-26` — repro-03 artifactとINIの存在、plugin SHAを確認する。（分類: 検証専用）
- `V243-27` — r1284、av1_cuvid、FFmpeg configure markerを確認する。（分類: 検証専用）
- `S243-28` — active Plugin directoryとファイル変数を設定しdirectoryを確保する。（分類: 成功）
- `S243-29` — 既存lwinput.aui2/lsmash.iniをtimestamp付きbackupする。（分類: 成功）
- `S243-30` — repro-03 lwinput.aui2をactive pluginへ配置しbyte一致を確認する。（分類: 成功）
- `S243-31` — repro-03 lsmash.iniをactive pluginへ配置する。（分類: 成功）
- `S243-32` — active lsmash.iniをNVDEC設定へ書き換える。（分類: 成功）
- `V243-33` — active plugin SHAとlsmash.iniの必須3値を確認する。（分類: 検証専用）

## Phase 9: Fcitx5/Mozc

- `V244-02` — ホストのXMODIFIERSとFcitx5/Mozcプロセスを確認する。（分類: 検証専用）
- `S244-03` — AviUtl2専用`InputStyle=overthespot`を登録する。（分類: 成功）
- `V244-04` — InputStyle値をqueryする。（分類: 検証専用）

## Phase 10: AviUtl2起動

- `S243-23` — フォント復旧後のNV prefixでAviUtl2を起動する。（分類: 成功）
- `S243-34` — custom r1284導入後のAviUtl2を起動する。（分類: 成功）

## Phase 11: NVDEC検証

- `S-E07` — NVIDIA wrapper復元後のNVDEC再試験ログを初期化する。（分類: 成功）
- `V-E08` — wrapper復元後にAV1素材を読み込み、NVDEC DLL/load traceを採取する。（分類: 検証専用）
- `V-E09` — NVDEC成功・失敗markerを最終ログから抽出する。（分類: 検証専用）

## Phase 12: DWrite/Mozc検証

- `S244-05` — テキスト検証前にWineプロセスを停止・待機する。（分類: 成功）
- `S244-06` — テキスト検証ログを初期化しAviUtl2ディレクトリへ移動する。（分類: 成功）
- `V244-07` — Fcitx XIMとDWrite traceを有効にしてAviUtl2を起動し実操作する。（分類: 検証専用）
- `V244-08` — DWrite HitTestPoint/HitTestTextRange呼び出しを抽出する。（分類: 検証専用）
- `V244-09` — stub、E_NOTIMPL、未処理例外を検出する。（分類: 検証専用）
- `V244-10` — XIM style選択を確認する。（分類: 検証専用）

## Phase 13: Catalog

- `S245-01` — Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。（分類: 成功）
- `V245-02` — 必要コマンドの存在を確認する。（分類: 検証専用）
- `V245-03` — AviUtl2、Wine、wineserver、patched dwriteの必要pathを確認する。（分類: 検証専用）
- `S245-04` — Catalog導入前にWineプロセスを停止・待機する。（分類: 成功）
- `S245-05` — Catalog導入前checkpointを作成する。（分類: 成功）
- `S245-06` — Catalog cache/log directoryを作成する。（分類: 成功）
- `S245-07` — Catalog 0.3.3 release metadataを取得しtagを解決する。（分類: 成功）
- `S245-08` — release JSONから唯一のx64 setup asset名を解決する。（分類: 成功）
- `S245-09` — Catalog installerをdownloadし形式とSHAを確認する。（分類: 成功）
- `S245-10` — 既存prefix内でCatalog installerを実行する。（分類: 成功）
- `V245-11` — インストールされたCatalog executableを検索・一意確認する。（分類: 検証専用）
- `S245-12` — Catalogを初回起動しUIでAviUtl2 root/portable mode/プラグイン導入を行う。（分類: 成功）
- `S245-13` — Catalog終了後にWineプロセスを完全停止する。（分類: 成功）

## Phase 14: Catalog後overlay

- `V245-14` — overlay用repro-03 artifact pathとactive plugin pathを設定・存在確認する。（分類: 検証専用）
- `V245-15` — overlay前artifact SHAを確認する。（分類: 検証専用）
- `S245-16` — install helperでCatalog packageをpauseしcustom r1284を最後にoverlayする。（分類: 成功）
- `V245-17` — artifactとactive pluginのSHA・byte一致を確認する。（分類: 検証専用）
- `V245-18` — active pluginのr1284/CUVID markerを確認する。（分類: 検証専用）
- `V245-19` — active lsmash.iniの必須3値を確認する。（分類: 検証専用）
- `V245-20` — Catalog settings.jsonを一意に検索する。（分類: 検証専用）
- `V245-21` — settings.jsonのJSON妥当性を確認する。（分類: 検証専用）
- `V245-22` — `Mr-Ojii.L-SMASH-Works`がpause listに含まれるか確認する。（分類: 検証専用）

## Phase 15: 最終検証

- `V245-23` — Catalog再起動前のactive r1284 SHAを保存する。（分類: 検証専用）
- `S245-24` — overlay後にCatalogを再起動して通常表示を確認する。（分類: 成功）
- `V245-25` — Catalog再起動前後のplugin SHAを比較する。（分類: 検証専用）

## Phase 16: checkpoint・backup

- `S243-03` — 既存NV prefixをtimestamp付きbackupへ退避する。（分類: 成功）
- `S243-25` — L-SMASH導入前のprefix checkpointを作成する。（分類: 成功）
- `S245-05` — Catalog導入前checkpointを作成する。（分類: 成功）

## Phase 17: Git反映

- `H165` — 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。（分類: 成功）
- `H166` — 対象ソースまたは依存ライブラリをビルド・インストールする。（分類: 成功）
- `S237-02` — L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。（分類: 成功）
- `S237-05` — 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。（分類: 成功）
- `S239-01` — full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。（分類: 成功）

## 前後関係を断定できない箇所

- 初期のDXVK source編集の細かな試行と、最終採用patchのどの編集が直接現在のsource treeへ残ったかは、Fish historyだけでは一意に確定できない。最終binary/hashとrepository patchを優先する。
- Tahoma-compatible OTFの**生成コマンド**はこの会話の実行ログから回収できない。今回の成功環境ではknown-good backupからコピーした。
- NVIDIA wrapper archiveの**最初の取得・展開・symlink生成コマンド**は最終再構築transcriptに完全な形で残っていない。今回の成功環境ではknown-good prefixからsymlinkを復元した。
- patched runnerの元GE-Proton複製と初期Wine configure/build全体は断片的。最終DWrite hardening command `H167`とknown-good runner hashは確認できるが、ゼロからの全runner生成手順は追加確認が必要。

# 最終一覧表

| ID | コマンド概要 | 分類 | 成功確認 | 最終手順への採用 | 追加確認 |
| -- | -- | -- | -- | -- | -- |
| H001 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H002 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H003 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H004 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H005 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H006 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H007 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H008 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H009 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H010 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H011 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H012 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H013 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H014 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H015 | 後続コマンドで使用するシェル変数を設定する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H016 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H017 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H018 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H019 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H020 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H021 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H022 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H023 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H024 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H025 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H026 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H027 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H028 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H029 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H030 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H031 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H032 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H033 | DXVKのMesonビルドディレクトリを構成する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H034 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H035 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H036 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H037 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H038 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H039 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H040 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H041 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H042 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H043 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H044 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H045 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H046 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H047 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H048 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H049 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H050 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H051 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H052 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H053 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H054 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H055 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H056 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H057 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H058 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H059 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H060 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H061 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H062 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H063 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H064 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H065 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H066 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H067 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H068 | Wineレジストリの旧設定を削除する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H069 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H070 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H071 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H072 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H073 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H074 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H075 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H076 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H077 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H078 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H079 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H080 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H081 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H082 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H083 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H084 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H085 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H086 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H087 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H088 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H089 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H090 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H091 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H092 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H093 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H094 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H095 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H096 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H097 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H098 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H099 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H100 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H101 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H102 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H103 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H104 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H105 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H106 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H107 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H108 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H109 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H110 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H111 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H112 | AV1検証素材を作成またはメディア属性を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H113 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H114 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H115 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H116 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H117 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H118 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H119 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H120 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H121 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H122 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H123 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H124 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H125 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H126 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H127 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H128 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H129 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H130 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H131 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H132 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H133 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H134 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H135 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H136 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H137 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H138 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H139 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H140 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H141 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H142 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H143 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H144 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H145 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H146 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H147 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H148 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H149 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H150 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H151 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H152 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H153 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H154 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H155 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H156 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H157 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H158 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H159 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H160 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H161 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H162 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H163 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H164 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H165 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| H166 | 対象ソースまたは依存ライブラリをビルド・インストールする。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| H167 | 対象ソースまたは依存ライブラリをビルド・インストールする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H168 | DXVKをコンパイルする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H169 | DXVKをコンパイルする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H170 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H171 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H172 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H173 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H174 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H175 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H176 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H177 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H178 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H179 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H180 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H181 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H182 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H183 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H184 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H185 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H186 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H187 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H188 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H189 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| V224-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V225-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V226-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V228-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V229-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V230-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V231-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V233-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V234-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V235-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V238-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V240-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| D227-01 | AviUtl2環境を監査するFishスクリプト本文。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| V237-01 | Catalogとcustom L-SMASH Worksのhash分類を読み取り専用で検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| S237-02 | L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| C237-03 | 最初のrepro-01 work directoryでL-SMASH Worksを再現ビルドする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| C237-04 | FFmpeg validation修正patchを適用する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| S237-05 | 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| C237-06 | repository直下の`ffbuild/config.mak`を検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| C237-07 | 修正後のrepro-02 buildを実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| S239-01 | full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S239-02 | 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-01 | 最終再構築で使用するroot、prefix、runner、override変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| D241-02 | GE-Proton11-1がない場合だけrelease archiveを取得・展開する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| V241-03 | GE Wine binary形式とWine versionを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-04 | 旧base prefixのWineプロセスを停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-05 | 既存`prefix-ge`をtimestamp付きbackupへ退避する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| C241-06 | raw GE Wineで新しい64-bit `prefix-ge`を作成する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| V241-07 | 作成されたprefix基本ファイルの存在を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| S241-08 | AviUtl2本体ディレクトリをbase prefixから`prefix-ge`へコピーする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-09 | ProgramDataのAviUtl2データをbase prefixから`prefix-ge`へコピーする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-10 | base prefixのD3D/DXVK関連DLLを`prefix-ge/system32`へ配置する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V241-11 | 配置済みD3D DLLのSHA-256を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-12 | DXVK source/output変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-13 | 既存DXVK build.w64を再コンパイルしruntime出力へインストールする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V241-14 | 生成されたpatched d3d11.dllのmarkerを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-15 | 旧d3d11.dllをbackupし、patched d3d11.dllを`prefix-ge`へ配置する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V241-16 | patched d3d11.dllとactive DLLのSHA・byte一致を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-17 | DXVK config path変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V241-18 | `prefix-ge`でAviUtl2を起動しformat 69 workaround到達を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V242-01 | 歴史的な最初の成功環境のlauncher、prefix、vkd3d DLLの存在を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V242-02 | 旧`~/projects/aviutl2-linux`の最初の成功launcherを再実行し、原初成功ログを保存する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S242-03 | 正規repositoryへカレントディレクトリを戻す。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S242-04 | `prefix-ge`へD3D DLL overrideを登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V242-05 | `prefix-ge`のDllOverridesを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V242-06 | `prefix-ge`で最終再現起動ログを取得し、Wine/tee statusを記録する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-01 | current prefix clone用のroot/runner変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-02 | base `prefix-ge`のWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-03 | 既存NV prefixをtimestamp付きbackupへ退避する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-04 | 確認済み`prefix-ge`を`prefix-ge-nvdec-test`へreflink cloneする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-05 | clone後のregistry、AviUtl2本体、D3D DLLをbyte比較する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V243-06 | clone直後のNV prefixでAviUtl2を起動しformat 69到達を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-07 | NV prefixとknown-good runner変数を再設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-08 | NV prefixのWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-09 | NVIDIA DLL overrideをnativeへ登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-10 | NVIDIA DLL override値を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V243-11 | NVIDIA overrideを含む構成でAviUtl2を短時間起動する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-12 | known-good backupのフォントを復旧するための変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V243-13 | 4つのknown-good fontファイルの存在を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-14 | base/NV prefix双方のWineプロセスを停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-15 | Noto CJK TTCとTahoma-compatible OTFをbase/NV prefix双方へ配置する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-16 | Fonts/FontSubstitutes registry key変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-17 | Noto Sans CJK JPとTahoma-compatible fontのFonts registry entriesを登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-18 | 旧Tahoma FontSubstituteを削除する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-19 | MS Shell Dlg系をTahomaへ、日本語font aliasesをNoto Sans CJK JPへ登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-20 | フォント設定反映のため両prefixで`wineboot -u`し終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-21 | フォント反映確認のため両prefixで`wineboot -u`を再実行する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-22 | Tahoma/Noto font登録とFontSubstitutesをqueryする。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-23 | フォント復旧後のNV prefixでAviUtl2を起動する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-24 | L-SMASH導入前にWineプロセスを完全停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-25 | L-SMASH導入前のprefix checkpointを作成する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V243-26 | repro-03 artifactとINIの存在、plugin SHAを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V243-27 | r1284、av1_cuvid、FFmpeg configure markerを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-28 | active Plugin directoryとファイル変数を設定しdirectoryを確保する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-29 | 既存lwinput.aui2/lsmash.iniをtimestamp付きbackupする。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-30 | repro-03 lwinput.aui2をactive pluginへ配置しbyte一致を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-31 | repro-03 lsmash.iniをactive pluginへ配置する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-32 | active lsmash.iniをNVDEC設定へ書き換える。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-33 | active plugin SHAとlsmash.iniの必須3値を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-34 | custom r1284導入後のAviUtl2を起動する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S244-01 | Mozc/DWrite検証用のroot、prefix、runner変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V244-02 | ホストのXMODIFIERSとFcitx5/Mozcプロセスを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S244-03 | AviUtl2専用`InputStyle=overthespot`を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V244-04 | InputStyle値をqueryする。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S244-05 | テキスト検証前にWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S244-06 | テキスト検証ログを初期化しAviUtl2ディレクトリへ移動する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V244-07 | Fcitx XIMとDWrite traceを有効にしてAviUtl2を起動し実操作する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V244-08 | DWrite HitTestPoint/HitTestTextRange呼び出しを抽出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V244-09 | stub、E_NOTIMPL、未処理例外を検出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V244-10 | XIM style選択を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-01 | Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V245-02 | 必要コマンドの存在を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-03 | AviUtl2、Wine、wineserver、patched dwriteの必要pathを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-04 | Catalog導入前にWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-05 | Catalog導入前checkpointを作成する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S245-06 | Catalog cache/log directoryを作成する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-07 | Catalog 0.3.3 release metadataを取得しtagを解決する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-08 | release JSONから唯一のx64 setup asset名を解決する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-09 | Catalog installerをdownloadし形式とSHAを確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-10 | 既存prefix内でCatalog installerを実行する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-11 | インストールされたCatalog executableを検索・一意確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-12 | Catalogを初回起動しUIでAviUtl2 root/portable mode/プラグイン導入を行う。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-13 | Catalog終了後にWineプロセスを完全停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-14 | overlay用repro-03 artifact pathとactive plugin pathを設定・存在確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V245-15 | overlay前artifact SHAを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-16 | install helperでCatalog packageをpauseしcustom r1284を最後にoverlayする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-17 | artifactとactive pluginのSHA・byte一致を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-18 | active pluginのr1284/CUVID markerを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-19 | active lsmash.iniの必須3値を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-20 | Catalog settings.jsonを一意に検索する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-21 | settings.jsonのJSON妥当性を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-22 | `Mr-Ojii.L-SMASH-Works`がpause listに含まれるか確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-23 | Catalog再起動前のactive r1284 SHAを保存する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-24 | overlay後にCatalogを再起動して通常表示を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-25 | Catalog再起動前後のplugin SHAを比較する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S-E01 | known-good prefix内のNVIDIA wrapper symlinkとtargetを検証する。 | 検証専用 | あり | 内容を修正してから検証手順として採用 | 必要 |
| S-E02 | NVIDIA wrapper復元前backup directoryを作成する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S-E03 | known-good prefixのNVIDIA Wine wrapper symlinkをcurrent NV prefixへ復元する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V-E04 | 復元されたNVIDIA wrapper symlinkとtargetを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S-E05 | NVIDIA wrapper DLLのnative overrideを再登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V-E06 | NVIDIA wrapper override値をqueryする。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S-E07 | NVIDIA wrapper復元後のNVDEC再試験ログを初期化する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V-E08 | wrapper復元後にAV1素材を読み込み、NVDEC DLL/load traceを採取する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V-E09 | NVDEC成功・失敗markerを最終ログから抽出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| C-E10 | NVIDIA wrapper復元前のprefixでAV1/NVDEC traceを採取する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| V-E11 | 初回NVDECログからCUVID contextと致命的エラーを抽出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V-E12 | 初回NVDECログのcontext行とfatal errorを分けて確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| D-E13 | Catalog統合後の完全成功prefixを最終checkpointとして複製する。 | 実行確認不能 | なし | 要追加確認 | 必要 |

# REPRODUCTION.mdへそのまま採用できるコマンド

- `H033` — DXVKのMesonビルドディレクトリを構成する。
- `H054` — 対象Wine prefixのプロセスを停止または終了待ちする。
- `H067` — 対象Wine prefixのプロセスを停止または終了待ちする。
- `H068` — Wineレジストリの旧設定を削除する。
- `H069` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H070` — Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。
- `H112` — AV1検証素材を作成またはメディア属性を確認する。
- `H114` — 対象Wine prefixのプロセスを停止または終了待ちする。
- `H117` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H123` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H148` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H167` — 対象ソースまたは依存ライブラリをビルド・インストールする。
- `S237-02` — L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。
- `S237-05` — 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。
- `S239-01` — full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。
- `S239-02` — 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。
- `S241-01` — 最終再構築で使用するroot、prefix、runner、override変数を設定する。
- `S241-04` — 旧base prefixのWineプロセスを停止する。
- `S241-08` — AviUtl2本体ディレクトリをbase prefixから`prefix-ge`へコピーする。
- `S241-09` — ProgramDataのAviUtl2データをbase prefixから`prefix-ge`へコピーする。
- `S241-10` — base prefixのD3D/DXVK関連DLLを`prefix-ge/system32`へ配置する。
- `S241-12` — DXVK source/output変数を設定する。
- `S241-13` — 既存DXVK build.w64を再コンパイルしruntime出力へインストールする。
- `S241-17` — DXVK config path変数を設定する。
- `S242-03` — 正規repositoryへカレントディレクトリを戻す。
- `S242-04` — `prefix-ge`へD3D DLL overrideを登録する。
- `S243-02` — base `prefix-ge`のWineプロセスを停止・待機する。
- `S243-04` — 確認済み`prefix-ge`を`prefix-ge-nvdec-test`へreflink cloneする。
- `S243-08` — NV prefixのWineプロセスを停止・待機する。
- `S243-09` — NVIDIA DLL overrideをnativeへ登録する。
- `S243-14` — base/NV prefix双方のWineプロセスを停止する。
- `S243-15` — Noto CJK TTCとTahoma-compatible OTFをbase/NV prefix双方へ配置する。
- `S243-16` — Fonts/FontSubstitutes registry key変数を設定する。
- `S243-17` — Noto Sans CJK JPとTahoma-compatible fontのFonts registry entriesを登録する。
- `S243-18` — 旧Tahoma FontSubstituteを削除する。
- `S243-19` — MS Shell Dlg系をTahomaへ、日本語font aliasesをNoto Sans CJK JPへ登録する。
- `S243-20` — フォント設定反映のため両prefixで`wineboot -u`し終了待ちする。
- `S243-21` — フォント反映確認のため両prefixで`wineboot -u`を再実行する。
- `S243-23` — フォント復旧後のNV prefixでAviUtl2を起動する。
- `S243-24` — L-SMASH導入前にWineプロセスを完全停止する。
- `S243-28` — active Plugin directoryとファイル変数を設定しdirectoryを確保する。
- `S243-30` — repro-03 lwinput.aui2をactive pluginへ配置しbyte一致を確認する。
- `S243-31` — repro-03 lsmash.iniをactive pluginへ配置する。
- `S243-32` — active lsmash.iniをNVDEC設定へ書き換える。
- `S243-34` — custom r1284導入後のAviUtl2を起動する。
- `S244-03` — AviUtl2専用`InputStyle=overthespot`を登録する。
- `S244-05` — テキスト検証前にWineプロセスを停止・待機する。
- `S244-06` — テキスト検証ログを初期化しAviUtl2ディレクトリへ移動する。
- `S245-04` — Catalog導入前にWineプロセスを停止・待機する。
- `S245-06` — Catalog cache/log directoryを作成する。
- `S245-07` — Catalog 0.3.3 release metadataを取得しtagを解決する。
- `S245-08` — release JSONから唯一のx64 setup asset名を解決する。
- `S245-09` — Catalog installerをdownloadし形式とSHAを確認する。
- `S245-10` — 既存prefix内でCatalog installerを実行する。
- `S245-12` — Catalogを初回起動しUIでAviUtl2 root/portable mode/プラグイン導入を行う。
- `S245-13` — Catalog終了後にWineプロセスを完全停止する。
- `S245-16` — install helperでCatalog packageをpauseしcustom r1284を最後にoverlayする。
- `S245-24` — overlay後にCatalogを再起動して通常表示を確認する。
- `S-E03` — known-good prefixのNVIDIA Wine wrapper symlinkをcurrent NV prefixへ復元する。
- `S-E05` — NVIDIA wrapper DLLのnative overrideを再登録する。
- `S-E07` — NVIDIA wrapper復元後のNVDEC再試験ログを初期化する。

# 内容を修正してから採用すべきコマンド

- `H165` — 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。
- `H166` — 対象ソースまたは依存ライブラリをビルド・インストールする。
- `S241-05` — 既存`prefix-ge`をtimestamp付きbackupへ退避する。
- `S241-15` — 旧d3d11.dllをbackupし、patched d3d11.dllを`prefix-ge`へ配置する。
- `S243-01` — current prefix clone用のroot/runner変数を設定する。
- `S243-03` — 既存NV prefixをtimestamp付きbackupへ退避する。
- `S243-07` — NV prefixとknown-good runner変数を再設定する。
- `S243-12` — known-good backupのフォントを復旧するための変数を設定する。
- `S243-25` — L-SMASH導入前のprefix checkpointを作成する。
- `S243-29` — 既存lwinput.aui2/lsmash.iniをtimestamp付きbackupする。
- `S244-01` — Mozc/DWrite検証用のroot、prefix、runner変数を設定する。
- `S245-01` — Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。
- `S245-05` — Catalog導入前checkpointを作成する。
- `S-E01` — known-good prefix内のNVIDIA wrapper symlinkとtargetを検証する。
- `S-E02` — NVIDIA wrapper復元前backup directoryを作成する。

# 履歴だけでは不足している工程

1. Tahoma-compatible OTFをライセンス上安全かつ再現可能に生成するコマンド。
2. `nvidia-libs-v1.0.2`を最初に取得・展開し、`system32`へ3本のsymlinkを新規作成する完全なコマンド。
3. GE-Proton 11-1をゼロから複製し、Wine/DWrite build treeをconfigureする全コマンド。
4. AviUtl2本体とProgramDataの合法な入手元・展開元を含む初回配置コマンド。履歴には既存prefix間コピーしか完全には残っていない。
5. `install-dwrite.fish`内部が行うrunner内PE/Unix DWrite配置の全コマンド。helper invocationはあるが、実行時の内部command transcriptはない。
6. 最終repositoryへのcommit/pushのうち、最新repro-03/Catalog統合変更をpushした明示的な端末出力。過去のinitial pushは履歴にあるが、今回の最終差分は追加確認が必要。

# 証拠ファイルinventory

| File | Lines | SHA-256 |
| -- | --: | -- |
| `貼り付けられたテキスト（1 点）(223).txt` | 4905 | `2d131db7479bcd7040e7c5dd14b523f26ee944f0704386ae30d880ac7e215bc1` |
| `貼り付けられたテキスト（1 点）(224).txt` | 1406 | `49dbcf93301a022f94869b43f87879b9c1cb405849252c27b905c4062e01cdf8` |
| `貼り付けられたテキスト（1 点）(225).txt` | 3178 | `2e039cb0b517c469da33a479dc514eebb9f7fe5e8980388b28c63d79923fa69a` |
| `貼り付けられたテキスト（1 点）(226).txt` | 4248 | `c3373be3324dc0d313df12dcc6f6c2c5c0b880c6296242a3d7a4161280f44cc6` |
| `貼り付けられたテキスト（1 点）(227).txt` | 403 | `948e0518eee20ab778ea6bba818cec6159294a10579bd5adc1bb3f97cabbcd88` |
| `貼り付けられたテキスト（1 点）(228).txt` | 1587 | `77fbc24c1ca2a6620a9212abfa93c8536381373e094329a957e63a6f703d4f0c` |
| `貼り付けられたテキスト（1 点）(229).txt` | 1195 | `8a47b5ebb286eb6572b6be57134fa065731f4419502a25778717b7618d7b8d27` |
| `貼り付けられたテキスト（1 点）(230).txt` | 1960 | `c61b45ff2f425c99541d515a608ccc357fc94c02676365aca40ff9e20b506e61` |
| `貼り付けられたテキスト（1 点）(231).txt` | 7384 | `bc12b7fbed25586add985ff7a0098d587a30184fe4666bd05493cdf2c5a8285c` |
| `貼り付けられたテキスト（1 点）(232).txt` | 6437 | `0b272db85f70254e48285a14d652a13fdf1784338215752a06ec981c9273c19f` |
| `貼り付けられたテキスト（1 点）(233).txt` | 2593 | `ecd7d031b24653ea73c11cfa79f1891d0552b6be3d72e6507e8313ec4b2c5895` |
| `貼り付けられたテキスト（1 点）(234).txt` | 653 | `5674db11305692ae1e6e37bce446d50c6bbb1e4b2c07fb51998dfe0feeb6cb30` |
| `貼り付けられたテキスト（1 点）(235).txt` | 1351 | `cdf6a47ab8bf39eac0bb54384a33a4f42ab60724840d3088776307053bfea9ab` |
| `貼り付けられたテキスト（1 点）(236).txt` | 2817 | `3584c5ca27a840142fe7f0c2749ff5670ea7c1de0eae962be894b689e71cdde2` |
| `貼り付けられたテキスト（1 点）(237).txt` | 6864 | `b2a1b82e662fcc83447b19c0bae39da9f307d744c0c62c332e8c0482ad82fcc3` |
| `貼り付けられたテキスト（1 点）(238).txt` | 879 | `a0f4e93d5148ac6f677bf43d39eba45063b1021482df2d216a0e3474791a6113` |
| `貼り付けられたテキスト（1 点）(239).txt` | 4027 | `5e00db315508fd1450929ade1f87e0fa6bcffbebf54d570cfc85b90760c84425` |
| `貼り付けられたテキスト（1 点）(240).txt` | 515 | `6ba9609503fa777fb425746791756273656964276f790aa5071398306d15f95e` |
| `貼り付けられたテキスト（1 点）(241).txt` | 258 | `49ccbc201b4cc7067ec52b2056aa3275afd6f8b80790030c5cb89a057dfce332` |
| `貼り付けられたテキスト（1 点）(242).txt` | 1540 | `767afb4a23b9e71c731d489ba4d0b0b526ee982d1150c0c08028058cca8457af` |
| `貼り付けられたテキスト（1 点）(243).txt` | 8121 | `25bd47ba076748126cfa4d1b28376c7e554b4cd31f08afa4911a4368be76b098` |
| `貼り付けられたテキスト（1 点）(244).txt` | 188 | `25ee3e346a1f1699c9285bbf097c52178adbd439de00fb5469d0ca3ea151a2de` |
| `貼り付けられたテキスト（1 点）(245).txt` | 493 | `562a629cef6a7930b7444e7cf78e387bdea88131a9a5b06b51d04fc5ed4e08f6` |
| `build-l-smash-works-nvdec.fish` | 651 | `0ee649c38de355a5d71af50912b012506b7468cacf074d97e331a6b855fe4f86` |
| `install-l-smash-works-nvdec.fish` | 245 | `7e9714083224d9793e865660ac472bd2163f4720300d3e6eeb28afd728519650` |
| `restore-known-good-aviutl2.fish` | 513 | `96b7e46200de35de584b8a63797c3add776bcff72482c01ccc2730435e68263a` |
| `REPRODUCTION-FIRST-SUCCESS.md` | 1242 | `056a2c2cd5a74ef7c817974c90d3d310bfbad1e6438534be6f2dc9bf744614bf` |
| `REPRODUCTION.md` | 1242 | `056a2c2cd5a74ef7c817974c90d3d310bfbad1e6438534be6f2dc9bf744614bf` |
| `L-SMASH-WORKS-NVDEC.md` | 372 | `0b81aaec6c44839b78ab630f661dffb0ab680419c469ef5d57fa2db677cb8873` |

# Appendix A — 実行されたL-SMASH Works build helperの完全本文

`S239-02`で実際に起動された `scripts/build-l-smash-works-nvdec.fish` の保存済み本文。これは個別に端末入力されたコマンド群ではなく、script invocationにより内部実行された処理である。

```fish
#!/usr/bin/env fish

# Build the validated AviUtl2 L-SMASH Works r1284/NVDEC artifact from
# pinned source commits. This script builds into a fresh directory only.
# It never modifies a Wine prefix, AviUtl2 installation, or Catalog state.

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME [--work-dir PATH] [--output-dir PATH] [--jobs N]"
    echo
    echo "Defaults:"
    echo "  --work-dir   \$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro"
    echo "  --output-dir <work-dir>/output"
    echo "  --jobs       nproc"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function note
    echo
    echo "==> $argv"
end

function require_command
    set -l command_name $argv[1]
    command -q "$command_name"
    or die "required command not found: $command_name"
end

function clone_commit
    set -l name $argv[1]
    set -l url $argv[2]
    set -l destination $argv[3]
    set -l commit $argv[4]

    note "Fetching $name at $commit"

    test ! -e "$destination"
    or die "destination already exists: $destination"

    git init -q "$destination"
    or die "git init failed: $destination"

    git -C "$destination" remote add origin "$url"
    or die "git remote add failed: $name"

    git -C "$destination" fetch --depth 1 origin "$commit"
    or die "git fetch failed: $name ($commit)"

    git -C "$destination" checkout --detach -q FETCH_HEAD
    or die "git checkout failed: $name"

    set -l actual (git -C "$destination" rev-parse HEAD)
    test "$actual" = "$commit"
    or die "$name commit mismatch: expected $commit, got $actual"
end

argparse \
    'h/help' \
    'w/work-dir=' \
    'o/output-dir=' \
    'j/jobs=' \
    -- $argv
or begin
    usage >&2
    exit 2
end

if set -q _flag_help
    usage
    exit 0
end

set -l script_path (status filename)
set -l script_dir (cd (dirname "$script_path"); and pwd -P)
set -l repo_root (cd "$script_dir/.."; and pwd -P)

set -l work_dir "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro"
if set -q _flag_work_dir
    set work_dir (string trim -- "$_flag_work_dir")
end

test -n "$work_dir"
or die "--work-dir must not be empty"

set work_dir (string replace -r '/+$' '' -- "$work_dir")
set -l output_dir "$work_dir/output"
if set -q _flag_output_dir
    set output_dir (string trim -- "$_flag_output_dir")
end

test -n "$output_dir"
or die "--output-dir must not be empty"
set output_dir (string replace -r '/+$' '' -- "$output_dir")

set -l jobs
if set -q _flag_jobs
    set jobs "$_flag_jobs"
else
    set jobs (nproc 2>/dev/null)
    if test -z "$jobs"
        set jobs 1
    end
end

string match -rq '^[1-9][0-9]*$' -- "$jobs"
or die "--jobs must be a positive integer: $jobs"

set -l patch_file "$repo_root/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"
set -l lsmash_ini "$repo_root/config/lsmash.ini"

test -f "$patch_file"
or die "patch not found: $patch_file"

test -f "$lsmash_ini"
or die "configuration not found: $lsmash_ini"

set -l expected_patch_sha256 7c4b410fa4ffa5223b63522f27e9e2534bac550d2fa038c1aee94ed6de5ae0d2
set -l actual_patch_sha256 (sha256sum "$patch_file" | string split ' ')[1]
test "$actual_patch_sha256" = "$expected_patch_sha256"
or die "patch SHA-256 mismatch: expected $expected_patch_sha256, got $actual_patch_sha256"

for command_name in \
    git \
    cmake \
    meson \
    ninja \
    nasm \
    make \
    pkg-config \
    nproc \
    file \
    strings \
    sha256sum \
    grep \
    sed \
    x86_64-w64-mingw32-gcc \
    x86_64-w64-mingw32-g++ \
    x86_64-w64-mingw32-ar \
    x86_64-w64-mingw32-ranlib \
    x86_64-w64-mingw32-strip \
    x86_64-w64-mingw32-windres \
    x86_64-w64-mingw32-objdump \
    stat \
    head

    require_command "$command_name"
end

# Refuse to reuse a prior tree. This avoids silently combining stale build
# outputs with the pinned sources below.
test ! -e "$work_dir"
or die "work directory already exists; choose a new path or remove it manually: $work_dir"

test ! -e "$output_dir"
or die "output directory already exists: $output_dir"

set -l deps_dir "$work_dir/deps"
set -l prefix "$work_dir/prefix"
set -l tool_bin "$work_dir/bin"
set -l source_dir "$work_dir/src"
set -l lsw_source "$source_dir/L-SMASH-Works"
set -l toolchain "$work_dir/x86_64-w64-mingw32.cmake"

mkdir -p \
    "$deps_dir" \
    "$prefix/include" \
    "$prefix/lib/pkgconfig" \
    "$tool_bin" \
    "$source_dir" \
    "$output_dir"
or die "failed to create build directories"

set -l pkg_config_path (command -s pkg-config)
ln -s "$pkg_config_path" "$tool_bin/x86_64-w64-mingw32-pkg-config"
or die "failed to create the MinGW pkg-config wrapper"

set -gx PATH "$tool_bin" $PATH
set -gx PKG_CONFIG_PATH "$prefix/lib/pkgconfig"
set -gx PKG_CONFIG_LIBDIR "$prefix/lib/pkgconfig"

printf '%s\n' \
    'set(CMAKE_SYSTEM_NAME Windows)' \
    'set(CMAKE_SYSTEM_PROCESSOR x86_64)' \
    'set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)' \
    'set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)' \
    'set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)' \
    "set(CMAKE_FIND_ROOT_PATH \"$prefix\" \"/usr/x86_64-w64-mingw32\")" \
    "set(CMAKE_PREFIX_PATH \"$prefix\")" \
    'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)' \
    > "$toolchain"
or die "failed to write CMake toolchain file"

# Pinned source identities recovered from the validated 2026-07-31 build.
set -l lsw_base_commit a47764915f06fcd472e26ba2fbf25aff4b9d252e
set -l lsw_patched_commit 393df5ef669707f776261e4ac1bcc7e9a9a227ab
set -l zlib_commit da607da739fa6047df13e66a2af6b8bec7c2a498
set -l gme_commit fe8da4b6d3876d7542c2fb69d94487e19836d678
set -l dav1d_commit 54706fc6bc0cdecab7e9593974a4039cc038fca7
set -l libvpx_commit ade52487a37ef76a0f209bd39bea9fe67d6db4c4
set -l nvcodec_commit eddcea9e27f6b772057c9b3f87de2cc1737faffc
set -l libvpl_commit 674d015bcb294bc39fa276e99a652ea045423e82
set -l ffmpeg_commit cfa62de001af8ffeb7e22561f246469c7b809951
set -l obuparse_commit c2156b4a133714d0a9c04a7cd341efb1af415a33
set -l lsmash_commit 04315d02fef15a75f747493920724c91a62b8538

clone_commit \
    "L-SMASH Works" \
    "https://github.com/Mr-Ojii/L-SMASH-Works.git" \
    "$lsw_source" \
    "$lsw_base_commit"

note "Applying the hardware-frame-transfer patch"

env \
    GIT_COMMITTER_NAME='alexandergg-0520' \
    GIT_COMMITTER_EMAIL='uket.panda.1st@gmail.com' \
    GIT_COMMITTER_DATE='2026-07-31T03:58:59+09:00' \
    git \
    -C "$lsw_source" \
    -c commit.gpgSign=false \
    am \
    --committer-date-is-author-date \
    "$patch_file"
or die "failed to apply the L-SMASH Works patch"

set -l actual_lsw_commit (git -C "$lsw_source" rev-parse HEAD)
test "$actual_lsw_commit" = "$lsw_patched_commit"
or die "patched L-SMASH Works commit mismatch: expected $lsw_patched_commit, got $actual_lsw_commit"

git -C "$lsw_source" diff --quiet
or die "L-SMASH Works has an unexpected unstaged diff after git am"

git -C "$lsw_source" diff --cached --quiet
or die "L-SMASH Works has an unexpected staged diff after git am"

clone_commit \
    zlib \
    "https://github.com/madler/zlib.git" \
    "$deps_dir/zlib" \
    "$zlib_commit"

clone_commit \
    game-music-emu \
    "https://github.com/libgme/game-music-emu.git" \
    "$deps_dir/game-music-emu" \
    "$gme_commit"

clone_commit \
    dav1d \
    "https://code.videolan.org/videolan/dav1d.git" \
    "$deps_dir/dav1d" \
    "$dav1d_commit"

clone_commit \
    libvpx \
    "https://github.com/webmproject/libvpx.git" \
    "$deps_dir/libvpx" \
    "$libvpx_commit"

clone_commit \
    nv-codec-headers \
    "https://github.com/FFmpeg/nv-codec-headers.git" \
    "$deps_dir/nv-codec-headers" \
    "$nvcodec_commit"

clone_commit \
    libvpl \
    "https://github.com/intel/libvpl.git" \
    "$deps_dir/libvpl" \
    "$libvpl_commit"

clone_commit \
    FFmpeg \
    "https://github.com/FFmpeg/FFmpeg.git" \
    "$deps_dir/FFmpeg" \
    "$ffmpeg_commit"

clone_commit \
    obuparse \
    "https://github.com/dwbuiten/obuparse.git" \
    "$deps_dir/obuparse" \
    "$obuparse_commit"

clone_commit \
    l-smash \
    "https://github.com/Mr-Ojii/l-smash.git" \
    "$deps_dir/l-smash" \
    "$lsmash_commit"

note "Building zlib"
cd "$deps_dir/zlib"
or die "cannot enter zlib source"

env CROSS_PREFIX=x86_64-w64-mingw32- \
    ./configure \
    --static \
    --prefix="$prefix"
or die "zlib configure failed"

make -j "$jobs"
or die "zlib build failed"

make install
or die "zlib install failed"

note "Building game-music-emu (static)"
cd "$deps_dir/game-music-emu"
or die "cannot enter game-music-emu source"

cmake \
    -S . \
    -B build-static \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DCMAKE_PREFIX_PATH="$prefix" \
    -DZLIB_ROOT="$prefix" \
    -DZLIB_LIBRARY="$prefix/lib/libz.a" \
    -DZLIB_INCLUDE_DIR="$prefix/include" \
    -DZLIB_USE_STATIC_LIBS=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING=OFF \
    -DGME_BUILD_SHARED=OFF \
    -DGME_BUILD_STATIC=ON \
    -DGME_BUILD_EXAMPLES=OFF \
    -DGME_BUILD_TESTING=OFF \
    -DGME_ENABLE_UBSAN=OFF \
    -DGME_ENABLE_ASAN=OFF
or die "game-music-emu static configure failed"

cmake --build build-static -j "$jobs"
or die "game-music-emu static build failed"

cmake --install build-static
or die "game-music-emu static install failed"

note "Building game-music-emu (shared metadata/runtime build)"
cmake \
    -S . \
    -B build-shared \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DCMAKE_PREFIX_PATH="$prefix" \
    -DZLIB_LIBRARY="$prefix/lib/libz.a" \
    -DZLIB_INCLUDE_DIR="$prefix/include" \
    -DGME_BUILD_SHARED=ON \
    -DGME_BUILD_STATIC=OFF \
    -DGME_BUILD_EXAMPLES=OFF \
    -DGME_BUILD_TESTING=OFF \
    -DGME_ENABLE_UBSAN=OFF \
    -DGME_ENABLE_ASAN=OFF
or die "game-music-emu shared configure failed"

cmake --build build-shared -j "$jobs"
or die "game-music-emu shared build failed"

cmake --install build-shared
or die "game-music-emu shared install failed"

note "Building dav1d"
cd "$deps_dir/dav1d"
or die "cannot enter dav1d source"

meson setup \
    --cross-file=package/crossfiles/x86_64-w64-mingw32.meson \
    --buildtype=release \
    --default-library=static \
    -Denable_tests=false \
    --prefix="$prefix" \
    build-cross
or die "dav1d configure failed"

ninja -C build-cross
or die "dav1d build failed"

ninja -C build-cross install
or die "dav1d install failed"

note "Building libvpx"
mkdir "$deps_dir/libvpx/build-cross"
or die "failed to create libvpx build directory"

cd "$deps_dir/libvpx/build-cross"
or die "cannot enter libvpx build directory"

env CROSS=x86_64-w64-mingw32- \
    ../configure \
    --target=x86_64-win64-gcc \
    --enable-vp9-highbitdepth \
    --disable-docs \
    --disable-tools \
    --disable-examples \
    --disable-webm-io \
    --disable-vp8-encoder \
    --disable-vp9-encoder \
    --prefix="$prefix"
or die "libvpx configure failed"

make -j "$jobs"
or die "libvpx build failed"

make install
or die "libvpx install failed"

note "Installing nv-codec-headers"
cd "$deps_dir/nv-codec-headers"
or die "cannot enter nv-codec-headers source"

make PREFIX="$prefix" install
or die "nv-codec-headers install failed"

note "Building libvpl"
cd "$deps_dir/libvpl"
or die "cannot enter libvpl source"

cmake \
    -S . \
    -B build-cross \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DBUILD_EXPERIMENTAL=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DCXX_LIB=-lstdc++
or die "libvpl configure failed"

cmake --build build-cross -j "$jobs"
or die "libvpl build failed"

cmake --install build-cross
or die "libvpl install failed"

note "Checking pkg-config dependencies"
for module_name in dav1d vpx libgme vpl
    x86_64-w64-mingw32-pkg-config --modversion "$module_name"
    or die "pkg-config module unavailable: $module_name"
end

note "Building FFmpeg with AV1 CUVID"
cd "$deps_dir/FFmpeg"
or die "cannot enter FFmpeg source"

env \
    PKG_CONFIG_PATH="$prefix/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$prefix/lib/pkgconfig" \
    ./configure \
    --enable-version3 \
    --disable-hwaccels \
    --disable-encoders \
    --disable-avisynth \
    --disable-doc \
    --disable-network \
    --disable-programs \
    --disable-outdevs \
    --disable-indevs \
    --disable-avfilter \
    --disable-debug \
    --disable-muxers \
    --enable-avcodec \
    --enable-avformat \
    --enable-swresample \
    --enable-swscale \
    --enable-libdav1d \
    --enable-libvpx \
    --enable-libgme \
    --enable-libvpl \
    --enable-cuvid \
    --enable-decoder=av1_cuvid \
    --pkg-config=x86_64-w64-mingw32-pkg-config \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib" \
    --extra-libs=-lpthread \
    --cross-prefix=x86_64-w64-mingw32- \
    --target-os=mingw32 \
    --arch=x86_64 \
    --prefix="$prefix"
or die "FFmpeg configure failed"

grep -q '^#define CONFIG_CUVID 1' config.h
or die "FFmpeg CONFIG_CUVID is not enabled"

grep -q '^#define CONFIG_FFNVCODEC 1' config.h
or die "FFmpeg CONFIG_FFNVCODEC is not enabled"

grep -q '^#define CONFIG_AV1_CUVID_DECODER 1' config.h
or die "FFmpeg CONFIG_AV1_CUVID_DECODER is not enabled"

make -j "$jobs"
or die "FFmpeg build failed"

make install
or die "FFmpeg install failed"

note "Building obuparse"
cd "$deps_dir/obuparse"
or die "cannot enter obuparse source"

make \
    CROSS=x86_64-w64-mingw32- \
    -j "$jobs" \
    libobuparse.a
or die "obuparse build failed"

make \
    CROSS=x86_64-w64-mingw32- \
    PREFIX="$prefix" \
    install-static
or die "obuparse install failed"

note "Building l-smash"
cd "$deps_dir/l-smash"
or die "cannot enter l-smash source"

./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --target-os=mingw32 \
    --prefix="$prefix" \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib"
or die "l-smash configure failed"

make -j "$jobs" lib
or die "l-smash build failed"

make install-lib
or die "l-smash install failed"

note "Building patched L-SMASH Works r1284"
cd "$lsw_source/AviUtl2"
or die "cannot enter L-SMASH Works AviUtl2 source"

env \
    PKG_CONFIG_PATH="$prefix/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$prefix/lib/pkgconfig" \
    ./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --prefix="$prefix" \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib -static-libgcc -static-libstdc++ -static" \
    --extra-libs=-lpthread
or die "L-SMASH Works configure failed"

make -j "$jobs" input
or die "L-SMASH Works build failed"

set -l built_aui2 "$lsw_source/AviUtl2/lwinput.aui2"
test -s "$built_aui2"
or die "L-SMASH Works output missing or empty: $built_aui2"

file "$built_aui2" | grep -q 'PE32+ executable'
or die "L-SMASH Works output is not the expected PE32+ binary"

begin
    strings -a -n 5 "$built_aui2"
    strings -a --encoding=l -n 5 "$built_aui2"
end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
or die "the built plugin does not identify itself as r1284"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-cuvid'
or die "the built plugin does not contain the expected FFmpeg --enable-cuvid marker"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-decoder=av1_cuvid'
or die "the built plugin does not contain the expected av1_cuvid configure marker"

cp -a "$built_aui2" "$output_dir/lwinput.aui2"
or die "failed to copy lwinput.aui2 to output"

cp -a "$lsmash_ini" "$output_dir/lsmash.ini"
or die "failed to copy lsmash.ini to output"

set -l output_sha256 (sha256sum "$output_dir/lwinput.aui2" | string split ' ')[1]
set -l output_size (stat -c '%s' "$output_dir/lwinput.aui2")
set -l reference_sha256 fce81e0257a6730ada0729ffddfdb51d1528f8b4bdfb61488a7d01b074ab0fc3
set -l reference_size 26945536
set -l reference_xxh3 87dcdf17b419392c8172b843ab26e0a9

begin
    echo "L-SMASH Works NVDEC build provenance"
    echo "generated_at="(date --iso-8601=seconds)
    echo "work_dir=$work_dir"
    echo "prefix=$prefix"
    echo "jobs=$jobs"
    echo
    echo "source_commits:"
    echo "L-SMASH-Works=$lsw_patched_commit"
    echo "zlib=$zlib_commit"
    echo "game-music-emu=$gme_commit"
    echo "dav1d=$dav1d_commit"
    echo "libvpx=$libvpx_commit"
    echo "nv-codec-headers=$nvcodec_commit"
    echo "libvpl=$libvpl_commit"
    echo "FFmpeg=$ffmpeg_commit"
    echo "obuparse=$obuparse_commit"
    echo "l-smash=$lsmash_commit"
    echo
    echo "artifact:"
    echo "size=$output_size"
    echo "sha256=$output_sha256"
    echo "reference_size=$reference_size"
    echo "reference_sha256=$reference_sha256"
    echo "reference_xxh3_128=$reference_xxh3"
    echo
    echo "tool_versions:"
    x86_64-w64-mingw32-gcc --version | head -n 1
    cmake --version | head -n 1
    meson --version
    ninja --version
    nasm -v
    make --version | head -n 1
    pkg-config --version
end > "$output_dir/PROVENANCE.txt"
or die "failed to write provenance file"

sha256sum \
    "$output_dir/lwinput.aui2" \
    "$output_dir/lsmash.ini" \
    > "$output_dir/SHA256SUMS"
or die "failed to write SHA256SUMS"

note "Build completed"
echo "Output directory: $output_dir"
echo "lwinput.aui2 size: $output_size"
echo "lwinput.aui2 SHA-256: $output_sha256"
echo "Reference size: $reference_size"
echo "Reference SHA-256: $reference_sha256"
echo

if test "$output_sha256" = "$reference_sha256"
    echo "RESULT: byte-for-byte match with the original validated artifact"
else
    echo "RESULT: not a byte-for-byte match with the original artifact"
    echo "This is expected when the absolute build prefix or toolchain version differs."
    echo "The script already verified the pinned source commit, r1284 identity,"
    echo "and embedded AV1 CUVID configuration. Runtime validation is still required."
end

echo
echo "The plugin has NOT been installed into any Wine prefix."
echo "Pause Mr-Ojii.L-SMASH-Works in AviUtl2 Catalog before installing it."

```

# Appendix B — 実行されたL-SMASH Works install helperの完全本文

`S245-16`で実際に起動された `scripts/install-l-smash-works-nvdec.fish` の保存済み本文。

```fish
#!/usr/bin/env fish

# Install a validated patched L-SMASH Works r1284 artifact into an existing
# AviUtl2 Wine prefix while protecting it from AviUtl2 Catalog bulk updates.
#
# This script intentionally does NOT modify installed.json or hash-cache.json.

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --prefix PATH --artifact-dir PATH [--windows-user NAME]"
    echo
    echo "Required:"
    echo "  --prefix       Existing Wine/Proton prefix"
    echo "  --artifact-dir Directory containing lwinput.aui2 and lsmash.ini"
    echo
    echo "Default:"
    echo "  --windows-user steamuser"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function note
    echo
    echo "==> $argv"
end

function file_sha_or_missing
    set -l path $argv[1]
    if test -f "$path"
        sha256sum "$path" | string split ' ' | head -n 1
    else
        echo MISSING
    end
end

argparse \
    'h/help' \
    'p/prefix=' \
    'a/artifact-dir=' \
    'u/windows-user=' \
    -- $argv
or begin
    usage >&2
    exit 2
end

if set -q _flag_help
    usage
    exit 0
end

set -q _flag_prefix
or die "--prefix is required"

set -q _flag_artifact_dir
or die "--artifact-dir is required"

set -l prefix (string replace -r '/+$' '' -- (string trim -- "$_flag_prefix"))
set -l artifact_dir (string replace -r '/+$' '' -- (string trim -- "$_flag_artifact_dir"))
set -l windows_user steamuser

if set -q _flag_windows_user
    set windows_user (string trim -- "$_flag_windows_user")
end

test -n "$prefix"
or die "--prefix must not be empty"

test -n "$artifact_dir"
or die "--artifact-dir must not be empty"

test -n "$windows_user"
or die "--windows-user must not be empty"

for command_name in \
    python3 \
    sha256sum \
    strings \
    grep \
    cp \
    mkdir \
    date \
    pgrep \
    cmp \
    head

    command -q "$command_name"
    or die "required command not found: $command_name"
end

set -l plugin_dir "$prefix/drive_c/ProgramData/aviutl2/Plugin"
set -l roaming "$prefix/drive_c/users/$windows_user/AppData/Roaming/aviutl2-catalog"
set -l settings "$roaming/settings.json"
set -l installed "$roaming/installed.json"
set -l hash_cache "$roaming/hash-cache.json"
set -l built_aui2 "$artifact_dir/lwinput.aui2"
set -l built_ini "$artifact_dir/lsmash.ini"
set -l active_aui2 "$plugin_dir/lwinput.aui2"
set -l active_ini "$plugin_dir/lsmash.ini"
set -l package_id 'Mr-Ojii.L-SMASH-Works'

for required_path in \
    "$prefix/drive_c" \
    "$plugin_dir" \
    "$settings" \
    "$built_aui2" \
    "$built_ini"

    test -e "$required_path"
    or die "required path not found: $required_path"
end

# Do not race AviUtl2 or Catalog while replacing their files/settings.
if pgrep -af 'AviUtl2_Catalog\.exe|aviutl2\.exe' >/dev/null 2>&1
    pgrep -af 'AviUtl2_Catalog\.exe|aviutl2\.exe' >&2
    die "AviUtl2 or AviUtl2 Catalog appears to be running; close it first"
end

# Artifact validation. SHA-256 is intentionally not required to equal the
# original Alex build because the absolute build prefix is embedded in FFmpeg.
begin
    strings -a -n 5 "$built_aui2"
    strings -a --encoding=l -n 5 "$built_aui2"
end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
or die "artifact does not identify itself as L-SMASH Works r1284"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-cuvid'
or die "artifact lacks the FFmpeg --enable-cuvid marker"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-decoder=av1_cuvid'
or die "artifact lacks the FFmpeg av1_cuvid marker"

grep -qx 'libavsmash_disabled=1' "$built_ini"
or die "lsmash.ini must contain libavsmash_disabled=1"

grep -qx 'libav_disabled=0' "$built_ini"
or die "lsmash.ini must contain libav_disabled=0"

grep -qx 'preferred_decoders=av1_cuvid' "$built_ini"
or die "lsmash.ini must contain preferred_decoders=av1_cuvid"

set -l installed_before (file_sha_or_missing "$installed")
set -l hash_cache_before (file_sha_or_missing "$hash_cache")
set -l stamp (date +%Y%m%d-%H%M%S)

note "Creating backups"
cp -a "$settings" "$settings.before-lsmash-nvdec-$stamp"
or die "failed to back up Catalog settings"

if test -f "$active_aui2"
    cp -a "$active_aui2" "$active_aui2.before-lsmash-nvdec-$stamp"
    or die "failed to back up the existing lwinput.aui2"
end

if test -f "$active_ini"
    cp -a "$active_ini" "$active_ini.before-lsmash-nvdec-$stamp"
    or die "failed to back up the existing lsmash.ini"
end

note "Pausing the Catalog package before replacing the plugin"
python3 -c '
import json
import os
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
package_id = sys.argv[2]

data = json.loads(path.read_text(encoding="utf-8-sig"))
raw = data.get("package_updates_paused_ids", [])
if not isinstance(raw, list):
    raise SystemExit("package_updates_paused_ids is not a JSON array")

ids = sorted({str(value).strip() for value in raw if str(value).strip()})
if package_id not in ids:
    ids.append(package_id)
    ids.sort()

data["package_updates_paused_ids"] = ids

temporary = path.with_name(path.name + ".tmp-lsmash-nvdec")
temporary.write_text(
    json.dumps(data, ensure_ascii=False, indent=2) + "\n",
    encoding="utf-8",
)
os.replace(temporary, path)
' "$settings" "$package_id"
or die "failed to update Catalog package_updates_paused_ids"

python3 -c '
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
package_id = sys.argv[2]
data = json.loads(path.read_text(encoding="utf-8-sig"))
ids = data.get("package_updates_paused_ids", [])
if package_id not in ids:
    raise SystemExit(f"pause verification failed: {package_id}")
print(f"paused: {package_id}")
' "$settings" "$package_id"
or die "Catalog pause verification failed"

note "Installing patched L-SMASH Works r1284"
mkdir -p "$plugin_dir"
or die "failed to create plugin directory"

cp -f "$built_aui2" "$active_aui2"
or die "failed to install lwinput.aui2"

cp -f "$built_ini" "$active_ini"
or die "failed to install lsmash.ini"

cmp -s "$built_aui2" "$active_aui2"
or die "installed lwinput.aui2 differs from the artifact"

cmp -s "$built_ini" "$active_ini"
or die "installed lsmash.ini differs from the artifact"

set -l installed_after (file_sha_or_missing "$installed")
set -l hash_cache_after (file_sha_or_missing "$hash_cache")

test "$installed_after" = "$installed_before"
or die "installed.json changed unexpectedly"

test "$hash_cache_after" = "$hash_cache_before"
or die "hash-cache.json changed unexpectedly"

set -l active_sha256 (sha256sum "$active_aui2" | string split ' ')[1]

note "Installation completed"
echo "Active plugin: $active_aui2"
echo "SHA-256: $active_sha256"
echo "Catalog pause ID: $package_id"
echo "installed.json: unchanged ($installed_after)"
echo "hash-cache.json: unchanged ($hash_cache_after)"
echo
echo "Do not use Update, Reinstall, Remove, or initial setup for L-SMASH Works."
echo "Catalog will detect the custom file as installed version '不明'; this is expected."

```

# Appendix C — 実行確認不能のrestore helper本文

`restore-known-good-aviutl2.fish` は保存されているが、この台帳の証拠範囲ではscript自体を直接実行した終了出力を断定できない。したがって本文を保存するが成功手順へは昇格しない。

```fish
#!/usr/bin/env fish

# Restore the known-good AviUtl2 prefix and patched GE-Proton runner saved
# before the failed REPRODUCTION.md procedure replaced the active environment.
#
# Default: read-only audit
# Apply:   restore-known-good-aviutl2.fish --apply

function fail
    echo "ERROR: $argv" >&2
    exit 1
end

set MODE audit

if test (count $argv) -gt 1
    fail "usage: "(status filename)" [--apply]"
end

if test (count $argv) -eq 1
    switch "$argv[1]"
        case --apply
            set MODE apply
        case '*'
            fail "usage: "(status filename)" [--apply]"
    end
end

set ROOT \
    "$HOME/Games/aviutl2"

set ACTIVE_PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set SOURCE_PREFIX \
    "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

set GE_PARENT \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set ACTIVE_GE \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test"

set SOURCE_GE \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set EXPECTED_PLUGIN_SHA256 \
    "db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0"

function section
    echo
    echo "============================================================"
    echo "$argv"
    echo "============================================================"
end

function find_catalog
    set prefix "$argv[1]"

    find \
        "$prefix/drive_c" \
        -type f \
        -iname 'AviUtl2_Catalog.exe' \
        -print \
        -quit \
        2>/dev/null
end

function check_prefix
    set prefix "$argv[1]"

    for path in \
        "$prefix/user.reg" \
        "$prefix/system.reg" \
        "$prefix/userdef.reg" \
        "$prefix/drive_c/windows/system32" \
        "$prefix/drive_c/AviUtl2/aviutl2.exe" \
        "$prefix/drive_c/ProgramData/aviutl2"

        if not test -e "$path"
            echo "INCOMPLETE PREFIX: missing $path" >&2
            return 1
        end
    end

    set catalog_exe \
        (find_catalog "$prefix")

    if test (count $catalog_exe) -eq 0
        echo "INCOMPLETE PREFIX: Catalog executable was not found under $prefix/drive_c" >&2
        return 1
    end

    if not test -f "$catalog_exe"
        echo "INCOMPLETE PREFIX: Catalog executable is not a regular file: $catalog_exe" >&2
        return 1
    end

    echo "Catalog executable: $catalog_exe"

    set plugin \
        "$prefix/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

    if not test -f "$plugin"
        echo "INCOMPLETE PREFIX: L-SMASH Works plugin is missing: $plugin" >&2
        return 1
    end

    set plugin_sha \
        (sha256sum "$plugin" | string split ' ')[1]

    echo "Plugin SHA-256: $plugin_sha"
    return 0
end

function check_ge
    set ge "$argv[1]"

    for path in \
        "$ge/files/lib/wine/x86_64-unix/wine" \
        "$ge/files/bin/wineserver" \
        "$ge/files/lib/wine/x86_64-windows/dwrite.dll" \
        "$ge/files/lib/wine/x86_64-unix/dwrite.so"

        if not test -e "$path"
            echo "INCOMPLETE GE-PROTON: missing $path" >&2
            return 1
        end
    end

    if not test -x "$ge/files/lib/wine/x86_64-unix/wine"
        echo "INCOMPLETE GE-PROTON: Wine is not executable" >&2
        return 1
    end

    if not test -x "$ge/files/bin/wineserver"
        echo "INCOMPLETE GE-PROTON: wineserver is not executable" >&2
        return 1
    end

    return 0
end

function compare_file
    set source "$argv[1]"
    set copy "$argv[2]"

    cmp \
        --silent \
        "$source" \
        "$copy"
end

section "1. KNOWN-GOOD SOURCE PREFLIGHT"

test -d "$SOURCE_PREFIX"
or fail "known-good prefix backup is missing: $SOURCE_PREFIX"

test -d "$SOURCE_GE"
or fail "known-good GE-Proton backup is missing: $SOURCE_GE"

check_prefix "$SOURCE_PREFIX"
or fail "known-good prefix backup failed preflight"

check_ge "$SOURCE_GE"
or fail "known-good GE-Proton backup failed preflight"

set source_plugin_sha \
    (sha256sum "$SOURCE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" | string split ' ')[1]

test "$source_plugin_sha" = "$EXPECTED_PLUGIN_SHA256"
or fail "known-good prefix backup does not contain the expected rebuilt r1284 plugin"

section "2. ACTIVE TARGET AUDIT"

echo "Active prefix: $ACTIVE_PREFIX"

if test -d "$ACTIVE_PREFIX"
    for path in \
        "$ACTIVE_PREFIX/user.reg" \
        "$ACTIVE_PREFIX/system.reg" \
        "$ACTIVE_PREFIX/userdef.reg" \
        "$ACTIVE_PREFIX/drive_c/windows/system32" \
        "$ACTIVE_PREFIX/drive_c/AviUtl2/aviutl2.exe"

        if test -e "$path"
            echo "PRESENT: $path"
        else
            echo "MISSING: $path"
        end
    end
else
    echo "MISSING ACTIVE PREFIX"
end

echo
echo "Active GE-Proton: $ACTIVE_GE"

if test -d "$ACTIVE_GE"
    for path in \
        "$ACTIVE_GE/files/lib/wine/x86_64-unix/wine" \
        "$ACTIVE_GE/files/bin/wineserver" \
        "$ACTIVE_GE/files/lib/wine/x86_64-windows/dwrite.dll" \
        "$ACTIVE_GE/files/lib/wine/x86_64-unix/dwrite.so"

        if test -e "$path"
            echo "PRESENT: $path"
        else
            echo "MISSING: $path"
        end
    end
else
    echo "MISSING ACTIVE GE-PROTON"
end

if test "$MODE" = audit
    section "AUDIT COMPLETE"

    echo "No files were modified."
    echo
    echo "To restore the known-good prefix and runner, run:"
    echo "  "(status filename)" --apply"
    exit 0
end

section "3. STOP PREFIX"

set SOURCE_WINESERVER \
    "$SOURCE_GE/files/bin/wineserver"

set SOURCE_GE_LIBS \
    "$SOURCE_GE/files/lib64:$SOURCE_GE/files/lib:$SOURCE_GE/files/lib/wine/x86_64-unix:$SOURCE_GE/files/lib/wine/i386-unix"

env \
    WINEPREFIX="$ACTIVE_PREFIX" \
    LD_LIBRARY_PATH="$SOURCE_GE_LIBS" \
    "$SOURCE_WINESERVER" \
    -k \
    2>/dev/null

or true

env \
    WINEPREFIX="$ACTIVE_PREFIX" \
    LD_LIBRARY_PATH="$SOURCE_GE_LIBS" \
    "$SOURCE_WINESERVER" \
    -w \
    2>/dev/null

or true

sleep 1

section "4. CREATE VERIFIED STAGING COPIES"

set STAMP \
    (date +%Y%m%d-%H%M%S)

set PREFIX_STAGE \
    "$ROOT/.prefix-ge-nvdec-test.restore-$STAMP"

set PREFIX_BROKEN \
    "$ROOT/prefix-ge-nvdec-test.broken-$STAMP"

set PREFIX_FAILED \
    "$ROOT/prefix-ge-nvdec-test.failed-restore-$STAMP"

set GE_STAGE \
    "$GE_PARENT/.GE-Proton11-1-aviutl2-test.restore-$STAMP"

set GE_BROKEN \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test.broken-$STAMP"

set GE_FAILED \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test.failed-restore-$STAMP"

for path in \
    "$PREFIX_STAGE" \
    "$PREFIX_BROKEN" \
    "$PREFIX_FAILED" \
    "$GE_STAGE" \
    "$GE_BROKEN" \
    "$GE_FAILED"

    test ! -e "$path"
    or fail "transaction path already exists: $path"
end

cp -a \
    --reflink=auto \
    "$SOURCE_PREFIX" \
    "$PREFIX_STAGE"

or fail "failed to create prefix staging copy"

cp -a \
    --reflink=auto \
    "$SOURCE_GE" \
    "$GE_STAGE"

or fail "failed to create GE-Proton staging copy"

check_prefix "$PREFIX_STAGE"
or fail "prefix staging copy failed verification"

check_ge "$GE_STAGE"
or fail "GE-Proton staging copy failed verification"

for registry in \
    user.reg \
    system.reg \
    userdef.reg

    compare_file \
        "$SOURCE_PREFIX/$registry" \
        "$PREFIX_STAGE/$registry"
end

compare_file \
    "$SOURCE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
    "$PREFIX_STAGE/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

for relative in \
    files/lib/wine/x86_64-unix/wine \
    files/bin/wineserver \
    files/lib/wine/x86_64-windows/dwrite.dll \
    files/lib/wine/x86_64-unix/dwrite.so

    compare_file \
        "$SOURCE_GE/$relative" \
        "$GE_STAGE/$relative"
end

section "5. SWITCH ACTIVE ENVIRONMENT"

set HAD_ACTIVE_PREFIX 0
set HAD_ACTIVE_GE 0

if test -e "$ACTIVE_GE"
    mv \
        "$ACTIVE_GE" \
        "$GE_BROKEN"

    or fail "failed to preserve the current GE-Proton tree"

    set HAD_ACTIVE_GE 1
end

mv \
    "$GE_STAGE" \
    "$ACTIVE_GE"

or begin
    if test "$HAD_ACTIVE_GE" = 1
        and not test -e "$ACTIVE_GE"

        mv \
            "$GE_BROKEN" \
            "$ACTIVE_GE"

        and echo "Rolled back the original GE-Proton tree." >&2
    end

    fail "failed to promote the restored GE-Proton tree"
end

if test -e "$ACTIVE_PREFIX"
    mv \
        "$ACTIVE_PREFIX" \
        "$PREFIX_BROKEN"

    or begin
        mv \
            "$ACTIVE_GE" \
            "$GE_FAILED"

        if test "$HAD_ACTIVE_GE" = 1
            mv \
                "$GE_BROKEN" \
                "$ACTIVE_GE"
        end

        fail "failed to preserve the current prefix; GE-Proton was rolled back"
    end

    set HAD_ACTIVE_PREFIX 1
end

mv \
    "$PREFIX_STAGE" \
    "$ACTIVE_PREFIX"

or begin
    if test "$HAD_ACTIVE_PREFIX" = 1
        and not test -e "$ACTIVE_PREFIX"

        mv \
            "$PREFIX_BROKEN" \
            "$ACTIVE_PREFIX"
    end

    mv \
        "$ACTIVE_GE" \
        "$GE_FAILED"

    if test "$HAD_ACTIVE_GE" = 1
        mv \
            "$GE_BROKEN" \
            "$ACTIVE_GE"
    end

    fail "failed to promote the restored prefix; original environment was restored"
end

section "6. VERIFY PROMOTED ENVIRONMENT"

set VERIFY_FAILED 0

check_ge "$ACTIVE_GE"
or set VERIFY_FAILED 1

check_prefix "$ACTIVE_PREFIX"
or set VERIFY_FAILED 1

if test "$VERIFY_FAILED" = 1
    echo "ERROR: promoted environment failed verification; starting rollback" >&2

    if test -e "$ACTIVE_PREFIX"
        mv \
            "$ACTIVE_PREFIX" \
            "$PREFIX_FAILED"
    end

    if test "$HAD_ACTIVE_PREFIX" = 1
        and test -e "$PREFIX_BROKEN"

        mv \
            "$PREFIX_BROKEN" \
            "$ACTIVE_PREFIX"
    end

    if test -e "$ACTIVE_GE"
        mv \
            "$ACTIVE_GE" \
            "$GE_FAILED"
    end

    if test "$HAD_ACTIVE_GE" = 1
        and test -e "$GE_BROKEN"

        mv \
            "$GE_BROKEN" \
            "$ACTIVE_GE"
    end

    fail "restored environment failed final verification and was rolled back"
end

section "7. FINAL IDENTITY"

sha256sum \
    "$ACTIVE_PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    "$ACTIVE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
    "$ACTIVE_GE/files/lib/wine/x86_64-windows/dwrite.dll" \
    "$ACTIVE_GE/files/lib/wine/x86_64-unix/dwrite.so"

begin
    strings \
        -a \
        -n 6 \
        "$ACTIVE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

    strings \
        -a \
        -e l \
        -n 6 \
        "$ACTIVE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"
end \
    | grep \
        -E \
        'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid' \
    | sort \
        -u

section "RESTORE COMPLETE"

echo "Restored active prefix:"
echo "  $ACTIVE_PREFIX"
echo
echo "Restored active GE-Proton:"
echo "  $ACTIVE_GE"

if test "$HAD_ACTIVE_PREFIX" = 1
    echo
    echo "Preserved previous prefix:"
    echo "  $PREFIX_BROKEN"
end

if test "$HAD_ACTIVE_GE" = 1
    echo
    echo "Preserved previous GE-Proton:"
    echo "  $GE_BROKEN"
end

echo
echo "Next, inspect Catalog status:"
echo "  $REPO/scripts/manage-aviutl2-catalog-lutris.sh status"
echo
echo "Then launch Catalog:"
echo "  $REPO/scripts/manage-aviutl2-catalog-lutris.sh launch"

```

