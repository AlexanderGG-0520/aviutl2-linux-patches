# Documentation

このディレクトリは、AviUtl2 を Linux 上で動かすために作成したパッチ群の技術文書を収録する。

## 文書の読み方

このプロジェクトでは、次の3種類を明確に区別する。

- **元環境で確認済み**: `/home/alex` の CachyOS 環境で実際に動作確認した内容
- **別環境で再現確認中**: `/home/nanashi/Games/aviutl2` で現在検証している内容
- **未検証**: コマンド例または設計は存在するが、クリーン環境で最後まで通した確認がない内容

「元環境で動いた」と「第三者がクリーン環境から再現できた」は同じ意味ではない。
`REPRODUCTION.md` は、未確認の箇所を確認済みとして扱わない。

## 文書一覧

| 文書 | 内容 |
| --- | --- |
| [`REPRODUCTION.md`](REPRODUCTION.md) | 実際の構成と、クリーン環境で再現するための手順・停止条件 |
| [`STATUS.md`](STATUS.md) | 元環境と別環境の進捗、確認済み・未確認の一覧 |
| [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) | 実際に発生したエラーと切り分け方法 |
| [`TECHNICAL-NOTES.md`](TECHNICAL-NOTES.md) | DXVK、Wine DWrite、L-SMASH Works の修正理由 |
| [`LUTRIS-CATALOG.md`](LUTRIS-CATALOG.md) | 固定ランチャー、Lutris、AviUtl2 Catalog の運用 |

## 正本

実行時の GE-Proton パスと環境変数については、次の管理スクリプトを正本とする。

```text
scripts/manage-aviutl2-catalog-lutris.sh
```

特に、実際に使用した Wine バイナリは次である。

```text
GE_WINE=$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine
GE_WINESERVER=$GE_PROTON_ROOT/files/bin/wineserver
```

`files/bin/wine` を使用する別手順と混在させない。
