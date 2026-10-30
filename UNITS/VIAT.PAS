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

{ The offset of the text screen in its video segment }
const
  VideoOfs = $0000;

{ Video memory segments: color text modes, EGA and VGA graphics modes,
  and the monochrome adapter }
const
  VideoSeg = $B800;

const
  EGAVideoSeg = $A000;

const
  MonVideoSeg = $B000;

{ The color text screen laid over video memory, for direct reads and
  writes; the indexes are row, column, then 1 for the character or 2 for
  its attribute }

{ 80x25, modes BW80 and CO80 }
var
  Screen : array [1..25, 1..80, 1..2] of Byte absolute VideoSeg : VideoOfs;

{ 40x25, modes BW40 and CO40 }
var
  Screen40 : array [1..25, 1..40, 1..2] of Byte absolute VideoSeg : VideoOfs;

{ 40x50, modes BW40 and CO40 with Font8x8 on VGA }
var
  Screen8x8 : array [1..50, 1..40, 1..2] of Byte absolute VideoSeg : VideoOfs;

implementation

end.
