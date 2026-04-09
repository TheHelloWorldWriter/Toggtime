(**********************************************************)
{                                                          }
{  The Hello World Writer's                                }
{  Turbo Pascal Library                                    }
{  Video Memory Arrays Interface Unit                      }
{                                                          }
(**********************************************************)


unit ViAt;


interface


const
  VideoOfs = $0000;

const
  VideoSeg = $B800;

const
  EGAVideoSeg = $A000;

const
  MonVideoSeg = $B000;

var
  Screen : array [1..25, 1..80, 1..2] of Byte absolute VideoSeg : VideoOfs;

var
  Screen40 : array [1..25, 1..40, 1..2] of Byte absolute VideoSeg : VideoOfs;

var
  Screen8x8 : array [1..50, 1..40, 1..2] of Byte absolute VideoSeg : VideoOfs;


implementation


end.