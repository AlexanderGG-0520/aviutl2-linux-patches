# Troubleshooting

## Runtime still reports `HitTestPoint(): stub`

The new source was not included in the DLL.

Check:

```fish
grep -n "dwritetextlayout_HitTestPoint"     /path/to/wine-source/dlls/dwrite/layout.c
```

Remove the old object and DLL:

```fish
rm -f     /path/to/wine-build/dlls/dwrite/x86_64-windows/layout.o     /path/to/wine-build/dlls/dwrite/x86_64-windows/dwrite.dll
```

Build the exact target:

```fish
make -C /path/to/wine-build     -j(nproc)     dlls/dwrite/x86_64-windows/dwrite.dll
```

## `make dlls/dwrite` does nothing

`dlls/dwrite` is also an existing directory, so Make may consider that target
complete. Use the full DLL target instead.

## Configure runs unexpectedly

Avoid `make -B`. It may force Wine configure to run again.

## Patch file is empty

The tested Wine source directory was not itself a Git repository. Generate the
patch with `diff -u` against a known baseline file, or place the source under
version control first.

## Confirming the loaded implementation

Launch with:

```fish
WINEDEBUG="-all,+dwrite,+seh"
```

A working implementation logs:

```text
trace:dwrite:dwritetextlayout_HitTestPoint
```

A stale DLL logs:

```text
fixme:dwrite:dwritetextlayout_HitTestPoint ... stub
```
