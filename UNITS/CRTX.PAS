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

{ Extensions to Crt: attributes, windows, layout helpers, frames, sound }

{ Six box-drawing chars: [1]=horiz, [2]=vert, [3]=TL, [4]=BL, [5]=BR, [6]=TR }
type
  FrameChars = array[1..6] of Char;

const
  Single : FrameChars = 'Ä³ÚÀÙ¿'; { Chr 196,179,218,192,217,191 }
  Double : FrameChars = 'ÍºÉÈ¼»'; { Chr 205,186,201,200,188,187 }
  Pixels : FrameChars = '......';   { Six period chars }

{ Sound parameters for SaySound: tone freq, tone duration, silence after }
const
  SaySoundRec : record
    Freq, Delay1, Delay2 : Word;
  end = ( Freq : 5000 ; Delay1 : 1 ; Delay2 : 50);

{ Combines foreground C and background B colors into a text attribute byte }
function  Attr(const C, B :  Byte) : Byte;
{ Resets the active window to full screen (1,1)-(80,25) }
procedure NormWindow;
{ Sets a window, fills it with attribute Attr, and clears it }
procedure Win(const X1, Y1, X2, Y2, Attr : Byte);
{ Sets a full-screen window with attribute Attr and clears it }
procedure NormWin(const Attr : Byte);
{ Clears the current window with attribute Attr }
procedure Clr(const Attr : Byte);
{ Moves the cursor to column X (current row) }
procedure TabX(const X : Byte);
{ Moves the cursor to row Y (current column) }
procedure TabY(const Y : Byte);
{ Moves the cursor by relative offset (X, Y) }
procedure Plus(const X, Y : Byte);
{ Writes Msg at the current cursor position with attribute Attr }
procedure SayCo(const Attr : Byte ; const Msg : string);

{ Writes S character by character with a beep on each (see SaySoundRec) }
procedure SaySound(S : string);
{ Writes S at position (X, Y) }
procedure Say(X, Y : Byte ; S : string);
{ Writes S centered horizontally on row Line (within current window) }
procedure CenterLn(Line : Byte ; S : string);
{ Writes S centered both horizontally and vertically (within current window) }
procedure Center(S : string);
{ Writes S vertically starting at (X, Y), one char per row }
procedure Vert(X, Y : Byte ; S : string);
{ Draws a vertical line of Ch from (X, Y1) to (X, Y2) }
procedure VertLn(X, Y1, Y2 : Byte ; Ch : Char);
{ Draws a horizontal line of Ch from (X1, Y) to (X2, Y) }
procedure HorizLn(X1, X2, Y : Byte ; Ch : Char);
{ Draws a rectangle frame using FrameChars Fr (e.g. Single, Double, Pixels) }
procedure Frame(X1, Y1, X2, Y2 : Byte ; Fr : FrameChars);
{ Plays a tone of Hz frequency for MS milliseconds (PC speaker) }
procedure SoundX(Hz : Word ; MS : Word);

implementation

uses Crt;

function Attr(const C, B : Byte) : Byte; assembler;
asm
	{ AL = B * 16 + C  (background in high nibble, foreground in low) }
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
