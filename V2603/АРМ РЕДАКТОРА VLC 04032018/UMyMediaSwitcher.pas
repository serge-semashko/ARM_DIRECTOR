unit UMyMediaSwitcher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline;

Type

  TMyMediaSwitcher = Class(TObject)
  public
    PenColor: tcolor;
    FontColor: tcolor;
    FontSize: integer;
    FontName: tfontname;
    Select: integer;
    Color: tcolor;
    ColorSelect: tcolor;
    ColorUnselect: tcolor;
    Height: integer;
    Width: integer;
    Interval: integer;
    Name1: string;
    Name2: string;
    Select1: boolean;
    Select2: boolean;
    Rect1: TRect;
    Rect2: TRect;
    procedure Draw(cv: tcanvas);
    procedure MouseMove(cv: tcanvas; X, Y: integer);
    function MouseClick(cv: tcanvas; X, Y: integer): integer;
    Constructor Create;
    Destructor Destroy; override;
  end;

Var
  MyMediaSwitcher: TMyMediaSwitcher;

implementation

uses umain, ucommon;

Constructor TMyMediaSwitcher.Create;
begin
  inherited;
  PenColor := ProgrammFontColor;
  // FontColor     := ProgrammFontColor;
  // FontSize      := ProgrammFontSize;
  // FontName      := ProgrammFontName;
  Select := 0;
  Color := ProgrammColor;
  ColorSelect := clBlue;
  ColorUnselect := ProgrammColor;
  Height := 40;
  Width := 100;
  Interval := 20;
  Name1 := 'Видео';
  Name2 := 'Шаблоны';
  Select1 := false;
  Select2 := false;
  Rect1.Left := 0;
  Rect1.Right := Rect1.Left + Width;
  Rect1.Top := 0;
  Rect1.Bottom := Rect1.Top + Height;
  Rect2.Left := 0;
  Rect2.Right := Rect2.Left + Width;
  Rect2.Top := Rect1.Bottom + Interval;
  Rect2.Bottom := Rect2.Top + Height;
end;

Destructor TMyMediaSwitcher.Destroy;
begin
  FreeMem(@PenColor);
  // FreeMem(@FontColor);
  // FreeMem(@FontSize);
  // FreeMem(@FontName);
  FreeMem(@Select);
  FreeMem(@Color);
  FreeMem(@ColorSelect);
  FreeMem(@ColorUnselect);
  FreeMem(@Height);
  FreeMem(@Width);
  FreeMem(@Interval);
  FreeMem(@Name1);
  FreeMem(@Name2);
  FreeMem(@Select1);
  FreeMem(@Select2);
  FreeMem(@Rect1);
  FreeMem(@Rect2);
  inherited;
end;

procedure TMyMediaSwitcher.Draw(cv: tcanvas);
var
  rt: TRect;
  rds: integer;
  clrs: tcolor;
begin
  if (ColorSelect >= smoothColor(ProgrammColor, -8)) and
    (ColorSelect <= smoothColor(ProgrammColor, 8)) then
    clrs := smoothColor(ProgrammColor, 48)
  else
    clrs := ColorSelect;

  Rect1.Left := 0;
  Rect1.Right := Rect1.Left + Width;
  Rect1.Top := (cv.ClipRect.Bottom - cv.ClipRect.Top - 2 * Height -
    Interval) div 2;
  Rect1.Bottom := Rect1.Top + Height;
  Rect2.Left := 0;
  Rect2.Right := Rect2.Left + Width;
  Rect2.Top := Rect1.Bottom + Interval;
  Rect2.Bottom := Rect2.Top + Height;
  rds := Height div 2;
  cv.Brush.Style := bsSolid;
  cv.Brush.Color := ProgrammColor;
  cv.FillRect(cv.ClipRect);
  if Select1 then
    cv.Brush.Color := smoothColor(ProgrammColor, 24)
  else
    cv.Brush.Color := ProgrammColor;
  cv.Pen.Color := ProgrammFontColor;
  cv.Pen.Width := 2;
  cv.Font.Color := ProgrammFontColor;
  cv.Font.Size := ProgrammFontSize;
  cv.Font.Name := ProgrammFontName;
  rt.Left := Rect1.Right - rds;
  rt.Right := Rect1.Right + rds;
  rt.Top := Rect1.Top;
  rt.Bottom := Rect1.Bottom;
  cv.Ellipse(rt);
  cv.FillRect(Rect1);
  rt.Left := 4;
  rt.Right := 4 + rds;
  rt.Top := Rect1.Top + rds div 2;
  rt.Bottom := Rect1.Bottom - rds div 2;
  if Select = 0 then
    cv.Brush.Color := clrs
  else
    cv.Brush.Color := ProgrammColor;
  cv.Pen.Width := 1;
  cv.Ellipse(rt);
  cv.Pen.Width := 2;
  cv.MoveTo(Rect1.Left, Rect1.Top);
  cv.LineTo(Rect1.Right, Rect1.Top);
  cv.MoveTo(Rect1.Left, Rect1.Bottom - 1);
  cv.LineTo(Rect1.Right, Rect1.Bottom - 1);
  cv.Brush.Style := bsClear;
  cv.TextOut(14 + rds, Rect1.Top + (Height - cv.TextHeight('0')) div 2, Name1);

  cv.Brush.Style := bsSolid;
  if Select2 then
    cv.Brush.Color := smoothColor(ProgrammColor, 24)
  else
    cv.Brush.Color := ProgrammColor;
  // cv.Pen.Color := PenColor;
  cv.Pen.Width := 2;
  rt.Left := Rect2.Right - rds;
  rt.Right := Rect2.Right + rds;
  rt.Top := Rect2.Top;
  rt.Bottom := Rect2.Bottom;
  cv.Ellipse(rt);
  cv.FillRect(Rect2);
  rt.Left := 4;
  rt.Right := 4 + rds;
  rt.Top := Rect2.Top + rds div 2;
  rt.Bottom := Rect2.Bottom - rds div 2;
  if Select = 1 then
    cv.Brush.Color := clrs
  else
    cv.Brush.Color := ProgrammColor;
  cv.Pen.Width := 1;
  cv.Ellipse(rt);
  cv.Pen.Width := 2;
  cv.MoveTo(Rect2.Left, Rect2.Top);
  cv.LineTo(Rect2.Right, Rect2.Top);
  cv.MoveTo(Rect2.Left, Rect2.Bottom - 1);
  cv.LineTo(Rect2.Right, Rect2.Bottom - 1);
  cv.Brush.Style := bsClear;
  cv.TextOut(14 + rds, Rect2.Top + (Height - cv.TextHeight('0')) div 2, Name2);
end;

procedure TMyMediaSwitcher.MouseMove(cv: tcanvas; X, Y: integer);
begin
  if (X >= Rect1.Left) and (X <= Rect1.Right) and (Y >= Rect1.Top) and
    (Y <= Rect1.Bottom) then
    Select1 := true
  else
    Select1 := false;
  if (X >= Rect2.Left) and (X <= Rect2.Right) and (Y >= Rect2.Top) and
    (Y <= Rect2.Bottom) then
    Select2 := true
  else
    Select2 := false;
end;

function TMyMediaSwitcher.MouseClick(cv: tcanvas; X, Y: integer): integer;
begin
  result := -1;
  if (X >= Rect1.Left) and (X <= Rect1.Right) and (Y >= Rect1.Top) and
    (Y <= Rect1.Bottom) then
    Select := 0;
  if (X >= Rect2.Left) and (X <= Rect2.Right) and (Y >= Rect2.Top) and
    (Y <= Rect2.Bottom) then
    Select := 1;
  result := Select;
  Draw(cv);
end;

initialization

  ;

MyMediaSwitcher := TMyMediaSwitcher.Create;

finalization

MyMediaSwitcher.FreeInstance;

end.
