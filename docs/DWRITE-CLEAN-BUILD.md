# Wine DWrite clean-room build

最終更新: 2026-08-02

この手順は、既存のWine source tree、既存のWine build tree、既存のpatched `dwrite.dll`を入力にしない。
固定Wine sourceから新しいsource/build directoryを作成し、repositoryのDWrite patchを適用して、x86-64 PE版`dwrite.dll`を生成する。

## 固定入力

```text
Wine repository: ValveSoftware/wine
Wine commit: 31af7f983b2e345d11340b120ae3a39d88c9338a
Baseline dlls/dwrite/layout.c blob:
aefb49296b350c94372a3c793b1cafc7c2672e87

Patch 1:
patches/wine/0001-implement-dwrite-hit-testing.patch

Patch 2:
patches/wine/0002-harden-dwrite-hittestpoint.patch

Configure option:
--enable-archs=x86_64

Build target:
dlls/dwrite/x86_64-windows/dwrite.dll
```

## 1. 依存関係

CachyOS / Arch Linux:

```fish
sudo pacman -S --needed \
    base-devel \
    curl \
    flex \
    bison \
    mingw-w64-gcc
```

`base-devel`には、この手順で必要な`autoconf`、`make`、`patch`、`pkgconf`などが含まれる。

## 2. repositoryを更新する

```fish
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

## 3. clean-room buildを実行する

既存の`$HOME/Games/aviutl2/src/wine-ge11-1-dwrite`および`$HOME/Games/aviutl2/build/wine-ge11-1-dwrite`は使用しない。
clean build専用directoryを指定する。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set DWRITE_CLEAN_WORK \
    "$ROOT/build/dwrite-clean"

fish \
    "$REPO/scripts/build-dwrite-clean.fish" \
    "$DWRITE_CLEAN_WORK" \
    (nproc)
```

scriptは毎回、次のdirectoryを削除して新規作成する。

```text
$DWRITE_CLEAN_WORK/source
$DWRITE_CLEAN_WORK/build
```

download済みWine archiveだけは次にcacheする。

```text
$DWRITE_CLEAN_WORK/downloads
```

cache archiveも展開前に`tar -tzf`で検査される。

## 4. build成功条件

scriptがstatus `0`で終了し、最後に次を表示すること。

```text
Clean DWrite build completed.
DWRITE_PATH=...
DWRITE_SHA256=...
PROVENANCE=...
SHA256SUMS=...
```

生成物path:

```fish
set BUILT_DWRITE \
    "$DWRITE_CLEAN_WORK/build/dlls/dwrite/x86_64-windows/dwrite.dll"
```

確認する。

```fish
test -s "$BUILT_DWRITE"

file \
    "$BUILT_DWRITE"

sha256sum \
    "$BUILT_DWRITE"

cat \
    "$DWRITE_CLEAN_WORK/PROVENANCE.txt"
```

`file`の出力には次が必要である。

```text
PE32+ executable for WINE (DLL), x86-64
```

## 5. runnerを選択する

runnerのdirectory名は動作条件ではない。
実在するGE-Proton 11-1 runnerを明示する。

既存runnerへ直接導入する場合の例:

```fish
set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
```

元runnerを保持して別copyへ導入する場合:

```fish
set GE_BASE \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set GE_STOCK \
    "$GE_BASE/GE-Proton11-1"

set GE_PROTON_ROOT \
    "$GE_BASE/GE-Proton11-1-aviutl2"

if test -e "$GE_PROTON_ROOT"
    set STAMP \
        (date +%Y%m%d-%H%M%S)

    mv \
        "$GE_PROTON_ROOT" \
        "$GE_PROTON_ROOT.before-dwrite-$STAMP"
end

cp -a \
    --reflink=auto \
    "$GE_STOCK" \
    "$GE_PROTON_ROOT"
```

存在確認:

```fish
set GE_DWRITE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

set GE_WINE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

for path in \
    "$GE_PROTON_ROOT" \
    "$GE_DWRITE" \
    "$GE_WINE" \
    "$GE_WINESERVER"

    test -e "$path"
    or begin
        echo "ERROR: runner prerequisite is missing: $path" >&2
        return 1
    end
end
```

存在しない`GE-Proton11-1-aviutl2`を先に検証してはならない。
別copy方式では、必ず`cp -a`が成功した後に検証する。

## 6. built DLLをrunnerへ導入する

```fish
fish \
    "$REPO/scripts/install-dwrite.fish" \
    "$DWRITE_CLEAN_WORK/build" \
    "$GE_PROTON_ROOT"
```

`install-dwrite.fish`は次を行う。

1. build成果物とrunner内の導入先が存在することを確認する
2. runner内の既存`dwrite.dll`をtimestamp付きでbackupする
3. PE版`dwrite.dll`だけを置換する
4. `cmp`でbuild成果物と導入先のbyte一致を確認する
5. 一致しなければbackupを復元して非0で終了する

`files/lib/wine/x86_64-unix/dwrite.so`は置換しない。

## 7. 最終検証

```fish
cmp \
    --silent \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"

and sha256sum \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"
```

`cmp`がstatus `0`で、二つのSHA-256が一致したrunnerだけをAviUtl2起動に使用する。

runtime変数は選択したrunnerから再計算する。

```fish
set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"
```

## 8. clean-roomと判定する条件

次をすべて満たした場合だけ、このbuildをclean-room成功と扱う。

- 固定commit archiveからsourceを新規展開した
- `layout.c`のGit blobが固定値と一致した
- Patch 1とPatch 2がそれぞれ`patch --dry-run`に成功した
- `.rej`が存在しない
- `./autogen.sh`がstatus 0で終了した
- `configure --enable-archs=x86_64`がstatus 0で終了した
- `make -B`を使用していない
- `make dlls/dwrite`を使用していない
- 完全target`dlls/dwrite/x86_64-windows/dwrite.dll`をbuildした
- 生成物がx86-64 Wine PE DLLである
- patched source markerが生成物へ埋め込まれている
- runner導入後にbuild成果物と`cmp`で一致した

## 9. 既存成功履歴との対応

2026-07-30のAlex環境では、固定Wine sourceの新規展開後に次が実行され、configureとDWrite buildが成功した。

```fish
cd "$WINE_SRC"
./autogen.sh

cd "$WINE_BUILD"

"$WINE_SRC/configure" \
    --enable-archs=x86_64

rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make \
    -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

`build-dwrite-clean.fish`は、この成功経路へ固定source検証、patch dry-run、reject検査、ログ、provenance、artifact検査を追加したものである。
