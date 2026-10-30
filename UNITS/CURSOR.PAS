{*******************************************************}
{                                                       }
{    The Hello World Writer's Turbo Pascal Library      }
{    Cursor Handling Unit                               }
{                                                       }
{    Copyright (c) 1995-2026 The Hello World Writer     }
{                                                       }
{*******************************************************}

unit Cursor;

interface

{ Cursor shapes: the CGA, MDA and VGA underlines, on scan lines 6-7,
  11-12 and 13-14, and a hidden cursor, which sets bit 5 of the high byte }
const
  CGACursor     = $0607;
  MDACursor     = $0B0C;
  VGACursor     = $0D0E;
  HiddenCursor  = $2000;

{ The video page the cursor position routines work on }
const
  CVPage : Byte = 0;

{ Sets the keyboard repeat rate and delay; NewSpeed is the typematic
  byte, with the rate in bits 0-4, 0 fastest, and the delay in bits 5-6 }
procedure SetCursorSpeed(NewSpeed : Word);

{ Returns the cursor shape in the form SetCursorShape takes }
function CursorShape: Word;

{ Sets the cursor shape: the high byte of Shape is its first scan line
  and the low byte its last; visible only in text mode }
procedure SetCursorShape(Shape: Word);

{ Moves the cursor on the CVPage video page; X and Y count from 0 }
procedure MoveCursor(X, Y: Byte);

{ Returns the cursor column on the CVPage video page, counting from 0 }
function CPX: Byte;

{ Returns the cursor row on the CVPage video page, counting from 0 }
function CPY: Byte;

implementation

uses Crt;

procedure SetCursorSpeed(NewSpeed : Word);
begin
  Port[$60] := $F3;
  Delay(200);
  Port[$60] := NewSpeed;
end;

function CursorShape: Word; assembler;
asm
        MOV AH,03H
        MOV BH,CVPage
        INT 10H
        MOV AX,CX
end;

procedure SetCursorShape(Shape: Word); assembler;
asm
        MOV AH,01H
        MOV CX,Shape
        INT 10H
end;

procedure MoveCursor(X, Y: Byte); assembler;
asm
        MOV AH,02H
        MOV BH,CVPage
        MOV DH,Y
        MOV DL,X
        INT 10H
end;

function CPX: Byte; assembler;
asm
        MOV AH,03H
        MOV BH,CVPage
        INT 10H
        MOV AL,DL
end;

function CPY: Byte; assembler;
asm
        MOV AH,03H
        MOV BH,CVPage
        INT 10H
        MOV AL,DH
end;

end.
