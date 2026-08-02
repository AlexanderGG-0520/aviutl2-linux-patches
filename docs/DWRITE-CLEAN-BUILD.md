# Wine DWrite clean-room build

最終更新: 2026-08-02

この文書は、既存のWine source tree、Wine build tree、過去の`dwrite.dll`に依存せず、AviUtl2用のpatched Wine DWrite PE DLLを新規生成してGE-Proton 11-1へ導入する正本手順である。

build処理の正本は`./scripts/build-dwrite-clean.fish`とする。文書内へ同じ処理を別実装しない。

## 固定入力

| 項目 | 値 |
| --- | --- |
| Wine repository | `ValveSoftware/wine` |
| Wine commit | `31af7f983b2e345d11340b120ae3a39d88c9338a` |
| baseline `layout.c` Git blob | `aefb49296b350c94372a3c793b1cafc7c2672e87` |
| patch 1 | `patches/wine/0001-implement-dwrite-hit-testing.patch` |
| patch 2 | `patches/wine/0002-harden-dwrite-hittestpoint.patch` |
| configure option | `--enable-archs=x86_64` |
| build target | `dlls/dwrite/x86_64-windows/dwrite.dll` |
| GE-Proton内の導入先 | `files/lib/wine/x86_64-windows/dwrite.dll` |

runner directoryのbasenameは動作条件ではない。`GE-Proton11-1`へ直接導入しても、別名copyへ導入してもよい。

`dwrite.so`はこの手順の生成物ではないため置換しない。

## 1. build依存関係

CachyOS / Arch Linux:

```fish
sudo pacman -S --needed \
    base-devel \
    fish \
    git \
    curl \
    tar \
    patch \
    file \
    binutils \
    coreutils \
    grep \
    autoconf \
    flex \
    bison \
    gettext \
    pkgconf \
    freetype2 \
    libx11 \
    mingw-w64-binutils \
    mingw-w64-crt \
    mingw-w64-gcc \
    mingw-w64-headers \
    mingw-w64-winpthreads
```

GitHub ActionsのUbuntu 24.04 clean environmentでは、次のpackage集合でbuildが完走することを確認している。

```text
autoconf
binutils
bison
build-essential
curl
file
fish
flex
gettext
git
libfreetype-dev
libx11-dev
mingw-w64
patch
pkg-config
tar
```

`libx11-dev`がない場合、Wine configureは`X 64-bit development files not found`で失敗する。

`libfreetype-dev`がない場合、Wine configureは`FreeType 64-bit development files not found`で失敗する。

## 2. repositoryを更新する

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

cd "$REPO"
git pull --ff-only
```

次のfileが存在することを確認する。

```fish
for path in \
    "$REPO/scripts/build-dwrite-clean.fish" \
    "$REPO/scripts/install-dwrite.fish" \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch" \
    "$REPO/patches/wine/0002-harden-dwrite-hittestpoint.patch"

    test -s "$path"
    or begin
        echo "ERROR: missing or empty file: $path" >&2
        return 1
    end
end
```

## 3. 空のsource/build treeからDWriteをbuildする

buildごとに新しいwork directoryを指定する。

```fish
set DWRITE_CLEAN_ROOT \
    "$ROOT/build/dwrite-clean-"(date +%Y%m%d-%H%M%S)

fish \
    "$REPO/scripts/build-dwrite-clean.fish" \
    "$DWRITE_CLEAN_ROOT" \
    (nproc)
```

scriptは次を順番に実行する。

1. 固定Wine commitのarchiveを取得する。
2. `source`と`build` directoryを削除して新規作成する。
3. 展開直後の`dlls/dwrite/layout.c`が固定baseline blobと一致することを確認する。
4. patch 1とpatch 2をそれぞれ`patch --dry-run -p1`してから適用する。
5. `.rej`が存在しないこととpatched source markerを確認する。
6. source treeで`./autogen.sh`を実行する。
7. 空のbuild treeで`configure --enable-archs=x86_64`を実行する。
8. `layout.o`と既存`dwrite.dll`を削除する。
9. exact target `dlls/dwrite/x86_64-windows/dwrite.dll`をbuildする。
10. PE32+、DLL、x86-64であることと、patched markerがDLL内に存在することを確認する。
11. SHA-256とprovenanceを保存する。

成功時の生成物:

```fish
set WINE_BUILD \
    "$DWRITE_CLEAN_ROOT/build"

set BUILT_DWRITE \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

file "$BUILT_DWRITE"
sha256sum "$BUILT_DWRITE"
cat "$DWRITE_CLEAN_ROOT/PROVENANCE.txt"
cat "$DWRITE_CLEAN_ROOT/SHA256SUMS"
```

`file`には少なくとも次の三つが含まれなければならない。

```text
PE32+ executable
(DLL)
x86-64
```

## 4. 使用するGE-Proton runnerを選ぶ

既存の`GE-Proton11-1`へ直接導入する例:

```fish
set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
```

元runnerを保持して別名copyへ導入する例:

```fish
set GE_BASE \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set GE_SOURCE \
    "$GE_BASE/GE-Proton11-1"

set GE_PROTON_ROOT \
    "$GE_BASE/GE-Proton11-1-aviutl2"

if not test -e "$GE_PROTON_ROOT"
    cp -a \
        --reflink=auto \
        "$GE_SOURCE" \
        "$GE_PROTON_ROOT"
end
```

存在しない別名runnerを先に検証してはならない。別copy方式では、必ず`cp -a`が成功した後に検証する。

## 5. built DWriteをrunnerへ導入する

```fish
fish \
    "$REPO/scripts/install-dwrite.fish" \
    "$WINE_BUILD" \
    "$GE_PROTON_ROOT"
```

`install-dwrite.fish`が置換する対象は次だけである。

```text
$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll
```

## 6. build成果物とrunnerをbyte単位で検証する

```fish
set GE_WINE \
    "$GE_PROTON_ROOT/files/bin/wine"

if not test -x "$GE_WINE"
    set GE_WINE \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"
end

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_DWRITE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"

for path in \
    "$GE_PROTON_ROOT" \
    "$GE_WINE" \
    "$GE_WINESERVER" \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"

    test -e "$path"
    or begin
        echo "ERROR: missing required path: $path" >&2
        return 1
    end
end

cmp \
    --silent \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"
or begin
    echo "ERROR: installed DWrite differs from the clean build" >&2
    sha256sum \
        "$BUILT_DWRITE" \
        "$GE_DWRITE"
    return 1
end

sha256sum \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"
```

`cmp`がstatus 0で終了し、二つのSHA-256が一致した場合だけ、その`GE_PROTON_ROOT`をAviUtl2のruntime runnerとして使用する。

runner名、更新日時、backup fileの存在だけでは合格としない。

## 7. clean-room CIの検証範囲

`.github/workflows/dwrite-clean-build.yml`はUbuntu 24.04の空環境で次を検証する。

- build依存packageの新規導入
- Fish syntax
- 固定Wine sourceとbaseline blob
- 二つのpatchのdry-runと適用
- `autogen.sh`
- out-of-tree configure
- exact DWrite PE targetのcompile/link
- PE32+ / DLL / x86-64判定
- patched markerの埋め込み
- provenanceとSHA-256の生成
- DLLとlogのartifact upload

2026-08-02に成功したclean CI artifactの値:

```text
WINE_COMMIT=31af7f983b2e345d11340b120ae3a39d88c9338a
BASELINE_LAYOUT_BLOB=aefb49296b350c94372a3c793b1cafc7c2672e87
PATCH_1_SHA256=4a30fe8c8251734f24f614f45035818d8a442d3f45f26620bda0b97fe43eff9c
PATCH_2_SHA256=24fb566429b5394ae7a8cc0c38fb58da4c1f7b203cdb805b18e94c1ed6c60c1c
DWRITE_SHA256=a4c8216484dfb6c185082536875c97ebed6fac00f69459c381b00a08c87ca0fc
```

最後の`DWRITE_SHA256`はCIのcompiler、binutils、Wine build environmentに対する値である。異なるtoolchainでbyte-identicalになることは合格条件にしない。

各環境での合格条件は、その環境でclean buildした`BUILT_DWRITE`とrunnerへ導入した`GE_DWRITE`が`cmp`で一致することである。

## 8. 失敗時に保存するもの

```fish
printf '%s\n' \
    "$DWRITE_CLEAN_ROOT/logs/autogen.log" \
    "$DWRITE_CLEAN_ROOT/logs/configure.log" \
    "$DWRITE_CLEAN_ROOT/logs/build.log" \
    "$DWRITE_CLEAN_ROOT/logs/file.log" \
    "$DWRITE_CLEAN_ROOT/PROVENANCE.txt" \
    "$DWRITE_CLEAN_ROOT/SHA256SUMS"
```

patch失敗、configure失敗、compile失敗、生成物検証失敗を同じ「DWrite build失敗」として扱わず、最初に失敗したstageのlogを確認する。
