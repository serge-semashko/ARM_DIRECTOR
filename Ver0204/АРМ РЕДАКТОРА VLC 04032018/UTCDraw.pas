unit UTCDraw;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, utimeline, Math, FastDIB, FastFX, FastSize,
  FastFiles, FConvert, FastBlend;

type
  TMyTCData = class
    NTK : longint;
    KTK : longint;
    DURM : longint;
    DURC : longint;
    TC   : longint;
    Checked : boolean;
    rtaudio : trect;
    procedure Draw(cv : tcanvas);
    procedure MouseMove(cv : tcanvas; X, Y : integer);
    procedure MouseClick(cv : tcanvas; X, Y : integer);
    constructor create;
    destructor destroy;
  end;

implementation
uses ucommon;

constructor TMyTCData.create;
begin
  NTK := 0;
  KTK := 0;
  DURM := 0;
  DURC := 0;
  TC := 0;
  Checked := true;
  rtaudio.Left := 0;
  rtaudio.Top := 0;
  rtaudio.Right := 0;
  rtaudio.Bottom := 0;
end;

destructor TMyTCData.destroy;
begin
  freemem(@NTK);
  freemem(@KTK);
  freemem(@DURM);
  freemem(@DURC);
  freemem(@TC);
  freemem(@Checked);
  freemem(@rtaudio);
end;

procedure TMyTCData.Draw(cv : tcanvas);
begin

end;

procedure TMyTCData.MouseMove(cv : tcanvas; X, Y : integer);
begin

end;

procedure TMyTCData.MouseClick(cv : tcanvas; X, Y : integer);
begin

end;

end.
