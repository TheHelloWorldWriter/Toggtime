{*******************************************************}
{                                                       }
{    The Hello World Writer's Turbo Pascal Library      }
{    Keyboard Crt-Oriented Routines Unit                }
{                                                       }
{    Copyright (c) 1995-2026 The Hello World Writer     }
{                                                       }
{*******************************************************}

unit CRTKeyb;

interface

{ Keyboard input on top of Crt, with extended-key (#0 prefix) handling }

uses StdChar;

{ Two-byte key encoding: Code = ASCII (#0 if extended), ExtCode = scan code }
type
  KeyRec = record
    Code, ExtCode : Byte
  end;

{ Set of yes/no keys for confirmation prompts }
const
  YesNoKeys = [ 'y', 'Y', 'n', 'N' ];

{ Sentinel set meaning "match any key" (for KeyInRange / ExtKeyInRange) }
const
  AnyKey = [];

{ Most recent key pair read by ReadAKey }
var
  LastKey, LastExtKey : Char;

{ Reads a key pair. C = ASCII char (#0 for extended keys, then Ch = scan code) }
procedure ReadAKey(var C, Ch : Char);

{ Drains the keyboard buffer (discards all pending keystrokes) }
procedure ClrKbd;

{ Waits for and returns an ASCII key in K. Pass AnyKey to accept any. }
function  KeyInRange(const K : TCharSet) : Char;

{ Waits for and returns an extended-key scan code in K. Pass AnyKey for any. }
function  ExtKeyInRange(const K : TCharSet) : Char;

{ Returns true if Key is currently in the buffer (consumes one key) }
function  IsKey(const Key : Char) : Boolean;

{ Returns true if extended Key is currently in the buffer (consumes one key) }
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
