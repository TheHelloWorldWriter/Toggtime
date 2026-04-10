
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║   Toggtime v1.0                                                            ║
║   Direct video memory writes small demo program                            ║
║                                                                            ║
║   Copyright (c) 1995-2026 The Hello World Writer                           ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝

  ABOUT

  I wrote Toggtime in October 1995 in Borland Turbo Pascal 7, while I was
  learning to program. It explores direct writes to the text-mode video
  memory at $B800 — bypassing the standard Crt unit to throw characters
  and color attributes on screen as fast as the CPU allows.

  HOW TO RUN

  On MS-DOS or compatible, just run:

    TOGGTIME.EXE

  On a modern system (macOS, Windows, Linux), use DOSBox-X:

    https://dosbox-x.com

  Mount the directory containing TOGGTIME.EXE and run it from the DOS
  prompt.

  KEYS

    A         Toggle attributes only
    B         Both attributes and characters (default)
    C         Toggle characters only
    U         Unique attributes and characters
    P         Pause
    H, Esc    Toggle help screen
    Q         Quit

  SOURCE CODE

  Full source code is available on GitHub under the MIT License:

    https://github.com/TheHelloWorldWriter/Toggtime

  LICENSE

  MIT License — see LICENSE.TXT for the full text.

══════════════════════════════════════════════════════════════════════════════
  The Hello World Writer · https://www.thehelloworldwriter.com
══════════════════════════════════════════════════════════════════════════════
