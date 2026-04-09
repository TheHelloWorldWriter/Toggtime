(**********************************************************)
{                                                          }
{  The Hello World Writer's                                }
{  Turbo Pascal Library                                    }
{  Keyboard Crt-Oriented Routines Unit                     }
{                                                          }
(**********************************************************)


unit CRTKeyb;


interface


uses StdChar;

type
  KeyRec = record
    Code, ExtCode : Byte
  end;

const
  YesNoKeys = [ 'y', 'Y', 'n', 'N' ];

const
  AnyKey = [];

var
  LastKey, LastExtKey : Char;

procedure ReadAKey(var C, Ch : Char);
procedure ClrKbd;
function  KeyInRange(const K : TCharSet) : Char;
function  ExtKeyInRange(const K : TCharSet) : Char;
function  IsKey(const Key : Char) : Boolean;
function  IsExtKey(const Key : Char) : Boolean;


implementation


uses Crt;

procedure ReadAKey(var C, Ch : Char);
begin
  C := ReadKey;
  if C = #0 then Ch := ReadKey;
  LastKey := C;
  LastExtKey := Ch
end;

procedure ClrKbd;
var
  C, Ch : Char;
begin
  while KeyPressed do ReadAKey(C, Ch)
end;

function KeyInRange(const K : TCharSet) : Char;
var
  C, Ch: Char;
begin
  repeat
    ReadAKey(C, Ch)
  until (C in K) or ((K = AnyKey) and (C <> #0));
  KeyInRange := C
end;

function ExtKeyInRange(const K : TCharSet) : Char;
var
  C, Ch: Char;
begin
  repeat
    ReadAKey(C, Ch)
  until (Ch in K) or ((K = AnyKey) and (C = #0));
  ExtKeyInRange := Ch
end;

function IsKey(const Key : Char) : Boolean;
var
  C, Ch : Char;
begin
  IsKey := False;
  if KeyPressed then
  begin
    ReadAKey(C, Ch);
    if C = Key then IsKey := True
  end;
end;

function IsExtKey(const Key : Char) : Boolean;
var
  C, Ch : Char;
begin
  IsExtKey := False;
  if KeyPressed then
  begin
    ReadAKey(C, Ch);
    if (Ch = Key) and (C = #0) then IsExtKey := True
  end;
end;


end.