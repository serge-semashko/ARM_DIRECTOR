unit UGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, JPEG;

Type
  TTypeGrid = (projects, playlists, clips, actplaylist, grtemplate, empty);

  TPhrasePosition = (ppleft, ppcenter, ppright, ppafter, pptab);

  TTypeGraphics = (picture, ellipse, rectangle, roundrect, none);

  TTypeCell = (tsText, tsState, tsImage);

  TCellPhrase = Class(TObject)
  public
    Left: integer;
    Right: integer;
    Top: integer;
    Bottom: integer;
    Height: integer;
    Width: integer;
    Alignment: TPhrasePosition;
    Layout: TPhrasePosition;
    Text: string;
    Name: string;
    FontColor: TColor;
    FontSize: integer;
    FontName: tfontname;
    Bold: boolean;
    Italic: boolean;
    Underline: boolean;
    SubFontColor: TColor;
    SubFontSize: integer;
    SubFontName: tfontname;
    SubBold: boolean;
    SubItalic: boolean;
    SubUnderline: boolean;
    UsedSubFont: boolean;
    Visible: boolean;
    leftprocent: integer;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    constructor Create;
    destructor Destroy; override;
  end;

  TPhrasesRow = Class(TObject)
  public
    Count: integer;
    Height: integer;
    Top: integer;
    Phrases: array of TCellPhrase;
    function Add(Name, Text: string): integer;
    Procedure Clear;
    procedure Recount(Wdth: integer);
    procedure Assign(Phr: TPhrasesRow);
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    constructor Create;
    destructor Destroy; override;
  End;

  TMyCell = Class(TObject)
  public
    CellType: TTypeCell;
    Width: integer;
    Procents: integer;
    Title: string;
    TitlePosition: TPhrasePosition;
    TitleColorFont: TColor;
    TitleFontSize: integer;
    TitleFontName: tfontname;
    TitleBold: boolean;
    TitleItalic: boolean;
    TitleUnderline: boolean;
    Used: boolean;
    Mark: boolean;
    Select: boolean;
    Background: TColor;
    Name: string;
    TypeImage: TTypeGraphics;
    ImageWidth: integer;
    ImageHeight: integer;
    ImageRect: Trect;
    ImagePosition: TPhrasePosition;
    ImageLayout: TTextLayout;
    ImageTrue: string;
    ImageFalse: string;
    Stretch: boolean;
    Transperent: boolean;
    ColorTrue: TColor;
    ColorFalse: TColor;
    ColorPen: TColor;
    WidthPen: integer;
    Count: integer;
    TopPhrase: integer;
    Bitmap: tbitmap;
    Interval: integer;
    Rows: array of TPhrasesRow;
    procedure LoadJpeg(Filename: string; wdt, hgh: integer);
    procedure Clear;
    function PositionName(Name: string): tpoint;
    function AddRow: integer;
    function AddPhrase(ARow: integer; Name, Text: String): integer;
    function UpdatePhrase(Name, Text: string): boolean;
    procedure SetPhraseColor(Name: String; Color: TColor);
    function ReadPhrase(Name: string): string;
    function ReadPhraseColor(Name: String): TColor;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    constructor Create;
    destructor Destroy; override;
  end;

  TGridRows = Class(TObject)
  public
    ID: Longint;
    HeightRow: integer;
    HeightTitle: integer;
    Count: integer;
    MyCells: array of TMyCell;
    function AddCells: integer;
    procedure Clear;
    procedure SetDefaultFonts;
    procedure Assign(GR: TGridRows);
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    constructor Create; // (Hght : integer);
    destructor Destroy; override;
  end;

Var
  ProjCellClick, PlLsCellClick, GrTmCellClick, TxTmCellClick, AcPLCellClick,
    ClipCellClick: tpoint;
  RowGridClips, RowGridProject, RowGridListPL, RowGridListTxt, RowGridListGR,
    TempGridRow: TGridRows;
  ACell, ARow, APhr: integer;

procedure initgrid(grid: tstringgrid; obj: TGridRows; Width: integer);
procedure GridDrawMyCell(grid: tstringgrid; ACol, ARow: integer; Rect: Trect);
function GridAddRow(grid: tstringgrid; obj: TGridRows): integer;
procedure MyGridDeleteRow(grid: tstringgrid; ARow: integer; obj: TGridRows);
function GridColX(grid: tstringgrid; X: integer): integer;
function GridClickRow(grid: tstringgrid; Y: integer): integer;
function findgridselection(grid: tstringgrid; cell: integer): integer;
procedure GridClear(grid: tstringgrid; obj: TGridRows);
procedure GridImageReload(grid: tstringgrid);
function MarkRowPhraseInGrid(grid: tstringgrid; MarkCell, WorkCell: integer;
  Name, Text, ev: string): integer;

function SetTTypeCell(ps: Longint): TTypeCell;
function SetTPhrasePosition(ps: Longint): TPhrasePosition;
function SetTTypeGraphics(ps: Longint): TTypeGraphics;
function SetTTextLayout(ps: Longint): TTextLayout;

function IsPhraseInGrid(grid: tstringgrid; ACol: integer;
  Name, Text: string): boolean;
function GridCreateCopyName(grid: tstringgrid; ACol: integer;
  Name, Text: string): string;
procedure SortGridAlphabet(grid: tstringgrid; StartRow, ACol: integer;
  Name: string; Direction: boolean);
procedure SortGridDate(grid: tstringgrid; StartRow, ACol: integer; Name: string;
  Direction: boolean);
procedure SortGridTime(grid: tstringgrid; StartRow, ACol: integer; Name: string;
  Direction: boolean);

function CountGridMarkedRows(grid: tstringgrid;
  StartRow, ACol: integer): integer;

implementation

uses umain, ucommon, uproject, umyfiles;

// ==============Преобразование типов============

function SetTTypeCell(ps: Longint): TTypeCell;
begin
  case ps of
    ord(tsText):
      Result := tsText;
    ord(tsState):
      Result := tsState;
    ord(tsImage):
      Result := tsImage;
  end;
end;

function SetTPhrasePosition(ps: Longint): TPhrasePosition;
begin
  case ps of
    ord(ppleft):
      Result := ppleft;
    ord(ppcenter):
      Result := ppcenter;
    ord(ppright):
      Result := ppright;
    ord(ppafter):
      Result := ppafter;
    ord(pptab):
      Result := pptab;
  end;
end;

function SetTTypeGraphics(ps: Longint): TTypeGraphics;
begin
  case ps of
    ord(picture):
      Result := picture;
    ord(ellipse):
      Result := ellipse;
    ord(rectangle):
      Result := rectangle;
    ord(roundrect):
      Result := roundrect;
    ord(none):
      Result := none;
  end;
end;

function SetTTextLayout(ps: Longint): TTextLayout;
begin
  case ps of
    ord(tlTop):
      Result := tlTop;
    ord(tlCenter):
      Result := tlCenter;
    ord(tlBottom):
      Result := tlBottom;
  end;
end;

// ============== TGridRows =================

constructor TGridRows.Create; // (Hght : integer);
begin

  inherited;
  // IDCLIPS:=IDCLIPS+1;
  ID := IDCLIPS;
  HeightRow := 30;
  HeightRow := 30;
  Count := 0;
end;

destructor TGridRows.Destroy;
begin
  FreeMem(@ID);
  FreeMem(@HeightRow);
  FreeMem(@HeightTitle);
  FreeMem(@Count);
  FreeMem(@MyCells);
  inherited;
end;

procedure TGridRows.Clear;
var
  i: integer;
begin
  ID := -1;
  HeightRow := 30;
  HeightTitle := 30;
  For i := Count - 1 downto 0 do
    MyCells[i].Clear;
  Setlength(MyCells, 0);
  Count := 0;
end;

Procedure TGridRows.Assign(GR: TGridRows);
var
  i, j: integer;
begin
  Clear;
  ID := GR.ID;
  HeightRow := GR.HeightRow;
  HeightTitle := GR.HeightTitle;
  Count := 0;
  For i := 0 to GR.Count - 1 do
  begin
    Count := Count + 1;
    Setlength(MyCells, Count);
    MyCells[Count - 1] := TMyCell.Create;
    MyCells[Count - 1].CellType := GR.MyCells[Count - 1].CellType;
    MyCells[Count - 1].Width := GR.MyCells[Count - 1].Width;
    MyCells[Count - 1].Procents := GR.MyCells[Count - 1].Procents;
    MyCells[Count - 1].Title := GR.MyCells[Count - 1].Title;
    MyCells[Count - 1].TitlePosition := GR.MyCells[Count - 1].TitlePosition;
    MyCells[Count - 1].TitleFontName := GR.MyCells[Count - 1].TitleFontName;
    MyCells[Count - 1].TitleColorFont := GR.MyCells[Count - 1].TitleColorFont;
    MyCells[Count - 1].TitleFontSize := GR.MyCells[Count - 1].TitleFontSize;
    MyCells[Count - 1].TitleBold := GR.MyCells[Count - 1].TitleBold;
    MyCells[Count - 1].TitleItalic := GR.MyCells[Count - 1].TitleItalic;
    MyCells[Count - 1].TitleUnderline := GR.MyCells[Count - 1].TitleUnderline;
    MyCells[Count - 1].Used := GR.MyCells[Count - 1].Used;
    MyCells[Count - 1].Mark := GR.MyCells[Count - 1].Mark;
    MyCells[Count - 1].Select := GR.MyCells[Count - 1].Select;
    MyCells[Count - 1].Background := GR.MyCells[Count - 1].Background;
    MyCells[Count - 1].Name := GR.MyCells[Count - 1].Name;
    MyCells[Count - 1].TypeImage := GR.MyCells[Count - 1].TypeImage;
    MyCells[Count - 1].ImageWidth := GR.MyCells[Count - 1].ImageWidth;
    MyCells[Count - 1].ImageHeight := GR.MyCells[Count - 1].ImageHeight;
    MyCells[Count - 1].ImageRect.Left := GR.MyCells[Count - 1].ImageRect.Left;
    MyCells[Count - 1].ImageRect.Right := GR.MyCells[Count - 1].ImageRect.Right;
    MyCells[Count - 1].ImageRect.Top := GR.MyCells[Count - 1].ImageRect.Top;
    MyCells[Count - 1].ImageRect.Bottom := GR.MyCells[Count - 1]
      .ImageRect.Bottom;
    MyCells[Count - 1].ImagePosition := GR.MyCells[Count - 1].ImagePosition;
    MyCells[Count - 1].ImageLayout := GR.MyCells[Count - 1].ImageLayout;
    MyCells[Count - 1].ImageTrue := GR.MyCells[Count - 1].ImageTrue;
    MyCells[Count - 1].ImageFalse := GR.MyCells[Count - 1].ImageFalse;
    MyCells[Count - 1].Stretch := GR.MyCells[Count - 1].Stretch;
    MyCells[Count - 1].Transperent := GR.MyCells[Count - 1].Transperent;
    MyCells[Count - 1].ColorTrue := GR.MyCells[Count - 1].ColorTrue;
    MyCells[Count - 1].ColorFalse := GR.MyCells[Count - 1].ColorFalse;
    MyCells[Count - 1].ColorPen := GR.MyCells[Count - 1].ColorPen;
    MyCells[Count - 1].WidthPen := GR.MyCells[Count - 1].WidthPen;
    MyCells[Count - 1].TopPhrase := GR.MyCells[Count - 1].TopPhrase;
    MyCells[Count - 1].Interval := GR.MyCells[Count - 1].Interval;
    MyCells[Count - 1].Bitmap.Width := GR.MyCells[Count - 1].Bitmap.Width;
    MyCells[Count - 1].Bitmap.Height := GR.MyCells[Count - 1].Bitmap.Height;
    MyCells[Count - 1].Bitmap.Canvas.CopyRect
      (MyCells[Count - 1].Bitmap.Canvas.ClipRect,
      GR.MyCells[Count - 1].Bitmap.Canvas,
      GR.MyCells[Count - 1].Bitmap.Canvas.ClipRect);
    MyCells[Count - 1].Count := 0;
    For j := 0 to GR.MyCells[Count - 1].Count - 1 do
    begin
      MyCells[Count - 1].AddRow;
      MyCells[Count - 1].Rows[MyCells[Count - 1].Count - 1]
        .Assign(GR.MyCells[i].Rows[j]);
    end;

  end;
end;

function TGridRows.AddCells: integer;
begin
  Count := Count + 1;
  Setlength(MyCells, Count);
  MyCells[Count - 1] := TMyCell.Create;
  Result := Count - 1;
end;

Procedure TGridRows.WriteToStream(F: tStream);
var
  i: integer;
begin
  try
    F.WriteBuffer(ID, SizeOf(ID));
    F.WriteBuffer(HeightRow, SizeOf(HeightRow));
    F.WriteBuffer(HeightTitle, SizeOf(HeightTitle));
    F.WriteBuffer(Count, SizeOf(Count));
    For i := 0 to Count - 1 do
      MyCells[i].WriteToStream(F); // TMyCell;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TGridRows.WriteToStream | ' + E.Message);
  end;
end;

Procedure TGridRows.SetDefaultFonts;
var
  i, j, ph: integer;
begin
  try
    if makelogging then
      WriteLog('MAIN', 'UGrid.TGridRows.SetDefaultFonts');
    For i := 0 to Count - 1 do
    begin
      MyCells[i].ColorTrue := MyCellColorTrue;
      MyCells[i].ColorFalse := MyCellColorFalse;
      MyCells[i].TitleColorFont := GridTitleFontColor;
      MyCells[i].TitleFontSize := GridTitleFontSize;
      MyCells[i].TitleFontName := GridTitleFontName;
      MyCells[i].TitleBold := GridTitleFontBold;
      MyCells[i].TitleItalic := GridTitleFontItalic;
      MyCells[i].TitleUnderline := GridTitleFontUnderline;
      for j := 0 to MyCells[i].Count - 1 do
      begin
        for ph := 0 to MyCells[i].Rows[j].Count - 1 do
        begin
          MyCells[i].Rows[j].Phrases[ph].FontColor := GridFontColor;
          MyCells[i].Rows[j].Phrases[ph].FontSize := GridFontSize;
          MyCells[i].Rows[j].Phrases[ph].FontName := GridFontName;
          MyCells[i].Rows[j].Phrases[ph].Bold := GridFontBold;
          MyCells[i].Rows[j].Phrases[ph].Italic := GridFontItalic;
          MyCells[i].Rows[j].Phrases[ph].Underline := GridFontUnderline;

          MyCells[i].Rows[j].Phrases[ph].SubFontColor := GridSubFontColor;
          MyCells[i].Rows[j].Phrases[ph].SubFontSize := GridSubFontSize;
          MyCells[i].Rows[j].Phrases[ph].SubFontName := GridSubFontName;
          MyCells[i].Rows[j].Phrases[ph].SubBold := GridSubFontBold;
          MyCells[i].Rows[j].Phrases[ph].SubItalic := GridSubFontItalic;
          MyCells[i].Rows[j].Phrases[ph].SubUnderline := GridSubFontUnderline;
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TGridRows.SetDefaultFonts | ' + E.Message);
  end;
end;

Procedure TGridRows.ReadFromStream(F: tStream);
var
  i: integer;
begin
  try
    F.ReadBuffer(ID, SizeOf(ID));
    F.ReadBuffer(HeightRow, SizeOf(HeightRow));
    F.ReadBuffer(HeightTitle, SizeOf(HeightTitle));
    // clear;
    F.ReadBuffer(Count, SizeOf(Count));
    For i := 0 to Count - 1 do
    begin
      Setlength(MyCells, i + 1);
      MyCells[i] := TMyCell.Create;
      MyCells[i].ReadFromStream(F); // TMyCell;
    End;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TGridRows.ReadFromStream | ' + E.Message);
  end;
end;

// ============ TCellPhrase =============

Constructor TCellPhrase.Create;
begin
  inherited;
  Left := 0;
  Right := 0;
  Top := 0;
  Bottom := 0;
  Height := 0;
  Width := 0;
  Alignment := ppleft;
  Layout := ppcenter;
  Text := '';
  Name := '';
  FontColor := GridFontColor;
  FontSize := GridFontSize;
  FontName := GridFontName;
  Bold := GridFontBold;
  Italic := GridFontItalic;
  Underline := GridFontUnderline;
  SubFontColor := GridSubFontColor;
  SubFontSize := GridSubFontSize;
  SubFontName := GridSubFontName;
  SubBold := GridSubFontBold;
  SubItalic := GridSubFontItalic;
  SubUnderline := GridSubFontUnderline;
  UsedSubFont := false;
  Visible := true;
  leftprocent := 0;
end;

Destructor TCellPhrase.Destroy;
begin
  FreeMem(@Left);
  FreeMem(@Right);
  FreeMem(@Top);
  FreeMem(@Bottom);
  FreeMem(@Height);
  FreeMem(@Width);
  FreeMem(@Alignment);
  FreeMem(@Layout);
  FreeMem(@Text);
  FreeMem(@Name);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@Bold);
  FreeMem(@Italic);
  FreeMem(@Underline);
  FreeMem(@SubFontColor);
  FreeMem(@SubFontSize);
  FreeMem(@SubFontName);
  FreeMem(@SubBold);
  FreeMem(@SubItalic);
  FreeMem(@SubUnderline);
  FreeMem(@UsedSubFont);
  FreeMem(@Visible);
  FreeMem(@leftprocent);
  inherited;
end;

Procedure TCellPhrase.WriteToStream(F: tStream);
var
  ps: Longint;
begin
  try
    F.WriteBuffer(Left, SizeOf(Left));
    F.WriteBuffer(Right, SizeOf(Right));
    F.WriteBuffer(Top, SizeOf(Top));
    F.WriteBuffer(Bottom, SizeOf(Bottom));
    F.WriteBuffer(Height, SizeOf(Height));
    F.WriteBuffer(Width, SizeOf(Width));
    ps := ord(Alignment);
    F.WriteBuffer(ps, SizeOf(ps));
    ps := ord(Layout);
    F.WriteBuffer(ps, SizeOf(ps));
    WriteBufferStr(F, Text);
    WriteBufferStr(F, Name);
    F.WriteBuffer(FontColor, SizeOf(FontColor));
    F.WriteBuffer(FontSize, SizeOf(FontSize));
    WriteBufferStr(F, FontName);
    F.WriteBuffer(Bold, SizeOf(Bold));
    F.WriteBuffer(Italic, SizeOf(Italic));
    F.WriteBuffer(Underline, SizeOf(Underline));

    F.WriteBuffer(SubFontColor, SizeOf(SubFontColor));
    F.WriteBuffer(SubFontSize, SizeOf(SubFontSize));
    WriteBufferStr(F, SubFontName);
    F.WriteBuffer(SubBold, SizeOf(SubBold));
    F.WriteBuffer(SubItalic, SizeOf(SubItalic));
    F.WriteBuffer(SubUnderline, SizeOf(SubUnderline));
    F.WriteBuffer(UsedSubFont, SizeOf(UsedSubFont));
    F.WriteBuffer(Visible, SizeOf(Visible));
    F.WriteBuffer(leftprocent, SizeOf(leftprocent));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TCellPhrase.WriteToStream | ' + E.Message);
  end;
end;

Procedure TCellPhrase.ReadFromStream(F: tStream);
var
  ps: Longint;
begin
  try
    F.ReadBuffer(Left, SizeOf(Left));
    F.ReadBuffer(Right, SizeOf(Right));
    F.ReadBuffer(Top, SizeOf(Top));
    F.ReadBuffer(Bottom, SizeOf(Bottom));
    F.ReadBuffer(Height, SizeOf(Height));
    F.ReadBuffer(Width, SizeOf(Width));
    F.ReadBuffer(ps, SizeOf(ps));
    Alignment := SetTPhrasePosition(ps);
    F.ReadBuffer(ps, SizeOf(ps));
    Layout := SetTPhrasePosition(ps);
    ReadBufferStr(F, Text);
    ReadBufferStr(F, Name);
    F.ReadBuffer(FontColor, SizeOf(FontColor));
    F.ReadBuffer(FontSize, SizeOf(FontSize));
    ReadBufferStr(F, FontName);
    F.ReadBuffer(Bold, SizeOf(Bold));
    F.ReadBuffer(Italic, SizeOf(Italic));
    F.ReadBuffer(Underline, SizeOf(Underline));
    F.ReadBuffer(SubFontColor, SizeOf(SubFontColor));
    F.ReadBuffer(SubFontSize, SizeOf(SubFontSize));
    ReadBufferStr(F, SubFontName);
    F.ReadBuffer(SubBold, SizeOf(SubBold));
    F.ReadBuffer(SubItalic, SizeOf(SubItalic));
    F.ReadBuffer(SubUnderline, SizeOf(SubUnderline));
    F.ReadBuffer(UsedSubFont, SizeOf(UsedSubFont));
    F.ReadBuffer(Visible, SizeOf(Visible));
    F.ReadBuffer(leftprocent, SizeOf(leftprocent));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TCellPhrase.ReadFromStream | ' + E.Message);
  end;
end;

// ============= TPhrasesRow ======================

constructor TPhrasesRow.Create;
begin
  inherited;
  Count := 0;
  Height := 0;
  Top := 0;
end;

destructor TPhrasesRow.Destroy;
begin
  FreeMem(@Height);
  FreeMem(@Top);
  FreeMem(@Count);
  FreeMem(@Phrases);
  inherited;
end;

function TPhrasesRow.Add(Name, Text: string): integer;
begin
  Count := Count + 1;
  Setlength(Phrases, Count);
  Phrases[Count - 1] := TCellPhrase.Create;
  Phrases[Count - 1].Name := Name;
  Phrases[Count - 1].Text := Text;
  Phrases[Count - 1].Top := Top;
  // Phrases[Count-1].Left:=Left;
  // Phrases[Count-1].Right:=Right;
  Result := Count - 1;
end;

procedure TPhrasesRow.Recount(Wdth: integer);
var
  i, wdt: integer;
  prc: real;
begin
  if Count <= 0 then
    exit;
  prc := Wdth / 100;
  for i := 0 to Count - 1 do
  begin
    Phrases[i].Left := Round(Phrases[i].leftprocent * prc);
  end;
  wdt := 0;
  if Count > 1 then
  begin
    for i := 0 to Count - 2 do
    begin
      Phrases[i].Right := Phrases[i].Left;
      Phrases[i].Width := Phrases[i + 1].Left - Phrases[i].Left;
      wdt := wdt + Phrases[i].Width;
    end;
    Phrases[Count - 1].Width := Wdth - wdt;
  end
  else
  begin
    Phrases[0].Width := Wdth;
  end;
end;

procedure TPhrasesRow.Clear;
var
  i: integer;
begin
  Height := 0;
  Top := 0;
  for i := Count - 1 downto 0 do
    Phrases[i].FreeInstance;
  Setlength(Phrases, 0);
  Count := 0;
end;

procedure TPhrasesRow.Assign(Phr: TPhrasesRow);
var
  i: integer;
begin
  Clear;
  Height := Phr.Height;
  Top := Phr.Top;
  For i := 0 to Phr.Count - 1 do
  begin
    Count := Count + 1;
    Setlength(Phrases, Count);
    Phrases[Count - 1] := TCellPhrase.Create;
    Phrases[Count - 1].Left := Phr.Phrases[i].Left;
    Phrases[Count - 1].Right := Phr.Phrases[i].Right;
    Phrases[Count - 1].Top := Phr.Phrases[i].Top;
    Phrases[Count - 1].Bottom := Phr.Phrases[i].Bottom;
    Phrases[Count - 1].Height := Phr.Phrases[i].Height;
    Phrases[Count - 1].Width := Phr.Phrases[i].Width;
    Phrases[Count - 1].Alignment := Phr.Phrases[i].Alignment;
    Phrases[Count - 1].Layout := Phr.Phrases[i].Layout;
    Phrases[Count - 1].Text := Phr.Phrases[i].Text;
    Phrases[Count - 1].Name := Phr.Phrases[i].Name;
    Phrases[Count - 1].FontColor := Phr.Phrases[i].FontColor;
    Phrases[Count - 1].FontSize := Phr.Phrases[i].FontSize;
    Phrases[Count - 1].FontName := Phr.Phrases[i].FontName;
    Phrases[Count - 1].Bold := Phr.Phrases[i].Bold;
    Phrases[Count - 1].Italic := Phr.Phrases[i].Italic;
    Phrases[Count - 1].Underline := Phr.Phrases[i].Underline;

    Phrases[Count - 1].SubFontColor := Phr.Phrases[i].SubFontColor;
    Phrases[Count - 1].SubFontSize := Phr.Phrases[i].SubFontSize;
    Phrases[Count - 1].SubFontName := Phr.Phrases[i].SubFontName;
    Phrases[Count - 1].SubBold := Phr.Phrases[i].SubBold;
    Phrases[Count - 1].SubItalic := Phr.Phrases[i].SubItalic;
    Phrases[Count - 1].SubUnderline := Phr.Phrases[i].SubUnderline;
    Phrases[Count - 1].UsedSubFont := Phr.Phrases[i].UsedSubFont;
    Phrases[Count - 1].Visible := Phr.Phrases[i].Visible;
    Phrases[Count - 1].leftprocent := Phr.Phrases[i].leftprocent;
  end;
end;

Procedure TPhrasesRow.WriteToStream(F: tStream);
var
  i: integer;
begin
  try
    F.WriteBuffer(Height, SizeOf(Height));
    F.WriteBuffer(Top, SizeOf(Top));
    F.WriteBuffer(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
      Phrases[i].WriteToStream(F);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TPhrasesRow.WriteToStream | ' + E.Message);
  end;
end;

Procedure TPhrasesRow.ReadFromStream(F: tStream);
var
  i, cnt: integer;
begin
  try
    F.ReadBuffer(Height, SizeOf(Height));
    F.ReadBuffer(Top, SizeOf(Top));
    F.ReadBuffer(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
    begin
      Setlength(Phrases, i + 1);
      Phrases[i] := TCellPhrase.Create;
      Phrases[i].ReadFromStream(F);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TPhrasesRow.ReadFromStream | ' + E.Message);
  end;
end;

// ============ TMyCell ===========

constructor TMyCell.Create;
begin
  inherited;
  CellType := tsState;
  Width := -1;
  Procents := 100;
  Used := false;
  Mark := false;
  Title := '';
  TitlePosition := ppcenter;
  TitleColorFont := GridTitleFontColor;
  TitleFontSize := GridTitleFontSize + 2;
  TitleFontName := GridTitleFontName;
  TitleBold := GridTitleFontBold;
  TitleItalic := GridTitleFontItalic;
  TitleUnderline := GridTitleFontUnderline;
  Select := false;
  Background := GridBackGround;
  Name := '';
  TypeImage := none;
  ImageWidth := 0;
  ImageHeight := 0;
  ImageRect.Left := 0;
  ImageRect.Right := 0;
  ImageRect.Top := 0;
  ImageRect.Bottom := 0;
  ImagePosition := ppcenter;
  ImageLayout := tlCenter;
  ImageTrue := '';
  ImageFalse := '';
  Stretch := true;
  Transperent := true;
  ColorTrue := clGreen;
  ColorFalse := SmoothColor(Background, 32);
  ColorPen := GridColorPen;
  WidthPen := 1;
  Count := 0;
  TopPhrase := 0;
  Interval := 4;
  Bitmap := tbitmap.Create;
end;

Destructor TMyCell.Destroy;
begin
  FreeMem(@CellType);
  FreeMem(@Width);
  FreeMem(@Procents);
  FreeMem(@Title);
  FreeMem(@TitlePosition);
  FreeMem(@TitleColorFont);
  FreeMem(@TitleFontSize);
  FreeMem(@TitleFontName);
  FreeMem(@TitleBold);
  FreeMem(@TitleItalic);
  FreeMem(@TitleUnderline);
  FreeMem(@Used);
  FreeMem(@Mark);
  FreeMem(@Select);
  FreeMem(@Background);
  FreeMem(@Name);
  FreeMem(@TypeImage);
  FreeMem(@ImageWidth);
  FreeMem(@ImageHeight);
  FreeMem(@ImageRect.Left);
  FreeMem(@ImageRect.Right);
  FreeMem(@ImageRect.Top);
  FreeMem(@ImageRect.Bottom);
  FreeMem(@ImagePosition);
  FreeMem(@ImageTrue);
  FreeMem(@ImageFalse);
  FreeMem(@Stretch);
  FreeMem(@Transperent);
  FreeMem(@ColorTrue);
  FreeMem(@ColorFalse);
  FreeMem(@ColorPen);
  FreeMem(@WidthPen);
  FreeMem(@Count);
  FreeMem(@TopPhrase);
  FreeMem(@Interval);
  FreeMem(@Rows);
  Bitmap.Destroy;
  inherited;
end;

procedure TMyCell.LoadJpeg(Filename: string; wdt, hgh: integer);
var
  JpegIm: TJpegImage;
  Wdth, hght, bwdth, bhght: integer;
  dlt: real;
  bmp: tbitmap;
begin
  try
    if makelogging then
      WriteLog('MAIN', 'UGrid.TMyCell.LoadJpeg File=' + Filename + ' Width=' +
        inttostr(wdt) + ' Height=' + inttostr(hgh));
    Bitmap.Width := wdt;
    Bitmap.Height := hgh;
    bmp := tbitmap.Create;
    try
      JpegIm := TJpegImage.Create;
      try
        JpegIm.LoadFromFile(Filename);
        bmp.Assign(JpegIm);
        Bitmap.Canvas.StretchDraw(Bitmap.Canvas.ClipRect, bmp);
      finally
        JpegIm.Free;
      end;
    finally
      bmp.Free;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TMyCell.LoadJpeg | ' + E.Message);
  end;
end;

procedure TMyCell.Clear;
var
  i, j: integer;
begin
  inherited;
  CellType := tsState;
  Width := 0;
  Procents := 100;
  Title := '';
  TitlePosition := ppcenter;
  TitleColorFont := GridTitleFontColor;
  TitleFontSize := GridTitleFontSize;
  TitleFontName := GridTitleFontName;
  TitleBold := GridTitleFontBold;
  TitleItalic := GridTitleFontItalic;
  TitleUnderline := GridTitleFontUnderline;
  Used := false;
  Mark := false;
  Select := false;
  Background := GridBackGround;
  Name := '';
  TypeImage := none;
  ImageWidth := 0;
  ImageHeight := 0;
  ImageRect.Left := 0;
  ImageRect.Right := 0;
  ImageRect.Top := 0;
  ImageRect.Bottom := 0;
  ImagePosition := ppcenter;
  ImageTrue := '';
  ImageFalse := '';
  Stretch := true;
  Transperent := true;
  ColorTrue := clGreen;
  ColorFalse := SmoothColor(Background, 32);
  ColorPen := GridColorPen;
  WidthPen := 1;
  TopPhrase := 0;
  Interval := 4;
  Bitmap.Canvas.Brush.Color := Background;
  Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
  if Count < 0 then
    exit;
  for i := Count - 1 downto 0 do
  begin
    for j := Rows[i].Count - 1 downto 0 do
      Rows[i].Phrases[j].FreeInstance;
    Rows[i].Count := 0;
    Setlength(Rows[i].Phrases, 0);
  end;
  Count := 0;
  Setlength(Rows, 0);
end;

function TMyCell.PositionName(Name: string): tpoint;
var
  i, j: integer;
begin
  Result.X := -1;
  Result.Y := -1;
  if Count <= 0 then
    exit;
  For i := 0 to Count - 1 do
  begin
    For j := 0 to Rows[i].Count - 1 do
    begin
      if LowerCase(Rows[i].Phrases[j].Name) = LowerCase(name) then
      begin
        Result.X := i;
        Result.Y := j;
        exit;
      end;
    End;
  End;
end;

function TMyCell.AddRow: integer;
var
  i, tp: integer;
begin
  tp := TopPhrase;
  if Count > 0 then
  begin
    for i := 0 to Count - 1 do
      tp := tp + Rows[i].Height + Interval;
  end;
  Count := Count + 1;
  Setlength(Rows, Count);
  Rows[Count - 1] := TPhrasesRow.Create;
  Rows[Count - 1].Top := Count - 1;
  Result := Count - 1;
end;

function TMyCell.UpdatePhrase(Name, Text: String): boolean;
var
  CPos: tpoint;
begin
  CPos := PositionName(Name);
  Result := true;
  if (CPos.X <> -1) and (CPos.Y <> -1) then
    Rows[CPos.X].Phrases[CPos.Y].Text := Text
  else
    Result := false;
end;

procedure TMyCell.SetPhraseColor(Name: String; Color: TColor);
var
  CPos: tpoint;
begin
  CPos := PositionName(Name);
  if (CPos.X <> -1) and (CPos.Y <> -1) then
    Rows[CPos.X].Phrases[CPos.Y].FontColor := Color;
end;

function TMyCell.ReadPhrase(Name: string): string;
var
  CPos: tpoint;
begin
  Result := '';
  CPos := PositionName(Name);
  if (CPos.X <> -1) and (CPos.Y <> -1) then
    Result := Rows[CPos.X].Phrases[CPos.Y].Text;
end;

function TMyCell.ReadPhraseColor(Name: String): TColor;
var
  CPos: tpoint;
begin
  Result := GridFontColor;
  CPos := PositionName(Name);
  if (CPos.X <> -1) and (CPos.Y <> -1) then
    Result := Rows[CPos.X].Phrases[CPos.Y].FontColor;
end;

function TMyCell.AddPhrase(ARow: integer; Name, Text: String): integer;
begin
  Result := Rows[ARow].Add(Name, Text);
end;

Procedure TMyCell.WriteToStream(F: tStream);
Var
  i, sz: Longint;
begin
  try
    i := ord(CellType); // TTypeCell
    F.WriteBuffer(i, SizeOf(i));
    F.WriteBuffer(Width, SizeOf(Width));
    F.WriteBuffer(Procents, SizeOf(Procents));
    WriteBufferStr(F, Title);
    i := ord(TitlePosition); // TPhrasePosition
    F.WriteBuffer(i, SizeOf(i));
    F.WriteBuffer(TitleColorFont, SizeOf(TitleColorFont));
    F.WriteBuffer(TitleFontSize, SizeOf(TitleFontSize));
    WriteBufferStr(F, TitleFontName);
    F.WriteBuffer(TitleBold, SizeOf(TitleBold));
    F.WriteBuffer(TitleItalic, SizeOf(TitleItalic));
    F.WriteBuffer(TitleUnderline, SizeOf(TitleUnderline));
    F.WriteBuffer(Used, SizeOf(Used));
    F.WriteBuffer(Mark, SizeOf(Mark));
    F.WriteBuffer(Select, SizeOf(Select));
    F.WriteBuffer(Background, SizeOf(Background));
    WriteBufferStr(F, Name);
    i := ord(TypeImage); // TTypeGraphics
    F.WriteBuffer(i, SizeOf(i));
    F.WriteBuffer(ImageWidth, SizeOf(ImageWidth));
    F.WriteBuffer(ImageHeight, SizeOf(ImageHeight));

    F.WriteBuffer(ImageRect.Top, SizeOf(ImageRect.Top));
    F.WriteBuffer(ImageRect.Bottom, SizeOf(ImageRect.Bottom));
    F.WriteBuffer(ImageRect.Left, SizeOf(ImageRect.Left));
    F.WriteBuffer(ImageRect.Right, SizeOf(ImageRect.Right));

    i := ord(ImagePosition); // TPhrasePosition
    F.WriteBuffer(i, SizeOf(i));
    i := ord(ImageLayout); // TTextLayout
    F.WriteBuffer(i, SizeOf(i));
    WriteBufferStr(F, ImageTrue);
    WriteBufferStr(F, ImageFalse);
    F.WriteBuffer(Stretch, SizeOf(Stretch));
    F.WriteBuffer(Transperent, SizeOf(Transperent));
    F.WriteBuffer(ColorTrue, SizeOf(ColorTrue));
    F.WriteBuffer(ColorFalse, SizeOf(ColorFalse));
    F.WriteBuffer(ColorPen, SizeOf(ColorPen));
    F.WriteBuffer(WidthPen, SizeOf(ColorPen));

    F.WriteBuffer(TopPhrase, SizeOf(TopPhrase));

    // sz := SizeOf(Bitmap);
    // F.WriteBuffer(sz, SizeOf(sz));
    // F.WriteBuffer(Bitmap, sz);

    F.WriteBuffer(Interval, SizeOf(Interval));
    F.WriteBuffer(Count, SizeOf(Count));
    For i := 0 to Count - 1 do
      Rows[i].WriteToStream(F); // TPhrasesRow;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TMyCell.WriteToStream | ' + E.Message);
  end;
end;

Procedure TMyCell.ReadFromStream(F: tStream);
Var
  i, sz, cnt: Longint;
begin
  try
    F.ReadBuffer(i, SizeOf(i));
    CellType := SetTTypeCell(i);
    F.ReadBuffer(Width, SizeOf(Width));
    F.ReadBuffer(Procents, SizeOf(Procents));
    ReadBufferStr(F, Title);
    F.ReadBuffer(i, SizeOf(i));
    TitlePosition := SetTPhrasePosition(i);
    F.ReadBuffer(TitleColorFont, SizeOf(TitleColorFont));
    F.ReadBuffer(TitleFontSize, SizeOf(TitleFontSize));
    ReadBufferStr(F, TitleFontName);
    F.ReadBuffer(TitleBold, SizeOf(TitleBold));
    F.ReadBuffer(TitleItalic, SizeOf(TitleItalic));
    F.ReadBuffer(TitleUnderline, SizeOf(TitleUnderline));
    F.ReadBuffer(Used, SizeOf(Used));
    F.ReadBuffer(Mark, SizeOf(Mark));
    F.ReadBuffer(Select, SizeOf(Select));
    F.ReadBuffer(Background, SizeOf(Background));
    ReadBufferStr(F, Name);
    F.ReadBuffer(i, SizeOf(i));
    TypeImage := SetTTypeGraphics(i);
    F.ReadBuffer(ImageWidth, SizeOf(ImageWidth));
    F.ReadBuffer(ImageHeight, SizeOf(ImageHeight));

    F.ReadBuffer(ImageRect.Top, SizeOf(ImageRect.Top));
    F.ReadBuffer(ImageRect.Bottom, SizeOf(ImageRect.Bottom));
    F.ReadBuffer(ImageRect.Left, SizeOf(ImageRect.Left));
    F.ReadBuffer(ImageRect.Right, SizeOf(ImageRect.Right));

    F.ReadBuffer(i, SizeOf(i));
    ImagePosition := SetTPhrasePosition(i);
    F.ReadBuffer(i, SizeOf(i));
    ImageLayout := SetTTextLayout(i);
    ReadBufferStr(F, ImageTrue);
    ReadBufferStr(F, ImageFalse);
    F.ReadBuffer(Stretch, SizeOf(Stretch));
    F.ReadBuffer(Transperent, SizeOf(Transperent));
    F.ReadBuffer(ColorTrue, SizeOf(ColorTrue));
    F.ReadBuffer(ColorFalse, SizeOf(ColorFalse));
    F.ReadBuffer(ColorPen, SizeOf(ColorPen));
    F.ReadBuffer(WidthPen, SizeOf(WidthPen));

    F.ReadBuffer(TopPhrase, SizeOf(TopPhrase));

    // F.ReadBuffer(sz, SizeOf(sz));
    // F.ReadBuffer(Bitmap, sz);

    F.ReadBuffer(Interval, SizeOf(Interval));
    // clear;
    F.ReadBuffer(Count, SizeOf(Count));
    For i := 0 to Count - 1 do
    begin
      Setlength(Rows, i + 1);
      Rows[i] := TPhrasesRow.Create;
      Rows[i].ReadFromStream(F);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.TMyCell.ReadFromStream | ' + E.Message);
  end;
end;

// ============ GRID PROC=================

procedure initgrid(grid: tstringgrid; obj: TGridRows; Width: integer);
var
  i, j, wdt: integer;
begin
  try
    For i := 0 to grid.RowCount - 1 do
      for j := 0 to grid.ColCount do
      begin
        grid.Objects[j, i] := nil;
        grid.Cells[j, i] := '';
      end;
    If obj.HeightTitle <> -1 then
      grid.RowCount := 2
    else
      grid.RowCount := 1;
    grid.ColCount := obj.Count;
    for i := 0 to grid.RowCount - 1 do
    begin
      if (obj.HeightTitle <> -1) and (i = 0) then
        grid.RowHeights[0] := obj.HeightTitle
      else
        grid.RowHeights[i] := obj.HeightRow;
      grid.Objects[0, i] := TGridRows.Create;
      (grid.Objects[0, i] as TGridRows).Assign(obj);
    end;
    wdt := 0;
    grid.ColCount := obj.Count;
    For i := 0 to obj.Count - 1 do
    begin
      if obj.MyCells[i].Width <> -1 then
      begin
        wdt := wdt + obj.MyCells[i].Width;
        grid.ColWidths[i] := obj.MyCells[i].Width;
      end;
    end;
    wdt := Width - wdt;
    For i := 0 to obj.Count - 1 do
    begin
      if obj.MyCells[i].Width = -1 then
      begin
        grid.ColWidths[i] := Round(wdt / 100 * obj.MyCells[i].Procents);
      end;
    end;
    grid.Repaint;
    if makelogging then
      WriteLog('MAIN', 'UGrid.initgrid Grid=' + grid.Name + ' Width=' +
        inttostr(Width));

  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.initgrid | ' + E.Message);
  end;
end;

Procedure DrawMyTextCell(grid: tstringgrid; ACol, ARow: integer; Rect: Trect;
  obj: TMyCell);
var
  i, j, posx, posy: integer;
  cvc, pnc, fncl: TColor;
  cvs: tbrushstyle;
  pns: tpenstyle;
  fnsz, pnw: integer;
  fnnm: tfontname;
  fnst: tfontstyles;
begin
  try
    cvc := grid.Canvas.Brush.Color;
    cvs := grid.Canvas.Brush.Style;
    pnc := grid.Canvas.Pen.Color;
    pns := grid.Canvas.Pen.Style;
    pnw := grid.Canvas.Pen.Width;
    fncl := grid.Canvas.Font.Color;
    fnsz := grid.Canvas.Font.Size;
    fnnm := grid.Canvas.Font.Name;
    fnst := grid.Canvas.Font.Style;

    if (ARow = 0) and ((grid.Objects[0, 0] as TGridRows).HeightTitle > -1) then
    begin
      grid.Canvas.Font.Color := obj.TitleColorFont;
      grid.Canvas.Font.Size := obj.TitleFontSize;
      grid.Canvas.Font.Name := obj.TitleFontName;
      if obj.TitleBold then
        grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsBold]
      else
        grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsBold];
      if obj.TitleItalic then
        grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsItalic]
      else
        grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsItalic];
      if obj.TitleUnderline then
        grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsUnderline]
      else
        grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsUnderline];
      case obj.TitlePosition of
        ppleft:
          posx := Rect.Left + 5;
        ppright:
          posx := Rect.Right - 5 - grid.Canvas.TextWidth(obj.Title);
      else
        posx := Rect.Left +
          ((Rect.Right - Rect.Left - grid.Canvas.TextWidth(obj.Title)) div 2);
      end; // case
      posy := Rect.Top +
        ((Rect.Bottom - Rect.Top - grid.Canvas.TextHeight(obj.Title)) div 2);
      grid.Canvas.TextOut(posx, posy, obj.Title);
    end
    else
    begin
      if grid.Objects[0, ARow] is TGridRows then
        if (grid.Objects[0, ARow] as TGridRows).ID <= 0 then
          exit;
      For i := 0 to obj.Count - 1 do
      begin
        obj.Rows[i].Recount(grid.Width);
        For j := 0 to obj.Rows[i].Count - 1 do
        begin
          if obj.Rows[i].Phrases[j].UsedSubFont then
          begin
            grid.Canvas.Font.Color := obj.Rows[i].Phrases[j].SubFontColor;
            grid.Canvas.Font.Size := obj.Rows[i].Phrases[j].SubFontSize;
            grid.Canvas.Font.Name := obj.Rows[i].Phrases[j].SubFontName;
            if obj.Rows[i].Phrases[j].SubBold then
              grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsBold]
            else
              grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsBold];
            if obj.Rows[i].Phrases[j].SubItalic then
              grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsItalic]
            else
              grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsItalic];
            if obj.Rows[i].Phrases[j].SubUnderline then
              grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsUnderline]
            else
              grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsUnderline];
          end
          else
          begin
            grid.Canvas.Font.Color := obj.Rows[i].Phrases[j].FontColor;
            grid.Canvas.Font.Size := obj.Rows[i].Phrases[j].FontSize;
            grid.Canvas.Font.Name := obj.Rows[i].Phrases[j].FontName;
            if obj.Rows[i].Phrases[j].Bold then
              grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsBold]
            else
              grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsBold];
            if obj.Rows[i].Phrases[j].Italic then
              grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsItalic]
            else
              grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsItalic];
            if obj.Rows[i].Phrases[j].Underline then
              grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsUnderline]
            else
              grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsUnderline];
          end;

          posx := Rect.Left + obj.Rows[i].Phrases[j].Left;
          posy := Rect.Top + obj.Rows[i].Phrases[j].Top;

          if obj.Rows[i].Phrases[j].Visible then
          begin
            if j <> 0 then
              grid.Canvas.TextOut(posx - grid.Canvas.TextWidth('     '),
                posy, '     ');
            grid.Canvas.TextOut(posx, posy, obj.Rows[i].Phrases[j].Text);
          end;
        End;
      End
    end;;

    grid.Canvas.Brush.Color := cvc;
    grid.Canvas.Brush.Style := cvs;
    grid.Canvas.Pen.Color := pnc;
    grid.Canvas.Pen.Style := pns;
    grid.Canvas.Pen.Width := pnw;
    grid.Canvas.Font.Color := fncl;
    grid.Canvas.Font.Size := fnsz;
    grid.Canvas.Font.Name := fnnm;
    grid.Canvas.Font.Style := fnst;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.DrawMyTextCell | ' + E.Message);
  end;
end;

// +++++++++++++++++++++++++++++++++++++

Procedure DrawMyImageCell(grid: tstringgrid; ACol, ARow: integer; Rect: Trect;
  obj: TMyCell);
var
  i, j, posx, posy: integer;
  cvc, pnc, fncl: TColor;
  cvs: tbrushstyle;
  pns: tpenstyle;
  fnsz, pnw: integer;
  fnnm: tfontname;
  fnst: tfontstyles;
  bmp: tbitmap;
  nm, nt, ny: string;
  pict: tbitmap;
begin
  try
    cvc := grid.Canvas.Brush.Color;
    cvs := grid.Canvas.Brush.Style;
    pnc := grid.Canvas.Pen.Color;
    pns := grid.Canvas.Pen.Style;
    pnw := grid.Canvas.Pen.Width;
    fncl := grid.Canvas.Font.Color;
    fnsz := grid.Canvas.Font.Size;
    fnnm := grid.Canvas.Font.Name;
    fnst := grid.Canvas.Font.Style;
    if grid.Objects[0, ARow] is TGridRows then
      if (grid.Objects[0, ARow] as TGridRows).ID <= 0 then
        exit;
    if obj.Count = 0 then
      exit;
    nm := obj.ReadPhrase('File');
    nt := obj.ReadPhrase('Note');
    ny := obj.ReadPhrase('Import');

    if FileExists(PathTemplates + '\' + nm) then
    begin
      bitblt(grid.Canvas.Handle, Rect.Left, Rect.Top,
        Rect.Right { -rect.Left } , Rect.Bottom { -rect.Top } ,
        obj.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
    end
    else
    begin
      grid.Canvas.Font.Size := DefineFontSizeW(grid.Canvas,
        Rect.Right - Rect.Left, nt);
      posx := Rect.Left +
        ((Rect.Right - Rect.Left - grid.Canvas.TextWidth(nt)) div 2);
      posy := Rect.Top +
        ((Rect.Bottom - Rect.Top - grid.Canvas.TextHeight(nt)) div 2);
      grid.Canvas.TextOut(posx, posy, nt);
    end;

    grid.Canvas.Brush.Color := cvc;
    grid.Canvas.Brush.Style := cvs;
    grid.Canvas.Pen.Color := pnc;
    grid.Canvas.Pen.Style := pns;
    grid.Canvas.Pen.Width := pnw;
    grid.Canvas.Font.Color := fncl;
    grid.Canvas.Font.Size := fnsz;
    grid.Canvas.Font.Name := fnnm;
    grid.Canvas.Font.Style := fnst;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.DrawMyImageCell | ' + E.Message);
  end;
end;

// +++++++++++++++++++++++++++++++++++++

Procedure DrawMyStateCell(grid: tstringgrid; ACol, ARow: integer; Rect: Trect;
  var obj: TMyCell);
var
  img: string;
  cvc, pnc, fncl, tempclr: TColor;
  cvs: tbrushstyle;
  pns: tpenstyle;
  i, j, fnsz, pnw: integer;
  fnnm: tfontname;
  fnst: tfontstyles;
begin
  try
    cvc := grid.Canvas.Brush.Color;
    cvs := grid.Canvas.Brush.Style;
    pnc := grid.Canvas.Pen.Color;
    pns := grid.Canvas.Pen.Style;
    pnw := grid.Canvas.Pen.Width;
    fncl := grid.Canvas.Font.Color;
    fnsz := grid.Canvas.Font.Size;
    fnnm := grid.Canvas.Font.Name;
    fnst := grid.Canvas.Font.Style;

    if not obj.Used then
    begin
      grid.Canvas.FillRect(Rect);
      exit;
    end;

    case obj.ImagePosition of
      ppleft:
        begin
          obj.ImageRect.Left := Rect.Left;
          obj.ImageRect.Right := obj.ImageRect.Left + obj.ImageWidth;
        end;
      ppright:
        begin
          obj.ImageRect.Left := Rect.Right - obj.ImageWidth;
          obj.ImageRect.Right := Rect.Right;
        end;
      ppcenter:
        begin
          obj.ImageRect.Left := Rect.Left +
            ((Rect.Right - Rect.Left - obj.ImageWidth) div 2);
          obj.ImageRect.Right := obj.ImageRect.Left + obj.ImageWidth;
        end;
    else
      begin
        obj.ImageRect.Left := Rect.Left;
        obj.ImageRect.Right := Rect.Right;
      end;
    end; // case

    case obj.ImageLayout of
      tlTop:
        begin
          obj.ImageRect.Top := Rect.Top;
          obj.ImageRect.Bottom := obj.ImageRect.Top + obj.ImageHeight;
        end;
      tlCenter:
        begin
          obj.ImageRect.Top := Rect.Top +
            ((Rect.Bottom - Rect.Top - obj.ImageHeight) div 2);
          obj.ImageRect.Bottom := obj.ImageRect.Top + obj.ImageHeight;
        end;
      tlBottom:
        begin
          obj.ImageRect.Top := Rect.Bottom - obj.ImageHeight;
          obj.ImageRect.Bottom := Rect.Bottom;
        end;
    end; // case

    if obj.Mark then
    begin
      grid.Canvas.Brush.Color := obj.ColorTrue;
      img := obj.ImageTrue;
    end
    else
    begin
      grid.Canvas.Brush.Color := obj.ColorFalse;
      img := obj.ImageFalse;
    end;;
    grid.Canvas.Pen.Color := ProgrammFontColor;
    case obj.TypeImage of
      picture:
        begin

          LoadBMPFromRes(grid.Canvas, obj.ImageRect, obj.ImageWidth,
            obj.ImageHeight, img);
          if obj.Mark then
            tempclr := obj.ColorFalse
          else
            tempclr := obj.ColorTrue;
          for i := obj.ImageRect.Left to obj.ImageRect.Right - 1 do
            for j := obj.ImageRect.Top to obj.ImageRect.Bottom - 1 do
              if grid.Canvas.Pixels[i, j] = clWhite then
                grid.Canvas.Pixels[i, j] := tempclr;
        end;
      ellipse:
        begin

          grid.Canvas.ellipse(obj.ImageRect);
        end;
      rectangle:
        begin
          grid.Canvas.rectangle(obj.ImageRect);
        end;
      roundrect:
        begin
          grid.Canvas.roundrect(obj.ImageRect.Left, obj.ImageRect.Top,
            obj.ImageRect.Right, obj.ImageRect.Bottom,
            (obj.ImageRect.Right - obj.ImageRect.Left) div 2,
            (obj.ImageRect.Bottom - obj.ImageRect.Top) div 2);
        end;
      none:
        begin
          grid.Canvas.FillRect(Rect);
        end;
    end; // case

    grid.Canvas.Brush.Color := cvc;
    grid.Canvas.Brush.Style := cvs;
    grid.Canvas.Pen.Color := pnc;
    grid.Canvas.Pen.Style := pns;
    grid.Canvas.Pen.Width := pnw;
    grid.Canvas.Font.Color := fncl;
    grid.Canvas.Font.Size := fnsz;
    grid.Canvas.Font.Name := fnnm;
    grid.Canvas.Font.Style := fnst;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.DrawMyStateCell | ' + E.Message);
  end;
end;

procedure GridDrawMyCell(grid: tstringgrid; ACol, ARow: integer; Rect: Trect);
Var
  RT, rt1: Trect;
  strs: string;
  deltx, delty: integer;
  oldfontsize: integer;
  oldfontcolor: TColor;
  cvc, pnc, fncl: TColor;
  cvs: tbrushstyle;
  pns: tpenstyle;
  fnsz, pnw: integer;
  fnnm: tfontname;
  fnst: tfontstyles;
begin
  try
    rt1.Left := Rect.Left - 5;
    rt1.Right := Rect.Right + 5;
    rt1.Top := Rect.Top;
    rt1.Bottom := Rect.Bottom;
    // grid.Canvas.FillRect(rt1);
    // if Grid.Objects[0,] Grid.RowHeights[ARow]:=
    cvc := grid.Canvas.Brush.Color;
    cvs := grid.Canvas.Brush.Style;
    pnc := grid.Canvas.Pen.Color;
    pns := grid.Canvas.Pen.Style;
    pnw := grid.Canvas.Pen.Width;
    fncl := grid.Canvas.Font.Color;
    fnsz := grid.Canvas.Font.Size;
    fnnm := grid.Canvas.Font.Name;
    fnst := grid.Canvas.Font.Style;

    strs := '';

    If ARow = 0 then
    begin
      grid.Canvas.Brush.Color := ProgrammColor;
      grid.Canvas.Font.Color := ProgrammFontColor;
      grid.Canvas.Font.Size := ProgrammFontSize;
      grid.Canvas.Font.Name := ProgrammFontName;
      grid.Canvas.Pen.Color := SmoothColor(GridBackGround, 64);
      // grid.Canvas.Pen.Width:=1;
      // grid.Canvas.MoveTo(Rect.Left,Rect.Bottom);
      // grid.Canvas.LineTo(Rect.Right,Rect.Bottom);
      // if ACol in [2,3,4] then begin
      // grid.Canvas.MoveTo(Rect.Right-1,Rect.Top);
      // grid.Canvas.LineTo(Rect.Right-1,Rect.Bottom);
      // end;
    end
    else
    begin
      if (ARow mod 2) = 0 then
        grid.Canvas.Brush.Color := GridColorRow1
      else
        grid.Canvas.Brush.Color := GridColorRow2;
      if ARow = grid.Selection.Top then
        grid.Canvas.Brush.Color := GridColorSelection;
      grid.Canvas.FillRect(rt1);
      grid.Canvas.Pen.Color := SmoothColor(GridBackGround, 64); // GridColorPen;
      grid.Canvas.Pen.Width := 1;
    end;

    if grid.Objects[0, ARow] is TGridRows then
    begin
      if ARow = 0 then
      begin
        if (grid.Objects[0, ARow] as TGridRows).HeightTitle <> -1 then
          grid.RowHeights[ARow] := (grid.Objects[0, ARow] as TGridRows)
            .HeightTitle
        else
          grid.RowHeights[ARow] := (grid.Objects[0, ARow] as TGridRows)
            .HeightRow
      end
      else
        grid.RowHeights[ARow] := (grid.Objects[0, ARow] as TGridRows).HeightRow;
      case (grid.Objects[0, ARow] as TGridRows).MyCells[ACol].CellType of
        tsText:
          DrawMyTextCell(grid, ACol, ARow, Rect,
            (grid.Objects[0, ARow] as TGridRows).MyCells[ACol]);
        tsState:
          DrawMyStateCell(grid, ACol, ARow, Rect,
            (grid.Objects[0, ARow] as TGridRows).MyCells[ACol]);
        tsImage:
          DrawMyImageCell(grid, ACol, ARow, Rect,
            (grid.Objects[0, ARow] as TGridRows).MyCells[ACol]);
      end; // case
    end;

    grid.Canvas.Brush.Color := cvc;
    grid.Canvas.Brush.Style := cvs;
    grid.Canvas.Pen.Color := pnc;
    grid.Canvas.Pen.Style := pns;
    grid.Canvas.Pen.Width := pnw;
    grid.Canvas.Font.Color := fncl;
    grid.Canvas.Font.Size := fnsz;
    grid.Canvas.Font.Name := fnnm;
    grid.Canvas.Font.Style := fnst;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.GridDrawMyCell | ' + E.Message);
  end;
end;

function GridAddRow(grid: tstringgrid; obj: TGridRows): integer;
var
  min: integer;
begin
  try
    Result := -1;
    if grid.Objects[0, 0] is TGridRows then
    begin
      if (grid.Objects[0, 0] as TGridRows).HeightTitle = -1 then
        min := 1
      else
        min := 2;
      if grid.RowCount = min then
      begin
        if grid.Objects[0, min - 1] is TGridRows then
        begin
          if (grid.Objects[0, min - 1] as TGridRows).ID = 0 then
          begin
            (grid.Objects[0, min - 1] as TGridRows).Assign(obj);
            // IDCLIPS:=IDCLIPS+1;
            // (Grid.Objects[0,min-1] as TGridRows).ID:=IDCLIPS;
            Result := min - 1;
            if makelogging then
              WriteLog('MAIN', 'UGrid.GridAddRow Grid=' + grid.Name + ' Result='
                + inttostr(Result));
            exit;
          end;
        end;
      end;
      grid.RowCount := grid.RowCount + 1;
      if not(grid.Objects[0, grid.RowCount - 1] is TGridRows) then
      begin
        grid.Objects[0, grid.RowCount - 1] := TGridRows.Create;
        (grid.Objects[0, grid.RowCount - 1] as TGridRows).Assign(obj);
        // IDCLIPS:=IDCLIPS+1;
        // (Grid.Objects[0,Grid.RowCount-1] as TGridRows).ID:=IDCLIPS;
      end;
      Result := grid.RowCount - 1;
      if makelogging then
        WriteLog('MAIN', 'UGrid.GridAddRow Grid=' + grid.Name + ' Result=' +
          inttostr(Result));
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.GridAddRow | ' + E.Message);
  end;
end;

procedure MyGridDeleteRow(grid: tstringgrid; ARow: integer; obj: TGridRows);
var
  i, min: integer;
begin
  try
    if grid.Objects[0, 0] is TGridRows then
    begin
      if makelogging then
        WriteLog('MAIN', 'UGrid.MyGridDeleteRow Grid=' + grid.Name + ' Row=' +
          inttostr(ARow));
      if (grid.Objects[0, 0] as TGridRows).HeightTitle = -1 then
        min := 1
      else
        min := 2;
      if ARow < min - 1 then
        exit;
      if grid.RowCount = min then
      begin
        (grid.Objects[0, min - 1] as TGridRows).Assign(obj);
        (grid.Objects[0, min - 1] as TGridRows).ID := 0;
        exit;
      end;
      If ARow = grid.RowCount - 1 then
      begin
        grid.Objects[0, ARow] := nil;
        grid.RowCount := grid.RowCount - 1;
        exit;
      end;
      If (ARow >= min - 1) and (ARow < grid.RowCount - 1) then
      begin
        for i := ARow to grid.RowCount - 2 do
        begin
          (grid.Objects[0, i] as TGridRows)
            .Assign((grid.Objects[0, i + 1] as TGridRows));
        end;
        grid.Objects[0, grid.RowCount - 1] := nil;
        grid.RowCount := grid.RowCount - 1;
        exit;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.MyGridDeleteRow | ' + E.Message);
  end;
end;

function GridColX(grid: tstringgrid; X: integer): integer;
var
  i, lft, rgt, cl: integer;
begin
  try
    Result := -1;
    lft := 0;
    for i := grid.LeftCol to grid.ColCount - 1 do
    begin
      rgt := lft + grid.ColWidths[i] + grid.GridLineWidth;
      if (X > lft) and (X < rgt) then
      begin
        Result := i;
        if makelogging then
          WriteLog('MAIN', 'UGrid.GridColX-1 Grid=' + grid.Name + ' X=' +
            inttostr(X) + ' Result=' + inttostr(Result));
        exit;
      end;
      lft := rgt;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.GridColX-2 Grid=' + grid.Name + ' X=' +
        inttostr(X) + ' Result=' + inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.GridColX | ' + E.Message);
  end;
end;

function GridClickRow(grid: tstringgrid; Y: integer): integer;
var
  i, tp, btn, tprw, vsrw, hgh: integer;
begin
  try
    Result := -1;
    tprw := grid.TopRow;
    vsrw := grid.VisibleRowCount;
    hgh := grid.Height;
    if grid.FixedRows > 0 then
    begin
      tp := grid.GridLineWidth;
      For i := 0 to grid.FixedRows - 1 do
      begin
        btn := tp + grid.RowHeights[i];
        if (Y >= tp) and (Y <= btn) then
        begin
          Result := i;
          if makelogging then
            WriteLog('MAIN', 'UGrid.GridClickRow-1 Grid=' + grid.Name + ' Y=' +
              inttostr(Y) + ' Result=' + inttostr(Result));
          exit;
        end;
        tp := btn + grid.GridLineWidth;
      end
    end;

    for i := grid.TopRow to grid.RowCount - 1 do
    begin
      btn := tp + grid.RowHeights[i];
      if (Y >= tp) and (Y <= btn) then
      begin
        Result := i;
        if makelogging then
          WriteLog('MAIN', 'UGrid.GridClickRow-2 Grid=' + grid.Name + ' Y=' +
            inttostr(Y) + ' Result=' + inttostr(Result));
        // Grid.TopRow := TopRowGridGrTemplate;
        exit;
      end
      else
      begin
        if tp >= hgh then
        begin
          if i > 0 then
            Result := i - 1;
          WriteLog('MAIN', 'UGrid.GridClickRow-3 Grid=' + grid.Name + ' Y=' +
            inttostr(Y) + ' Result=' + inttostr(Result));
          // Grid.TopRow := TopRowGridGrTemplate;
          exit;
        end;
      end;
      tp := btn + grid.GridLineWidth;
      WriteLog('MAIN', 'UGrid.GridClickRow-4 Grid=' + grid.Name + ' Y=' +
        inttostr(Y) + ' Result=' + inttostr(Result));
    end;

  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.GridClickRow | ' + E.Message);
  end;
  // Grid.TopRow := TopRowGridGrTemplate;
  // if (result=-1) and (Grid.Row=Grid.RowCount-1) then result := Grid.RowCount-1;
end;

function findgridselection(grid: tstringgrid; cell: integer): integer;
var
  i, st: integer;
begin
  try
    Result := -1;
    if grid.Objects[0, 0] is TGridRows then
    begin
      if (grid.Objects[0, 0] as TGridRows).HeightTitle >= 0 then
        st := 1
      else
        st := 0;
    end;
    if grid.RowCount = st + 1 then
    begin
      if (grid.Objects[0, st] as TGridRows).ID <= 0 then
        exit;
    end;
    for i := st to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        if (grid.Objects[0, i] as TGridRows).MyCells[cell].Mark then
        begin
          Result := i;
          if makelogging then
            WriteLog('MAIN', 'UGrid.findgridselection Grid=' + grid.Name +
              ' Cell=' + inttostr(cell) + ' Result=' + inttostr(Result));
          exit;
        end;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.findgridselection Grid=' + grid.Name + ' Cell=' +
        inttostr(cell) + ' Result=' + inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.findgridselection | ' + E.Message);
  end;
end;

procedure GridClear(grid: tstringgrid; obj: TGridRows);
var
  i, strt: integer;
begin
  try
    strt := 1;
    if grid.Objects[0, 0] is TGridRows then
      if (grid.Objects[0, 0] as TGridRows).HeightTitle <> -1 then
        strt := 1
      else
        strt := 0;
    for i := grid.RowCount - 1 downto strt do
    begin
      MyGridDeleteRow(grid, i, obj);
      if makelogging then
        WriteLog('MAIN', 'UGrid.GridClear Row=' + inttostr(i));
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.GridClear | ' + E.Message);
  end;
end;

procedure GridImageReload(grid: tstringgrid);
var
  i, rw: integer;
  nm: string;
begin
  try
    // (grid.Objects[0,rw] as tgridrows).HeightRow
    for rw := 0 to grid.RowCount - 1 do
    begin
      if grid.Objects[0, rw] is TGridRows then
      begin
        for i := 0 to grid.ColCount - 1 do
        begin
          if (grid.Objects[0, rw] as TGridRows).MyCells[i].CellType = tsImage
          then
          begin
            nm := (grid.Objects[0, rw] as TGridRows).MyCells[i]
              .ReadPhrase('File');
            if FileExists(PathTemplates + '\' + nm) then
            begin
              (grid.Objects[0, rw] as TGridRows).MyCells[i]
                .LoadJpeg(PathTemplates + '\' + nm, grid.ColWidths[i],
                (grid.Objects[0, rw] as TGridRows).HeightRow);
              // grid.RowHeights[rw]);
              if makelogging then
                WriteLog('MAIN', 'UGrid.GridImageReload Grid=' + grid.Name +
                  ' File=' + PathTemplates + '\' + nm);
            end;
          end;
          if rw mod 5 = 0 then
            grid.Repaint;
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.GridImageReload | ' + E.Message);
  end;
end;

function MarkRowPhraseInGrid(grid: tstringgrid; MarkCell, WorkCell: integer;
  Name, Text, ev: string): integer;
var
  i: integer;
  txt: string;
begin
  try
    Result := -1;
    // if trim(Text)=Trim(CurrentImageTemplate) then exit;

    if Trim(Text) = '' then
    begin
      for i := 0 to grid.RowCount - 1 do
        if grid.Objects[0, i] is TGridRows then
        begin
          (grid.Objects[0, i] as TGridRows).MyCells[MarkCell].Mark := false;
          // if makelogging then WriteLog('TC', 'MarkRowPhraseInGrid 1=' + MyTimeToStr + ' ' + ev);
          // if makelogging then WriteLog('MAIN', 'UGrid.MarkRowPhraseInGrid Grid=' + Grid.Name + ' MarkCell=' + inttostr(MarkCell)
          // + ' WorkCell=' + inttostr(WorkCell)+ ' Name=' + Name + ' Text' + Text + ' Row=' + inttostr(i)
          // + ' Mark:=false' + ' ' + ev);
        end;
      grid.Repaint;

      exit;
    end;
    for i := 0 to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        txt := (grid.Objects[0, i] as TGridRows).MyCells[WorkCell]
          .ReadPhrase(Name);
        if Trim(LowerCase(txt)) = Trim(LowerCase(Text)) then
        begin
          (grid.Objects[0, i] as TGridRows).MyCells[MarkCell].ColorTrue
            := clRed;
          (grid.Objects[0, i] as TGridRows).MyCells[MarkCell].Mark := true;
          grid.Row := i;
          // if makelogging then WriteLog('TC', 'MarkRowPhraseInGrid 2=' + MyTimeToStr + ' ' + ev);
          // if makelogging then WriteLog('MAIN', 'UGrid.MarkRowPhraseInGrid Grid=' + Grid.Name + ' MarkCell=' + inttostr(MarkCell)
          // + ' WorkCell=' + inttostr(WorkCell)+ ' Name=' + Name + ' Text' + Text + ' Row=' + inttostr(i)
          // + ' Mark:=true' + ' ' + ev);
        end
        else
        begin
          (grid.Objects[0, i] as TGridRows).MyCells[MarkCell].Mark := false;
          // if makelogging then WriteLog('TC', 'MarkRowPhraseInGrid 3=' + MyTimeToStr + ' ' + ev);
          // if makelogging then WriteLog('MAIN', 'UGrid.MarkRowPhraseInGrid Grid=' + Grid.Name + ' MarkCell=' + inttostr(MarkCell)
          // + ' WorkCell=' + inttostr(WorkCell)+ ' Name=' + Name + ' Text' + Text + ' Row=' + inttostr(i)
          // + ' Mark:=false' + ' ' + ev);
        end;
      end;
    end;
    grid.Repaint;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.MarkRowPhraseInGrid | ' + E.Message);
  end;
end;

function IsPhraseInGrid(grid: tstringgrid; ACol: integer;
  Name, Text: string): boolean;
var
  i: integer;
  txt: string;
begin
  try
    Result := false;
    for i := 0 to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        txt := (grid.Objects[0, i] as TGridRows).MyCells[ACol].ReadPhrase(Name);
        if Trim(LowerCase(txt)) = Trim(LowerCase(Text)) then
        begin
          Result := true;
          if makelogging then
            WriteLog('MAIN', 'UGrid.GridCreateCopyName Grid=' + grid.Name +
              ' ACol=' + inttostr(ACol) + ' Name=' + Name + ' Text' + Text +
              'Result=true');
          exit;
        end;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.GridCreateCopyName Grid=' + grid.Name + ' ACol=' +
        inttostr(ACol) + ' Name=' + Name + ' Text' + Text + 'Result=false');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.IsPhraseInGrid | ' + E.Message);
  end;
end;

function GridCreateCopyName(grid: tstringgrid; ACol: integer;
  Name, Text: string): string;
var
  i, j: integer;
  txt: string;
begin
  try
    i := 0;
    repeat
      if i = 0 then
        txt := Text + '(Копия)'
      else
        txt := Text + '(Копия' + inttostr(i) + ')';
      i := i + 1;
    until not IsPhraseInGrid(grid, ACol, Name, txt);
    Result := txt;
    if makelogging then
      WriteLog('MAIN', 'UGrid.GridCreateCopyName Grid=' + grid.Name + ' ACol=' +
        inttostr(ACol) + ' Name=' + Name + ' Text' + 'Result=' + Result);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.GridCreateCopyName | ' + E.Message);
  end;
end;

function IsSubStrInPhraseGrid(grid: tstringgrid; StartRow, ACol: integer;
  Name, SubStr: string): integer;
var
  i, ps: integer;
  txt, sbs, txt1: string;
begin
  try
    Result := -1;
    sbs := Trim(LowerCase(SubStr));
    for i := StartRow to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        txt := (grid.Objects[0, i] as TGridRows).MyCells[ACol].ReadPhrase(Name);
        txt := Trim(AnsiLowerCase(txt));
        ps := -1;
        ps := pos(sbs, txt);
        if ps = 1 then
        begin
          Result := i;
          if makelogging then
            WriteLog('MAIN', 'UGrid.IsSubStrInPhraseGrid-1 Grid=' + grid.Name +
              ' StartRow=' + inttostr(StartRow) + ' ACol=' + inttostr(ACol) +
              ' Name=' + Name + ' SubStr=' + SubStr + ' Result=' +
              inttostr(Result));
          exit;
        end;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.IsSubStrInPhraseGrid-2 Grid=' + grid.Name +
        ' StartRow=' + inttostr(StartRow) + ' ACol=' + inttostr(ACol) + ' Name='
        + Name + ' SubStr=' + SubStr + ' Result=' + inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.IsSubStrInPhraseGrid | ' + E.Message);
  end;
end;

procedure SortGridAlphabet(grid: tstringgrid; StartRow, ACol: integer;
  Name: string; Direction: boolean);
var
  i, RowPos, CurrPos, FindPos: integer;
begin
  try
    RowPos := StartRow;
    CurrPos := StartRow;
    if Direction then
    begin
      For i := 1 to length(Alphabet) do
      begin
        while not(CurrPos > grid.RowCount) do
        begin
          FindPos := IsSubStrInPhraseGrid(grid, CurrPos, ACol, Name,
            Alphabet[i]);
          if FindPos = -1 then
            break;
          TempGridRow.Clear;
          TempGridRow.Assign((grid.Objects[0, CurrPos] as TGridRows));
          (grid.Objects[0, CurrPos] as TGridRows)
            .Assign((grid.Objects[0, FindPos] as TGridRows));
          (grid.Objects[0, FindPos] as TGridRows).Assign(TempGridRow);
          CurrPos := CurrPos + 1;
        end;
      end;
      if makelogging then
        WriteLog('MAIN', 'UGrid.SortGridAlphabet Grid=' + grid.Name +
          ' Direction=true StartRow=' + inttostr(StartRow) + ' ACol=' +
          inttostr(ACol) + ' Name=' + Name);
    end
    else
    begin
      For i := length(Alphabet) downto 1 do
      begin
        while not(CurrPos > grid.RowCount) do
        begin
          FindPos := IsSubStrInPhraseGrid(grid, CurrPos, ACol, Name,
            Alphabet[i]);
          if FindPos = -1 then
            break;
          TempGridRow.Clear;
          TempGridRow.Assign((grid.Objects[0, CurrPos] as TGridRows));
          (grid.Objects[0, CurrPos] as TGridRows)
            .Assign((grid.Objects[0, FindPos] as TGridRows));
          (grid.Objects[0, FindPos] as TGridRows).Assign(TempGridRow);
          CurrPos := CurrPos + 1;
        end;
        if makelogging then
          WriteLog('MAIN', 'UGrid.SortGridAlphabet Grid=' + grid.Name +
            ' Direction=false StartRow=' + inttostr(StartRow) + ' ACol=' +
            inttostr(ACol) + ' Name=' + Name);
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.FindMinDateInPhraseGrid | ' + E.Message);
  end;
end;

function FindMinDateInPhraseGrid(grid: tstringgrid; StartRow, ACol: integer;
  Name: string): integer;
var
  i: integer;
  txt: string;
  dt1, dt2: TDate;
begin
  try
    Result := -1;
    txt := (grid.Objects[0, StartRow] as TGridRows).MyCells[ACol]
      .ReadPhrase(Name);
    if Trim(txt) = '' then
      exit;
    dt1 := StrToDate(txt);
    for i := StartRow + 1 to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        txt := (grid.Objects[0, i] as TGridRows).MyCells[ACol].ReadPhrase(Name);
        if Trim(txt) = '' then
          continue;
        dt2 := StrToDate(txt);
        if dt2 < dt1 then
        begin
          Result := i;
          dt1 := dt2;
        end;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.FindMinDateInPhraseGrid Grid=' + grid.Name +
        ' StartRow=' + inttostr(StartRow) + ' ACol=' + inttostr(ACol) + ' Name='
        + Name + ' Result=' + inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.FindMinDateInPhraseGrid | ' + E.Message);
  end;
end;

function FindMinTimeInPhraseGrid(grid: tstringgrid; StartRow, ACol: integer;
  Name: string): integer;
var
  i: integer;
  txt: string;
  dt1, dt2: Longint;
begin
  try
    Result := -1;
    txt := (grid.Objects[0, StartRow] as TGridRows).MyCells[ACol]
      .ReadPhrase(Name);
    if Trim(txt) = '' then
      exit;
    dt1 := StrTimeCodeToFrames(txt);
    for i := StartRow + 1 to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        txt := (grid.Objects[0, i] as TGridRows).MyCells[ACol].ReadPhrase(Name);
        if Trim(txt) = '' then
          continue;
        dt2 := StrTimeCodeToFrames(txt);
        if dt2 < dt1 then
        begin
          Result := i;
          dt1 := dt2;
        end;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.FindMinDateInPhraseGrid Grid=' + grid.Name +
        ' StartRow=' + inttostr(StartRow) + ' ACol=' + inttostr(ACol) + ' Name='
        + Name + ' Result=' + inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.FindMinDateInPhraseGrid | ' + E.Message);
  end;
end;

function FindMaxDateInPhraseGrid(grid: tstringgrid; StartRow, ACol: integer;
  Name: string): integer;
var
  i: integer;
  txt: string;
  dt1, dt2: TDate;
begin
  try
    Result := -1;
    txt := (grid.Objects[0, StartRow] as TGridRows).MyCells[ACol]
      .ReadPhrase(Name);
    if Trim(txt) = '' then
      exit;
    dt1 := StrToDate(txt);
    for i := StartRow + 1 to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        txt := (grid.Objects[0, i] as TGridRows).MyCells[ACol].ReadPhrase(Name);
        if Trim(txt) = '' then
          continue;
        dt2 := StrToDate(txt);
        if dt2 > dt1 then
        begin
          Result := i;
          dt1 := dt2;
        end;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.FindMaxDateInPhraseGrid Grid=' + grid.Name +
        ' StartRow=' + inttostr(StartRow) + ' ACol=' + inttostr(ACol) + ' Name='
        + Name + ' Result=' + inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.FindMaxDateInPhraseGrid | ' + E.Message);
  end;
end;

function FindMaxTimeInPhraseGrid(grid: tstringgrid; StartRow, ACol: integer;
  Name: string): integer;
var
  i: integer;
  txt: string;
  dt1, dt2: Longint;
begin
  try
    Result := -1;
    txt := (grid.Objects[0, StartRow] as TGridRows).MyCells[ACol]
      .ReadPhrase(Name);
    if Trim(txt) = '' then
      exit;
    dt1 := StrTimeCodeToFrames(txt);
    for i := StartRow + 1 to grid.RowCount - 1 do
    begin
      if grid.Objects[0, i] is TGridRows then
      begin
        txt := (grid.Objects[0, i] as TGridRows).MyCells[ACol].ReadPhrase(Name);
        if Trim(txt) = '' then
          continue;
        dt2 := StrTimeCodeToFrames(txt);
        if dt2 > dt1 then
        begin
          Result := i;
          dt1 := dt2;
        end;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGrid.FindMaxDateInPhraseGrid Grid=' + grid.Name +
        ' StartRow=' + inttostr(StartRow) + ' ACol=' + inttostr(ACol) + ' Name='
        + Name + ' Result=' + inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.FindMaxDateInPhraseGrid | ' + E.Message);
  end;
end;

procedure SortGridDate(grid: tstringgrid; StartRow, ACol: integer; Name: string;
  Direction: boolean);
var
  i, j, RowPos, CurrPos, FindPos: integer;
begin
  try
    if Direction then
    begin
      for i := StartRow to grid.RowCount - 1 do
      begin
        FindPos := FindMaxDateInPhraseGrid(grid, i, ACol, Name);
        if FindPos = -1 then
          continue;
        if FindPos = i then
          continue;
        TempGridRow.Clear;
        TempGridRow.Assign((grid.Objects[0, i] as TGridRows));
        (grid.Objects[0, i] as TGridRows)
          .Assign((grid.Objects[0, FindPos] as TGridRows));
        (grid.Objects[0, FindPos] as TGridRows).Assign(TempGridRow);
      end;
      if makelogging then
        WriteLog('MAIN', 'UGrid.SortGridDate Grid=' + grid.Name +
          ' Direction=true StartRow=' + inttostr(StartRow) + ' ACol=' +
          inttostr(ACol) + ' Name=' + Name);
    end
    else
    begin
      for i := StartRow to grid.RowCount - 1 do
      begin
        FindPos := FindMinDateInPhraseGrid(grid, i, ACol, Name);
        if FindPos = -1 then
          continue;
        if FindPos = i then
          continue;
        TempGridRow.Clear;
        TempGridRow.Assign((grid.Objects[0, i] as TGridRows));
        (grid.Objects[0, i] as TGridRows)
          .Assign((grid.Objects[0, FindPos] as TGridRows));
        (grid.Objects[0, FindPos] as TGridRows).Assign(TempGridRow);
      end;
      if makelogging then
        WriteLog('MAIN', 'UGrid.SortGridDate Grid=' + grid.Name +
          ' Direction=false StartRow=' + inttostr(StartRow) + ' ACol=' +
          inttostr(ACol) + ' Name=' + Name);
    end;

  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.SortGridDate | ' + E.Message);
  end;
end;

procedure SortGridTime(grid: tstringgrid; StartRow, ACol: integer; Name: string;
  Direction: boolean);
var
  i, j, RowPos, CurrPos, FindPos: integer;
begin
  try
    if Direction then
    begin
      for i := StartRow to grid.RowCount - 1 do
      begin
        FindPos := FindMaxTimeInPhraseGrid(grid, i, ACol, Name);
        if FindPos = -1 then
          continue;
        if FindPos = i then
          continue;
        TempGridRow.Clear;
        TempGridRow.Assign((grid.Objects[0, i] as TGridRows));
        (grid.Objects[0, i] as TGridRows)
          .Assign((grid.Objects[0, FindPos] as TGridRows));
        (grid.Objects[0, FindPos] as TGridRows).Assign(TempGridRow);
      end;
      if makelogging then
        WriteLog('MAIN', 'UGrid.SortGridDate Grid=' + grid.Name +
          ' Direction=true StartRow=' + inttostr(StartRow) + ' ACol=' +
          inttostr(ACol) + ' Name=' + Name);
    end
    else
    begin
      for i := StartRow to grid.RowCount - 1 do
      begin
        FindPos := FindMinTimeInPhraseGrid(grid, i, ACol, Name);
        if FindPos = -1 then
          continue;
        if FindPos = i then
          continue;
        TempGridRow.Clear;
        TempGridRow.Assign((grid.Objects[0, i] as TGridRows));
        (grid.Objects[0, i] as TGridRows)
          .Assign((grid.Objects[0, FindPos] as TGridRows));
        (grid.Objects[0, FindPos] as TGridRows).Assign(TempGridRow);
      end;
      if makelogging then
        WriteLog('MAIN', 'UGrid.SortGridDate Grid=' + grid.Name +
          ' Direction=false StartRow=' + inttostr(StartRow) + ' ACol=' +
          inttostr(ACol) + ' Name=' + Name);
    end;

  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.SortGridDate | ' + E.Message);
  end;
end;

function CountGridMarkedRows(grid: tstringgrid;
  StartRow, ACol: integer): integer;
var
  i, cnt: integer;
begin
  try
    cnt := 0;
    for i := StartRow to grid.RowCount - 1 do
      if grid.Objects[0, i] is TGridRows then
        if (grid.Objects[0, i] as TGridRows).MyCells[ACol].Mark then
          cnt := cnt + 1;
    Result := cnt;
    if makelogging then
      WriteLog('MAIN', 'UGrid.CountGridMarkedRows StartRow=' +
        inttostr(StartRow) + ' ACol=' + inttostr(ACol) + ' Result=' +
        inttostr(Result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGrid.CountGridMarkedRows | ' + E.Message);
  end;
end;

Initialization

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Создаем шаблон таблицы Клипов и Активного плей-листа
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
RowGridClips := TGridRows.Create;

RowGridClips.HeightTitle := ClipsHeightTitle;
RowGridClips.HeightRow := ClipsHeightRow;

ACell := RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType := tsState;
RowGridClips.MyCells[ACell].Width := 30;
RowGridClips.MyCells[ACell].Used := true;
RowGridClips.MyCells[ACell].Mark := false;
RowGridClips.MyCells[ACell].Name := 'Lock';
RowGridClips.MyCells[ACell].TypeImage := picture;
RowGridClips.MyCells[ACell].ImageWidth := 25;
RowGridClips.MyCells[ACell].ImageHeight := 25;
RowGridClips.MyCells[ACell].ImagePosition := ppcenter;
RowGridClips.MyCells[ACell].ImageTrue := 'Lock';
RowGridClips.MyCells[ACell].ImageFalse := 'Unlock';

ACell := RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType := tsState;
RowGridClips.MyCells[ACell].Width := 30;
RowGridClips.MyCells[ACell].Used := true;
RowGridClips.MyCells[ACell].Mark := false;
RowGridClips.MyCells[ACell].Name := 'Select';
RowGridClips.MyCells[ACell].TypeImage := ellipse;
RowGridClips.MyCells[ACell].ColorFalse := clGray;
RowGridClips.MyCells[ACell].ImageWidth := 18;
RowGridClips.MyCells[ACell].ImageHeight := 18;
RowGridClips.MyCells[ACell].ImagePosition := ppcenter;
RowGridClips.MyCells[ACell].ColorTrue := clLime;

ACell := RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType := tsState;
RowGridClips.MyCells[ACell].Width := 30;
RowGridClips.MyCells[ACell].Used := true;
RowGridClips.MyCells[ACell].Mark := true;
RowGridClips.MyCells[ACell].Name := 'Play';
RowGridClips.MyCells[ACell].TypeImage := picture;
RowGridClips.MyCells[ACell].ImageWidth := 25;
RowGridClips.MyCells[ACell].ImageHeight := 25;
RowGridClips.MyCells[ACell].ImageLayout := tlCenter;
RowGridClips.MyCells[ACell].ImagePosition := ppcenter;
RowGridClips.MyCells[ACell].ImageTrue := 'Button2';
RowGridClips.MyCells[ACell].ImageFalse := 'Button2';

ACell := RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType := tsText;
RowGridClips.MyCells[ACell].Title := 'Список клипов';
RowGridClips.MyCells[ACell].Mark := true;
RowGridClips.MyCells[ACell].Width := -1;
RowGridClips.MyCells[ACell].Procents := 100;
RowGridClips.MyCells[ACell].TopPhrase := 2;
RowGridClips.MyCells[ACell].Interval := 4;

ARow := RowGridClips.MyCells[ACell].AddRow;
RowGridClips.MyCells[ACell].Rows[ARow].Top := ClipsRowsTop;
RowGridClips.MyCells[ACell].Rows[ARow].Height := ClipsRowsHeight;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'Clip', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
// RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold := true;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := false;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'File', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 25;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'DurTTL', 'Хр-ж медиа:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 55;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'Duration', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 65;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].SubFontColor := clLime;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'NTKNM', 'НТК:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 77;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'NTK', '00:00:00:00');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 85;
// RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=True;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'Comment', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 99;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

ARow := RowGridClips.MyCells[ACell].AddRow;
RowGridClips.MyCells[ACell].Rows[ARow].Top := ClipsRowsTop + ClipsRowsHeight +
  ClipsRowsInterval;
RowGridClips.MyCells[ACell].Rows[ARow].Height := ClipsRowsHeight;
APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'Song', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'Singer', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 25;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'TypeTTL', 'Время старта:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 55;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'StartTime', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 65;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, '', 'Хр-ж воспр.:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 77;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'Dur', '00:00:00:00');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 85;
// RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=True;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'ClipID', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 97;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridClips.MyCells[ACell].AddPhrase(ARow, 'MediaType', '');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 99;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Создаем шаблон списка Проекты
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RowGridProject := TGridRows.Create;

RowGridProject.HeightTitle := ProjectHeightTitle;
RowGridProject.HeightRow := ProjectHeightRow;

ACell := RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType := tsState;
RowGridProject.MyCells[ACell].Width := 30;
RowGridProject.MyCells[ACell].Used := true;
RowGridProject.MyCells[ACell].Mark := true;
RowGridProject.MyCells[ACell].Name := 'Lock';
RowGridProject.MyCells[ACell].TypeImage := picture;
RowGridProject.MyCells[ACell].ImageWidth := 25;
RowGridProject.MyCells[ACell].ImageHeight := 25;
RowGridProject.MyCells[ACell].ImagePosition := ppcenter;
RowGridProject.MyCells[ACell].ImageTrue := 'Lock';
RowGridProject.MyCells[ACell].ImageFalse := 'Unlock';

ACell := RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType := tsState;
RowGridProject.MyCells[ACell].Width := 30;
RowGridProject.MyCells[ACell].Used := true;
RowGridProject.MyCells[ACell].Mark := false;
RowGridProject.MyCells[ACell].Name := 'Select';
RowGridProject.MyCells[ACell].TypeImage := ellipse;
RowGridProject.MyCells[ACell].ColorFalse := clGray;
RowGridProject.MyCells[ACell].ImageWidth := 18;
RowGridProject.MyCells[ACell].ImageHeight := 18;
RowGridProject.MyCells[ACell].ImagePosition := ppcenter;
RowGridProject.MyCells[ACell].ColorTrue := clLime;

ACell := RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType := tsState;
RowGridProject.MyCells[ACell].Width := 30;
RowGridProject.MyCells[ACell].Used := true;
RowGridProject.MyCells[ACell].Mark := false;
RowGridProject.MyCells[ACell].Name := 'Play';
RowGridProject.MyCells[ACell].TypeImage := picture;
RowGridProject.MyCells[ACell].ImageWidth := 20;
RowGridProject.MyCells[ACell].ImageHeight := 20;
RowGridProject.MyCells[ACell].ImagePosition := ppcenter;
RowGridProject.MyCells[ACell].ImageTrue := 'OK';

ACell := RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType := tsText;
RowGridProject.MyCells[ACell].Title := 'Список проектов';
RowGridProject.MyCells[ACell].Mark := true;
RowGridProject.MyCells[ACell].Width := -1;
RowGridProject.MyCells[ACell].Procents := 100;
RowGridProject.MyCells[ACell].TopPhrase := 2;
RowGridProject.MyCells[ACell].Interval := 4;

ARow := RowGridProject.MyCells[ACell].AddRow;
RowGridProject.MyCells[ACell].Rows[ARow].Top := ProjectRowsTop;
RowGridProject.MyCells[ACell].Rows[ARow].Height := ProjectRowsHeight;

APhr := RowGridProject.MyCells[ACell].AddPhrase(ARow, 'Project', '');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize :=
  ProgrammFontSize + 2;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold := true;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := false;

APhr := RowGridProject.MyCells[ACell].AddPhrase(ARow, 'Note', '');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 45;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;

APhr := RowGridProject.MyCells[ACell].AddPhrase(ARow, 'ImDataTTL',
  'Дата регистрации:');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 58;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridProject.MyCells[ACell].AddPhrase(ARow, 'ImportDate', '');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 69;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

ARow := RowGridProject.MyCells[ACell].AddRow;
RowGridProject.MyCells[ACell].Rows[ARow].Top := ProjectRowsTop +
  ProjectRowsHeight + ProjectRowsInterval;
RowGridProject.MyCells[ACell].Rows[ARow].Height := ProjectRowsHeight;
APhr := RowGridProject.MyCells[ACell].AddPhrase(ARow, 'Comment', '');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize :=
  ProgrammFontSize - 2;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridProject.MyCells[ACell].AddPhrase(ARow, 'EndDataTTL',
  'Дата окончания:');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 58;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

APhr := RowGridProject.MyCells[ACell].AddPhrase(ARow, 'EndDate', '');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 69;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Создаем шаблон списка Плей-листов
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RowGridListPL := TGridRows.Create;

RowGridListPL.HeightTitle := PLHeightTitle;
RowGridListPL.HeightRow := PLHeightRow;

ACell := RowGridListPL.AddCells;
RowGridListPL.MyCells[ACell].CellType := tsState;
RowGridListPL.MyCells[ACell].Width := 30;
RowGridListPL.MyCells[ACell].Used := true;
RowGridListPL.MyCells[ACell].Mark := true;
RowGridListPL.MyCells[ACell].Name := 'Lock';
RowGridListPL.MyCells[ACell].TypeImage := picture;
RowGridListPL.MyCells[ACell].ImageWidth := 25;
RowGridListPL.MyCells[ACell].ImageHeight := 25;
RowGridListPL.MyCells[ACell].ImagePosition := ppcenter;
RowGridListPL.MyCells[ACell].ImageTrue := 'Lock';
RowGridListPL.MyCells[ACell].ImageFalse := 'Unlock';

ACell := RowGridListPL.AddCells;
RowGridListPL.MyCells[ACell].CellType := tsState;
RowGridListPL.MyCells[ACell].Width := 30;
RowGridListPL.MyCells[ACell].Used := true;
RowGridListPL.MyCells[ACell].Mark := false;
RowGridListPL.MyCells[ACell].Name := 'Select';
RowGridListPL.MyCells[ACell].TypeImage := ellipse;
RowGridListPL.MyCells[ACell].ColorFalse := clGray;
RowGridListPL.MyCells[ACell].ImageWidth := 18;
RowGridListPL.MyCells[ACell].ImageHeight := 18;
RowGridListPL.MyCells[ACell].ImagePosition := ppcenter;
RowGridListPL.MyCells[ACell].ColorTrue := clLime;

ACell := RowGridListPL.AddCells;
RowGridListPL.MyCells[ACell].CellType := tsState;
RowGridListPL.MyCells[ACell].Width := 30;
RowGridListPL.MyCells[ACell].Used := true;
RowGridListPL.MyCells[ACell].Mark := false;
RowGridListPL.MyCells[ACell].Name := 'Play';
RowGridListPL.MyCells[ACell].TypeImage := picture;
RowGridListPL.MyCells[ACell].ImageWidth := 20;
RowGridListPL.MyCells[ACell].ImageHeight := 20;
RowGridListPL.MyCells[ACell].ImagePosition := ppcenter;
RowGridListPL.MyCells[ACell].ImageTrue := 'OK';

ACell := RowGridListPL.AddCells;
RowGridListPL.MyCells[ACell].CellType := tsText;
RowGridListPL.MyCells[ACell].Title := 'Список плей-листов';
RowGridListPL.MyCells[ACell].Mark := true;
RowGridListPL.MyCells[ACell].Width := -1;
RowGridListPL.MyCells[ACell].Procents := 100;
RowGridListPL.MyCells[ACell].TopPhrase := 2;
RowGridListPL.MyCells[ACell].Interval := 4;

ARow := RowGridListPL.MyCells[ACell].AddRow;
RowGridListPL.MyCells[ACell].Rows[ARow].Top := PLRowsTop;
RowGridListPL.MyCells[ACell].Rows[ARow].Height := PLRowsHeight;

APhr := RowGridListPL.MyCells[ACell].AddPhrase(ARow, 'Name', '');
RowGridListPL.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
// RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridListPL.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold := true;
RowGridListPL.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := false;

APhr := RowGridListPL.MyCells[ACell].AddPhrase(ARow, 'Note', '');
RowGridListPL.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 45;
RowGridListPL.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;

ARow := RowGridListPL.MyCells[ACell].AddRow;
RowGridListPL.MyCells[ACell].Rows[ARow].Top := PLRowsTop + PLRowsHeight +
  PLRowsInterval;
RowGridListPL.MyCells[ACell].Rows[ARow].Height := PLRowsHeight;
APhr := RowGridListPL.MyCells[ACell].AddPhrase(ARow, 'Comment', '');
RowGridListPL.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
RowGridListPL.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Создаем шаблон списка Текстовых шаблонов
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TempGridRow := TGridRows.Create;

RowGridListTxt := TGridRows.Create;

RowGridListTxt.HeightTitle := ListTxtHeightTitle;
RowGridListTxt.HeightRow := ListTxtHeightRow;

ACell := RowGridListTxt.AddCells;
RowGridListTxt.MyCells[ACell].CellType := tsState;
RowGridListTxt.MyCells[ACell].Width := 30;
RowGridListTxt.MyCells[ACell].Used := true;
RowGridListTxt.MyCells[ACell].Mark := false;
RowGridListTxt.MyCells[ACell].Name := 'Select';
RowGridListTxt.MyCells[ACell].TypeImage := ellipse;
RowGridListTxt.MyCells[ACell].ColorFalse := clGray;
RowGridListTxt.MyCells[ACell].ImageWidth := 18;
RowGridListTxt.MyCells[ACell].ImageHeight := 18;
RowGridListTxt.MyCells[ACell].ImagePosition := ppcenter;
RowGridListTxt.MyCells[ACell].ColorTrue := clGreen;

ACell := RowGridListTxt.AddCells;
RowGridListTxt.MyCells[ACell].CellType := tsText;
RowGridListTxt.MyCells[ACell].Title := 'Список текстовых щаблонов';
RowGridListTxt.MyCells[ACell].Mark := true;
RowGridListTxt.MyCells[ACell].Width := -1;
RowGridListTxt.MyCells[ACell].Procents := 100;
RowGridListTxt.MyCells[ACell].TopPhrase := 2;
RowGridListTxt.MyCells[ACell].Interval := 4;

ARow := RowGridListTxt.MyCells[ACell].AddRow;
RowGridListTxt.MyCells[ACell].Rows[ARow].Top := ListTxtRowsTop;
RowGridListTxt.MyCells[ACell].Rows[ARow].Height := ListTxtRowsHeight;

APhr := RowGridListTxt.MyCells[ACell].AddPhrase(ARow, 'Template', '');
RowGridListTxt.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
// RowGridListTxt .MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridListTxt.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold := true;
RowGridListTxt.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := false;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Создаем шаблон списка Графических шаблонов
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RowGridListGR := TGridRows.Create;

RowGridListGR.HeightTitle := ListGRHeightTitle;
RowGridListGR.HeightRow := ListGRHeightRow;

ACell := RowGridListGR.AddCells;
RowGridListGR.MyCells[ACell].CellType := tsState;
RowGridListGR.MyCells[ACell].Width := 30;
RowGridListGR.MyCells[ACell].Used := true;
RowGridListGR.MyCells[ACell].Mark := false;
RowGridListGR.MyCells[ACell].Name := 'Select';
RowGridListGR.MyCells[ACell].TypeImage := ellipse;
RowGridListGR.MyCells[ACell].ColorFalse := clGray;
RowGridListGR.MyCells[ACell].ImageWidth := 18;
RowGridListGR.MyCells[ACell].ImageHeight := 18;
RowGridListGR.MyCells[ACell].ImagePosition := ppcenter;
RowGridListGR.MyCells[ACell].ColorTrue := clLime;

ACell := RowGridListGR.AddCells;
RowGridListGR.MyCells[ACell].CellType := tsImage;
RowGridListGR.MyCells[ACell].Width := RowGridListGR.HeightRow div 9 * 16;
RowGridListGR.MyCells[ACell].Used := true;
RowGridListGR.MyCells[ACell].Mark := false;
RowGridListGR.MyCells[ACell].Name := 'Picture';
RowGridListGR.MyCells[ACell].TypeImage := ellipse;
RowGridListGR.MyCells[ACell].ColorFalse := clGray;

ARow := RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top := ListGrRowsTop;
RowGridListGR.MyCells[ACell].Rows[ARow].Height := ListGrRowsHeight;
APhr := RowGridListGR.MyCells[ACell].AddPhrase(ARow, 'File', '');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;

APhr := RowGridListGR.MyCells[ACell].AddPhrase(ARow, 'Import', '');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;

ARow := RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top := ListGrRowsTop + ListGrRowsHeight
  + ListGrRowsInterval;
RowGridListGR.MyCells[ACell].Rows[ARow].Height := ListGrRowsHeight;
APhr := RowGridListGR.MyCells[ACell].AddPhrase(ARow, 'Note', 'Файл не найден');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible := false;

ACell := RowGridListGR.AddCells;
RowGridListGR.MyCells[ACell].CellType := tsText;
RowGridListGR.MyCells[ACell].Title := 'Список графических шаблонов';
RowGridListGR.MyCells[ACell].Mark := true;
RowGridListGR.MyCells[ACell].Width := -1;
RowGridListGR.MyCells[ACell].Procents := 100;
RowGridListGR.MyCells[ACell].TopPhrase := 2;
RowGridListGR.MyCells[ACell].Interval := 4;

ARow := RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top := ListGrRowsTop;
RowGridListGR.MyCells[ACell].Rows[ARow].Height := ListGrRowsHeight;

APhr := RowGridListGR.MyCells[ACell].AddPhrase(ARow, 'Template', '');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
// RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold := true;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := false;

ARow := RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top := ListGrRowsTop + ListGrRowsHeight
  + ListGrRowsInterval;
RowGridListGR.MyCells[ACell].Rows[ARow].Height := ListGrRowsHeight;

APhr := RowGridListGR.MyCells[ACell].AddPhrase(ARow, 'File', '');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent := 2;
// RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize-2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold := true;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].UsedSubFont := true;

finalization

RowGridClips.FreeInstance;
RowGridProject.FreeInstance;
RowGridListPL.FreeInstance;
RowGridListTxt.FreeInstance;
RowGridListGR.FreeInstance;
TempGridRow.FreeInstance;

end.
