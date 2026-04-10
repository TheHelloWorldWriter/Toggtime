# Toggtime

![Turbo Pascal 7.0](https://img.shields.io/badge/Turbo_Pascal-7.0-0000AA)
![MS-DOS](https://img.shields.io/badge/Platform-MS--DOS-000000)
![Written in 1995](https://img.shields.io/badge/Written_in-1995-CC8800)
![License: MIT](https://img.shields.io/github/license/TheHelloWorldWriter/Toggtime)
![GitHub Release](https://img.shields.io/github/v/release/TheHelloWorldWriter/Toggtime)
![GitHub Downloads](https://img.shields.io/github/downloads/TheHelloWorldWriter/Toggtime/total)

Toggtime is a small DOS demo I wrote in October 1995 in Borland Turbo Pascal 7, while I was learning to program. I had just discovered that the 80×25 text-mode screen is really just an array of bytes at memory address `$B800` — two bytes per position, one for the character and one for the color attribute — and that Turbo Pascal's `absolute` keyword lets you map a typed array directly onto it. Instead of the standard Crt approach — `GotoXY` to move the cursor, `Write` to output a character — you just assign a byte to any screen position and it appears instantly.

<p align="center">
  <img src="docs/images/toggtime-dosbox-x-macos-demo.gif" width="480" alt="Animated demo of Toggtime toggling random characters and color attributes on a DOS text-mode screen">
</p>

I built it to see that in action. It throws random characters and color attributes at video memory as fast as the CPU allows, and lets you switch modes to isolate what each byte does: colors only, characters only, both at once, or a single random pair frozen across the entire screen.

Thirty years later, in April 2026, I brought it back to life on a modern Mac via DOSBox-X. It still works.

## What it does

When you launch Toggtime, it starts filling the screen with random characters and color attributes. You can change the mode with single keystrokes:

| Modes | Controls |
|---|---|
| **A** — Attributes only | **P** — Pause |
| **B** — Both attributes and characters (default) | **H** / **Esc** — Toggle help screen |
| **C** — Characters only | **Q** — Quit |
| **U** — Unique attributes and characters | |

## Download

<p>
  <a href="https://github.com/TheHelloWorldWriter/Toggtime/releases/latest">
    <img alt="Download Toggtime from GitHub Releases" src="https://img.shields.io/badge/Download-from_GitHub_Releases-181717?style=for-the-badge&logo=github">
  </a>
</p>

The ZIP contains the DOS executable, a short readme, and the MIT license. Run `TOGGTIME.EXE` in [DOSBox-X](https://dosbox-x.com/) or any DOS-compatible environment.

## Building and running

I build and run Toggtime using [DOSBox-X](https://dosbox-x.com/) on macOS, with a copy of [Borland Turbo Pascal 7.0](https://winworldpc.com/product/turbo-pascal/7x) downloaded from WinWorld:

1. Mount the project directory and the Turbo Pascal installation in DOSBox-X
2. Launch `TURBO.EXE` and set **Options > Directories** to point at the `UNITS\` path
3. Open `SRC\TOGGTIME.PAS`
4. Press **ALT+F9** to compile, **Ctrl+F9** to run

What surprised me was how familiar it all felt. Turbo Pascal was one of the first IDEs I ever worked in — along with QBasic and Turbo C++ — when I was learning to program for the first time. And here it is again: the same blue editor, the same compilation dialog, running inside a macOS window with traffic-light buttons. A different frame around a very familiar experience.

<table>
  <tr>
    <td align="center">
      <img src="docs/images/toggtime-turbo-pascal-dosbox-x-macos-window-screenshot.png" width="400" alt="Borland Turbo Pascal 7 IDE showing successful compilation of TOGGTIME.PAS in DOSBox-X on macOS">
      <br><em>Compiling in Turbo Pascal on macOS</em>
    </td>
    <td align="center">
      <img src="docs/images/toggtime-dosbox-x-macos-window-screenshot.png" width="400" alt="Toggtime running in DOSBox-X on macOS, showing colorful random characters filling the screen">
      <br><em>Running on macOS via DOSBox-X</em>
    </td>
  </tr>
</table>

## Source layout

```
SRC/
  TOGGTIME.PAS    main program
UNITS/
  STDCHAR.PAS     character types and digit/hex constants
  CURSOR.PAS      BIOS INT 10h cursor + keyboard typematic rate
  CRTKEYB.PAS     keyboard input with extended-key handling
  CRTX.PAS        Crt extensions: attributes, windows, frames, sound
  VIAT.PAS        direct VRAM arrays mapped via the absolute keyword
```

The five units are small and reusable on their own. They may eventually move into a shared Hello World Writer Pascal library.

## License

Toggtime is licensed under the [MIT License](LICENSE).

---

Made with ❤️ in Oradea, Romania
[https://www.thehelloworldwriter.com](https://www.thehelloworldwriter.com)
