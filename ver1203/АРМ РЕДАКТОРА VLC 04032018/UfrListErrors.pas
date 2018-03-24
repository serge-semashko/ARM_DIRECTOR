unit UfrListErrors;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Math,
  FastDIB,
  FastFX, FastSize, FastFiles, FConvert, FastBlend, Vcl.StdCtrls;

type
  TMyUpDown = class
    rtup: TRect;
    rtdown: TRect;
    rtlift: TRect;
    VisualRowCount: integer;
    RowHeight: integer;
    RowCount: integer;
    Position: integer;
    Down: boolean;
    OldPos: integer;
    select1: boolean;
    select2: boolean;
    procedure Draw(cv: tcanvas);
    procedure liftposition(Y: integer);
    procedure setposition(Posi: integer);
    function MyStep: Real;
    function MouseDown(cv: tcanvas; X, Y: integer): integer;
    function MouseMove(cv: tcanvas; X, Y: integer): integer;
    function MouseUp(cv: tcanvas; X, Y: integer): integer;
    constructor Create(cv: tcanvas);
    destructor destroy;
  end;

  TFrListErrors = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    imgBtn: TImage;
    ImgUpDown: TImage;
    ImgListErr: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImgUpDownMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ImgUpDownMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure ImgUpDownMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormCreate(Sender: TObject);
    procedure imgBtnMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure imgBtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrListErrors: TFrListErrors;
  ScrollUpDown: TMyUpDown;
  ListErrors: Tstrings;

procedure ShowListErrors();
procedure DrawListErrors(cv: tcanvas);

implementation

uses ucommon, uimgbuttons, uinitforms;

{$R *.dfm}

procedure ShowListErrors();
var
  i: integer;
begin
  // for i:=0 to 99 do ListErrors.Add('Строка ' + inttostr(i+1));

  if ScrollUpDown = nil then
    ScrollUpDown := TMyUpDown.Create(FrListErrors.ImgUpDown.Canvas);
  ScrollUpDown.RowCount := ListErrors.Count;
  ScrollUpDown.RowHeight := 18;
  ScrollUpDown.liftposition(0);
  ScrollUpDown.Draw(FrListErrors.ImgUpDown.Canvas);
  FrListErrors.ImgUpDown.Repaint;
  btnerrpnl.Rows[0].Btns[0].Color := FormsColor;
  btnerrpnl.Rows[0].Btns[0].Selection := false;
  btnerrpnl.Draw(FrListErrors.imgBtn.Canvas);
  ScrollUpDown.setposition(0);
  DrawListErrors(FrListErrors.ImgListErr.Canvas);
  FrListErrors.ImgListErr.Repaint;
  FrListErrors.imgBtn.Repaint;
  FrListErrors.ShowModal;
  if FrListErrors.ModalResult = mrOk then
  begin

  end;
end;

procedure DrawListErrors(cv: tcanvas);
var
  tmp: tfastdib;
  i, ps, sz, shtl, shtr, cps: integer;
  rt1, rt2: TRect;
begin
  tmp := tfastdib.Create;
  try
    tmp.SetSize(cv.ClipRect.Right - cv.ClipRect.Left,
      cv.ClipRect.Bottom - cv.ClipRect.Top, 32);
    tmp.Clear(TColorToTfcolor(FormsColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetTextColor(colortorgb(FormsFontColor));
    tmp.SetFont(FormsFontName, ScrollUpDown.RowHeight - 2);

    if ScrollUpDown.RowCount - 1 <= ScrollUpDown.VisualRowCount then
    begin
      sz := ScrollUpDown.RowCount - 1;
      ScrollUpDown.Position := 0;
    end
    else
    begin
      sz := ScrollUpDown.Position + ScrollUpDown.VisualRowCount + 1;
      if sz > ScrollUpDown.RowCount - 1 then
      begin
        sz := ScrollUpDown.RowCount - 1;
        ScrollUpDown.Position := sz - ScrollUpDown.VisualRowCount + 1;
      end;
    end;

    ps := cv.ClipRect.Top;
    for i := ScrollUpDown.Position to sz do
    begin
      rt1.Left := cv.ClipRect.Left;
      rt1.Right := cv.ClipRect.Left + 40;
      rt2.Left := rt1.Right + 5;
      rt2.Right := cv.ClipRect.Right;
      rt1.Top := ps;
      rt1.Bottom := rt1.Top + ScrollUpDown.RowHeight;
      rt2.Top := rt1.Top;
      rt2.Bottom := rt1.Bottom;
      ps := rt1.Bottom;
      tmp.DrawText(inttostr(i), rt1, DT_CENTER);
      tmp.DrawText(ListErrors.Strings[i], rt2, DT_LEFT); // or DT_WORDBREAK);
    end;
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
  end;
end;

constructor TMyUpDown.Create(cv: tcanvas);
var
  sz: integer;
begin
  sz := cv.ClipRect.Right - cv.ClipRect.Left;
  rtup.Left := cv.ClipRect.Left;
  rtup.Top := cv.ClipRect.Top + 1;
  rtup.Right := cv.ClipRect.Right;
  rtup.Bottom := cv.ClipRect.Left + sz;
  rtdown.Left := cv.ClipRect.Left;
  rtdown.Top := cv.ClipRect.Bottom - sz;
  rtdown.Right := cv.ClipRect.Right;
  rtdown.Bottom := cv.ClipRect.Bottom - 1;
  VisualRowCount := 0;
  RowCount := 0;
  RowHeight := 25;
  Position := 0;
  Down := false;
  OldPos := 0;
  select1 := false;
  select2 := false;
  rtlift.Left := cv.ClipRect.Left + 2;
  rtlift.Right := cv.ClipRect.Right - 2;
  rtlift.Top := rtup.Bottom + 1;
  rtlift.Bottom := rtdown.Top - 1;
end;

destructor TMyUpDown.destroy;
begin
  freemem(@rtup);
  freemem(@rtdown);
  freemem(@rtlift);
  freemem(@VisualRowCount);
  freemem(@RowCount);
  freemem(@RowHeight);
  freemem(@Position);
  freemem(@Down);
  freemem(@select1);
  freemem(@select2);
  freemem(@OldPos);
end;

procedure TMyUpDown.liftposition(Y: integer);
var
  sz, shght, AHGHT, szlift, dlt: integer;
  step: Real;
begin
  AHGHT := RowHeight * RowCount;
  shght := rtdown.Bottom - rtup.Top;
  sz := rtdown.Top - rtup.Bottom + 2;
  if shght mod RowHeight = 0 then
    VisualRowCount := shght div RowHeight
  else
    VisualRowCount := trunc(shght / RowHeight) + 1;
  if RowCount <= VisualRowCount then
  begin
    rtlift.Top := rtup.Bottom + 1;
    rtlift.Bottom := rtdown.Top - 1;
    exit;
  end;
  step := sz / RowCount;
  szlift := trunc(VisualRowCount * step);
  if OldPos = Y then
  begin
    if rtlift.Top + szlift > rtdown.Top - 1 then
    begin
      rtlift.Bottom := rtdown.Top - 1;
      rtlift.Top := rtlift.Bottom - szlift;
    end
    else
    begin
      rtlift.Bottom := rtlift.Top + szlift;
    end;
  end;
  dlt := Y - OldPos;
  rtlift.Top := rtlift.Top + dlt;
  rtlift.Bottom := rtlift.Top + szlift;
  if rtlift.Top < rtup.Bottom + 1 then
  begin
    rtlift.Top := rtup.Bottom + 1;
    rtlift.Bottom := rtlift.Top + szlift;
  end;
  if rtlift.Bottom > rtdown.Top - 1 then
  begin
    rtlift.Bottom := rtdown.Top - 1;
    rtlift.Top := rtlift.Bottom - szlift;
  end;
  dlt := rtlift.Top - rtup.Bottom - 1;
  if dlt < 0 then
    dlt := 0;
  Position := trunc(dlt / step) + 1;
  if Position >= RowCount - VisualRowCount then
    Position := RowCount - VisualRowCount;

  OldPos := Y;
end;

procedure TMyUpDown.setposition(Posi: integer);
var
  sz, shght, AHGHT, szlift, dlt: integer;
  step: Real;
begin
  AHGHT := RowHeight * RowCount;
  shght := rtdown.Bottom - rtup.Top;
  sz := rtdown.Top - rtup.Bottom + 2;
  if shght mod RowHeight = 0 then
    VisualRowCount := shght div RowHeight
  else
    VisualRowCount := trunc(shght / RowHeight) + 1;
  if RowCount <= VisualRowCount then
  begin
    rtlift.Top := rtup.Bottom + 1;
    rtlift.Bottom := rtdown.Top - 1;
    exit;
  end;
  step := sz / RowCount;
  szlift := trunc(VisualRowCount * step);

  if Posi < VisualRowCount then
  begin
    rtlift.Top := rtup.Bottom + 1;
    rtlift.Bottom := rtlift.Top + szlift;
    Position := 0;
  end
  else
  begin
    if Posi + VisualRowCount > RowCount - 1 then
      dlt := RowCount - VisualRowCount + 1
    else
      dlt := Posi - VisualRowCount + 1;
    rtlift.Top := rtup.Bottom + 1 + trunc(step * dlt);
    rtlift.Bottom := rtlift.Top + szlift;
    Position := dlt;
  end;
end;

procedure TMyUpDown.Draw(cv: tcanvas);
var
  tmp: tfastdib;
  sz, shtl, shtr, cps, vsp: integer;
  poli: array of tpoint;
begin
  tmp := tfastdib.Create;
  try
    setlength(poli, 3);
    tmp.SetSize(cv.ClipRect.Right - cv.ClipRect.Left,
      cv.ClipRect.Bottom - cv.ClipRect.Top, 32);
    tmp.Clear(TColorToTfcolor(FormsColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(smoothcolor(FormsColor, 96)));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    sz := rtup.Right - rtup.Left;
    cps := sz div 2;
    if (sz mod 2) = 0 then
    begin
      cps := cps - 1;
      shtl := 5;
      shtr := 6;
    end
    else
    begin
      // cps:=cps + 1;
      shtl := 5;
      shtr := 5;
    end;

    tmp.SetPen(ps_Solid, 2, colortorgb(FormsFontColor));
    if select1 then
      tmp.SetBrush(bs_solid, 0, colortorgb(smoothcolor(FormsColor, 64)))
    else
      tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));

    tmp.FillRect(rtup);
    tmp.Rectangle(rtup.Left, rtup.Top, rtup.Right, rtup.Bottom);
    poli[0].X := rtup.Left + cps;
    poli[0].Y := rtup.Top + 7;
    poli[1].X := rtup.Left + shtl;
    poli[1].Y := rtup.Bottom - 8;
    poli[2].X := rtup.Right - shtr - 1;
    poli[2].Y := rtup.Bottom - 8;
    tmp.SetPen(ps_Solid, 1, colortorgb(FormsFontColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsFontColor));
    tmp.Polygon(poli);

    tmp.SetPen(ps_Solid, 2, colortorgb(FormsFontColor));
    if select2 then
      tmp.SetBrush(bs_solid, 0, colortorgb(smoothcolor(FormsColor, 64)))
    else
      tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    // tmp.SetBrush(bs_solid,0,colortorgb(FormsColor));
    tmp.FillRect(rtdown);
    tmp.Rectangle(rtdown.Left, rtdown.Top, rtdown.Right, rtdown.Bottom);
    poli[0].X := rtdown.Left + shtl;
    poli[0].Y := rtdown.Top + 7;
    poli[1].X := rtdown.Right - shtr - 1;
    poli[1].Y := rtdown.Top + 7;
    poli[2].X := rtdown.Left + cps;
    poli[2].Y := rtdown.Bottom - 8;
    tmp.SetPen(ps_Solid, 1, colortorgb(FormsFontColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsFontColor));
    tmp.Polygon(poli);
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    tmp.Rectangle(rtlift.Left, rtlift.Top, rtlift.Right, rtlift.Bottom);
    vsp := rtlift.Top + (rtlift.Bottom - rtlift.Top) div 2;
    tmp.MoveTo(rtlift.Left + 3, vsp - 3);
    tmp.LineTo(rtlift.Right - 3, vsp - 3);
    tmp.MoveTo(rtlift.Left + 3, vsp);
    tmp.LineTo(rtlift.Right - 3, vsp);
    tmp.MoveTo(rtlift.Left + 3, vsp + 3);
    tmp.LineTo(rtlift.Right - 3, vsp + 3);
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
  end;
end;

function TMyUpDown.MyStep: Real;
var
  sz, shght, AHGHT, szlift, dlt: integer;
  step: Real;
begin
  AHGHT := RowHeight * RowCount;
  shght := rtdown.Bottom - rtup.Top;
  sz := rtdown.Top - rtup.Bottom + 2;
  if shght mod RowHeight = 0 then
    VisualRowCount := shght div RowHeight
  else
    VisualRowCount := trunc(shght / RowHeight) + 1;
  if RowCount <= VisualRowCount then
  begin
    result := 0;
  end;
  result := sz / RowCount;
end;

function TMyUpDown.MouseDown(cv: tcanvas; X, Y: integer): integer;
begin
  result := -1;
  if (X > rtlift.Left) and (X < rtlift.Right) and (Y > rtlift.Top) and
    (Y < rtlift.Bottom) and (Not Down) then
  begin
    Down := true;
    OldPos := Y;
    // liftposition(Y);
    // result := Position;
  end;
end;

function TMyUpDown.MouseMove(cv: tcanvas; X, Y: integer): integer;
begin
  result := -1;
  if Down then
  begin
    liftposition(Y);
    // Draw(cv);
    result := Position;
  end;
  if (X > rtup.Left) and (X < rtup.Right) and (Y > rtup.Top) and
    (Y < rtup.Bottom) then
  begin
    select1 := true;
    select2 := false;
    exit;
  end;
  if (X > rtdown.Left) and (X < rtdown.Right) and (Y > rtdown.Top) and
    (Y < rtdown.Bottom) then
  begin
    select1 := false;
    select2 := true;
    exit;
  end;
end;

function TMyUpDown.MouseUp(cv: tcanvas; X, Y: integer): integer;
begin
  result := Position;
  if (X > rtup.Left) and (X < rtup.Right) and (Y > rtup.Bottom + 1) and
    (Y < rtdown.Top - 1) then
  begin
    liftposition(Y);
    result := Position;
  end;

  Down := false;

  if (X > rtup.Left) and (X < rtup.Right) and (Y > rtup.Top) and
    (Y < rtup.Bottom) then
  begin
    select1 := false;
    select2 := false;
    OldPos := rtlift.Top;
    liftposition(OldPos - Round(MyStep));
    exit;
  end;
  if (X > rtdown.Left) and (X < rtdown.Right) and (Y > rtdown.Top) and
    (Y < rtdown.Bottom) then
  begin
    select1 := false;
    select2 := false;
    OldPos := rtlift.Top;
    liftposition(OldPos + Round(MyStep));
    exit;
  end;
end;

procedure TFrListErrors.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ScrollUpDown.FreeInstance;
  ScrollUpDown := nil;
  ListErrors.Clear;
end;

procedure TFrListErrors.FormCreate(Sender: TObject);
begin
  InitFrListErrors;
end;

procedure TFrListErrors.imgBtnMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  btnerrpnl.MouseMove(imgBtn.Canvas, X, Y);
end;

procedure TFrListErrors.imgBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  res: integer;
begin
  res := btnerrpnl.ClickButton(imgBtn.Canvas, X, Y);
  if res = 0 then
    FrListErrors.Close;
end;

procedure TFrListErrors.ImgUpDownMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  ScrollUpDown.MouseDown(ImgUpDown.Canvas, X, Y);
  ScrollUpDown.Draw(ImgUpDown.Canvas);
  ImgUpDown.Repaint;
end;

procedure TFrListErrors.ImgUpDownMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  res: integer;
begin
  res := ScrollUpDown.MouseMove(ImgUpDown.Canvas, X, Y);
  ScrollUpDown.Draw(ImgUpDown.Canvas);
  ImgUpDown.Repaint;
  if res >= 0 then
  begin
    DrawListErrors(FrListErrors.ImgListErr.Canvas);
    FrListErrors.ImgListErr.Repaint;
  end;
end;

procedure TFrListErrors.ImgUpDownMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  res: integer;
begin
  res := ScrollUpDown.MouseUp(ImgUpDown.Canvas, X, Y);
  ScrollUpDown.Draw(ImgUpDown.Canvas);
  ImgUpDown.Repaint;
  if res >= 0 then
  begin
    DrawListErrors(FrListErrors.ImgListErr.Canvas);
    FrListErrors.ImgListErr.Repaint;
  end;
end;

initialization

ListErrors := tstringlist.Create;
ListErrors.Clear;

finalization

ListErrors.Free;

end.
