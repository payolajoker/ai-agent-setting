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


def load_styles() -> dict[str, dict[str, str]]:
    styles = {}
    for path in STYLES_DIR.glob("*.md"):
        style = parse_style_file(path)
        styles[style["slug"]] = style
    return styles


def main() -> int:
    parser = argparse.ArgumentParser(description="Show one archived design style")
    parser.add_argument("slug")
    parser.add_argument("--prompt-only", action="store_true")
    parser.add_argument("--metadata-only", action="store_true")
    args = parser.parse_args()

    styles = load_styles()
    style = styles.get(args.slug)

    if not style:
        print(f"Unknown style slug: {args.slug}", file=sys.stderr)
        print("Available slugs:", file=sys.stderr)
        for slug in sorted(styles):
            print(f"- {slug}", file=sys.stderr)
        return 1

    if args.prompt_only:
        print(style["prompt"])
        return 0

    print(f"slug: {style['slug']}")
    print(f"name: {style['name']}")
    print(f"mode: {style.get('mode', 'unknown')}")
    print(f"type: {style.get('type', 'unknown')}")
    print(f"site_order: {style.get('site_order', '?')}")
    print(f"source_url: {style.get('source_url', '')}")
    print(f"prompt_characters: {style.get('prompt_characters', '?')}")
    print(f"path: {style['path']}")
    print()
    print(style["description"])

    if args.metadata_only:
        return 0

    print()
    print(style["prompt"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
