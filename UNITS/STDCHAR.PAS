(**********************************************************)
{                                                          }
{  The Hello World Writer's                                }
{  Turbo Pascal Library                                    }
{  Char-Oriented Routines Unit.                            }
{                                                          }
(**********************************************************)

unit StdChar;


interface


type
  PXChar = ^Char;

type
  TCharSet = set of Char;

type
  PCharSet  = ^TCharSet;

const
  Digits : array[0..9] of Char = '0123456789';

const
  HexDigits : array [0..$F] of Char = '0123456789ABCDEF';

const
  HexDigitsSet : set of '0'..'z' = ['0'..'9', 'A'..'F', 'a'..'f'];


implementation


end.