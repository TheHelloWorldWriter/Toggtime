(**********************************************************)
{                                                          }
{  The Hello World Writer's                                }
{  Turbo Pascal Programs Source                            }
{                                                          }
{  Toggtime Version 1.0                                    }
{                                                          }
(**********************************************************)


program Toggtime;

uses Crt, CrtX, ViAT, Cursor, CRTKeyb;

var
  I,J,C,A : Byte;
  Ch, ECh : Char;
  Cod : 1..5;

procedure ComLnHelp;
begin
  WriteLn('Toggtime v1.0  Program by The Hello World Writer. Oct 13 1995');
  WriteLn('Direct video memory writes small demo program.');
  Halt(0)
end;

procedure HelpScreen;
begin
  TextAttr := Attr(7, 0);
  ClrScr;
  Say(31, 8, 'Esc     Exit program');
  Say(33, 9, 'A     Toggle attributes only');
  Say(33, 10, 'B     Both attributes and characters');
  Say(33, 11, 'C     Toggle characters only');
  Say(33, 12, 'P     Pause');
  Say(33, 13, 'U     Unique attributes and characters');
  Say(25, 14, 'Other key     This help screen');
  CenterLn(22, 'Toggtime  !!!   - Author: The Hello World Writer');
  CenterLn(23, 'Direct video memory writes small demo program');
  CenterLn(25, 'Version 1.0  Oct 13 1995');
  CenterLn(17, 'Now press any key to continue...');
  if ReadKey = #0 then ReadKey
end;

begin
  if ParamStr(1) = '/?' then ComLnHelp;
  TextMode(3);
  SetCursorShape(HiddenCursor);
  Randomize;
  Cod := 2;
  repeat
    repeat
      I := Random(26);
      J := Random(81);
      if Cod in [2, 3, 4] then C := Random(256);
      if Cod in [1, 2, 4] then A := Random(256);
      if Cod = 4 then Cod := 5;
      if Cod in [2, 3, 4, 5] then Screen[I, J, 1] := C;
      if Cod in [1, 2, 4, 5] then Screen[I, J, 2] := A
    until KeyPressed;
    ReadAKey(Ch, Ech);
    case UpCase(Ch) of
      'A' : Cod := 1;
      'B' : Cod := 2;
      'C' : Cod := 3;
      'U' : Cod := 4;
      'P' : begin
              TextAttr := Attr(15, 0);
              Say(1,25,'Paused. Press any key to continue...');
              if ReadKey = #0 then ReadKey
            end
      else
        if Ch <> #27 then HelpScreen
    end
  until Ch = #27;
  SetCursorShape(VGACursor);
  TextAttr := Attr(7, 0);
  ClrScr
end.