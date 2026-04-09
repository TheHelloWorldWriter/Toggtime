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

{ Cursor shape constants }

const
  CGACursor     = $0607;    { Scan lines 6-7 (CGA underline) }
  MDACursor     = $0B0C;    { Scan lines 11-12 (MDA underline) }
  VGACursor     = $0D0E;    { Scan lines 13-14 (VGA underline) }
  HiddenCursor  = $2000;    { Bit 5 of CH set = cursor disabled }

{ Selected video page (used by all routines below) }

const
  CVPage : Byte = 0;

{ Sets the cursor speed (keyboard typematic rate via port $60) }

procedure SetCursorSpeed(NewSpeed : Word);

{ Returns the current cursor shape word (high byte = top scan line, low = bottom) }

function CursorShape: Word;

{ Sets the cursor shape (high byte of Shape = top scan line, low = bottom) }

procedure SetCursorShape(Shape: Word);

{ Moves the cursor to (X, Y) - zero-based BIOS coordinates }

procedure MoveCursor(X, Y: Byte);

{ Returns the cursor's X (column) coordinate }

function CPX: Byte;

{ Returns the cursor's Y (row) coordinate }

function CPY: Byte;

implementation

uses Crt;

procedure SetCursorSpeed(NewSpeed : Word);
begin
  { 8042 keyboard controller: command $F3 = set typematic, then rate byte }
  Port[$60] := $F3;
  Delay(200);
  Port[$60] := NewSpeed;
end;

function CursorShape: Word; assembler;
asm
        { INT 10h, AH=03h: get cursor shape (returned in CX -> AX) }
        MOV AH,03H
        MOV BH,CVPage
        INT 10H
        MOV AX,CX
end;

procedure SetCursorShape(Shape: Word); assembler;
asm
        { INT 10h, AH=01h: set cursor shape from CX }
        MOV AH,01H
        MOV CX,Shape
        INT 10H
end;

procedure MoveCursor(X, Y: Byte); assembler;
asm
        { INT 10h, AH=02h: set cursor position (DH=row, DL=col) }
        MOV AH,02H
        MOV BH,CVPage
        MOV DH,Y
        MOV DL,X
        INT 10H
end;

function CPX: Byte; assembler;
asm
        { INT 10h, AH=03h: get cursor position; column in DL -> AL }
        MOV AH,03H
        MOV BH,CVPage
        INT 10H
        MOV AL,DL
end;

function CPY: Byte; assembler;
asm
        { INT 10h, AH=03h: get cursor position; row in DH -> AL }
        MOV AH,03H
        MOV BH,CVPage
        INT 10H
        MOV AL,DH
end;

end.
