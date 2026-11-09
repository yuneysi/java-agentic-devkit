#!/usr/bin/env python3
"""Install the devkit skills into OpenCode; preserve other skills and back up replacements."""
import argparse
import datetime
import json
import hashlib
from pathlib import Path
import shutil


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dest", type=Path, default=Path.home() / ".config/opencode/skills")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    lock = json.loads((root / "opencode/community-skills.lock.json").read_text())
    for source in lock["sources"]:
        directory = root / "opencode/skills/community" / source["name"]
        for relative, expected in source["files"].items():
            actual = hashlib.sha256((directory / relative).read_bytes()).hexdigest()
            if actual != expected:
                raise SystemExit("Upstream checksum mismatch: " + source["name"] + "/" + relative)
    sources = [root / "opencode/skills", root / "templates/java21-migration/skills"]
    skills = {}
    for source in sources:
        for entry in sorted(source.rglob("SKILL.md")):
            if "phases" in entry.relative_to(source).parts:
                continue
            # All bundled entry points use a plain scalar name.
            name = next(line.split(":", 1)[1].strip() for line in entry.read_text().splitlines() if line.startswith("name:"))
            if name in skills:
                raise SystemExit("Duplicate skill: " + name)
            skills[name] = entry.parent
    destination = args.dest.expanduser().resolve()
    if any(source.resolve() == destination or source.resolve() in destination.parents or destination in source.resolve().parents for source in sources):
        raise SystemExit("Destination must not overlap skill sources")
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    backup = destination.parent / ("devkit-skills-backup-" + stamp)
    for name, source in skills.items():
        target = destination / name
        destination.mkdir(parents=True, exist_ok=True)
        if target.exists() or target.is_symlink():
            backup.mkdir(parents=True, exist_ok=True)
            target.rename(backup / name)
        shutil.copytree(source, target)
        print("Installed " + name)
    if backup.exists():
        print("Backup: " + str(backup))
    print("Restart OpenCode to reload skills. Existing runtime configuration was preserved.")


if __name__ == "__main__":
    main()
