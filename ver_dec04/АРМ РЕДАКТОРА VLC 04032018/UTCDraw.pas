unit UTCDraw;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, utimeline, Math, FastDIB, FastFX, FastSize,
  FastFiles, FConvert, FastBlend;

type
  TMyTCData = class
    rtaudio : trect;
    AChecked : boolean;
    rtvideo : trect;
    VChecked : boolean;
    rtvalue : trect;
    value : integer;
    down : boolean;
    procedure Draw(cv : tcanvas);
    procedure MouseMove(cv : tcanvas; X, Y : integer);
    procedure MouseClick(cv : tcanvas; X, Y : integer);
    procedure MouseDown(cv : tcanvas; X, Y : integer);
    constructor create;
    destructor destroy;
  end;

var MyTCData : TMyTCData;

implementation
uses umain, ucommon, ugrtimelines, vlcpl;

constructor TMyTCData.create;
begin
  AChecked := true;
  VChecked := true;
  rtaudio.Left := 0;
  rtaudio.Top := 0;
  rtaudio.Right := 0;
  rtaudio.Bottom := 0;
  rtvideo.Left := 0;
  rtvideo.Top := 0;
  rtvideo.Right := 0;
  rtvideo.Bottom := 0;
  rtvalue.Left := 0;
  rtvalue.Top := 0;
  rtvalue.Right := 0;
  rtvalue.Bottom := 0;
  value := 70;
  down := false;
end;

destructor TMyTCData.destroy;
begin
  freemem(@AChecked);
  freemem(@rtaudio);
  freemem(@VChecked);
  freemem(@rtvideo);
  freemem(@rtvalue);
  freemem(@value);
  freemem(@down);
end;

procedure TMyTCData.Draw(cv : tcanvas);
var
  dib: tfastdib;
  rt: Trect;
  fs: TPoint;
  i, j, bld: integer;
  stmp : string;
  flg: Word;
  hdlt, dlt, fntsz : integer;
  Width, Height, WStep, HStep, RStep, VWdth, VHght, TWdth : integer;
  kfc : real;

begin
  // Width := cv.ClipRect.Right-cv.ClipRect.Left;
  // Height := cv.ClipRect.Bottom-cv.ClipRect.Top;
//  cv.Brush.Color := ProgrammColor;
//  cv.FillRect(cv.ClipRect);
  Width := cv.ClipRect.Right - cv.ClipRect.Left;
  Height := cv.ClipRect.Bottom - cv.ClipRect.Top;
  dlt := Width div 64;

  HStep := Height div 4;
  //hdlt := (HStep div 3)*2;
  if (HStep>dlt) then fntsz := dlt else fntsz := HStep;

  WStep := 22 * (fntsz  div 3);

  dib := tfastdib.Create;
  try
    dib.SetSize(Width, Height, 32);
    dib.Clear(TColorToTfcolor(ProgrammColor));
    dib.SetBrush(bs_solid, 0, ColorToRGB(ProgrammColor));
    dib.FillRect(Rect(0, 0, Width, Height));
    // dib.SetPen(PS_DASHDOT,1,colortorgb(MTFontColor));
    dib.SetTransparent(true);
    dib.SetFont(ProgrammFontName, fntsz);
    dib.SetTextColor(ColorToRGB(ProgrammFontColor));

    rt.Top := 0;
    rt.Bottom := HStep;
  //Draw NTK
    rt.Left := 2;
    rt.Right := WStep;
    // dib.SetFontEx(MTFontName,HeightTitle,-1,bld,Italic,Underline,Strike);
    dib.DrawText('Н.Т.К   ', rt, DT_SINGLELINE or DT_LEFT); // DT_SINGLELINE or DT_VCENTER or DT_LEFT
    rt.Left := WStep;
    rt.Right := 2*WStep;
    stmp := FramesToStr(TLParameters.Start - TLParameters.ZeroPoint);
    dib.DrawText(stmp, rt, DT_SINGLELINE or DT_LEFT);

  //Draw KTK
    rt.Left := Width - 2*WStep;
    rt.Right := Width - WStep;
    dib.DrawText('К.Т.К', rt, DT_SINGLELINE or DT_RIGHT); // DT_SINGLELINE or DT_VCENTER or DT_LEFT
    rt.Left := Width - WStep;
    rt.Right := Width;
    stmp := FramesToStr(TLParameters.Finish - TLParameters.ZeroPoint);
    dib.DrawText(stmp, rt, DT_SINGLELINE or DT_CENTER);

    rt.Top := 2*HStep;
    rt.Bottom := 3*Height;
  //Draw DurMedia
    rt.Left := 2;
    rt.Right := WStep;
    // dib.SetFontEx(MTFontName,HeightTitle,-1,bld,Italic,Underline,Strike);
    dib.DrawText('Хр-ж Медиа', rt, DT_SINGLELINE or DT_LEFT); // DT_SINGLELINE or DT_VCENTER or DT_LEFT
    rt.Left := WStep;
    rt.Right := 2*WStep;
    stmp := FramesToStr(TLParameters.Duration);;
    dib.DrawText(stmp, rt, DT_SINGLELINE or DT_LEFT);

  //Draw DurTotal
    rt.Left := Width - 2*WStep;
    rt.Right := Width - WStep;
    dib.DrawText('Хр-ж Воспр.', rt, DT_SINGLELINE or DT_RIGHT); // DT_SINGLELINE or DT_VCENTER or DT_LEFT
    rt.Left := Width - WStep;
    rt.Right := Width;
    stmp := FramesToStr(TLParameters.Finish - TLParameters.Start);
    dib.DrawText(stmp, rt, DT_SINGLELINE or DT_CENTER);

  //Draw TC
    rt.Top := HStep div 3;
    rt.Bottom := 2*HStep - rt.Top;
    rt.Left := 2*WStep;
    rt.Right := Width - 2*WStep;
    dib.SetFont(ProgrammFontName, rt.Bottom - rt.Top);
    stmp := FramesToStr(TLParameters.Position - TLParameters.ZeroPoint);
    dib.DrawText(stmp, rt, DT_SINGLELINE or DT_CENTER);

    TWdth := Width - 4 * WStep;
    //WStep := TWdth div 2;
    RStep := TWdth div 16;
    dlt  := (HStep div 5)*4;
    if dlt > RStep then dlt := RStep;
    hdlt := (HStep - dlt) div 2;

    dib.SetFont(ProgrammFontName, HStep);
    rt.Top := 2*HStep;
    rt.Bottom := 3*HStep;
  //Draw Audio
    rtaudio.Left := 2*WStep + RStep;
    rtaudio.Top := rt.Top+hdlt;
    rtaudio.Right := rtaudio.Left + dlt;
    rtaudio.Bottom := rtaudio.Top+dlt;
    dib.SetPen(ps_solid,1,ColorToRGB(ProgrammFontColor));
    if AChecked then begin
      dib.SetBrush(bs_solid, 0, ColorToRGB(clLime));
    end else begin
      dib.SetBrush(bs_solid, 0, ColorToRGB(ProgrammColor));
    end;
    dib.FillRect(rtaudio);
    dib.Rectangle(rtaudio.Left,rtaudio.Top,rtaudio.Right,rtaudio.Bottom);
    dib.SetBrush(bs_solid, 0, ColorToRGB(ProgrammColor));
    //dib.SetFont(ProgrammFontName, dlt);
    //if AChecked then dib.DrawText('X', rtaudio, DT_SINGLELINE or DT_CENTER);
    rt.Left := rtaudio.Right+5;
    rt.Right := 2*(WStep + RStep);;
    //dib.SetFont(ProgrammFontName, HStep);
    dib.DrawText('A', rt, DT_SINGLELINE or DT_LEFT);

  //Draw Video
    rtvideo.Left := 2*WStep + 2*RStep;
    rtvideo.Top := rt.Top+hdlt;
    rtvideo.Right := rtvideo.Left + dlt;
    rtvideo.Bottom := rtvideo.Top + dlt;
    //dib.SetPen(ps_solid,2,ColorToRGB(ProgrammFontColor));
    if VChecked then begin
      dib.SetBrush(bs_solid, 0, ColorToRGB(clLime));
    end else begin
      dib.SetBrush(bs_solid, 0, ColorToRGB(ProgrammColor));
    end;
    dib.FillRect(rtvideo);
    dib.Rectangle(rtvideo.Left,rtvideo.Top,rtvideo.Right,rtvideo.Bottom);
    dib.SetBrush(bs_solid, 0, ColorToRGB(ProgrammColor));
    //dib.SetFont(ProgrammFontName, dlt);
    //if VChecked then dib.DrawText('X', rtvideo, DT_SINGLELINE or DT_CENTER);
    rt.Left := rtvideo.Right+5;
    rt.Right := 2*WStep + 3*RStep;
    //dib.SetFont(ProgrammFontName, HStep);
    dib.DrawText('V', rt, DT_SINGLELINE or DT_LEFT);

  //Draw Value
    rt.Left := 2*WStep + 10*RStep;
    rt.Right := 2*WStep + 12*RStep-5;
    dib.DrawText('Уровень', rt, DT_SINGLELINE or DT_RIGHT);
    rtvalue.Left := 2*WStep + 12*RStep;
    rtvalue.Top := rt.Top;
    rtvalue.Right := rtvalue.Left + 2*RStep;
    rtvalue.Bottom := rt.Bottom;
    dib.SetBrush(bs_solid, 0, ColorToRGB(smoothColor(ProgrammColor,64)));
    dib.SetPen(ps_solid,1,ColorToRGB(smoothColor(ProgrammColor,64)));
    dib.Polygon([Point(rtvalue.Left, rtvalue.Bottom - hdlt),
                 Point(rtvalue.Right, rtvalue.Bottom - hdlt),
                 Point(rtvalue.Right, rtvalue.Top + hdlt)]);
    if AChecked then begin

      kfc := ((rtvalue.Bottom - rtvalue.Top-hdlt) / (rtvalue.Right - rtvalue.Left));
      VWdth := trunc(((rtvalue.Right - rtvalue.Left) / 100) * value);
      VHght := trunc(VWdth * kfc);
      dib.SetBrush(bs_solid, 0, ColorToRGB(ProgrammFontColor));
      dib.SetPen(ps_solid,1,ColorToRGB(ProgrammFontColor));
      dib.Polygon([Point(rtvalue.Left, rtvalue.Bottom - hdlt),
                   Point(rtvalue.Left + VWdth, rtvalue.Bottom - hdlt),
                   Point(rtvalue.Left + VWdth, rtvalue.Bottom - VHght)]);
    end;

    dib.SetTransparent(false);
    dib.DrawRect(cv.Handle, 0, 0, Width, Height, 0, 0);
    cv.Refresh;
  finally
    dib.Free;
  end;
end;

procedure TMyTCData.MouseDown(cv : tcanvas; X, Y : integer);
begin
  if (X>rtvalue.Left) and (X<rtvalue.Right)
     and (Y>rtvalue.Top) and (Y<rtvalue.Bottom)
    then down := true;
end;

procedure TMyTCData.MouseMove(cv : tcanvas; X, Y : integer);
begin
  if down then begin
    if (X>rtvalue.Left) and (X<rtvalue.Right)
       and (Y>rtvalue.Top) and (Y<rtvalue.Bottom) then begin
       value := trunc(100*(X-rtvalue.Left) / (rtvalue.Right - rtvalue.Left));
    end else begin
       if (Y>rtvalue.Top) and (Y<rtvalue.Bottom)
       then begin
         if X<rtvalue.Left then value := 0;
         if X>rtvalue.Right then value := 100;
       end;
    end;
    if (VLCPlayer.p_mi <> NIL) then VLCPlayer.setVolume(value);
    if value=0 then AChecked:=false else AChecked:=true;
  end;
end;

procedure TMyTCData.MouseClick(cv : tcanvas; X, Y : integer);
begin
  if (X>rtaudio.Left) and (X<rtaudio.Right)
       and (Y>rtaudio.Top) and (Y<rtaudio.Bottom) then begin
    AChecked := not AChecked;
    if (VLCPlayer.p_mi <> NIL) then begin
      if AChecked
        then VLCPlayer.setVolume(value)
        else VLCPlayer.setVolume(0);
    end;
  end;
  if (X>rtvideo.Left) and (X<rtvideo.Right)
       and (Y>rtvideo.Top) and (Y<rtvideo.Bottom) then begin
    VChecked := not VChecked;
    if (VLCPlayer.p_mi <> NIL) then begin
//      if VChecked
//        then VLCPlayer.setOption('--audio')
//        else VLCPlayer.setOption('--no-audio');
    end;
  end;
  if (X>rtvalue.Left) and (X<rtvalue.Right)
       and (Y>rtvalue.Top) and (Y<rtvalue.Bottom) then begin
    value := trunc(100*(X-rtvalue.Left) / (rtvalue.Right - rtvalue.Left));
    if (VLCPlayer.p_mi <> NIL) then VLCPlayer.setVolume(value);
    if value=0 then AChecked:=false else AChecked:=true;
  end;
  down := false;
end;

end.
