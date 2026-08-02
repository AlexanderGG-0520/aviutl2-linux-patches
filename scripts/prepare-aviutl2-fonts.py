#!/usr/bin/env python3
"""Prepare the four font files required by the AviUtl2 Wine prefix.

The script copies Arch Linux's Noto Sans CJK TTC files and derives two local,
Tahoma-named OTF files for Wine/DirectWrite compatibility. Generated fonts are
for local compatibility use and are not committed to this repository.
"""

from __future__ import annotations

import argparse
import hashlib
import shutil
import sys
from pathlib import Path

from fontTools.ttLib import TTCollection, TTFont


NAME_IDS = {1, 2, 3, 4, 6, 16, 17, 21, 22}


def die(message: str) -> "NoReturn":
    raise SystemExit(f"ERROR: {message}")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def decoded_names(font: TTFont, name_id: int) -> set[str]:
    values: set[str] = set()
    for record in font["name"].names:
        if record.nameID != name_id:
            continue
        try:
            values.add(record.toUnicode())
        except Exception:
            continue
    return values


def select_japanese_face(collection: TTCollection, source: Path) -> TTFont:
    for font in collection.fonts:
        names = decoded_names(font, 16) | decoded_names(font, 1)
        if any("Noto Sans CJK JP" in value for value in names):
            return font
    available = sorted(", ".join(sorted(decoded_names(font, 1))) for font in collection.fonts)
    die(f"Japanese Noto Sans CJK face was not found in {source}; faces={available}")


def set_compatibility_names(font: TTFont, *, bold: bool) -> None:
    subfamily = "Bold" if bold else "Regular"
    full_name = "Tahoma Bold" if bold else "Tahoma"
    postscript = "Tahoma-Bold" if bold else "Tahoma"
    unique = f"AviUtl2 local compatibility font; {full_name}"

    name_table = font["name"]
    name_table.names = [record for record in name_table.names if record.nameID not in NAME_IDS]

    values = {
        1: "Tahoma",
        2: subfamily,
        3: unique,
        4: full_name,
        6: postscript,
        16: "Tahoma",
        17: subfamily,
        21: "Tahoma",
        22: subfamily,
    }

    for name_id, value in values.items():
        # Windows Unicode, English and Japanese.
        name_table.setName(value, name_id, 3, 1, 0x0409)
        name_table.setName(value, name_id, 3, 1, 0x0411)
        # Unicode platform fallback.
        name_table.setName(value, name_id, 0, 4, 0)


def build_tahoma_compat(source: Path, destination: Path, *, bold: bool) -> None:
    collection = TTCollection(str(source), lazy=False)
    try:
        font = select_japanese_face(collection, source)
        set_compatibility_names(font, bold=bold)
        destination.parent.mkdir(parents=True, exist_ok=True)
        font.save(str(destination), reorderTables=True)
    finally:
        collection.close()

    check = TTFont(str(destination), lazy=False)
    try:
        families = decoded_names(check, 16) | decoded_names(check, 1)
        expected_full = "Tahoma Bold" if bold else "Tahoma"
        full_names = decoded_names(check, 4)
        if "Tahoma" not in families or expected_full not in full_names:
            die(f"generated font name verification failed: {destination}")
    finally:
        check.close()


def locate_font(filename: str) -> Path:
    roots = [Path("/usr/share/fonts"), Path.home() / ".local/share/fonts"]
    matches: list[Path] = []
    for root in roots:
        if root.is_dir():
            matches.extend(root.rglob(filename))
    matches = sorted({path.resolve() for path in matches if path.is_file()})
    if len(matches) != 1:
        rendered = ", ".join(str(path) for path in matches) or "none"
        die(f"expected exactly one {filename}; found: {rendered}")
    return matches[0]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output-dir",
        default=str(Path.home() / "Games/aviutl2/artifacts/fonts"),
    )
    args = parser.parse_args()

    output_dir = Path(args.output_dir).expanduser().resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    regular_source = locate_font("NotoSansCJK-Regular.ttc")
    bold_source = locate_font("NotoSansCJK-Bold.ttc")

    outputs = {
        "NotoSansCJK-Regular.ttc": output_dir / "NotoSansCJK-Regular.ttc",
        "NotoSansCJK-Bold.ttc": output_dir / "NotoSansCJK-Bold.ttc",
        "Tahoma-Noto-Regular.otf": output_dir / "Tahoma-Noto-Regular.otf",
        "Tahoma-Noto-Bold.otf": output_dir / "Tahoma-Noto-Bold.otf",
    }

    shutil.copy2(regular_source, outputs["NotoSansCJK-Regular.ttc"])
    shutil.copy2(bold_source, outputs["NotoSansCJK-Bold.ttc"])
    build_tahoma_compat(regular_source, outputs["Tahoma-Noto-Regular.otf"], bold=False)
    build_tahoma_compat(bold_source, outputs["Tahoma-Noto-Bold.otf"], bold=True)

    sums_path = output_dir / "SHA256SUMS"
    with sums_path.open("w", encoding="utf-8") as handle:
        for name, path in outputs.items():
            if not path.is_file() or path.stat().st_size == 0:
                die(f"missing or empty output: {path}")
            digest = sha256(path)
            handle.write(f"{digest}  {name}\n")
            print(f"{digest}  {path}")

    print(f"Font artifacts prepared: {output_dir}")
    print("Do not commit generated Tahoma compatibility fonts to the repository.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
