{*******************************************************}
{                                                       }
{    Toggtime Version 1.0                               }
{    Main Program Source Code                           }
{                                                       }
{    Copyright (c) 1995-2026 The Hello World Writer     }
{                                                       }
{*******************************************************}

program Toggtime;

uses Crt, CrtX, ViAT, Cursor, CRTKeyb;

var
  I,J,C,A : Byte;     { Anim: row I, column J, char code C, attribute A }
  Ch, ECh : Char;     { Key pair from ReadAKey }
  Cod : 1..5;         { Mode 1=attr, 2=both, 3=char, 4-5=unique }
  Done : Boolean;     { Main loop exit flag }

{ Prints command-line help and exits (called when /? is passed) }
procedure ComLnHelp;
begin
  WriteLn('Toggtime v1.0  Program by The Hello World Writer. Oct 13 1995');
  WriteLn('Direct video memory writes small demo program.');
  Halt(0)
end;

{ Draws the interactive help screen and waits for a recognized key }
procedure HelpScreen;
var
  HelpDone : Boolean;
begin
  TextAttr := Attr(7, 0);
  ClrScr;
  CenterLn(3, 'Toggtime  -  Help');
  Say(33, 8, 'Q     Exit program');
  Say(33, 9, 'P     Pause');
  Say(33, 10, 'A     Toggle attributes only');
  Say(33, 11, 'B     Both attributes and characters');
  Say(33, 12, 'C     Toggle characters only');
  Say(33, 13, 'U     Unique attributes and characters');
  Say(28, 14, 'H, Esc     Toggle this help screen');
  CenterLn(22, 'Toggtime  !!!   - Author: The Hello World Writer');
  CenterLn(23, 'Direct video memory writes small demo program');
  CenterLn(25, 'Version 1.0  Oct 13 1995');
  HelpDone := False;
  repeat
    ReadAKey(Ch, ECh);
    case UpCase(Ch) of
      'H', #27,
      'A', 'B', 'C', 'U', 'P', 'Q' : HelpDone := True
    else
      SoundX(700, 50)
    end
  until HelpDone
end;

begin
  if ParamStr(1) = '/?' then ComLnHelp;
  TextMode(3);
  SetCursorShape(HiddenCursor);
  Randomize;
  Cod := 2;     { Default mode: both attrs and chars }
  Done := False;
  repeat
    { Inner loop: animate VRAM until a key is pressed }
    repeat
      I := Random(26);
      J := Random(81);
      if Cod in [2, 3, 4] then C := Random(256);
      if Cod in [1, 2, 4] then A := Random(256);
      if Cod = 4 then Cod := 5;    { One-shot init for mode 5 (locks C, A) }
      if Cod in [2, 3, 4, 5] then Screen[I, J, 1] := C;
      if Cod in [1, 2, 4, 5] then Screen[I, J, 2] := A
    until KeyPressed;
    ReadAKey(Ch, ECh);
    if Ch in ['H', 'h', #27] then HelpScreen;
    case UpCase(Ch) of
      'A' : Cod := 1;
      'B' : Cod := 2;
      'C' : Cod := 3;
      'U' : Cod := 4;
      'P' : begin
              TextAttr := Attr(15, 0);
              Say(1, 25, 'Paused. Press any key to continue...');
              if ReadKey = #0 then ReadKey
            end;
      'Q' : Done := True;
      'H', #27 : ;
    else
      SoundX(700, 50)
    end
  until Done;
  SetCursorShape(VGACursor);
  TextAttr := Attr(7, 0);
  ClrScr
end.
