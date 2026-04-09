{*******************************************************}
{                                                       }
{    The Hello World Writer's Turbo Pascal Library      }
{    Char-Oriented Routines Unit                        }
{                                                       }
{    Copyright (c) 1995-2026 The Hello World Writer     }
{                                                       }
{*******************************************************}

unit StdChar;

interface

type
  PXChar = ^Char;    { Pointer to Char }

type
  TCharSet = set of Char;    { Named set-of-Char type }

type
  PCharSet  = ^TCharSet;    { Pointer to a TCharSet }

const
  { Decimal digit chars, indexed 0..9 }
  Digits : array[0..9] of Char = '0123456789';

const
  { Hex digit chars, indexed $0..$F }
  HexDigits : array [0..$F] of Char = '0123456789ABCDEF';

const
  { All valid hex digit chars (upper- and lower-case) }
  HexDigitsSet : set of '0'..'z' = ['0'..'9', 'A'..'F', 'a'..'f'];

implementation

end.
