unit UMyTextTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Math,
  FastDIB,
  FastFX, FastSize, FastFiles, FConvert, FastBlend;

Type
  TMyOneCell = Class
    Name: string;
    Text: string;
    Rect: Trect;
    WordWrap: boolean;
    FontName: tfontname;
    FontSize: integer;
    FontColor: tcolor;
    Bold: boolean;
    Italic: boolean;
    Underline: boolean;
    Strike: boolean;
    Interval: integer;
    Flags: Word;
    // procedure Draw();
    procedure Assign(MOC: TMyOneCell);
    Constructor Create;
    Destructor Destroy;
  End;

  TMyTextRow = Class
    Rect: Trect;
    Height: integer;
    Count: integer;
    Columns: array of TMyOneCell;
    procedure Clear;
    procedure Assign(TTR: TMyTextRow);
    function Add(Left, cwidth: integer): integer;
    procedure Delete(ACol: integer);
    function Update(Number, Left, Top, Right, Bottom: integer): boolean;
    Constructor Create;
    Destructor Destroy;
  End;

  TMyTextTable = Class
    AutoSize: boolean;
    HeightRow: integer;
    Width: integer;
    Height: integer;
    DrawBorder: boolean;
    OffsetLeft: integer;
    OffsetTop: integer;
    OffsetRight: integer;
    OffsetBottom: integer;
    RowInterval: integer;
    ColInterval: integer;
    Title: string;
    FontSize: integer;
    HeightTitle: integer;
    Bold: boolean;
    Italic: boolean;
    Underline: boolean;
    Strike: boolean;
    Flags: Word;
    Count: integer;
    Rows: array of TMyTextRow;
    procedure Clear;
    procedure Assign(MTT: TMyTextTable);
    function AddRow: integer; overload;
    function AddRow(Hght: integer): integer; overload;
    procedure DeleteRow(ARow: integer);
    procedure DeleteCol(ARow, ACol: integer);
    procedure UpdateRow(Number, Left, Top, Right, Bottom: integer);
    function AddCol(ARow: integer): integer;
    procedure updatetable;
    procedure SetText(TName, TText: string);
    function GetText(TName: string): string;
    procedure Draw(cv: tcanvas);
    Constructor Create(Wdth, Hght: integer);
    Destructor Destroy;
  end;

var // MTFontName   : tfontname;
  // MTFontColor  : tcolor = clBlack;
  // MTBackground : tcolor = clBtnFace;
  // MTFontSize : integer = 15;
  // MTFontSizeS : integer = 16;
  // MTFontSizeB : integer = 18;
  pntlproj, pntlclips, pntlprep, pntlplist, pntlapls: TMyTextTable;
  ARow, ACol: integer;

implementation

uses ucommon;

function TColorToTfcolor(Color: tcolor): TFColor;
// Преобразование TColor в RGB
var
  Clr: longint;
begin
  Clr := ColorToRGB(Color);
  Result.r := Clr;
  Result.g := Clr shr 8;
  Result.b := Clr shr 16;
end;

function SmoothColor(Color: tcolor; step: integer): tcolor;
var
  cColor: longint;
  r, g, b: Byte;
  zn: integer;
  rm, gm, bm: Byte;
begin
  try
    cColor := ColorToRGB(Color);
    r := cColor;
    g := cColor shr 8;
    b := cColor shr 16;

    if (r >= g) and (r >= b) then
    begin
      if (r + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      Result := RGB(r, g, b);
      exit;
    end;

    if (g >= r) and (g >= b) then
    begin
      if (g + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      Result := RGB(r, g, b);
      exit;
    end;

    if (b >= r) and (b >= g) then
    begin
      if (b + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      Result := RGB(r, g, b);
      exit;
    end;
  except
    // On E : Exception do WriteLog('MAIN', 'UCommon.SmoothColor | ' + E.Message);
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Constructor TMyTextTable.Create(Wdth, Hght: integer);
begin
  AutoSize := true;
  HeightRow := 25;
  Width := Wdth;
  Height := Hght;
  OffsetLeft := 5;
  OffsetTop := 5;
  OffsetRight := 5;
  OffsetBottom := 5;
  RowInterval := 2;
  ColInterval := 2;
  Title := '';
  FontSize := 12;
  HeightTitle := 30;
  Bold := false;
  Italic := false;
  Underline := false;
  Strike := false;
  Flags := DT_CENTER;
  Count := 0;
end;

procedure TMyTextTable.Clear;
var
  i: integer;
begin
  AutoSize := true;
  HeightRow := 25;
  // Width        := Wdth;
  // Height       := Hght;
  OffsetLeft := 5;
  OffsetTop := 5;
  OffsetRight := 5;
  OffsetBottom := 5;
  RowInterval := 2;
  ColInterval := 2;
  Title := '';
  FontSize := 12;
  HeightTitle := 30;
  Bold := false;
  Italic := false;
  Underline := false;
  Strike := false;
  Flags := DT_CENTER;
  for i := Count - 1 downto 0 do
  begin
    Rows[i].FreeInstance;
    Setlength(Rows, i);
  end;
  Count := 0;
end;

procedure TMyTextTable.Assign(MTT: TMyTextTable);
var
  i: integer;
begin
  // clear;
  AutoSize := MTT.AutoSize;
  HeightRow := MTT.HeightRow;
  Width := MTT.Width;
  Height := MTT.Height;
  DrawBorder := MTT.DrawBorder;
  OffsetLeft := MTT.OffsetLeft;
  OffsetTop := MTT.OffsetTop;
  OffsetRight := MTT.OffsetRight;
  OffsetBottom := MTT.OffsetBottom;
  RowInterval := MTT.RowInterval;
  ColInterval := MTT.ColInterval;
  Title := MTT.Title;
  FontSize := MTT.FontSize;
  HeightTitle := MTT.HeightTitle;
  Bold := MTT.Bold;
  Italic := MTT.Italic;
  Underline := MTT.Underline;
  Strike := MTT.Strike;
  Flags := MTT.Flags;
  For i := 0 to MTT.Count - 1 do
  begin
    Count := Count + 1;
    Setlength(Rows, Count);
    Rows[Count - 1] := TMyTextRow.Create;
    Rows[Count - 1].Assign(MTT.Rows[i]);
  end;
  Count := MTT.Count;
  Rows := MTT.Rows;
end;

function DefineFontSize(Text: string; Rect: Trect): TPoint;
var
  wdt, hgh, len: integer;
begin
  len := length(trim(Text));
  if len = 0 then
    len := 1;

  wdt := (Rect.Right - Rect.Left) div len;
  hgh := Rect.Bottom - Rect.Top;
  if hgh < 5 then
  begin
    Result.X := 0;
    Result.Y := 0;
    exit;
  end;
  if wdt > hgh then
  begin
    Result.X := hgh;
    Result.Y := hgh;
    exit;
  end;
  if hgh > 1.5 * wdt then
  begin
    Result.X := wdt;
    Result.Y := trunc(1.5 * wdt);
    exit;
  end;
  Result.X := wdt;
  Result.Y := hgh;
end;

function TMyTextTable.AddRow: integer;
begin
  Result := -1;
  Count := Count + 1;
  Setlength(Rows, Count);
  Rows[Count - 1] := TMyTextRow.Create;
  if Count = 1 then
    Rows[0].Rect.Top := HeightTitle + OffsetTop
  else
    Rows[Count - 1].Rect.Top := Rows[Count - 2].Rect.Bottom + RowInterval;
  Rows[Count - 1].Rect.Left := OffsetLeft;
  Rows[Count - 1].Rect.Right := Width - OffsetRight - OffsetLeft;
  Rows[Count - 1].Rect.Bottom := Rows[Count - 1].Rect.Top + HeightRow;
  Result := Count - 1;
end;

function TMyTextTable.AddRow(Hght: integer): integer;
begin
  Result := -1;
  Count := Count + 1;
  Setlength(Rows, Count);
  Rows[Count - 1] := TMyTextRow.Create;
  if Count = 1 then
    Rows[0].Rect.Top := HeightTitle + OffsetTop
  else
    Rows[Count - 1].Rect.Top := Rows[Count - 2].Rect.Bottom + RowInterval;
  Rows[Count - 1].Rect.Left := OffsetLeft;
  Rows[Count - 1].Rect.Right := Width - OffsetRight - OffsetLeft;
  Rows[Count - 1].Rect.Bottom := Rows[Count - 1].Rect.Top + Hght;
  Result := Count - 1;
end;

procedure TMyTextTable.UpdateRow(Number, Left, Top, Right, Bottom: integer);
begin
  Rows[Number].Rect.Left := Left;
  Rows[Number].Rect.Top := Top;
  Rows[Number].Rect.Right := Right;
  Rows[Number].Rect.Bottom := Bottom;
end;

procedure TMyTextTable.DeleteRow(ARow: integer);
var
  i: integer;
begin
  For i := ARow to Count - 2 do
  begin
    Rows[i].Clear;
    Rows[i].Assign(Rows[i + 1]);
  end;
  Rows[Count - 1].Clear;
  Rows[Count - 1].FreeInstance;
  Count := Count - 1;
  Setlength(Rows, Count);
end;

procedure TMyTextTable.DeleteCol(ARow, ACol: integer);
begin
  Rows[ARow].Delete(ACol);
end;

function TMyTextTable.AddCol(ARow: integer): integer;
begin
  Result := -1;
  if ARow >= Count then
    exit;

  Rows[ARow].Count := Rows[ARow].Count + 1;
  Setlength(Rows[ARow].Columns, Rows[ARow].Count);
  Rows[ARow].Columns[Count - 1] := TMyOneCell.Create;
  if Rows[ARow].Count = 1 then
  begin
    Rows[ARow].Columns[Count - 1].Rect.Top := HeightTitle + OffsetTop
  end
  else
  begin
    Rows[Count - 1].Rect.Top := Rows[Count - 2].Rect.Bottom + RowInterval;
  end;
  Rows[Count - 1].Rect.Left := OffsetLeft;
  Rows[Count - 1].Rect.Right := Width - OffsetRight - OffsetLeft;
  Rows[Count - 1].Rect.Bottom := Rows[Count - 1].Rect.Top + HeightRow;
  Result := Count - 1;
end;

procedure TMyTextTable.SetText(TName: string; TText: string);
var
  i, j: integer;
begin
  for i := 0 to Count - 1 do
  begin
    for j := 0 to Rows[i].Count - 1 do
    begin
      if lowercase(trim(TName)) = lowercase(trim(Rows[i].Columns[j].Name)) then
      begin
        Rows[i].Columns[j].Text := TText;
        exit;
      end;
    end;
  end;
end;

function TMyTextTable.GetText(TName: string): string;
var
  i, j: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    for j := 0 to Rows[i].Count - 1 do
    begin
      if lowercase(trim(TName)) = lowercase(trim(Rows[i].Columns[j].Name)) then
      begin
        Result := Rows[i].Columns[j].Text;
        exit;
      end;
    end;
  end;
end;

procedure TMyTextTable.Draw(cv: tcanvas);
var
  dib: tfastdib;
  rt: Trect;
  fs: TPoint;
  i, j, bld: integer;
  flg: Word;
begin
  // Width := cv.ClipRect.Right-cv.ClipRect.Left;
  // Height := cv.ClipRect.Bottom-cv.ClipRect.Top;
  cv.Brush.Color := ProgrammColor;
  cv.FillRect(cv.ClipRect);
  dib := tfastdib.Create;
  try
    updatetable;
    dib.SetSize(Width, Height, 32);
    dib.Clear(TColorToTfcolor(ProgrammColor));
    dib.SetBrush(bs_solid, 0, ColorToRGB(ProgrammColor));
    dib.FillRect(Rect(0, 0, Width, Height));
    // dib.SetPen(PS_DASHDOT,1,colortorgb(MTFontColor));
    dib.SetTransparent(true);
    rt.Left := OffsetLeft;
    rt.Right := Width - OffsetLeft - OffsetRight;
    rt.Top := OffsetTop;
    rt.Bottom := Height - OffsetBottom;
    // dib.Rectangle(rt.Left,rt.Top,rt.Right,rt.Bottom);
    rt.Bottom := OffsetTop + HeightTitle;
    // dib.Rectangle(rt.Left,rt.Top,rt.Right,rt.Bottom);
    fs := DefineFontSize(Title, rt);
    if Bold then
      bld := 5
    else
      bld := 1;
    // dib.SetFontEx(MTFontName,HeightTitle,-1,bld,Italic,Underline,Strike);
    dib.SetFont(ProgrammFontName, HeightTitle);
    dib.SetTextColor(ColorToRGB(ProgrammFontColor));
    dib.DrawText(Title, rt, Flags); // DT_SINGLELINE or DT_VCENTER or DT_LEFT
    if Count > 0 then
    begin
      for i := 0 to Count - 1 do
      begin
        // dib.SetPen(ps_dot,1,colortorgb(MTFontColor));
        // dib.Rectangle(Rows[i].Rect.Left,Rows[i].Rect.Top,Rows[i].Rect.Right,Rows[i].Rect.Bottom);
        for j := 0 to Rows[i].Count - 1 do
        begin
          // dib.Rectangle(Rows[i].Columns[j].Rect.Left,Rows[i].Columns[j].Rect.Top,
          // Rows[i].Columns[j].Rect.Right,Rows[i].Columns[j].Rect.Bottom);
          dib.SetTextColor(ColorToRGB(ProgrammFontColor));
          dib.SetFont(ProgrammFontName, Rows[i].Columns[j].FontSize);
          if Rows[i].Columns[j].WordWrap then
            flg := Rows[i].Columns[j].Flags or DT_WORDBREAK
          else
            flg := Rows[i].Columns[j].Flags;
          dib.DrawText(Rows[i].Columns[j].Text, Rows[i].Columns[j].Rect, flg);
        end;
      end;
    end;
    dib.SetTransparent(false);
    dib.DrawRect(cv.Handle, 0, 0, Width, Height, 0, 0);
    cv.Refresh;
  finally
    dib.Free;
  end;
end;

Destructor TMyTextTable.Destroy;
begin
  freemem(@AutoSize);
  freemem(@HeightRow);
  freemem(@Width);
  freemem(@Height);
  freemem(@OffsetLeft);
  freemem(@OffsetTop);
  freemem(@OffsetRight);
  freemem(@OffsetBottom);
  freemem(@RowInterval);
  freemem(@ColInterval);
  freemem(@Title);
  freemem(@FontSize);
  freemem(@HeightTitle);
  freemem(@Bold);
  freemem(@Italic);
  freemem(@Underline);
  freemem(@Strike);
  freemem(@Flags);
  freemem(@Count);
  freemem(@Rows);
end;

procedure TMyTextTable.updatetable;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if i = 0 then
      Rows[0].Rect.Top := HeightTitle + OffsetTop
    else
      Rows[i].Rect.Top := Rows[i - 1].Rect.Bottom + RowInterval;
    Rows[i].Rect.Left := OffsetLeft;
    Rows[i].Rect.Right := Width - OffsetRight - OffsetLeft;
    Rows[i].Rect.Bottom := Rows[i].Rect.Top + HeightRow;
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TMyTextRow.Create;
begin
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := 50;
  Rect.Bottom := 25;
  Count := 0;
end;

procedure TMyTextRow.Clear;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
  begin
    Columns[i].FreeInstance;
    Setlength(Columns, i);
  end;
  Count := 0;
end;

procedure TMyTextRow.Assign(TTR: TMyTextRow);
var
  i: integer;
begin
  // clear;
  Rect.Left := TTR.Rect.Left;
  // Rect.Top    := TTR.Rect.Top;
  Rect.Right := TTR.Rect.Right;
  // Rect.Bottom := TTR.Rect.Bottom;
  for i := 0 to TTR.Count - 1 do
  begin
    Count := Count + 1;
    Setlength(Columns, Count);
    Columns[Count - 1] := TMyOneCell.Create;
    Columns[Count - 1].Assign(TTR.Columns[i]);
    Columns[Count - 1].Rect.Top := Rect.Top;
    Columns[Count - 1].Rect.Bottom := Rect.Bottom;
  end;
end;

Destructor TMyTextRow.Destroy;
begin
  Clear;
  freemem(@Count);
  freemem(@Rect);
  freemem(@Columns);
end;

function TMyTextRow.Add(Left, cwidth: integer): integer;
begin
  Count := Count + 1;
  Setlength(Columns, Count);
  Columns[Count - 1] := TMyOneCell.Create;
  Columns[Count - 1].Rect.Left := Rect.Left + Left;
  Columns[Count - 1].Rect.Top := Rect.Top;
  Columns[Count - 1].Rect.Right := Columns[Count - 1].Rect.Left + cwidth;
  if Columns[Count - 1].Rect.Right > Rect.Right then
    Columns[Count - 1].Rect.Right := Rect.Right;
  Columns[Count - 1].Rect.Bottom := Rect.Bottom;
  Result := Count - 1;
end;

procedure TMyTextRow.Delete(ACol: integer);
var
  i: integer;
begin
  if ACol >= Count then
    exit;
  for i := ACol to Count - 2 do
    Columns[i].Assign(Columns[i + 1]);
  Columns[Count - 1].FreeInstance;
  Count := Count - 1;
  Setlength(Columns, Count)
end;

function TMyTextRow.Update(Number, Left, Top, Right, Bottom: integer): boolean;
begin
  Columns[Number].Rect.Left := Left;
  Columns[Number].Rect.Top := Top;
  Columns[Number].Rect.Right := Right;
  Columns[Number].Rect.Bottom := Bottom
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TMyOneCell.Create;
begin
  Name := '';
  Text := '';
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := 50;
  Rect.Bottom := 25;
  WordWrap := false;
  FontName := ProgrammFontName;
  FontColor := ProgrammFontColor;
  FontSize := 12;
  Bold := false;
  Italic := false;
  Underline := false;
  Strike := false;
  Interval := 0;
  Flags := DT_LEFT;
end;

procedure TMyOneCell.Assign(MOC: TMyOneCell);
begin
  Name := MOC.Name;
  Text := MOC.Text;
  Rect.Left := MOC.Rect.Left;
  Rect.Top := MOC.Rect.Top;
  Rect.Right := MOC.Rect.Right;
  Rect.Bottom := MOC.Rect.Bottom;
  WordWrap := MOC.WordWrap;
  FontName := MOC.FontName;
  FontColor := MOC.FontColor;
  FontSize := MOC.FontSize;
  Bold := MOC.Bold;
  Italic := MOC.Italic;
  Underline := MOC.Underline;
  Strike := MOC.Strike;
  Flags := MOC.Flags;
  Interval := MOC.Interval;
end;

Destructor TMyOneCell.Destroy;
begin
  freemem(@Name);
  freemem(@Text);
  freemem(@Rect);
  freemem(@WordWrap);
  freemem(@FontName);
  freemem(@FontColor);
  freemem(@FontSize);
  freemem(@Bold);
  freemem(@Italic);
  freemem(@Underline);
  freemem(@Strike);
  freemem(@Flags);
  freemem(@Interval);
end;

initialization

pntlproj := TMyTextTable.Create(300, 250);
pntlproj.Clear;
pntlproj.HeightRow := 35;
pntlproj.OffsetTop := 35;
pntlproj.HeightTitle := 0;
// pntlproj.Title:= 'Голубой огонек 2018';
ARow := pntlproj.AddRow(50);
ACol := pntlproj.Rows[ARow].Add(0, 100);
pntlproj.Rows[ARow].Columns[ACol].Name := 'Project';
pntlproj.Rows[ARow].Columns[ACol].Text := 'Проект:';
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSizeB;
ACol := pntlproj.Rows[ARow].Add(105, 300);
pntlproj.Rows[ARow].Columns[ACol].Name := 'ProjectName';
pntlproj.Rows[ARow].Columns[ACol].Text := '';
pntlproj.Rows[ARow].Columns[ACol].WordWrap := true;
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSizeB;

ARow := pntlproj.AddRow(50);
ACol := pntlproj.Rows[ARow].Add(0, 100);
pntlproj.Rows[ARow].Columns[ACol].Name := 'Comment';
pntlproj.Rows[ARow].Columns[ACol].Text := 'Комментарий:';
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlproj.Rows[ARow].Add(105, 300);
pntlproj.Rows[ARow].Columns[ACol].Name := 'CommentText';
pntlproj.Rows[ARow].Columns[ACol].Text := '';
pntlproj.Rows[ARow].Columns[ACol].WordWrap := true;
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize - 1;

ARow := pntlproj.AddRow(50);
ACol := pntlproj.Rows[ARow].Add(0, 100);
pntlproj.Rows[ARow].Columns[ACol].Name := 'File';
pntlproj.Rows[ARow].Columns[ACol].Text := 'Файл:';
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlproj.Rows[ARow].Add(105, 300);
pntlproj.Rows[ARow].Columns[ACol].Name := 'FileName';
pntlproj.Rows[ARow].Columns[ACol].Text := '';
pntlproj.Rows[ARow].Columns[ACol].WordWrap := true;
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize - 1;

ARow := pntlproj.AddRow(30);
ACol := pntlproj.Rows[ARow].Add(0, 100);
pntlproj.Rows[ARow].Columns[ACol].Name := 'User';
pntlproj.Rows[ARow].Columns[ACol].Text := 'Пользователь:';
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlproj.Rows[ARow].Add(105, 300);
pntlproj.Rows[ARow].Columns[ACol].Name := 'UserName';
pntlproj.Rows[ARow].Columns[ACol].Text := '';
pntlproj.Rows[ARow].Columns[ACol].WordWrap := true;
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlproj.AddRow(20);
ACol := pntlproj.Rows[ARow].Add(0, 100);
pntlproj.Rows[ARow].Columns[ACol].Name := 'SDate';
pntlproj.Rows[ARow].Columns[ACol].Text := 'Дата создания:';
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlproj.Rows[ARow].Add(105, 300);
pntlproj.Rows[ARow].Columns[ACol].Name := 'DateStart';
pntlproj.Rows[ARow].Columns[ACol].Text := '';
pntlproj.Rows[ARow].Columns[ACol].WordWrap := true;
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlproj.AddRow(20);
ACol := pntlproj.Rows[ARow].Add(0, 100);
pntlproj.Rows[ARow].Columns[ACol].Name := 'EDate';
pntlproj.Rows[ARow].Columns[ACol].Text := 'Дата окончания:';
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlproj.Rows[ARow].Add(105, 300);
pntlproj.Rows[ARow].Columns[ACol].Name := 'DateEnd';
pntlproj.Rows[ARow].Columns[ACol].Text := '';
pntlproj.Rows[ARow].Columns[ACol].WordWrap := true;
pntlproj.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

// ============================================================================

pntlclips := TMyTextTable.Create(300, 650);
pntlclips.Clear;
pntlclips.HeightRow := 35;
pntlclips.OffsetTop := 50;
pntlclips.OffsetLeft := 10;
pntlclips.OffsetRight := 10;
pntlclips.HeightTitle := 0;
// pntlclips.Title:= 'Голубой огонек 2018';
ARow := pntlclips.AddRow(60);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'Clip';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Клип:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSizeB;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'ClipName';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;

ARow := pntlclips.AddRow(60);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'Song';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Песня:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'SongName';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;

ARow := pntlclips.AddRow(50);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'Singer';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Исполнитель:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'SingerName';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlclips.AddRow(50);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'Comment';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Комментарий:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'CommentText';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize - 1;

ARow := pntlclips.AddRow(50);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'File';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Файл:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'FileName';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize - 1;

ARow := pntlclips.AddRow(18);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'NNTK';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Нач. тайм-код:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'NTK';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlclips.AddRow(18);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'DurM';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Хр-ж медиа:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'DurMedia';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlclips.AddRow(18);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'DurP';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Хр-ж воспр.:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'DurPlay';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlclips.AddRow(50);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'STime';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Время старта:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'StartTime';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlclips.AddRow(50);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'ADur';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Общ. хр-ж:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'TotalTime';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlclips.AddRow(50);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'SType';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Тип данных:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'TypeMedia';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlclips.AddRow(50);
ACol := pntlclips.Rows[ARow].Add(0, 100);
pntlclips.Rows[ARow].Columns[ACol].Name := 'APL';
pntlclips.Rows[ARow].Columns[ACol].Text := 'Акт. плей-лист:';
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlclips.Rows[ARow].Add(105, 300);
pntlclips.Rows[ARow].Columns[ACol].Name := 'APlayList';
pntlclips.Rows[ARow].Columns[ACol].Text := '';
pntlclips.Rows[ARow].Columns[ACol].WordWrap := true;
pntlclips.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

// ============================================================================

pntlprep := TMyTextTable.Create(300, 650);
pntlprep.Clear;
pntlprep.HeightRow := 35;
pntlprep.OffsetTop := 15;
pntlprep.HeightTitle := 0;
ARow := pntlprep.AddRow(40);
ACol := pntlprep.Rows[ARow].Add(0, 30);
pntlprep.Rows[ARow].Columns[ACol].Name := 'Nom';
pntlprep.Rows[ARow].Columns[ACol].Text := '';
pntlprep.Rows[ARow].Columns[ACol].FontSize := MTFontSizeB;
pntlprep.Rows[ARow].Columns[ACol].Flags := DT_CENTER;
ACol := pntlprep.Rows[ARow].Add(30, 55);
pntlprep.Rows[ARow].Columns[ACol].Name := 'Clip';
pntlprep.Rows[ARow].Columns[ACol].Text := 'Клип:';
pntlprep.Rows[ARow].Columns[ACol].FontSize := MTFontSizeB;
pntlprep.Rows[ARow].Columns[ACol].Flags := DT_RIGHT;
ACol := pntlprep.Rows[ARow].Add(95, 300);
pntlprep.Rows[ARow].Columns[ACol].Name := 'ClipName';
pntlprep.Rows[ARow].Columns[ACol].Text := '';
pntlprep.Rows[ARow].Columns[ACol].WordWrap := true;
pntlprep.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;

ARow := pntlprep.AddRow(35);
ACol := pntlprep.Rows[ARow].Add(0, 85);
pntlprep.Rows[ARow].Columns[ACol].Name := 'Song';
pntlprep.Rows[ARow].Columns[ACol].Text := 'Песня:';
pntlprep.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;
pntlprep.Rows[ARow].Columns[ACol].Flags := DT_RIGHT;
ACol := pntlprep.Rows[ARow].Add(95, 300);
pntlprep.Rows[ARow].Columns[ACol].Name := 'SongName';
pntlprep.Rows[ARow].Columns[ACol].Text := '';
pntlprep.Rows[ARow].Columns[ACol].WordWrap := true;
pntlprep.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;

ARow := pntlprep.AddRow(20);
ACol := pntlprep.Rows[ARow].Add(0, 85);
pntlprep.Rows[ARow].Columns[ACol].Name := 'Singer';
pntlprep.Rows[ARow].Columns[ACol].Text := 'Исполнитель:';
pntlprep.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
pntlprep.Rows[ARow].Columns[ACol].Flags := DT_RIGHT;
ACol := pntlprep.Rows[ARow].Add(95, 300);
pntlprep.Rows[ARow].Columns[ACol].Name := 'SingerName';
pntlprep.Rows[ARow].Columns[ACol].Text := '';
pntlprep.Rows[ARow].Columns[ACol].WordWrap := true;
pntlprep.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

// ============================================================================

pntlplist := TMyTextTable.Create(300, 650);
pntlplist.Clear;
pntlplist.HeightRow := 35;
pntlplist.OffsetTop := 40;
pntlplist.HeightTitle := 0;
// pntlplist.Title:= 'Голубой огонек 2018';
ARow := pntlplist.AddRow(50);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'Clip';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Клип:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSizeB;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'ClipName';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;

ARow := pntlplist.AddRow(50);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'Song';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Песня:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'SongName';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSizeS;

ARow := pntlplist.AddRow(50);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'Singer';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Исполнитель:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'SingerName';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlplist.AddRow(50);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'Comment';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Комментарий:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'CommentText';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize - 1;

ARow := pntlplist.AddRow(50);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'File';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Файл:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'FileName';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlplist.AddRow(18);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'NNTK';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Нач. тайм-код:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'NTK';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlplist.AddRow(18);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'DurM';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Хр-ж медиа:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'DurMedia';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlplist.AddRow(18);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'DurP';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Хр-ж воспр.:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'DurPlay';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlplist.AddRow(50);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'STime';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Время старта:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'StartTime';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlplist.AddRow(50);
ACol := pntlplist.Rows[ARow].Add(0, 100);
pntlplist.Rows[ARow].Columns[ACol].Name := 'SType';
pntlplist.Rows[ARow].Columns[ACol].Text := 'Тип данных:';
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlplist.Rows[ARow].Add(105, 300);
pntlplist.Rows[ARow].Columns[ACol].Name := 'TypeMedia';
pntlplist.Rows[ARow].Columns[ACol].Text := '';
pntlplist.Rows[ARow].Columns[ACol].WordWrap := true;
pntlplist.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

// =============================================================================

pntlapls := TMyTextTable.Create(300, 250);
pntlapls.Clear;
pntlapls.HeightRow := 25;
pntlapls.OffsetTop := 15;
pntlapls.HeightTitle := 0;
// pntlapl.Title:= 'Голубой огонек 2018';
ARow := pntlapls.AddRow(50);
ACol := pntlapls.Rows[ARow].Add(0, 100);
pntlapls.Rows[ARow].Columns[ACol].Name := 'Comment';
pntlapls.Rows[ARow].Columns[ACol].Text := 'Комментарий:';
pntlapls.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlapls.Rows[ARow].Add(105, 300);
pntlapls.Rows[ARow].Columns[ACol].Name := 'CommentText';
pntlapls.Rows[ARow].Columns[ACol].Text := '';
pntlapls.Rows[ARow].Columns[ACol].WordWrap := true;
pntlapls.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

ARow := pntlapls.AddRow(50);
ACol := pntlapls.Rows[ARow].Add(0, 100);
pntlapls.Rows[ARow].Columns[ACol].Name := 'ADur';
pntlapls.Rows[ARow].Columns[ACol].Text := 'Общий хр-ж:';
pntlapls.Rows[ARow].Columns[ACol].FontSize := MTFontSize;
ACol := pntlapls.Rows[ARow].Add(105, 300);
pntlapls.Rows[ARow].Columns[ACol].Name := 'TotalDur';
pntlapls.Rows[ARow].Columns[ACol].Text := '';
pntlapls.Rows[ARow].Columns[ACol].WordWrap := true;
pntlapls.Rows[ARow].Columns[ACol].FontSize := MTFontSize;

finalization

pntlproj.FreeInstance;
pntlproj := nil;

pntlclips.FreeInstance;
pntlclips := nil;

pntlprep.FreeInstance;
pntlprep := nil;

pntlplist.FreeInstance;
pntlplist := nil;

pntlapls.FreeInstance;
pntlapls := nil;

end.
