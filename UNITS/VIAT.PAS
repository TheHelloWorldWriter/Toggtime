{*******************************************************}
{                                                       }
{    The Hello World Writer's Turbo Pascal Library      }
{    Video Memory Arrays Interface Unit                 }
{                                                       }
{    Copyright (c) 1995-2026 The Hello World Writer     }
{                                                       }
{*******************************************************}

unit ViAt;

interface

const
  VideoOfs = $0000;    { Offset within the video segment (always 0) }

const
  VideoSeg = $B800;    { Color text-mode video segment (CGA/EGA/VGA) }

const
  EGAVideoSeg = $A000;    { EGA/VGA graphics-mode segment }

const
  MonVideoSeg = $B000;    { Monochrome text-mode segment (MDA/Hercules) }

var
  { 80x25 color text-mode VRAM, char + attribute pairs }
  Screen : array [1..25, 1..80, 1..2] of Byte absolute VideoSeg : VideoOfs;

var
  { 40x25 color text-mode VRAM, char + attribute pairs }
  Screen40 : array [1..25, 1..40, 1..2] of Byte absolute VideoSeg : VideoOfs;

var
  { 40x50 color text-mode VRAM (8x8 character cells) }
  Screen8x8 : array [1..50, 1..40, 1..2] of Byte absolute VideoSeg : VideoOfs;

implementation

end.
