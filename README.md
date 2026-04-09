# Toggtime

A small DOS demo that animates the text-mode video memory at $B800 by toggling characters and color attributes at random screen positions.

I wrote Toggtime in October 1995 in Borland Turbo Pascal 7, on an MS-DOS PC, as a Hello World experiment in direct video memory writes. Thirty years later, in April 2026, I dug the source out, brought it back to life, and got it to compile and run again in DOSBox-X on a modern Mac. It still works.

## What it does

When you launch Toggtime, it starts filling the screen with random characters and color attributes. You can change the mode with single keystrokes:

| Key | Effect |
|---|---|
| A | Toggle attributes only |
| B | Both attributes and characters (default) |
| C | Toggle characters only |
| U | Unique attributes and characters |
| P | Pause |
| H, Esc | Show or hide the help screen |
| Q | Quit |

## Building and running

I build and run Toggtime in DOSBox-X with Borland Turbo Pascal 7 installed inside. Detailed build steps will go here once I have a stable workflow written down.

## Project layout

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

MIT — see [LICENSE](LICENSE).

---

A small program from 1995, given a home in 2026.
