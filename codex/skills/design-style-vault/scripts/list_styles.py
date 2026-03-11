from __future__ import annotations

import argparse
import pathlib
import re
import sys


STYLES_DIR = pathlib.Path(__file__).resolve().parent.parent / "references" / "styles"


def configure_output() -> None:
    for stream in (sys.stdout, sys.stderr):
        reconfigure = getattr(stream, "reconfigure", None)
        if callable(reconfigure):
            reconfigure(encoding="utf-8")


configure_output()


def parse_style_file(path: pathlib.Path) -> dict[str, str]:
    content = path.read_text(encoding="utf-8")
    match = re.match(r"\A---\r?\n(.*?)\r?\n---\r?\n(.*)\Z", content, re.S)
    if not match:
        raise ValueError(f"Invalid style file: {path}")

    metadata: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if not line.strip():
            continue
        key, value = line.split(":", 1)
        metadata[key.strip()] = value.strip()

    metadata["prompt"] = match.group(2).strip()
    metadata["path"] = str(path)
    return metadata


def load_styles() -> list[dict[str, str]]:
    styles = [parse_style_file(path) for path in sorted(STYLES_DIR.glob("*.md"))]
    styles.sort(key=lambda item: int(item.get("site_order", "999")))
    return styles


def main() -> int:
    parser = argparse.ArgumentParser(description="List archived design styles")
    parser.add_argument("--mode", choices=["light", "dark"])
    parser.add_argument("--type", choices=["sans", "serif", "mono", "unknown"])
    parser.add_argument("--query", help="Case-insensitive match against slug, name, or description")
    args = parser.parse_args()

    styles = load_styles()

    if args.mode:
        styles = [style for style in styles if style.get("mode") == args.mode]
    if args.type:
        styles = [style for style in styles if style.get("type") == args.type]
    if args.query:
        needle = args.query.lower()
        styles = [
            style
            for style in styles
            if needle in style.get("slug", "").lower()
            or needle in style.get("name", "").lower()
            or needle in style.get("description", "").lower()
        ]

    if not styles:
        print("No archived styles matched.")
        return 1

    for style in styles:
        order = style.get("site_order", "?").rjust(2, "0")
        mode = style.get("mode", "unknown")
        type_name = style.get("type", "unknown")
        print(f"[{order}] {style['slug']} | {style['name']} | {mode} | {type_name}")
        print(f"    {style['description']}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
