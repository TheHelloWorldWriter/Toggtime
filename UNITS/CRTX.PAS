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

type
  FrameChars = array[1..6] of Char;

const
  Single : FrameChars = 'Ä³ÚÀÙ¿'; { Chr 196,179,218,192,217,191 }
  Double : FrameChars = 'ÍºÉÈ¼»'; { Chr 205,186,201,200,188,187 }
  Pixels : FrameChars = '......';

const
  SaySoundRec : record
    Freq, Delay1, Delay2 : Word;
  end = ( Freq : 5000 ; Delay1 : 1 ; Delay2 : 50);

function  Attr(const C, B :  Byte) : Byte;
procedure NormWindow;
procedure Win(const X1, Y1, X2, Y2, Attr : Byte);
procedure NormWin(const Attr : Byte);
procedure Clr(const Attr : Byte);
procedure TabX(const X : Byte);
procedure TabY(const Y : Byte);
procedure Plus(const X, Y : Byte);
procedure SayCo(const Attr : Byte ; const Msg : string);

procedure SaySound(S : string);
procedure Say(X, Y : Byte ; S : string);
procedure CenterLn(Line : Byte ; S : string);
procedure Center(S : string);
procedure Vert(X, Y : Byte ; S : string);
procedure VertLn(X, Y1, Y2 : Byte ; Ch : Char);
procedure HorizLn(X1, X2, Y : Byte ; Ch : Char);
procedure Frame(X1, Y1, X2, Y2 : Byte ; Fr : FrameChars);
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
