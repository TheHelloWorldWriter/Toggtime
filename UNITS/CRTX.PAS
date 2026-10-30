{*******************************************************}
{                                                       }
{    The Hello World Writer's Turbo Pascal Library      }
{    Crt-Oriented Routines Unit.                        }
{                                                       }
{    Copyright (c) 1995-2026 The Hello World Writer     }
{                                                       }
{*******************************************************}

unit CrtX;

interface

{ Frame characters: horizontal, vertical, then the corners top-left,
  bottom-left, bottom-right and top-right }
type
  FrameChars = array[1..6] of Char;

{ Single-line, double-line and dotted frames }
const
  Single : FrameChars = 'Ä³ÚÀÙ¿'; { Chr 196,179,218,192,217,191 }
  Double : FrameChars = 'ÍºÉÈ¼»'; { Chr 205,186,201,200,188,187 }
  Pixels : FrameChars = '......';

{ The tone and delays SaySound uses for each character }
const
  SaySoundRec : record
    Freq, Delay1, Delay2 : Word;
  end = ( Freq : 5000 ; Delay1 : 1 ; Delay2 : 50);

{ Returns the text attribute for foreground C on background B }
function  Attr(const C, B : Byte) : Byte;

{ Resets the window to the full 80x25 screen }
procedure NormWindow;

{ Sets the window, selects Attr and clears the window }
procedure Win(const X1, Y1, X2, Y2, Attr : Byte);

{ Resets the window to the full screen and clears it in Attr }
procedure NormWin(const Attr : Byte);

{ Clears the window in Attr }
procedure Clr(const Attr : Byte);

{ Moves the cursor to column X of the current row }
procedure TabX(const X : Byte);

{ Moves the cursor to row Y of the current column }
procedure TabY(const Y : Byte);

{ Moves the cursor X columns right and Y rows down }
procedure Plus(const X, Y : Byte);

{ Writes Msg in Attr; Attr stays selected }
procedure SayCo(const Attr : Byte ; const Msg : string);

{ Writes S one character at a time, with a click after each }
procedure SaySound(S : string);

{ Writes S at column X, row Y }
procedure Say(X, Y : Byte ; S : string);

{ Writes S centered on row Line of the window }
procedure CenterLn(Line : Byte ; S : string);

{ Writes S centered in the window }
procedure Center(S : string);

{ Writes S downwards, starting at column X, row Y }
procedure Vert(X, Y : Byte ; S : string);

{ Draws a vertical line of Ch in column X, from row Y1 to Y2 }
procedure VertLn(X, Y1, Y2 : Byte ; Ch : Char);

{ Draws a horizontal line of Ch on row Y, from column X1 to X2 }
procedure HorizLn(X1, X2, Y : Byte ; Ch : Char);

{ Draws a frame of Fr with the corners X1, Y1 and X2, Y2 }
procedure Frame(X1, Y1, X2, Y2 : Byte ; Fr : FrameChars);

{ Plays a Hz tone for MS milliseconds }
procedure SoundX(Hz : Word ; MS : Word);

implementation

uses Crt;

function Attr(const C, B : Byte) : Byte; assembler;
asm
	MOV	AL,16
	MUL	B
	ADD	AL, C
end;

procedure NormWindow;
begin
  Window(1, 1, 80, 25)
end;

procedure Win(const X1, Y1, X2, Y2, Attr : Byte);
begin
  Window(X1, Y1, X2, Y2);
  TextAttr := Attr;
  ClrScr
end;

procedure NormWin(const Attr : Byte);
begin
  Win(1, 1, 80, 25, Attr)
end;

procedure Clr(const Attr : Byte);
begin
  TextAttr := Attr;
  ClrScr
end;

procedure TabX(const X : Byte);
begin
  GotoXY(X, WhereY)
end;

procedure TabY(const Y : Byte);
begin
  GotoXY(WhereX, Y)
end;

procedure Plus(const X, Y : Byte);
begin
  GotoXY(WhereX + X, WhereY + Y)
end;

procedure SayCo(const Attr : Byte ; const Msg : string);
begin
  TextAttr := Attr;
  Write(Msg)
end;

procedure SaySound(S : string);
var
  I : Byte;
begin
  for I := 1 to Length(S) do
  begin
    Write(S[I]);
    with SaySoundRec do
    begin
      Sound(Freq);
      Delay(Delay1);
      NoSound;
      Delay(Delay2);
    end;
  end;
end;

procedure Say(X, Y : Byte ; S : string);
begin
  GotoXY(X, Y);
  Write(S)
end;

procedure CenterLn(Line : Byte ; S : string);
var
  LenX : word;
begin
  LenX := Lo(WindMax) - Lo(WindMin) + 1;
  Say(((LenX - Length(S)) div 2) + 1, Line, S)
end;

procedure Center(S : string);
var
  LenY : Word;
begin
  LenY := Hi(WindMax) - Hi(WindMin) + 1;
  CenterLn((LenY div 2) + 1, S)
end;

procedure Vert(X, Y : Byte ; S : string);
var
  I : Byte;
begin
  for I := 1 to Length(S) do
    Say(X, Y + I - 1, S[I])
end;

procedure VertLn(X, Y1, Y2 : Byte ; Ch : Char);
var
  I : 0..25;
begin
  for I := 0 to Y2 - Y1 do
    Say(X, Y1 + I, Ch)
end;

procedure HorizLn(X1, X2, Y : Byte ; Ch : Char);
var
  I : 0..80;
begin
  GotoXY(X1, Y);
  for I := 0 to X2 - X1 do
    Write(Ch)
end;

procedure Frame(X1, Y1, X2, Y2 : Byte ; Fr : FrameChars);
begin
  HorizLn(X1 + 1, X2 - 1, Y1, Fr[1]);
  HorizLn(X1 + 1, X2 - 1, Y2, Fr[1]);
  VertLn(X1, Y1 + 1, Y2 - 1, Fr[2]);
  VertLn(X2, Y1 + 1, Y2 - 1, Fr[2]);
  Say(X1, Y1, Fr[3]);
  Say(X1, Y2, Fr[4]);
  Say(X2, Y2, Fr[5]);
  Say(X2, Y1, Fr[6])
end;

procedure SoundX(Hz : Word ; MS : Word);
begin
  Sound(Hz);
  Delay(Ms);
  NoSound
end;

end.
