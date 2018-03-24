unit UDrawTimelines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline,uwebget;

Type

  TTLZone = (znscaler, znedit, zntimelines, znreview, znnone);

  TTLButton = (btplusH, btminusH, btplusW, btminusW, btprocent, btlock,
    btstatus, bttimeline, btreview, btnone);

  TTLNResult = record
    Zone: TTLZone;
    ID: integer;
    Position: integer;
    Button: TTLButton;
  end;

  TZoneScaler = Class(TObject)
  public
    Rect: Trect;
    OffsetText: integer;
    Text: string;
    Color: tcolor;
    FontColor: tcolor;
    FontSize: integer;
    FontName: tfontname;
    FontBold: boolean;
    FontItalic: boolean;
    FontUnderline: boolean;
    plusH: Trect;
    plusHSelect: boolean;
    plusHLock: boolean;
    minusH: Trect;
    minusHSelect: boolean;
    minusHLock: boolean;
    plusW: Trect;
    plusWSelect: boolean;
    plusWLock: boolean;
    minusW: Trect;
    minusWSelect: boolean;
    minusWLock: boolean;
    procent: Trect;
    procentSelect: boolean;
    function ClickScaler(cv: tcanvas; X, Y: integer): TTLNResult;
    procedure MoveMouse(cv: tcanvas; X, Y: integer);
    procedure Draw(cv: tcanvas; height: integer);
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure ColorUpdate;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTimeLineName = Class(TObject)
  public
    Rect: Trect;
    IDTimeline: longint;
    Selection: boolean;
    Editing: boolean;
    OffsetTextX: integer;
    Color: tcolor;
    FontColor: tcolor;
    FontColorSelect: tcolor;
    FontSize: integer;
    FontName: tfontname;
    FontBold: boolean;
    FontItalic: boolean;
    FontUnderline: boolean;
    imgRect: Trect;
    BlockRect: Trect;
    StatusRect: Trect;
    procedure Draw(cv: tcanvas; Grid: tstringgrid; APos: integer);
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure ColorUpdate;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TNamesTL = Class(TObject)
  public
    Rect: Trect;
    Interval: integer;
    HeightTL: integer;
    Color: tcolor;
    FontColor: tcolor;
    FontSize: integer;
    FontName: tfontname;
    FontBold: boolean;
    FontItalic: boolean;
    FontUnderline: boolean;
    Count: integer;
    Names: array of TTimeLineName;
    Procedure MoveMouse(cv: tcanvas; Grid: tstringgrid; X, Y: integer);
    function ClickNamesTL(cv: tcanvas; X, Y: integer): TTLNResult;
    Procedure Draw(cv: tcanvas; Grid: tstringgrid; Top, height: integer);
    Function Add(Timeline: TTimelineOptions): integer;
    Procedure Clear;
    Function Init(Grid: tstringgrid; erase: boolean): integer;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure ColorUpdate;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TZoneEditTL = Class(TObject)
  public
    Rect: Trect;
    IDTimeline: integer;
    OffsetTextX: integer;
    OffsetTextY: integer;
    Color: tcolor;
    FontColor: tcolor;
    FontSize: integer;
    FontName: tfontname;
    FontBold: boolean;
    FontItalic: boolean;
    FontUnderline: boolean;
    imgRect: Trect;
    BlockRect: Trect;
    BlockSelect: boolean;
    StatusRect: Trect;
    StatusSelect: boolean;
    procedure MoveMouse(cv: tcanvas; Grid: tstringgrid; X, Y: integer);
    function ClickEditTl(cv: tcanvas; Grid: tstringgrid; X, Y: integer)
      : TTLNResult;
    Procedure AssignTL(cv: tcanvas; Grid: tstringgrid; TLN: TTimeLineName);
    function GridPosition(Grid: tstringgrid; IDTimeline: integer): integer;
    function TLPosition(NM: TNamesTL; IDTimeline: integer): integer;
    procedure Draw(cv: tcanvas; Grid: tstringgrid; Top, height: integer);
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure ColorUpdate;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TZoneReview = Class(TObject)
  public
    Rect: Trect;
    imgRect: Trect;
    Selection: boolean;
    Color: tcolor;
    FontColor: tcolor;
    FontSize: integer;
    FontName: tfontname;
    FontBold: boolean;
    FontItalic: boolean;
    FontUnderline: boolean;
    startview: integer;
    stopview: integer;
    procedure Draw(cv: tcanvas; Top, height: integer);
    procedure MouseMove(cv: tcanvas; X, Y: integer);
    function ClickViewer(cv: tcanvas; X, Y: integer): TTLNResult;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure ColorUpdate;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLHeights = Class(TObject)
  public
    MaxHeight: integer;
    MinHeightTL: integer;
    Step: integer;
    Scaler: integer;
    IntervalEdit: integer;
    Edit: integer;
    IntervalTL: integer;
    Timelines: integer;
    Review: integer;
    HeightTL: integer;
    Interval: integer;
    function StepPlus: boolean;
    function StepMinus: boolean;
    function height: integer;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLNames = Class(TObject)
  public
    BackGround: tcolor;
    Color: tcolor;
    Scaler: TZoneScaler;
    Edit: TZoneEditTL;
    NamesTL: TNamesTL;
    Review: TZoneReview;
    // Procedure Update;
    Procedure Draw(cv: tcanvas; Grid: tstringgrid; updtl: boolean);
    function ClickTTLNames(cv: tcanvas; Grid: tstringgrid; X, Y: integer)
      : TTLNResult;
    Procedure MoveMouse(cv: tcanvas; Grid: tstringgrid; X, Y: integer);
    procedure SetDefaultFonts;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure ColorUpdate;
    Constructor Create;
    Destructor Destroy; override;
  end;

Var
  HScale, HEditTL, HTimelines, HView, HDelt: integer;
  ZoneNames: TTLNames;
  // ZoneTimelines : array[0..18] of trect;
  CountTL: integer;
  Scal: TZoneScaler;
  EditTL: TZoneEditTL;
  NamesTL: TNamesTL;
  TLHeights: TTLHeights;

  ZoneReview: TZoneReview;
  ZoneNamesLeft, ZoneNamesRight: integer;
  TLBitmap: integer;

implementation

uses umain, uinitforms, ucommon, uimgbuttons, ugrtimelines, uplayer, umyfiles,
  usetprocent;

// Класс TTLNames отвечает за работу с зоной имен тайм-линий

Constructor TTLNames.Create;
begin
  inherited;
  BackGround := TLBackGround;
  Color := TLZoneNamesColor;
  Scaler := TZoneScaler.Create;
  Edit := TZoneEditTL.Create;
  NamesTL := TNamesTL.Create;
  Review := TZoneReview.Create;
end;

procedure TTLNames.ColorUpdate;
begin
  BackGround := TLBackGround;
  Color := TLZoneNamesColor;
  Scaler.ColorUpdate;
  Edit.ColorUpdate;
  NamesTL.ColorUpdate;
  Review.ColorUpdate;
end;

Destructor TTLNames.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@Color);
  Scaler.Free;
  Edit.Free;
  NamesTL.Free;
  Review.Free;
  inherited;
end;

Procedure TTLNames.Draw(cv: tcanvas; Grid: tstringgrid; updtl: boolean);
var
  tp: integer;
begin
  try
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.Draw Start');
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := BackGround;
    cv.FillRect(cv.ClipRect);

    NamesTL.HeightTL := TLHeights.HeightTL;
    NamesTL.Interval := TLHeights.Interval;

    Scaler.Draw(cv, TLHeights.Scaler);
    tp := TLHeights.Scaler + TLHeights.IntervalEdit;
    ZoneNames.Edit.Draw(cv, Grid, tp, TLHeights.Edit);

    tp := tp + TLHeights.Edit + TLHeights.IntervalTL;
    ZoneNames.NamesTL.Init(Grid, updtl);
    ZoneNames.NamesTL.Draw(cv, Grid, tp, TLHeights.Timelines);

    tp := tp + TLHeights.Timelines + 2 * TLHeights.Interval;
    ZoneNames.Review.Draw(cv, tp, TLHeights.Review);
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.Draw Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.Draw | ' + E.Message);
  end;
end;

procedure TTLNames.SetDefaultFonts;
var
  i: integer;
begin
  Scaler.FontColor := TLZoneNamesFontColor;
  Scaler.FontSize := TLZoneNamesFontSize;
  Scaler.FontName := TLZoneNamesFontName;
  Scaler.FontBold := TLZoneNamesFontBold;
  Scaler.FontItalic := TLZoneNamesFontItalic;
  Scaler.FontUnderline := TLZoneNamesFontUnderline;

  Edit.FontColor := TLZoneNamesFontColor;
  Edit.FontSize := TLZoneNamesFontSize;
  Edit.FontName := TLZoneNamesFontName;
  Edit.FontBold := TLZoneNamesFontBold;
  Edit.FontItalic := TLZoneNamesFontItalic;
  Edit.FontUnderline := TLZoneNamesFontUnderline;

  NamesTL.FontColor := TLZoneNamesFontColor;
  NamesTL.FontSize := TLZoneNamesFontSize;
  NamesTL.FontName := TLZoneNamesFontName;
  NamesTL.FontBold := TLZoneNamesFontBold;
  NamesTL.FontItalic := TLZoneNamesFontItalic;
  NamesTL.FontUnderline := TLZoneNamesFontUnderline;

  for i := 0 to NamesTL.Count - 1 do
  begin
    NamesTL.Names[i].FontColor := TLZoneNamesFontColor;
    NamesTL.Names[i].FontSize := TLZoneNamesFontSize;
    NamesTL.Names[i].FontName := TLZoneNamesFontName;
    NamesTL.Names[i].FontBold := TLZoneNamesFontBold;
    NamesTL.Names[i].FontItalic := TLZoneNamesFontItalic;
    NamesTL.Names[i].FontUnderline := TLZoneNamesFontUnderline;
  end;

  Review.FontColor := TLZoneNamesFontColor;
  Review.FontSize := TLZoneNamesFontSize;
  Review.FontName := TLZoneNamesFontName;
  Review.FontBold := TLZoneNamesFontBold;
  Review.FontItalic := TLZoneNamesFontItalic;
  Review.FontUnderline := TLZoneNamesFontUnderline;
  if MakeLogging then
    WriteLog('MAIN', 'UDrawTimelines.TTLNames.SetDefaultFonts;');
end;

Procedure TTLNames.MoveMouse(cv: tcanvas; Grid: tstringgrid; X, Y: integer);
begin
  Scaler.MoveMouse(cv, X, Y);
  // Application.ProcessMessages;
  Edit.MoveMouse(cv, Grid, X, Y);
  // Application.ProcessMessages;
  NamesTL.MoveMouse(cv, Grid, X, Y);
  // Application.ProcessMessages;
  Review.MouseMove(cv, X, Y);
end;

function TTLNames.ClickTTLNames(cv: tcanvas; Grid: tstringgrid; X, Y: integer)
  : TTLNResult;
var
  i, res, APos, GPos, MyY: integer;
begin
  try
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.ClickTTLNames Start Grid=' +
        Grid.Name);
    Result := Scaler.ClickScaler(cv, X, Y);
    if Result.Button <> btnone then
    begin
      case Result.Button of
        btplusH:
          TLHeights.StepPlus;
        btminusH:
          TLHeights.StepMinus;
        btplusW:
          TLZone.PlusHoriz;
        btminusW:
          TLZone.MinusHoriz;
        btprocent:
          if vlcmode <> play then
          begin
            MyY := form1.panel4.Top + form1.PanelControl.height +
              (form1.Width - form1.ClientWidth);
            SetProcent(Scaler.procent.Left, MyY + Scaler.procent.Bottom, 0);
          end;
      end;
      // TLZone.DrawBitmap(bmptimeline);
      PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
      TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
      TLZone.DrawBitmap(bmptimeline);
      // Form1.imgTimelines.Canvas.Lock;
      form1.imgTimelines.Canvas.FillRect(form1.imgTimelines.Canvas.ClipRect);
      TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
      InvalidateRect(form1.imgTimelines.Canvas.Handle, NIL, FALSE);
      // Form1.imgTimelines.Canvas.UnLock;
      TLZone.DrawLayer2(form1.imgLayer2.Canvas);
      exit;
    end;
    Result := Edit.ClickEditTl(cv, Grid, X, Y);
    if Result.Button <> btnone then
    begin
      APos := Edit.TLPosition(NamesTL, Result.ID);
      if APos = -1 then
        exit;
      NamesTL.Names[APos].Draw(cv, Grid, APos);
      CurrentImageTemplate := '@#@' + inttostr(APos);
      exit;
    end;
    Result := NamesTL.ClickNamesTL(cv, X, Y);
    if Result.Position >= 0 then
    begin
      for i := 0 to NamesTL.Count - 1 do
        NamesTL.Names[i].Editing := FALSE;
      Edit.AssignTL(cv, Grid, NamesTL.Names[Result.Position]);
      // TLZone.DrawBitmap(bmptimeline);
      TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
      NamesTL.Names[Result.Position].Editing := true;
      if vlcmode <> play then
        TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
      exit;
    end;
    Result := Review.ClickViewer(cv, X, Y);
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.ClickTTLNames Finish Position='
        + inttostr(Result.Position) + ' IDTimeline=' + inttostr(Result.ID));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.ClickTTLNames | ' + E.Message);
  end;
end;

Procedure TTLNames.WriteToStream(F: tStream);
begin
  try
    F.WriteBuffer(BackGround, SizeOf(BackGround));
    F.WriteBuffer(Color, SizeOf(Color));
    Scaler.WriteToStream(F);
    Edit.WriteToStream(F);
    NamesTL.WriteToStream(F);
    Review.WriteToStream(F);
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.WriteToStream | ' + E.Message);
  end;
end;

Procedure TTLNames.ReadFromStream(F: tStream);
begin
  try
    F.ReadBuffer(BackGround, SizeOf(BackGround));
    F.ReadBuffer(Color, SizeOf(Color));
    Scaler.ReadFromStream(F);
    Edit.ReadFromStream(F);
    NamesTL.ReadFromStream(F);
    Review.ReadFromStream(F);
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLNames.ReadFromStream | ' + E.Message);
  end;
end;

// Класс TTLHeights отвечает за высоты элементов зоны тайм-линий

Constructor TTLHeights.Create;
begin
  inherited;
  MinHeightTL := 25;
  Step := 2;
  Scaler := MinHeightTL;
  IntervalEdit := 20;
  HeightTL := MinHeightTL + 10;
  Edit := HeightTL * 3;
  Review := HeightTL + 10;
  Interval := trunc(HeightTL / 10);
  IF Interval < 4 then
    Interval := 4;
  IntervalTL := 3 * Interval;
  Timelines := (HeightTL + Interval) * 3 - Interval;
  MaxHeight := 22 * MinHeightTL + 16 * Interval + IntervalEdit + IntervalTL;
end;

Destructor TTLHeights.Destroy;
begin
  FreeMem(@MaxHeight);
  FreeMem(@MinHeightTL);
  FreeMem(@Step);
  FreeMem(@IntervalEdit);
  FreeMem(@IntervalTL);
  FreeMem(@Scaler);
  FreeMem(@Edit);
  FreeMem(@Timelines);
  FreeMem(@Review);
  FreeMem(@HeightTL);
  FreeMem(@Interval);
  inherited Destroy;
end;

function TTLHeights.height: integer;
begin
  Timelines := (HeightTL + Interval) * (form1.GridTimeLines.RowCount - 1)
    - Interval;
  Result := Scaler + IntervalEdit + Edit + IntervalTL + Timelines + 2 *
    Interval + Review;
  // if makelogging then WriteLog('MAIN', 'UDrawTimelines.TTLHeights.Height Height=' + inttostr(Result));
end;

function TTLHeights.StepPlus: boolean;
var
  ed, tl, intrv, rv, htl, hght: integer;
begin
  try
    Result := FALSE;
    HeightTL := HeightTL + Step;
    Edit := 3 * HeightTL;
    intrv := trunc(HeightTL / 10);
    if intrv < 4 then
      intrv := 4;
    rv := HeightTL + 10;
    hght := Scaler + IntervalEdit + ed + IntervalTL + (htl + intrv) *
      (form1.GridTimeLines.RowCount - 1) + 2 * intrv + rv;
    if hght <= MaxHeight then
    begin
      Edit := Edit + Step;
      Review := HeightTL + 10;;
      HeightTL := HeightTL + Step;
      Interval := intrv;
      Timelines := (HeightTL + Interval) * (form1.GridTimeLines.RowCount - 1)
        - Interval;
      Result := true;
    end;
    UpdatePanelPrepare;
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TTLHeights.StepPlus Timelines=' +
        inttostr(Timelines) + ' Interval=' + inttostr(Interval));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLHeights.StepPlus | ' + E.Message);
  end;
end;

function TTLHeights.StepMinus: boolean;
var
  ed, tl, intrv, rv, htl, hght: integer;
begin
  try
    Result := true;
    if HeightTL - Step < MinHeightTL then
    begin
      HeightTL := MinHeightTL;
      Interval := trunc(HeightTL / 10);
      If Interval < 4 then
        Interval := 4;
      Edit := 3 * HeightTL;
      Review := HeightTL + 10;
      Timelines := (HeightTL + Interval) * (form1.GridTimeLines.RowCount - 1)
        - Interval;
      Result := FALSE;
      if MakeLogging then
        WriteLog('MAIN', 'UDrawTimelines.TTLHeights.StepMinus-1 Timelines=' +
          inttostr(Timelines) + ' Interval=' + inttostr(Interval));
      exit;
    end;
    HeightTL := HeightTL - Step;
    Edit := 3 * HeightTL;
    Interval := trunc(HeightTL / 10);
    If Interval < 4 then
      Interval := 4;
    Review := HeightTL + 10;
    Timelines := (HeightTL + Interval) * (form1.GridTimeLines.RowCount - 1)
      - Interval;
    UpdatePanelPrepare;
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TTLHeights.StepMinus-2 Timelines=' +
        inttostr(Timelines) + ' Interval=' + inttostr(Interval));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLHeights.StepMinus | ' + E.Message);
  end;
end;

Procedure TTLHeights.WriteToStream(F: tStream);
begin
  try
    F.WriteBuffer(MaxHeight, SizeOf(MaxHeight));
    F.WriteBuffer(MinHeightTL, SizeOf(MinHeightTL));
    F.WriteBuffer(Step, SizeOf(Step));
    F.WriteBuffer(Scaler, SizeOf(Scaler));
    F.WriteBuffer(IntervalEdit, SizeOf(IntervalEdit));
    F.WriteBuffer(Edit, SizeOf(Edit));
    F.WriteBuffer(IntervalTL, SizeOf(IntervalTL));
    F.WriteBuffer(Timelines, SizeOf(Timelines));
    F.WriteBuffer(Review, SizeOf(Review));
    F.WriteBuffer(HeightTL, SizeOf(HeightTL));
    F.WriteBuffer(Interval, SizeOf(Interval));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLHeights.WriteToStream | ' +
        E.Message);
  end;
end;

Procedure TTLHeights.ReadFromStream(F: tStream);
begin
  try
    F.ReadBuffer(MaxHeight, SizeOf(MaxHeight));
    F.ReadBuffer(MinHeightTL, SizeOf(MinHeightTL));
    F.ReadBuffer(Step, SizeOf(Step));
    F.ReadBuffer(Scaler, SizeOf(Scaler));
    F.ReadBuffer(IntervalEdit, SizeOf(IntervalEdit));
    F.ReadBuffer(Edit, SizeOf(Edit));
    F.ReadBuffer(IntervalTL, SizeOf(IntervalTL));
    F.ReadBuffer(Timelines, SizeOf(Timelines));
    F.ReadBuffer(Review, SizeOf(Review));
    F.ReadBuffer(HeightTL, SizeOf(HeightTL));
    F.ReadBuffer(Interval, SizeOf(Interval));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTLHeights.ReadFromStream | ' +
        E.Message);
  end;
end;

// Класс TZoneReview - отвечает за область отображения всех тайм линий;

Constructor TZoneReview.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 60;
  imgRect.Left := 0;
  imgRect.Right := 0;
  imgRect.Top := 0;
  imgRect.Bottom := 60;
  Selection := FALSE;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
  startview := 0;
  stopview := 0;
end;

procedure TZoneReview.ColorUpdate;
begin
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
end;

Destructor TZoneReview.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@imgRect);
  FreeMem(@Selection);
  FreeMem(@startview);
  FreeMem(@stopview);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  inherited Destroy;
end;

procedure TZoneReview.Draw(cv: tcanvas; Top, height: integer);
var
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TZoneReview.Draw Top=' + inttostr(Top) +
        ' Height=' + inttostr(height));
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    cv.Pen.Color := FontColor;
    cv.Font.Size := FontSize - 1;
    cv.Font.Color := FontColor;
    cv.Font.Name := FontName;
    if FontBold then
      cv.Font.Style := cv.Font.Style + [fsBold]
    else
      cv.Font.Style := cv.Font.Style - [fsBold];
    if FontItalic then
      cv.Font.Style := cv.Font.Style + [fsItalic]
    else
      cv.Font.Style := cv.Font.Style - [fsItalic];
    if FontBold then
      cv.Font.Style := cv.Font.Style + [fsUnderline]
    else
      cv.Font.Style := cv.Font.Style - [fsUnderline];
    cv.Pen.Color := FontColor;
    Rect.Left := cv.ClipRect.Left;
    Rect.Right := cv.ClipRect.Right;
    Rect.Top := Top;
    Rect.Bottom := Top + height;
    cv.Brush.Color := Color;
    cv.FillRect(Rect);
    imgRect.Left := cv.ClipRect.Left + 10;
    imgRect.Right := imgRect.Left + 30;
    imgRect.Top := Top + (height - 25) div 2;
    imgRect.Bottom := imgRect.Top + 25;
    if Selection then
      cv.Brush.Color := Color
    else
      cv.Brush.Color := SmoothColor(Color, 32);
    cv.FillRect(imgRect);

    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneReview.Draw | ' + E.Message);
  end;
end;

function TZoneReview.ClickViewer(cv: tcanvas; X, Y: integer): TTLNResult;
begin
  try
    Result.Zone := znreview;
    Result.ID := -1;
    Result.Position := -1;
    Result.Button := btnone;
    if (X > imgRect.Left) and (X < imgRect.Right) and (Y > imgRect.Top) and
      (Y < imgRect.Bottom) then
    begin
      Result.Button := btreview;
      WriteLog('MAIN',
        'UDrawTimelines.TZoneReview.ClickViewer Button:=btreview');
    end
    else
      WriteLog('MAIN',
        'UDrawTimelines.TZoneReview.ClickViewer Button:=btnone');;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneReview.ClickViewer | ' + E.Message);
  end;
end;

procedure TZoneReview.MouseMove(cv: tcanvas; X, Y: integer);
begin
  if (X > imgRect.Left) and (X < imgRect.Right) and (Y > imgRect.Top) and
    (Y < imgRect.Bottom) then
    Selection := true
  else
    Selection := FALSE;
  Draw(cv, Rect.Top, Rect.Bottom - Rect.Top);
end;

Procedure TZoneReview.WriteToStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
    F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
    F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

    F.WriteBuffer(imgRect.Top, SizeOf(imgRect.Top));
    F.WriteBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
    F.WriteBuffer(imgRect.Left, SizeOf(imgRect.Left));
    F.WriteBuffer(imgRect.Right, SizeOf(imgRect.Right));

    F.WriteBuffer(Selection, SizeOf(Selection));

    F.WriteBuffer(Color, SizeOf(Color));
    F.WriteBuffer(FontColor, SizeOf(FontColor));
    F.WriteBuffer(FontSize, SizeOf(FontSize));
    WriteBufferStr(F, FontName);

    F.WriteBuffer(FontBold, SizeOf(FontBold));
    F.WriteBuffer(FontItalic, SizeOf(FontItalic));
    F.WriteBuffer(FontUnderline, SizeOf(FontUnderline));

    F.WriteBuffer(startview, SizeOf(startview));
    F.WriteBuffer(stopview, SizeOf(stopview));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneReview.WriteToStream | ' +
        E.Message);
  end;
end;

Procedure TZoneReview.ReadFromStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
    F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
    F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

    F.ReadBuffer(imgRect.Top, SizeOf(imgRect.Top));
    F.ReadBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
    F.ReadBuffer(imgRect.Left, SizeOf(imgRect.Left));
    F.ReadBuffer(imgRect.Right, SizeOf(imgRect.Right));

    F.ReadBuffer(Selection, SizeOf(Selection));

    F.ReadBuffer(Color, SizeOf(Color));
    F.ReadBuffer(FontColor, SizeOf(FontColor));
    F.ReadBuffer(FontSize, SizeOf(FontSize));
    ReadBufferStr(F, FontName);

    F.ReadBuffer(FontBold, SizeOf(FontBold));
    F.ReadBuffer(FontItalic, SizeOf(FontItalic));
    F.ReadBuffer(FontUnderline, SizeOf(FontUnderline));

    F.ReadBuffer(startview, SizeOf(startview));
    F.ReadBuffer(stopview, SizeOf(stopview));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneReview.ReadFromStream | ' +
        E.Message);
  end;
end;

// ================= TNamesTL ======================

Constructor TNamesTL.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 60;
  Interval := 3;
  HeightTL := 25;
  Count := 0;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
end;

procedure TNamesTL.ColorUpdate;
var
  i: integer;
begin
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
  for i := 0 to Count - 1 do
    Names[i].ColorUpdate;
end;

Destructor TNamesTL.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@Interval);
  FreeMem(@HeightTL);
  FreeMem(@Count);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@Names);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  inherited Destroy;
end;

function TNamesTL.Add(Timeline: TTimelineOptions): integer;
begin
  Count := Count + 1;
  setlength(Names, Count);
  Names[Count - 1] := TTimeLineName.Create;
  Names[Count - 1].Rect.Left := Rect.Left;
  Names[Count - 1].Rect.Right := Rect.Right;
  Names[Count - 1].Rect.Top := Rect.Top + (HeightTL + Interval) * (Count - 1);
  Names[Count - 1].Rect.Bottom := Names[Count - 1].Rect.Top + HeightTL;
  Names[Count - 1].IDTimeline := Timeline.IDTimeline;
  Names[Count - 1].Selection := FALSE;
  Names[Count - 1].OffsetTextX := 20;
  Names[Count - 1].Color := Color;
  Names[Count - 1].FontColor := FontColor;
  Names[Count - 1].FontSize := FontSize;
  Names[Count - 1].FontName := FontName;
  Names[Count - 1].FontBold := FontBold;
  Names[Count - 1].FontItalic := FontItalic;
  Names[Count - 1].FontUnderline := FontUnderline;
  Result := Count - 1;
  if MakeLogging then
    WriteLog('MAIN', 'UDrawTimelines.TNamesTL.Add Result=' + inttostr(Result) +
      ' IDTimeline=' + inttostr(Timeline.IDTimeline));
end;

procedure TNamesTL.Clear;
var
  i: integer;
begin
  if Count <= 0 then
    exit;
  for i := Count - 1 downto 0 do
    Names[i].FreeInstance;
  setlength(Names, 0);
  Count := 0;
  if MakeLogging then
    WriteLog('MAIN', 'UDrawTimelines.TNamesTL.Clear');
end;

function TNamesTL.Init(Grid: tstringgrid; erase: boolean): integer;
var
  i, APos, hght: integer;
begin
  Result := 0;
  Clear;
  For i := 1 to Grid.RowCount - 1 do
  begin
    if Grid.Objects[0, i] is TTimelineOptions then
      APos := Add(Grid.Objects[0, i] as TTimelineOptions);

    Result := Result + HeightTL + Interval;
  end;
  Result := Result - Interval;
  if MakeLogging then
    WriteLog('MAIN', 'UDrawTimelines.TNamesTL.Init Result=' + inttostr(Result));
end;

procedure TNamesTL.Draw(cv: tcanvas; Grid: tstringgrid; Top, height: integer);
var
  i, tp: integer;
begin
  try
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TNamesTL.Draw Grid=' + Grid.Name +
        ' Top=' + inttostr(Top) + ' Height=' + inttostr(height));
    tp := Top;
    Rect.Left := cv.ClipRect.Left;
    Rect.Right := cv.ClipRect.Right;
    Rect.Top := Top;
    Rect.Bottom := Top + height;
    for i := 0 to Count - 1 do
    begin
      Names[i].Rect.Left := Rect.Left;
      Names[i].Rect.Right := Rect.Right;
      Names[i].Rect.Top := tp;
      Names[i].Rect.Bottom := Names[i].Rect.Top + HeightTL;
      Names[i].Draw(cv, Grid, i);
      tp := Names[i].Rect.Bottom + Interval;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TNamesTL.Draw | ' + E.Message);
  end;
end;

function TNamesTL.ClickNamesTL(cv: tcanvas; X, Y: integer): TTLNResult;
var
  i, j: integer;
begin
  try
    Result.Zone := zntimelines;
    Result.ID := -1;
    Result.Position := -1;
    Result.Button := btnone;
    for i := 0 to Count - 1 do
    begin
      if (X > Names[i].Rect.Left + 10) and (X < Names[i].Rect.Right - 10) and
        (Y + 2 > Names[i].Rect.Top) and (Y - 2 < Names[i].Rect.Bottom) then
      begin
        Result.ID := Names[i].IDTimeline;
        Result.Position := i;
        Result.Button := bttimeline;
        for j := 0 to Count - 1 do
          Names[j].Editing := FALSE;
        Names[i].Editing := true;
      end;
    end;
    // Draw(cv,Rect.Top,Rect.Bottom-Rect.Top);
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TNamesTL.ClickNamesTL Position=' +
        inttostr(Result.Position) + 'IDTimeline=' + inttostr(Result.ID));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TNamesTL.ClickNamesTL | ' + E.Message);
  end;
end;

Procedure TNamesTL.MoveMouse(cv: tcanvas; Grid: tstringgrid; X, Y: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if (X > Names[i].Rect.Left + 10) and (X < Names[i].Rect.Right - 10) and
      (Y + 2 > Names[i].Rect.Top) and (Y - 2 < Names[i].Rect.Bottom) then
      Names[i].Selection := true
    else
      Names[i].Selection := FALSE;
  end;
  Draw(cv, Grid, Rect.Top, Rect.Bottom - Rect.Top);
end;

Procedure TNamesTL.WriteToStream(F: tStream);
var
  i: integer;
  fsbl: boolean;
begin
  try
    F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
    F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
    F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

    F.WriteBuffer(Interval, SizeOf(Interval));
    F.WriteBuffer(HeightTL, SizeOf(HeightTL));

    F.WriteBuffer(Color, SizeOf(Color));
    F.WriteBuffer(FontColor, SizeOf(FontColor));
    F.WriteBuffer(FontSize, SizeOf(FontSize));
    WriteBufferStr(F, FontName);

    F.WriteBuffer(FontBold, SizeOf(FontBold));
    F.WriteBuffer(FontItalic, SizeOf(FontItalic));
    F.WriteBuffer(FontUnderline, SizeOf(FontUnderline));

    F.WriteBuffer(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
      Names[i].WriteToStream(F);
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TNamesTL.WriteToStream | ' + E.Message);
  end;
end;

Procedure TNamesTL.ReadFromStream(F: tStream);
var
  i: integer;
  fsbl: boolean;
begin
  try
    F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
    F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
    F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

    F.ReadBuffer(Interval, SizeOf(Interval));
    F.ReadBuffer(HeightTL, SizeOf(HeightTL));

    F.ReadBuffer(Color, SizeOf(Color));
    F.ReadBuffer(FontColor, SizeOf(FontColor));
    F.ReadBuffer(FontSize, SizeOf(FontSize));
    ReadBufferStr(F, FontName);

    F.ReadBuffer(FontBold, SizeOf(FontBold));
    F.ReadBuffer(FontItalic, SizeOf(FontItalic));
    F.ReadBuffer(FontUnderline, SizeOf(FontUnderline));

    Clear;
    F.ReadBuffer(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
    begin
      setlength(Names, i + 1);
      Names[i] := TTimeLineName.Create;
      Names[i].ReadFromStream(F);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TNamesTL.ReadFromStream | ' + E.Message);
  end;
end;

// ========= Класс одного поля тайм-лайна TTimeLineName

Constructor TTimeLineName.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  IDTimeline := 0;
  Selection := FALSE;
  Editing := FALSE;
  OffsetTextX := 20;
  Color := clGray;
  FontColor := TLZoneNamesFontColor;
  FontColorSelect := TLZoneFontColorSelect;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
  imgRect.Left := 0;
  imgRect.Right := 0;
  imgRect.Top := 0;
  imgRect.Bottom := 0;
  BlockRect.Left := 0;
  BlockRect.Right := 0;
  BlockRect.Top := 0;
  BlockRect.Bottom := 0;
  StatusRect.Left := 0;
  StatusRect.Right := 0;
  StatusRect.Top := 0;
  StatusRect.Bottom := 0;
end;

procedure TTimeLineName.ColorUpdate;
begin
  FontColor := TLZoneNamesFontColor;
  FontColorSelect := TLZoneFontColorSelect;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
end;

Destructor TTimeLineName.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@IDTimeline);
  FreeMem(@Selection);
  FreeMem(@Editing);
  FreeMem(@OffsetTextX);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontColorSelect);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  FreeMem(@imgRect);
  FreeMem(@BlockRect);
  FreeMem(@StatusRect);
  inherited Destroy;
end;

procedure TTimeLineName.Draw(cv: tcanvas; Grid: tstringgrid; APos: integer);
var
  Text: string;
  hgh: integer;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TTimeLineName.Draw Position=' +
        inttostr(APos));
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    cv.Pen.Color := FontColor;
    cv.Font.Size := FontSize - 1;

    if Selection then
      cv.Font.Color := FontColorSelect
    else if IDTimeline = ZoneNames.Edit.IDTimeline then
      cv.Font.Color := FontColor
    else
      cv.Font.Color := SmoothColor(FontColor, 32);
    cv.Font.Name := FontName;
    if FontBold then
      cv.Font.Style := cv.Font.Style + [fsBold]
    else
      cv.Font.Style := cv.Font.Style - [fsBold];
    if FontItalic then
      cv.Font.Style := cv.Font.Style + [fsItalic]
    else
      cv.Font.Style := cv.Font.Style - [fsItalic];
    if FontUnderline then
      cv.Font.Style := cv.Font.Style + [fsUnderline]
    else
      cv.Font.Style := cv.Font.Style - [fsUnderline];

    cv.Pen.Color := FontColor;

    // if Selection
    // then cv.Brush.Color:=SmoothColor(Color,16)
    // else
    if IDTimeline = ZoneNames.Edit.IDTimeline then
      cv.Brush.Color := Color
    else
      cv.Brush.Color := SmoothColor(Color, 48);

    cv.FillRect(Rect);
    cv.Brush.Style := bsClear;

    if (Grid.Objects[0, APos + 1] is TTimelineOptions) then
    begin

      imgRect.Left := Rect.Left + 1;
      imgRect.Right := imgRect.Left + 21;
      imgRect.Top := Rect.Top + (Rect.Bottom - Rect.Top - 20) div 2;
      imgRect.Bottom := imgRect.Top + 20;
      with (Grid.Objects[0, APos + 1] as TTimelineOptions) do
      begin
        Case TypeTL of
          tldevice:
            Text := 'Tools';
          tltext:
            Text := 'Text';
          tlmedia:
            Text := 'Media';
        end;
        LoadBMPFromRes(cv, imgRect, 20, 20, Text + inttostr(NumberBmp));
        hgh := (Rect.Bottom - Rect.Top - cv.TextHeight('Name')) div 2;
        cv.TextOut(imgRect.Right + 10, Rect.Top + hgh, Name);
      end;

      StatusRect.Left := Rect.Right - 22;
      StatusRect.Right := Rect.Right - 8;
      StatusRect.Top := Rect.Top + (Rect.Bottom - Rect.Top - 16) div 2;
      StatusRect.Bottom := StatusRect.Top + 16;
      cv.Pen.Color := FontColor;

      // cv.Brush.Color:= StatusColor[(Grid.Objects[0,APos+1] as TTimelineOptions).Status];
      if TLZone.Count > APos then
        cv.Brush.Color := StatusColor[TLZone.Timelines[APos].Status]
      else
        cv.Brush.Color := StatusColor[4];
      cv.Pen.Color := FontColor;
      cv.Ellipse(StatusRect);

      BlockRect.Right := StatusRect.Left - 10;
      BlockRect.Left := BlockRect.Right - 18;
      BlockRect.Top := Rect.Top + (Rect.Bottom - Rect.Top - 18) div 2;
      BlockRect.Bottom := BlockRect.Top + 18;
      if TLZone.Count > APos then
      begin
        if TLZone.Timelines[APos].Block
        // (Grid.Objects[0,APos+1] as TTimelineOptions).Block
        then
          LoadBMPFromRes(cv, BlockRect, 20, 20, 'Lock')
        else
          LoadBMPFromRes(cv, BlockRect, 20, 20, 'Unlock');
      end
      else
        LoadBMPFromRes(cv, BlockRect, 20, 20, 'Unlock');
    end;

    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTimeLineName.Draw| ' + E.Message);
  end;
end;

Procedure TTimeLineName.WriteToStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
    F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
    F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

    F.WriteBuffer(IDTimeline, SizeOf(IDTimeline));
    F.WriteBuffer(Selection, SizeOf(Selection));
    F.WriteBuffer(Editing, SizeOf(Editing));
    F.WriteBuffer(OffsetTextX, SizeOf(OffsetTextX));
    F.WriteBuffer(Color, SizeOf(Color));
    F.WriteBuffer(FontColor, SizeOf(FontColor));
    F.WriteBuffer(FontSize, SizeOf(FontSize));
    WriteBufferStr(F, FontName);

    F.WriteBuffer(FontBold, SizeOf(FontBold));
    F.WriteBuffer(FontItalic, SizeOf(FontItalic));
    F.WriteBuffer(FontUnderline, SizeOf(FontUnderline));

    F.WriteBuffer(imgRect.Top, SizeOf(imgRect.Top));
    F.WriteBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
    F.WriteBuffer(imgRect.Left, SizeOf(imgRect.Left));
    F.WriteBuffer(imgRect.Right, SizeOf(imgRect.Right));

    F.WriteBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
    F.WriteBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
    F.WriteBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
    F.WriteBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

    F.WriteBuffer(StatusRect.Top, SizeOf(integer));
    F.WriteBuffer(StatusRect.Bottom, SizeOf(integer));
    F.WriteBuffer(StatusRect.Left, SizeOf(integer));
    F.WriteBuffer(StatusRect.Right, SizeOf(integer));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTimeLineName.WriteToStream| ' +
        E.Message);
  end;
end;

Procedure TTimeLineName.ReadFromStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
    F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
    F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

    F.ReadBuffer(IDTimeline, SizeOf(IDTimeline));
    F.ReadBuffer(Selection, SizeOf(Selection));
    F.ReadBuffer(Editing, SizeOf(Editing));
    F.ReadBuffer(OffsetTextX, SizeOf(OffsetTextX));
    F.ReadBuffer(Color, SizeOf(Color));
    F.ReadBuffer(FontColor, SizeOf(FontColor));
    F.ReadBuffer(FontSize, SizeOf(FontSize));
    ReadBufferStr(F, FontName);

    F.ReadBuffer(FontBold, SizeOf(FontBold));
    F.ReadBuffer(FontItalic, SizeOf(FontItalic));
    F.ReadBuffer(FontUnderline, SizeOf(FontUnderline));

    F.ReadBuffer(imgRect.Top, SizeOf(imgRect.Top));
    F.ReadBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
    F.ReadBuffer(imgRect.Left, SizeOf(imgRect.Left));
    F.ReadBuffer(imgRect.Right, SizeOf(imgRect.Right));

    F.ReadBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
    F.ReadBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
    F.ReadBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
    F.ReadBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

    F.ReadBuffer(StatusRect.Top, SizeOf(StatusRect.Top));
    F.ReadBuffer(StatusRect.Bottom, SizeOf(StatusRect.Bottom));
    F.ReadBuffer(StatusRect.Left, SizeOf(StatusRect.Left));
    F.ReadBuffer(StatusRect.Right, SizeOf(StatusRect.Right));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TTimeLineName.ReadFromStream | ' +
        E.Message);
  end;
end;

// =================== Зона редактируемуего тайм-лайна ZoneEditTL

Constructor TZoneEditTL.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  IDTimeline := 1;
  OffsetTextX := 20;
  OffsetTextY := 5;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneEditFontBold;
  FontItalic := TLZoneEditFontItalic;
  FontUnderline := TLZoneEditFontUnderline;
  imgRect.Left := 0;
  imgRect.Right := 0;
  imgRect.Top := 0;
  imgRect.Bottom := 0;
  BlockRect.Left := 0;
  BlockRect.Right := 0;
  BlockRect.Top := 0;
  BlockRect.Bottom := 0;
  BlockSelect := FALSE;
  StatusRect.Left := 0;
  StatusRect.Right := 0;
  StatusRect.Top := 0;
  StatusRect.Bottom := 0;
  StatusSelect := FALSE;
end;

procedure TZoneEditTL.ColorUpdate;
begin
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneEditFontBold;
  FontItalic := TLZoneEditFontItalic;
  FontUnderline := TLZoneEditFontUnderline;
end;

Destructor TZoneEditTL.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@IDTimeline);
  FreeMem(@OffsetTextX);
  FreeMem(@OffsetTextY);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  FreeMem(@imgRect);
  FreeMem(@BlockRect);
  FreeMem(@BlockSelect);
  FreeMem(@StatusRect);
  FreeMem(@StatusSelect);
  inherited Destroy;
end;

procedure TZoneEditTL.Draw(cv: tcanvas; Grid: tstringgrid;
  Top, height: integer);
var
  APos: integer;
  Text: string;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.Draw Grid=' + Grid.Name +
        ' Top=' + inttostr(Top) + ' Height=' + inttostr(height));
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    cv.Font.Size := FontSize + 2;;
    cv.Font.Color := FontColor;
    cv.Font.Name := FontName;
    if FontBold then
      cv.Font.Style := cv.Font.Style + [fsBold]
    else
      cv.Font.Style := cv.Font.Style - [fsBold];
    if FontItalic then
      cv.Font.Style := cv.Font.Style + [fsItalic]
    else
      cv.Font.Style := cv.Font.Style - [fsItalic];
    if FontUnderline then
      cv.Font.Style := cv.Font.Style + [fsUnderline]
    else
      cv.Font.Style := cv.Font.Style - [fsUnderline];

    cv.Pen.Color := FontColor;

    Rect.Left := cv.ClipRect.Left;
    Rect.Right := cv.ClipRect.Right;
    Rect.Top := cv.ClipRect.Top + Top;
    Rect.Bottom := Rect.Top + height;

    cv.Brush.Color := Color;
    cv.FillRect(Rect);
    cv.Brush.Style := bsClear;

    // if IDTimeline <= 0 then IDTimeline:=(Grid.Objects[0,1] as TTimelineOptions).IDTimeline;

    APos := GridPosition(Grid, IDTimeline);
    if APos = -1 then
      APos := 1;
    if (Grid.Objects[0, APos] is TTimelineOptions) then
    begin
      imgRect.Left := Rect.Left + 1;
      imgRect.Right := imgRect.Left + 25;
      imgRect.Top := Rect.Top + OffsetTextY;
      imgRect.Bottom := imgRect.Top + 25;
      with (Grid.Objects[0, APos] as TTimelineOptions) do
      begin
        Case TypeTL of
          tldevice:
            Text := 'Tools';
          tltext:
            Text := 'Text';
          tlmedia:
            Text := 'Media';
        end;
        LoadBMPFromRes(cv, imgRect, 25, 25, Text + inttostr(NumberBmp));
        cv.TextOut(imgRect.Right + 10, Rect.Top + OffsetTextY, Name);
        StatusRect.Left := Rect.Right - 29;
        StatusRect.Right := Rect.Right - 4;
        StatusRect.Bottom := Rect.Bottom - 4;
        StatusRect.Top := StatusRect.Bottom - 25;
        cv.Pen.Color := FontColor;
        if TLZone.Count > APos - 1 then
        begin
          if StatusSelect then
          begin
            cv.Brush.Color :=
              SmoothColor(StatusColor[TLZone.Timelines[APos - 1].Status], 32);
            cv.Pen.Color := SmoothColor(cv.Pen.Color, 32);
          end
          else
          begin
            cv.Brush.Color := StatusColor[TLZone.Timelines[APos - 1].Status];
            cv.Pen.Color := FontColor;
          end;
        end
        else
        begin
          cv.Brush.Color := StatusColor[4];
          cv.Pen.Color := FontColor;
        end;
        cv.Ellipse(StatusRect);

        BlockRect.Right := StatusRect.Left - 10;
        BlockRect.Left := BlockRect.Right - 25;
        BlockRect.Bottom := Rect.Bottom - 4;
        BlockRect.Top := StatusRect.Bottom - 25;

        if BlockSelect then
          cv.Brush.Color := SmoothColor(Color, 32)
        else
          cv.Brush.Color := Color;
        cv.Pen.Color := cv.Brush.Color;
        cv.Rectangle(BlockRect);
        if TLZone.Count > APos - 1 then
        begin
          if TLZone.Timelines[APos - 1].Block then
          begin
            LoadBMPFromRes(cv, BlockRect, 25, 25, 'Lock');
            cv.Font.Size := cv.Font.Size - 3;
            cv.Brush.Color := Color;
            UserLock := CurrentUser;
            cv.TextOut(imgRect.Right + 10, Rect.Bottom - 4 -
              cv.TextHeight(UserLock), UserLock);
          end
          else
            LoadBMPFromRes(cv, BlockRect, 25, 25, 'Unlock');
        end
        else
          LoadBMPFromRes(cv, BlockRect, 25, 25, 'Unlock');
      end;
    end;

    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.Draw | ' + E.Message);
  end;
end;

function TZoneEditTL.GridPosition(Grid: tstringgrid;
  IDTimeline: integer): integer;
var
  i: integer;
  s: string;
begin
  try
    Result := -1;
    for i := 1 to Grid.RowCount - 1 do
    begin
      if Grid.Objects[0, i] is TTimelineOptions then
      begin
        s := inttostr((Grid.Objects[0, i] as TTimelineOptions).IDTimeline);
        // Warning
        if (Grid.Objects[0, i] as TTimelineOptions).IDTimeline = IDTimeline then
        begin
          Result := i;
          if MakeLogging then
            WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.GridPosition Grid=' +
              Grid.Name + ' Position=' + inttostr(Result) + ' IDTimeline=' +
              inttostr(IDTimeline));
          exit;
        end;
      end;
    end;
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.GridPosition Grid=' +
        Grid.Name + ' Position=' + inttostr(Result) + ' IDTimeline=' +
        inttostr(IDTimeline));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.GridPosition | ' +
        E.Message);
  end;
end;

function TZoneEditTL.TLPosition(NM: TNamesTL; IDTimeline: integer): integer;
var
  i: integer;
begin
  try
    Result := -1;
    for i := 0 to NM.Count - 1 do
    begin
      if NM.Names[i].IDTimeline = IDTimeline then
      begin
        Result := i;
        if MakeLogging then
          WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.TLPosition Position=' +
            inttostr(Result) + ' IDTimeline=' + inttostr(IDTimeline));
        exit;
      end;
    end;
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.TLPosition Position=' +
        inttostr(Result) + ' IDTimeline=' + inttostr(IDTimeline));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.TLPosition | ' + E.Message);
  end;
end;

Procedure TZoneEditTL.AssignTL(cv: tcanvas; Grid: tstringgrid;
  TLN: TTimeLineName);
var
  APos: integer;
begin
  try
    IDTimeline := TLN.IDTimeline;
    Draw(cv, Grid, Rect.Top, Rect.Bottom - Rect.Top);
    APos := GridPosition(Grid, TLN.IDTimeline);
    TLZone.TLEditor.Assign(TLZone.Timelines[APos - 1], APos);

    if APos > 0 then
    begin
      if Grid.Objects[0, APos] is TTimelineOptions then
      begin
        SetPanelTypeTL((Grid.Objects[0, APos] as TTimelineOptions)
          .TypeTL, APos);
        (* case (Grid.Objects[0,Apos] as TTimelineOptions).TypeTL of
          tldevice : begin
          Form1.pnDevTL.Visible:=true;
          Form1.PnTextTL.Visible:=false;
          Form1.pnMediaTL.Visible:=false;
          btnsdevicepr.BackGround:=ProgrammColor;
          InitBTNSDEVICE(Form1.imgDeviceTL.Canvas, (Grid.Objects[0,APos] as TTimelineOptions), btnsdevicepr);
          end;
          tltext   : begin
          Form1.pnDevTL.Visible:=false;
          Form1.PnTextTL.Visible:=true;
          Form1.pnMediaTL.Visible:=false;
          Form1.imgTextTL.Width:=Form1.pnPrepareCTL.Width;
          Form1.imgTextTL.Picture.Bitmap.Width:=Form1.imgTextTL.Width;
          btnstexttl.Draw(Form1.imgTextTL.Canvas);
          end;
          tlmedia  : begin
          Form1.pnDevTL.Visible:=false;
          Form1.PnTextTL.Visible:=false;
          Form1.pnMediaTL.Visible:=true;
          Form1.imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
          Form1.imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
          btnsmediatl.Top:=Form1.imgMediaTL.Height div 2 - 35;
          btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
          end;
          end; //case *)
        UpdatePanelPrepare;
      end;
      if MakeLogging then
        WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.AssignTL Grid=' + Grid.Name
          + ' Position=' + inttostr(APos) + ' IDTimeline=' +
          inttostr(IDTimeline));
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.AssignTL | ' + E.Message);
  end;
end;

function TZoneEditTL.ClickEditTl(cv: tcanvas; Grid: tstringgrid; X, Y: integer)
  : TTLNResult;
var
  GPos: integer;
begin
  try
    StatusSelect := FALSE;
    BlockSelect := FALSE;
    Result.Zone := znedit;
    Result.ID := IDTimeline;
    Result.Position := -1;
    Result.Button := btnone;
    GPos := GridPosition(Grid, IDTimeline);
    if Grid.Objects[0, GPos] is TTimelineOptions then
    begin
      if (X > StatusRect.Left) and (X < StatusRect.Right) and
        (Y > StatusRect.Top) and (Y < StatusRect.Bottom) then
      begin
        Result.ID := IDTimeline;
        Result.Button := btstatus;
        TLZone.Timelines[GPos - 1].Status := TLZone.Timelines[GPos - 1]
          .Status + 1;
        If TLZone.Timelines[GPos - 1].Status > 4 then
          TLZone.Timelines[GPos - 1].Status := 0;
      end
      else if (X > BlockRect.Left) and (X < BlockRect.Right) and
        (Y > BlockRect.Top) and (Y < BlockRect.Bottom) then
      begin
        Result.ID := IDTimeline;
        Result.Button := btlock;
        TLZone.Timelines[GPos - 1].Block := not TLZone.Timelines
          [GPos - 1].Block;
      end;
    end;
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.ClickEditTl Grid=' +
        Grid.Name + ' Position=' + inttostr(GPos) + ' IDTimeline=' +
        inttostr(IDTimeline));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.ClickEditTl | ' + E.Message);
  end;
end;

procedure TZoneEditTL.MoveMouse(cv: tcanvas; Grid: tstringgrid; X, Y: integer);
begin
  StatusSelect := FALSE;
  BlockSelect := FALSE;
  if (X > StatusRect.Left) and (X < StatusRect.Right) and (Y > StatusRect.Top)
    and (Y < StatusRect.Bottom) then
    StatusSelect := true
  else if (X > BlockRect.Left) and (X < BlockRect.Right) and (Y > BlockRect.Top)
    and (Y < BlockRect.Bottom) then
    BlockSelect := true;
  Draw(cv, Grid, Rect.Top, Rect.Bottom - Rect.Top);
end;

Procedure TZoneEditTL.WriteToStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
    F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
    F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

    F.WriteBuffer(IDTimeline, SizeOf(IDTimeline));
    F.WriteBuffer(OffsetTextX, SizeOf(OffsetTextX));
    F.WriteBuffer(OffsetTextY, SizeOf(OffsetTextY));

    F.WriteBuffer(Color, SizeOf(Color));
    F.WriteBuffer(FontColor, SizeOf(FontColor));
    F.WriteBuffer(FontSize, SizeOf(FontSize));
    WriteBufferStr(F, FontName);

    F.WriteBuffer(FontBold, SizeOf(FontBold));
    F.WriteBuffer(FontItalic, SizeOf(FontItalic));
    F.WriteBuffer(FontUnderline, SizeOf(FontUnderline));

    F.WriteBuffer(imgRect.Top, SizeOf(imgRect.Top));
    F.WriteBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
    F.WriteBuffer(imgRect.Left, SizeOf(imgRect.Left));
    F.WriteBuffer(imgRect.Right, SizeOf(imgRect.Right));

    F.WriteBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
    F.WriteBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
    F.WriteBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
    F.WriteBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

    F.WriteBuffer(BlockSelect, SizeOf(BlockSelect));

    F.WriteBuffer(StatusRect.Top, SizeOf(StatusRect.Top));
    F.WriteBuffer(StatusRect.Bottom, SizeOf(StatusRect.Bottom));
    F.WriteBuffer(StatusRect.Left, SizeOf(StatusRect.Left));
    F.WriteBuffer(StatusRect.Right, SizeOf(StatusRect.Right));

    F.WriteBuffer(StatusSelect, SizeOf(StatusSelect));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.WriteToStream | ' +
        E.Message);
  end;
end;

Procedure TZoneEditTL.ReadFromStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
    F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
    F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

    F.ReadBuffer(IDTimeline, SizeOf(IDTimeline));
    F.ReadBuffer(OffsetTextX, SizeOf(OffsetTextX));
    F.ReadBuffer(OffsetTextY, SizeOf(OffsetTextY));

    F.ReadBuffer(Color, SizeOf(Color));
    F.ReadBuffer(FontColor, SizeOf(FontColor));
    F.ReadBuffer(FontSize, SizeOf(FontSize));
    ReadBufferStr(F, FontName);

    F.ReadBuffer(FontBold, SizeOf(FontBold));
    F.ReadBuffer(FontItalic, SizeOf(FontItalic));
    F.ReadBuffer(FontUnderline, SizeOf(FontUnderline));

    F.ReadBuffer(imgRect.Top, SizeOf(imgRect.Top));
    F.ReadBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
    F.ReadBuffer(imgRect.Left, SizeOf(imgRect.Left));
    F.ReadBuffer(imgRect.Right, SizeOf(imgRect.Right));

    F.ReadBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
    F.ReadBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
    F.ReadBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
    F.ReadBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

    F.ReadBuffer(BlockSelect, SizeOf(BlockSelect));

    F.ReadBuffer(StatusRect.Top, SizeOf(StatusRect.Top));
    F.ReadBuffer(StatusRect.Bottom, SizeOf(StatusRect.Bottom));
    F.ReadBuffer(StatusRect.Left, SizeOf(StatusRect.Left));
    F.ReadBuffer(StatusRect.Right, SizeOf(StatusRect.Right));

    F.ReadBuffer(StatusSelect, SizeOf(StatusSelect));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneEditTL.ReadFromStream | ' +
        E.Message);
  end;
end;


// ================================Зона Подсмотра TZoneScaler

Constructor TZoneScaler.Create;
begin
  inherited;
  plusHSelect := FALSE;
  minusHSelect := FALSE;
  plusWSelect := FALSE;
  minusWSelect := FALSE;
  plusHLock := FALSE;
  minusHLock := FALSE;
  plusWLock := FALSE;
  minusWLock := FALSE;
  procentSelect := FALSE;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 30;
  OffsetText := 22;
  Text := 'Масштаб';
  plusH.Left := 0;
  plusH.Right := 0;
  plusH.Top := 0;
  plusH.Bottom := 30;
  minusH.Left := 0;
  minusH.Right := 0;
  minusH.Top := 0;
  minusH.Bottom := 30;
  plusW.Left := 0;
  plusW.Right := 0;
  plusW.Top := 0;
  plusW.Bottom := 30;
  minusW.Left := 0;
  minusW.Right := 0;
  minusW.Top := 0;
  minusW.Bottom := 30;
  procent.Left := 0;
  procent.Right := 0;
  procent.Top := 0;
  procent.Bottom := 30;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
end;

procedure TZoneScaler.ColorUpdate;
begin
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
end;

destructor TZoneScaler.Destroy;
begin
  FreeMem(@plusHSelect);
  FreeMem(@minusHSelect);
  FreeMem(@plusWSelect);
  FreeMem(@minusWSelect);
  FreeMem(@plusHLock);
  FreeMem(@minusHLock);
  FreeMem(@plusWLock);
  FreeMem(@minusWLock);
  FreeMem(@procentSelect);
  FreeMem(@Rect);
  FreeMem(@OffsetText);
  FreeMem(@Text);
  FreeMem(@plusH);
  FreeMem(@minusH);
  FreeMem(@plusW);
  FreeMem(@minusW);
  FreeMem(@procent);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  inherited Destroy;
end;

procedure TZoneScaler.Draw(cv: tcanvas; height: integer);
var
  psx, psy: integer;
  s: string;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
  prcnt: string;
  len, vid, opr: longint;
  scr: Real;
begin
  try
    if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.Draw Height=' +
        inttostr(height));
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    cv.Font.Size := FontSize;
    cv.Font.Color := FontColor;
    cv.Font.Name := FontName;
    // cv.Font.Style:=FontStyles;
    cv.Pen.Color := FontColor;

    Rect.Left := cv.ClipRect.Left;
    Rect.Right := cv.ClipRect.Right;
    Rect.Top := cv.ClipRect.Top;
    Rect.Bottom := cv.ClipRect.Top + height;

    cv.Brush.Color := Color;
    cv.FillRect(Rect);
    cv.Brush.Style := bsClear;
    // OffsetText := 22;
    // Text := 'Масштаб';
    plusH.Left := cv.ClipRect.Left + 16;
    plusH.Right := cv.ClipRect.Left + 30;
    plusH.Top := cv.ClipRect.Top + 1;
    plusH.Bottom := cv.ClipRect.Top + height - 1; // + (height div 2);

    if plusHSelect then
      cv.Brush.Color := SmoothColor(Color, 32)
    else
      cv.Brush.Color := Color;
    cv.Rectangle(plusH);
    cv.TextRect(plusH, plusH.Left + (plusH.Right - plusH.Left -
      cv.TextWidth('+')) div 2, (plusH.Bottom - plusH.Top - cv.TextHeight('+'))
      div 2, '+');

    minusH.Left := cv.ClipRect.Left + 1;
    minusH.Right := cv.ClipRect.Left + 15;
    minusH.Top := cv.ClipRect.Top + 1; // (height div 2)+ 1;
    minusH.Bottom := cv.ClipRect.Top + height - 1;

    if minusHSelect then
      cv.Brush.Color := SmoothColor(Color, 32)
    else
      cv.Brush.Color := Color;
    cv.Rectangle(minusH);
    cv.TextRect(minusH, minusH.Left + (minusH.Right - minusH.Left -
      cv.TextWidth('-')) div 2, minusH.Top + (minusH.Bottom - minusH.Top -
      cv.TextHeight('-')) div 2, '-');
    // cv.TextOut(MinusH.Left + (MinusH.Right-MinusH.Left - cv.TextWidth('-')) div 2, (MinusH.Bottom-MinusH.Top - cv.TextHeight('-')) div 2, '-');

    minusW.Left := Rect.Right - 20;
    minusW.Right := Rect.Right - 2;
    minusW.Top := Rect.Top + 2;
    minusW.Bottom := Rect.Bottom - 2;

    // cv.Rectangle(MinusW);
    if minusWSelect then
      cv.Brush.Color := SmoothColor(Color, 32)
    else
      cv.Brush.Color := Color;
    cv.TextRect(minusW, minusW.Left + (minusW.Right - minusW.Left -
      cv.TextWidth('-')) div 2, (minusW.Bottom - minusW.Top - cv.TextHeight('-')
      ) div 2, '-');

    cv.Font.Size := cv.Font.Size - 2;
    procent.Left := minusW.Left - cv.TextWidth('000%') - 8;
    procent.Right := minusW.Left - 4;
    procent.Top := Rect.Top;
    procent.Bottom := Rect.Bottom;
    if procentSelect then
      cv.Brush.Color := SmoothColor(Color, 32)
    else
      cv.Brush.Color := Color;

    len := TLParameters.Preroll + TLParameters.Finish;
    // +TLparameters.Postroll;
    vid := TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame;
    opr := len div 100;
    scr := vid / opr;
    if scr >= 100 then
      prcnt := FormatFloat('0', scr) + '%'
    else
      prcnt := FormatFloat('0.0', scr) + '%';
    cv.Font.Size := cv.Font.Size - 2;
    cv.TextRect(procent, procent.Left + 4,
      (procent.Bottom - procent.Top - cv.TextHeight('0')) div 2, prcnt);
    cv.Brush.Color := Color;
    cv.Font.Size := cv.Font.Size + 1;
    cv.TextOut(Rect.Left + 30,
      (procent.Bottom - procent.Top - cv.TextHeight('0')) div 2, Text);

    cv.Font.Size := cv.Font.Size + 2;
    plusW.Left := procent.Left - 18;
    plusW.Right := procent.Left;
    plusW.Top := Rect.Top + 2;
    plusW.Bottom := Rect.Bottom - 2;

    // cv.Rectangle(PlusW);
    if plusWSelect then
      cv.Brush.Color := SmoothColor(Color, 32)
    else
      cv.Brush.Color := Color;
    cv.TextRect(plusW, plusW.Left + (plusW.Right - plusW.Left -
      cv.TextWidth('+')) div 2, (plusW.Bottom - plusW.Top - cv.TextHeight('+'))
      div 2, '+');

    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.Draw | ' + E.Message);
  end;
end;

Procedure TZoneScaler.MoveMouse(cv: tcanvas; X, Y: integer);
begin
  plusHSelect := FALSE;
  minusHSelect := FALSE;
  plusWSelect := FALSE;
  minusWSelect := FALSE;
  procentSelect := FALSE;
  if (X > plusH.Left) and (X < plusH.Right) and (Y > plusH.Top) and
    (Y < plusH.Bottom) then
    plusHSelect := true
  else if (X > minusH.Left) and (X < minusH.Right) and (Y > minusH.Top) and
    (Y < minusH.Bottom) then
    minusHSelect := true
  else if (X > minusW.Left) and (X < minusW.Right) and (Y > minusW.Top) and
    (Y < minusW.Bottom) then
    minusWSelect := true
  else if (X > plusW.Left) and (X < plusW.Right) and (Y > plusW.Top) and
    (Y < plusW.Bottom) then
    plusWSelect := true
  else if (X > procent.Left) and (X < procent.Right) and (Y > procent.Top) and
    (Y < procent.Bottom) then
    procentSelect := true;
  application.ProcessMessages;
  Draw(cv, Rect.Bottom - Rect.Top);
end;

function TZoneScaler.ClickScaler(cv: tcanvas; X, Y: integer): TTLNResult;
begin
  try
    plusHSelect := FALSE;
    minusHSelect := FALSE;
    plusWSelect := FALSE;
    minusWSelect := FALSE;
    procentSelect := FALSE;
    Result.Zone := znscaler;
    Result.ID := -1;
    Result.Position := -1;
    Result.Button := btnone;
    if (X > plusH.Left) and (X < plusH.Right) and (Y > plusH.Top) and
      (Y < plusH.Bottom) then
    begin
      Result.Button := btplusH;
      if MakeLogging then
        WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ClickScaler btplusH');
    end
    else if (X > minusH.Left) and (X < minusH.Right) and (Y > minusH.Top) and
      (Y < minusH.Bottom) then
    begin
      Result.Button := btminusH;
      if MakeLogging then
        WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ClickScaler btminusH');
    end
    else if (X > minusW.Left) and (X < minusW.Right) and (Y > minusW.Top) and
      (Y < minusW.Bottom) then
    begin
      Result.Button := btminusW;
      if MakeLogging then
        WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ClickScaler btminusW');
    end
    else if (X > plusW.Left) and (X < plusW.Right) and (Y > plusW.Top) and
      (Y < plusW.Bottom) then
    begin
      Result.Button := btplusW;
      if MakeLogging then
        WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ClickScaler btplusW');
    end
    else if (X > procent.Left) and (X < procent.Right) and (Y > procent.Top) and
      (Y < procent.Bottom) then
    begin
      Result.Button := btprocent;
      if MakeLogging then
        WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ClickScaler btprocent');
    end
    else if MakeLogging then
      WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ClickScaler btnone');;
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ClickScaler | ' + E.Message);
  end;
end;

Procedure TZoneScaler.WriteToStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
    F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
    F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

    F.WriteBuffer(OffsetText, SizeOf(OffsetText));
    WriteBufferStr(F, Text);
    F.WriteBuffer(Color, SizeOf(Color));
    F.WriteBuffer(FontColor, SizeOf(FontColor));
    F.WriteBuffer(FontSize, SizeOf(FontSize));
    WriteBufferStr(F, FontName);

    F.WriteBuffer(FontBold, SizeOf(FontBold));
    F.WriteBuffer(FontItalic, SizeOf(FontItalic));
    F.WriteBuffer(FontUnderline, SizeOf(FontUnderline));

    F.WriteBuffer(plusH.Top, SizeOf(plusH.Top));
    F.WriteBuffer(plusH.Bottom, SizeOf(plusH.Bottom));
    F.WriteBuffer(plusH.Left, SizeOf(plusH.Left));
    F.WriteBuffer(plusH.Right, SizeOf(plusH.Right));

    F.WriteBuffer(plusHSelect, SizeOf(plusHSelect));
    F.WriteBuffer(plusHLock, SizeOf(plusHLock));

    F.WriteBuffer(minusH.Top, SizeOf(minusH.Top));
    F.WriteBuffer(minusH.Bottom, SizeOf(minusH.Bottom));
    F.WriteBuffer(minusH.Left, SizeOf(minusH.Left));
    F.WriteBuffer(minusH.Right, SizeOf(minusH.Right));

    F.WriteBuffer(minusHSelect, SizeOf(minusHSelect));
    F.WriteBuffer(minusHLock, SizeOf(minusHLock));

    F.WriteBuffer(plusW.Top, SizeOf(plusW.Top));
    F.WriteBuffer(plusW.Bottom, SizeOf(plusW.Bottom));
    F.WriteBuffer(plusW.Left, SizeOf(plusW.Left));
    F.WriteBuffer(plusW.Right, SizeOf(plusW.Right));

    F.WriteBuffer(plusWSelect, SizeOf(plusWSelect));
    F.WriteBuffer(plusWLock, SizeOf(plusWLock));

    F.WriteBuffer(minusW.Top, SizeOf(minusW.Top));
    F.WriteBuffer(minusW.Bottom, SizeOf(minusW.Bottom));
    F.WriteBuffer(minusW.Left, SizeOf(minusW.Left));
    F.WriteBuffer(minusW.Right, SizeOf(minusW.Right));

    F.WriteBuffer(minusWSelect, SizeOf(minusWSelect));
    F.WriteBuffer(minusWLock, SizeOf(minusWLock));

    F.WriteBuffer(procent.Top, SizeOf(procent.Top));
    F.WriteBuffer(procent.Bottom, SizeOf(procent.Bottom));
    F.WriteBuffer(procent.Left, SizeOf(procent.Left));
    F.WriteBuffer(procent.Right, SizeOf(procent.Right));

    F.WriteBuffer(procentSelect, SizeOf(procentSelect));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.WriteToStream | ' +
        E.Message);
  end;
end;

Procedure TZoneScaler.ReadFromStream(F: tStream);
var
  fsbl: boolean;
begin
  try
    F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
    F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
    F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

    F.ReadBuffer(OffsetText, SizeOf(OffsetText));
    ReadBufferStr(F, Text);
    F.ReadBuffer(Color, SizeOf(Color));
    F.ReadBuffer(FontColor, SizeOf(FontColor));
    F.ReadBuffer(FontSize, SizeOf(FontSize));
    ReadBufferStr(F, FontName);

    F.ReadBuffer(FontBold, SizeOf(FontBold));
    F.ReadBuffer(FontItalic, SizeOf(FontItalic));
    F.ReadBuffer(FontUnderline, SizeOf(FontUnderline));

    F.ReadBuffer(plusH.Top, SizeOf(plusH.Top));
    F.ReadBuffer(plusH.Bottom, SizeOf(plusH.Bottom));
    F.ReadBuffer(plusH.Left, SizeOf(plusH.Left));
    F.ReadBuffer(plusH.Right, SizeOf(plusH.Right));

    F.ReadBuffer(plusHSelect, SizeOf(plusHSelect));
    F.ReadBuffer(plusHLock, SizeOf(plusHLock));

    F.ReadBuffer(minusH.Top, SizeOf(minusH.Top));
    F.ReadBuffer(minusH.Bottom, SizeOf(minusH.Bottom));
    F.ReadBuffer(minusH.Left, SizeOf(minusH.Left));
    F.ReadBuffer(minusH.Right, SizeOf(minusH.Right));

    F.ReadBuffer(minusHSelect, SizeOf(minusHSelect));
    F.ReadBuffer(minusHLock, SizeOf(minusHLock));

    F.ReadBuffer(plusW.Top, SizeOf(plusW.Top));
    F.ReadBuffer(plusW.Bottom, SizeOf(plusW.Bottom));
    F.ReadBuffer(plusW.Left, SizeOf(plusW.Left));
    F.ReadBuffer(plusW.Right, SizeOf(plusW.Right));

    F.ReadBuffer(plusWSelect, SizeOf(plusWSelect));
    F.ReadBuffer(plusWLock, SizeOf(plusWLock));

    F.ReadBuffer(minusW.Top, SizeOf(minusW.Top));
    F.ReadBuffer(minusW.Bottom, SizeOf(minusW.Bottom));
    F.ReadBuffer(minusW.Left, SizeOf(minusW.Left));
    F.ReadBuffer(minusW.Right, SizeOf(minusW.Right));

    F.ReadBuffer(minusWSelect, SizeOf(minusWSelect));
    F.ReadBuffer(minusWLock, SizeOf(minusWLock));

    F.ReadBuffer(procent.Top, SizeOf(procent.Top));
    F.ReadBuffer(procent.Bottom, SizeOf(procent.Bottom));
    F.ReadBuffer(procent.Left, SizeOf(procent.Left));
    F.ReadBuffer(procent.Right, SizeOf(procent.Right));

    F.ReadBuffer(procentSelect, SizeOf(procentSelect));
  except
    on E: Exception do
      WriteLog('MAIN', 'UDrawTimelines.TZoneScaler.ReadFromStream | ' +
        E.Message);
  end;
end;

Initialization

ZoneNames := TTLNames.Create;
TLHeights := TTLHeights.Create;

finalization

ZoneNames.FreeInstance;
ZoneNames := nil;
TLHeights.FreeInstance;
TLHeights := nil;

end.
