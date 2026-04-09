(**********************************************************)
{                                                          }
{  The Hello World Writer's                                }
{  Turbo Pascal Library                                    }
{  Cursor Handling Unit                                    }
{                                                          }
(**********************************************************)


unit Cursor;


interface


{ Cursor shape constants }

const
  CGACursor	= $0607;
  MDACursor	= $0B0C;
  VGACursor	= $0D0E;
  HiddenCursor	= $2000;

{ Stores a selected video page. }

const
  CVPage : Byte = 0;

{ Sets the cursor speed.						}

procedure SetCursorSpeed(NewSpeed : Word);

{ Returns the current shape of the cursor for the CVPage video page.	}

function CursorShape: Word;

{ Selects the current shape of the cursor. The high-order byte of Shape }
{ is the first line of the cursor and the low-order byte of Shape is	}
{ the last line of the cursor within the current row of characters.	}
{ The cursor is visible only in text mode.				}

procedure SetCursorShape(Shape: Word);

{ Moves the cursor to the given coordinates for the CVPage video page.	}

procedure MoveCursor(X, Y: Byte);

{ Returns the X coordinate of the current cursor location for the	}
{ CVPage video page.							}

function CPX: Byte;

{ Returns the Y coordinate of the current cursor location for the	}
{ CVPage video page.							}

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
	MOV	AH,03H
	MOV	BH,CVPage
        INT	10H
	MOV	AX,CX
end;

procedure SetCursorShape(Shape: Word); assembler;
asm
	MOV	AH,01H
        MOV	CX,Shape
        INT	10H
end;

procedure MoveCursor(X, Y: Byte); assembler;
asm
	MOV	AH,02H
	MOV	BH,CVPage
        MOV	DH,Y
        MOV	DL,X
        INT	10H
end;

function CPX: Byte; assembler;
asm
	MOV	AH,03H
	MOV	BH,CVPage
        INT	10H
	MOV	AL,DL
end;

function CPY: Byte; assembler;
asm
	MOV	AH,03H
	MOV	BH,CVPage
        INT	10H
	MOV	AL,DH
end;

end.