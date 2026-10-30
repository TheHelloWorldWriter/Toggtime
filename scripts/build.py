"""Build the DOS version of Toggtime with Turbo Pascal 7.0 in DOSBox.

The compiler runs inside a DOSBox Staging that starts, compiles and exits on
its own, working on a temporary copy of the source so the repo stays clean.
Run from anywhere: python scripts/build.py [--web] [--package]

Environment variables:
  DOSBOX      the DOSBox Staging executable
  DOS_C_DIR   the folder mounted as the DOS C: drive
  TPC         the compiler's DOS path on that drive (default C:\\BP\\BIN\\TPC.EXE)
"""

import argparse
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path, PureWindowsPath

REPO_DIR = Path(__file__).resolve().parent.parent
PROGRAM = REPO_DIR / "SRC" / "TOGGTIME.PAS"
UNITS_DIR = REPO_DIR / "UNITS"
WEB_BUNDLE = REPO_DIR / "web" / "toggtime.jsdos"
DIST_DIR = REPO_DIR / "dist"

VERSION = "1.0.0"
PACKAGE = DIST_DIR / f"toggtime-{VERSION}-dos.zip"

DEFAULT_TPC = r"C:\BP\BIN\TPC.EXE"

# SHA-256 of TOGGTIME.EXE as the current source builds it, the same EXE as in
# the v1.0.0 release; a change here means the program itself changed
EXPECTED_SHA256 = "600ed9ebcdcb89858e68e78d75c9e8ce88e0f87bbfb6252320dcf2a0c717de9c"

# The fixed cycles keep the speed steady across machines and stay below the
# speed at which the unpatched Crt unit fails with runtime error 200
BUNDLE_DOSBOX_CONF = """\
[cpu]
cycles=fixed 3000

[autoexec]
@echo off
mount c .
c:
toggtime
echo Type TOGGTIME to run Toggtime again.
"""

# Fixed dates keep the bundle and the ZIP byte-identical across builds; the
# ZIP's is the v1.0.0 release date
BUNDLE_DATE = (1995, 10, 13, 0, 0, 0)
PACKAGE_DATE = (2026, 4, 10, 0, 0, 0)


def add_file(archive: zipfile.ZipFile, name: str, data: bytes, date: tuple) -> None:
    info = zipfile.ZipInfo(name, date)
    info.compress_type = zipfile.ZIP_DEFLATED
    archive.writestr(info, data)


def required_env(name: str, description: str) -> Path:
    value = os.environ.get(name)
    if not value:
        sys.exit(f"Set {name} to {description}")
    return Path(value)


def compile_exe(build_dir: Path) -> bytes:
    dosbox = required_env("DOSBOX", "the DOSBox Staging executable")
    dos_c_dir = required_env("DOS_C_DIR", "the folder mounted as the DOS C: drive")
    tpc = os.environ.get("TPC", DEFAULT_TPC)

    # The compiler's DOS path, mapped onto the host folder mounted as C:
    tpc_on_host = dos_c_dir.joinpath(*PureWindowsPath(tpc).parts[1:])
    for path in (dosbox, tpc_on_host):
        if not path.is_file():
            sys.exit(f"Not found: {path}")

    build_dir.mkdir()
    shutil.copy2(PROGRAM, build_dir)
    shutil.copytree(UNITS_DIR, build_dir / "UNITS")
    subprocess.run(
        [
            str(dosbox), "--noprimaryconf", "--nolocalconf",
            "-c", f'mount c "{dos_c_dir}"',
            "-c", f'mount d "{build_dir}"',
            "-c", "d:",
            "-c", f"{tpc} /B /UUNITS TOGGTIME.PAS > BUILD.LOG",
            "--exit",
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )

    # Skip the bare FILE(line) progress lines; errors carry a message after them
    log = build_dir / "BUILD.LOG"
    if log.is_file():
        for line in log.read_text(encoding="cp437").splitlines():
            if line.strip() and not re.fullmatch(r"\S+\(\d+\)", line.strip()):
                print(line)
    exe = build_dir / "TOGGTIME.EXE"
    if not exe.is_file():
        sys.exit("Build failed: TOGGTIME.EXE was not produced")
    return exe.read_bytes()


def write_bundle(exe: bytes) -> None:
    WEB_BUNDLE.parent.mkdir(exist_ok=True)
    with zipfile.ZipFile(WEB_BUNDLE, "w") as archive:
        conf = BUNDLE_DOSBOX_CONF.encode("ascii")
        add_file(archive, ".jsdos/dosbox.conf", conf, BUNDLE_DATE)
        add_file(archive, "TOGGTIME.EXE", exe, BUNDLE_DATE)
    print(f"Wrote {WEB_BUNDLE.relative_to(REPO_DIR).as_posix()}")


def write_package(exe: bytes) -> None:
    with zipfile.ZipFile(PACKAGE, "w") as archive:
        add_file(archive, "TOGGTIME.EXE", exe, PACKAGE_DATE)
        for name in ("README.TXT", "LICENSE.TXT"):
            # DOS reads these, so they get CRLF whatever the checkout has
            text = (DIST_DIR / name).read_bytes().replace(b"\r\n", b"\n")
            add_file(archive, name, text.replace(b"\n", b"\r\n"), PACKAGE_DATE)
    print(f"Wrote {PACKAGE.relative_to(REPO_DIR).as_posix()}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--web", action="store_true", help="also write the js-dos bundle for web/"
    )
    parser.add_argument(
        "--package", action="store_true", help="also write the release ZIP in dist/"
    )
    args = parser.parse_args()

    with tempfile.TemporaryDirectory() as temp:
        exe = compile_exe(Path(temp) / "build")

    digest = hashlib.sha256(exe).hexdigest()
    if digest == EXPECTED_SHA256:
        print(f"TOGGTIME.EXE unchanged ({len(exe)} bytes, SHA-256 {digest[:12]})")
    else:
        print(f"TOGGTIME.EXE changed: SHA-256 is now {digest}")
        print("If the change is intended, update EXPECTED_SHA256 in build.py")

    if args.web:
        write_bundle(exe)
    if args.package:
        write_package(exe)


if __name__ == "__main__":
    main()
