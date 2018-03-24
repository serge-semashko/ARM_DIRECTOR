unit UGRTimelines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline,
  ucommon,
  umyevents, OpenGL, System.json,uwebget;

Type
  TEditingArea = (edNone, edStart, edCenter, edFinish);

  TTLParameters = Class(TObject)
  public
    BackGround: tcolor; // Фоновый цвет
    ForeGround: tcolor; // Цвет пустых тайм-линий
    MaxFrameSize: integer; // Максимальный размер кадра в пиксилях
    FrameSize: integer; // Текущий размер кадра
    Start: longint; // Позиция курсора начала воспроизведения (кадры)
    Finish: longint; // Позиция курсора конца воспроизведения (кадры)
    // NTK    : longint;           //Начальный тайм код (кадры)
    ZeroPoint: longint; // Нулевая точка отсчета начальный тайм-код (кадры)
    MyCursor: longint; // Положение курсора относительно начала экрана (пиксили)
    ScreenStart: longint; // Относительная позиция начала экрана (пиксили)
    ScreenEnd: longint; // Относительная позиция конца экрана (пиксли)
    Preroll: longint; // Начальный буффер (кадры)
    Postroll: longint; // Конечный буффер (кадры)
    Duration: longint; // Общая длителность клипа (кадры)
    EndPoint: longint; // Положение конца клипа Preroll+Duration (кадры)
    lrTransperent0: tcolor; // Цвет прозрачности для слоя 0
    lrTransperent1: tcolor; // Цвет прозрачности для слоя 1
    lrTransperent2: tcolor; // Цвет прозрачности для слоя 2
    Position: longint; // Tекущая позиция клипа (кадры)
    ScreenStartFrame: longint; // Абсолютная позиция начала экрана (кадры)
    ScreenEndFrame: longint; // Абсолютная позиция конца экрана (кадры)
    StopPosition: longint; // Позиция остановки клип (кадры)
    Scaler: real; // Отношение ширины Bitmap к ширине экрана
    VLCMode: TPlayerMode;
    command : string;
    TLTimeCode : string;
    procedure InitParameters;
    procedure UpdateParameters;
    procedure SetScreenBoanders;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLScaler = Class(TObject)
  public
    PenColor: tcolor;
    FontColor: tcolor;
    FontSize: integer;
    FontName: tfontname;
    Rect: TRect;
    procedure DrawScaler(cv: tcanvas);
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure UpdateData;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLTimeline = Class(TObject)
  public
    IDTimeline: longint;
    TypeTL: TTypeTimeline;
    Block: boolean;
    Status: integer;
    Rect: TRect;
    Count: integer;
    Events: Array of TMyEvent;

    function AddEvent(Position: longint; psgrd, psclr: integer): integer;
    function FindEventID(IdEvent: longint): integer;
    function FindEvent(Position: longint): integer;
    procedure Delete(Position: longint);
    procedure DeleteID(IdEvent: longint);
    procedure Clear;
    procedure Assign(ListEvents: TTLTimeline);
    Procedure DrawDeviceTimeline(cv: tcanvas; EPos: integer);
    Procedure DrawTextTimeline(cv: tcanvas; EPos: integer);
    Procedure DrawMediaTimeline(cv: tcanvas; Color: tcolor; EPos: integer);
    procedure DrawTimeline(cv: tcanvas; NomTl: integer; EPos: integer);
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    // procedure UpdateData;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLEditor = Class(TObject)
  public
    Index: integer;
    isZoneEditor: boolean;
    DoubleClick: boolean;
    IDTimeline: longint;
    Block: boolean;
    Status: integer;
    TypeTL: TTypeTimeline;
    Rect: TRect;
    Count: integer;
    Events: Array of TMyEvent;
    function AddEvent(Position: longint; psgrd, psclr: integer): integer;
    function InsertDevice(Position: longint): integer;
    function InsertText(Position: longint): integer;
    function InsertMarker(Position: longint): integer;
    procedure Clear;
    procedure DeleteEvent(Position: longint);
    procedure Assign(ttl: TTLTimeline; Indx: integer);
    procedure ReturnEvents(ttl: TTLTimeline);
    procedure DrawEditorDevice(cv: tcanvas; EPos: integer);
    procedure UpdateScreenDevice(cv: tcanvas);
    procedure DrawEditorDeviceEvent(evnt: TMyEvent; cv: tcanvas; TLRect: TRect;
      lr: boolean);
    procedure UpdateScreenText(cv: tcanvas);
    procedure DrawEditorTextEvent(evnt: TMyEvent; cv: tcanvas; TLRect: TRect;
      lr: boolean);
    procedure DrawEditorMediaEvent(evnt: TMyEvent; cv: tcanvas; TLRect: TRect;
      lr: boolean);
    procedure DrawEditorText(cv: tcanvas; EPos: integer);
    procedure DrawEditorMedia(cv: tcanvas; EPos: integer);
    procedure DrawEditor(cv: tcanvas; EPos: integer);
    procedure UpdateScreen(cv: tcanvas);
    procedure MouseClick(cv: tcanvas; X, Y: integer);
    procedure MouseMove(cv: tcanvas; X, Y: integer);
    procedure UpdateEventData(ev: TMyEvent);
    function FindEventPos(evframe: longint): integer;
    function FirstScreenEvent: integer;
    Function LastScreenEvent: integer;
    function CurrentEvents: TEventReplay;
    procedure AllSelectFalse;
    procedure EventsSelectFalse;
    Procedure WriteToStream(F: tStream);
    Procedure SaveToFile(FileName: string);
    Procedure ReadFromStream(F: tStream);
    procedure LoadFromFile(TLType: TTypeTimeline; FileName: string);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLZone = Class(TObject)
  private
    Countbuffer: integer;
    TLBuffer: array of TTLTimeline;
    // DownTimeline : boolean;
    // DownEditor : boolean;
    // DownScaler : boolean;
    XDown: integer;
    CRStart: tcolor;
    CRStartDown: boolean;
    CREnd: tcolor;
    CREndDown: boolean;
  public
    XViewer: integer;
    DownViewer: boolean;
    DownTimeline: boolean;
    DownEditor: boolean;
    DownScaler: boolean;
    TLScaler: TTLScaler;
    TLEditor: TTLEditor;
    Count: integer;
    Timelines: array of TTLTimeline;
    // Procedure DrawLayer1;
    procedure ClearBuffer;
    procedure WriteToBuffer;
    function FindInBuffer(ID: longint): integer;
    Procedure DownZoneTimeLines(cv: tcanvas; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    Procedure MoveMouseTimeline(cv: tcanvas; Shift: TShiftState; X, Y: integer);
    Procedure UPZoneTimeline(cv: tcanvas; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    Procedure AddTimeline(ID: longint);
    function FindTimeline(ID: longint): integer;
    Procedure InitTimelines(bmp: tbitmap);
    procedure ClearTimeline;
    Procedure DrawLayer2(cv: tcanvas);
    Procedure DrawBitmap(bmp: tbitmap);
    function PlusHoriz: integer;
    function MinusHoriz: integer;
    Procedure DrawTimelines(cv: tcanvas; bmp: tbitmap);
    Procedure DrawFlash(nomevent: integer);
    procedure DrawCursorStart(cv: tcanvas);
    function MouseInStartCursor(cv: tcanvas; X, Y: integer): boolean;
    function MouseInEndCursor(cv: tcanvas; X, Y: integer): boolean;
    procedure DrawCursorEnd(cv: tcanvas);
    Procedure SetEditingEventDevice;
    Procedure SetEditingEventText;
    Procedure SetEditingEventMedia;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    procedure ClearZone;
    procedure UpdateCursor;
    Constructor Create;
    Destructor Destroy; override;
  end;

  // ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
  // ========================  Helpers для классов. Сохранения в JSON и загрузка ==
  // ==============================================================================
{$INCLUDE ..\helpers\ugrtimelines_hdr.inc}
  // ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
  // ======================== END  Helpers для классов. Сохранения в JSON и загрузка ==
  // ==============================================================================

Var
  TLZone: TTLZone;
  TLParameters: TTLParameters;

  EditingEvent: integer = -1;
  EditingArea: TEditingArea;
  EditingStart: longint;
  EditingFinish: longint;
  LastSelection: longint = -1;

implementation

uses umain, uinitforms, uimgbuttons, udrawtimelines, uplayer, UAirDraw,
  usettemplate, ugrid, USetEventData, umyfiles, ulock, umyundo, uactplaylist,
  UMyTextTemplate, umymessage;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// процедуры и функции для отрисовки зоны курсоров
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TTLZone.DrawCursorStart(cv: tcanvas);
var
  hgh: integer;
  rt, rte: TRect;
  s: string;
  ps, st: longint;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    cv.Lock;
    try
      with form1 do
      begin
        TLParameters.SetScreenBoanders;
        cv.FillRect(cv.ClipRect);
        if TLParameters.Start < TLParameters.ScreenStartFrame then
          exit;
        if TLParameters.Start > TLParameters.ScreenEndFrame then
          exit;
        if TLParameters.Finish <= TLParameters.Start then
          TLParameters.Start := TLParameters.Finish - TLParameters.FrameSize;
        cv.FillRect(cv.ClipRect);
        cv.Pen.Color := CRStart;
        ps := (TLParameters.Start - TLParameters.ScreenStartFrame) *
          TLParameters.FrameSize; // -1;
        cv.Brush.Style := bsSolid;
        cv.MoveTo(ps, 0);
        cv.LineTo(ps, TLHeights.Height - TLHeights.Review);
        cv.Brush.Color := CRStart;
        // cv.Brush.Style:=bsSolid;

        cv.Polygon([Point(ps, 0), Point(ps, TLHeights.Scaler),
          Point(ps + 10, TLHeights.Scaler div 2)]);
        rt.Left := 0;
        rt.Top := 0;
        rt.Right := ps;
        rt.Bottom := TLHeights.Height - TLHeights.Review;
        cv.CopyRect(rt, imgTimelines.Canvas, rt);

        if (EditingEvent <> -1) and (EditingArea <> edCenter) then
        begin
          if EditingStart < ps then
          begin
            rte.Top := TLEditor.Rect.Top - TLHeights.IntervalEdit;
            rte.Bottom := TLEditor.Rect.Bottom;
            rte.Left := EditingStart;
            if EditingFinish > ps then
              rte.Right := ps
            else
              rte.Right := EditingFinish;
            cv.Brush.Style := bsClear;
            cv.CopyRect(rte, imgLayer0.Canvas, rte);
            cv.Brush.Style := bsSolid;
          end;
        end;
        cv.Pen.Mode := pmMerge;
        cv.Brush.Color := SmoothColor(clBlack, 20);
        cv.Pen.Color := SmoothColor(clBlack, 20);
        cv.Rectangle(rt);
        cv.Brush.Style := bsClear;
        cv.Pen.Mode := pmCopy;
        cv.Font.Color := SmoothColor(clWhite, 8);
        s := FramesToShortStr(TLParameters.Start - TLParameters.ZeroPoint);
        SetClipTimeParameters;
        cv.TextOut(ps - cv.TextWidth(s) - 2,
          (TLHeights.Scaler - cv.TextHeight(s)) div 2, s);
      end;
      cv.Brush.Color := cbr;
      cv.Pen.Color := cpn;
      cv.Pen.Width := wpn;
      cv.Brush.Style := sbr;
      cv.Pen.Mode := mpn;
    finally
      cv.Unlock;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.DrawCursorStart | ' + E.Message);
  end;
end;

procedure TTLZone.ClearZone;
begin
  try
    ClearBuffer;
    ClearTimeline;
    TLEditor.Clear;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearZone | ' + E.Message);
  end;
end;

procedure TTLZone.DrawCursorEnd(cv: tcanvas);
var
  hgh: integer;
  rt, rte: TRect;
  s: string;
  ps, pstl: longint;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;
    cv.Lock;
    try
      with form1 do
      begin
        TLParameters.SetScreenBoanders;
        if TLParameters.Finish < TLParameters.ScreenStartFrame then
          exit;
        if TLParameters.Finish > TLParameters.ScreenEndFrame then
          exit;
        if TLParameters.Finish <= TLParameters.Start then
          TLParameters.Start := TLParameters.Finish - TLParameters.FrameSize;
        cv.Pen.Color := CREnd;
        ps := (TLParameters.Finish - TLParameters.ScreenStartFrame) *
          TLParameters.FrameSize;
        cv.Brush.Color := CREnd;
        cv.Brush.Style := bsSolid;
        cv.MoveTo(ps, 0);
        cv.LineTo(ps, TLHeights.Height - TLHeights.Review);

        cv.Polygon([Point(ps, 0), Point(ps, TLHeights.Scaler),
          Point(ps - 10, TLHeights.Scaler div 2)]);
        rt.Left := ps;
        rt.Top := 0;
        rt.Right := cv.ClipRect.Right;
        rt.Bottom := TLHeights.Height - TLHeights.Review;
        cv.CopyRect(rt, imgTimelines.Canvas, rt);

        cv.Brush.Style := bsClear;
        cv.Font.Color := SmoothColor(clWhite, 8);
        s := FramesToShortStr(TLParameters.Finish - TLParameters.ZeroPoint);
        SetClipTimeParameters;
        cv.TextOut(ps + 2, (TLHeights.Scaler - cv.TextHeight(s)) div 2, s);
        cv.Brush.Style := bsSolid;

        if (EditingEvent <> -1) and (EditingArea <> edCenter) then
        begin
          if (EditingStart >= ps) or (EditingFinish > ps) then
          begin
            rte.Top := TLEditor.Rect.Top - TLHeights.IntervalEdit;
            rte.Bottom := TLEditor.Rect.Bottom;
            if EditingStart >= ps then
              rte.Left := EditingStart
            else
              rte.Left := ps;
            rte.Right := EditingFinish;
            cv.Brush.Style := bsClear;
            cv.CopyRect(rte, imgLayer0.Canvas, rte);
            cv.Brush.Style := bsSolid;
          end;
        end;

        // cv.Pen.Mode:=pmMerge;
        // cv.Brush.Color:=SmoothColor(clBlack,20);
        // cv.Pen.Color:=SmoothColor(clBlack,20);
        // cv.Rectangle(rt);

        // cv.Brush.Style:=bsClear;
        if TLParameters.vlcmode <> play then
        begin
          if TLZone.TLEditor.TypeTL = tldevice then
          begin
            pstl := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.TLEditor.Count > 0 then
            begin
              if TLParameters.Finish > TLZone.TLEditor.Events
                [TLZone.TLEditor.Count - 1].Finish then
                TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Finish :=
                  TLParameters.Finish;
              if TLParameters.Finish < TLZone.TLEditor.Events
                [TLZone.TLEditor.Count - 1].Finish then
              begin
                if TLParameters.Finish >
                  (TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Start +
                  TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].SafeZone)
                then
                  TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Finish :=
                    TLParameters.Finish
                else
                  TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Finish :=
                    (TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Start +
                    TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].SafeZone);
              end;
              TLZone.Timelines[pstl].Events[TLZone.TLEditor.Count - 1].Finish :=
                TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Finish;
              pstl := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
              ps := TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame);
              // TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, ps);
              TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
              TLZone.Timelines[pstl].DrawTimeline(bmptimeline.Canvas, pstl, ps);
            end;
          end;
        end;

        cv.Pen.Mode := pmMerge;
        cv.Brush.Color := SmoothColor(clBlack, 20);
        cv.Pen.Color := SmoothColor(clBlack, 20);
        cv.Rectangle(rt);
      end;
      cv.Brush.Color := cbr;
      cv.Pen.Color := cpn;
      cv.Pen.Width := wpn;
      cv.Brush.Style := sbr;
      cv.Pen.Mode := mpn;
    finally
      cv.Unlock;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.DrawCursorEnd | ' + E.Message);
  end;
end;

function TTLZone.MouseInStartCursor(cv: tcanvas; X, Y: integer): boolean;
var
  ps: longint;
begin
  result := false;
  ps := (TLParameters.Start - TLParameters.ScreenStartFrame) *
    TLParameters.FrameSize;
  if (X >= ps - 2) and (X <= ps + 8) then
    result := true;
end;

function TTLZone.MouseInEndCursor(cv: tcanvas; X, Y: integer): boolean;
var
  ps: longint;
begin
  result := false;
  ps := (TLParameters.Finish - TLParameters.ScreenStartFrame) *
    TLParameters.FrameSize;
  if (X >= ps - 8) and (X <= ps + 1) then
    result := true;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Вспомогательные процедуры и функции для отрисовки зоны тайм-линий
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure DrawZoneTimeline(cv: tcanvas; Rect: TRect);
var
  rt: TRect;
begin
  try
    cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
    rt.Left := Rect.Left;
    rt.Right := Rect.Left + TLParameters.Preroll * TLParameters.FrameSize;
    rt.Top := Rect.Top;
    rt.Bottom := Rect.Bottom;
    cv.FillRect(rt);

    cv.Brush.Color := TLParameters.ForeGround;
    rt.Left := rt.Right;
    rt.Right := rt.Right + TLParameters.Duration * TLParameters.FrameSize;
    cv.FillRect(rt);

    cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
    rt.Left := rt.Right;
    rt.Right := Rect.Right;
    cv.FillRect(rt);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.DrawZoneTimeline | ' + E.Message);
  end;
end;

procedure DrawPartZoneTimeline(cv: tcanvas; Rect: TRect; StartPos: longint);
var
  rt: TRect;
  ps: longint;
begin
  try
    rt.Top := Rect.Top;
    rt.Bottom := Rect.Bottom;
    rt.Left := StartPos * TLParameters.FrameSize;
    if rt.Left < TLParameters.Preroll * TLParameters.FrameSize then
    begin
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
      rt.Right := TLParameters.Preroll * TLParameters.FrameSize;
      cv.FillRect(rt);
      cv.Brush.Color := TLParameters.ForeGround;
      rt.Left := TLParameters.Preroll * TLParameters.FrameSize;
      rt.Right := rt.Right;
      cv.FillRect(rt);
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
      rt.Left := rt.Right;
      rt.Right := Rect.Right;
      cv.FillRect(rt);
    end
    else if rt.Left < (TLParameters.Preroll + TLParameters.Duration) *
      TLParameters.FrameSize then
    begin
      cv.Brush.Color := TLParameters.ForeGround;
      rt.Right := (TLParameters.Preroll + TLParameters.Duration) *
        TLParameters.FrameSize;
      cv.FillRect(rt);
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
      rt.Left := rt.Right;
      rt.Right := Rect.Right;
      cv.FillRect(rt);
    end
    else
    begin
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
      rt.Right := Rect.Right;
      cv.FillRect(rt);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.DrawPartZoneTimeline | ' + E.Message);
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLParametrs отвечает за параметры отрисовки зоны тайм-линий
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLParameters.Create;
begin
  inherited;
  BackGround := TLBackGround;;
  ForeGround := SmoothColor(TLZoneNamesColor, 16);
  MaxFrameSize := 10;
  FrameSize := 5;
  Start := 0;
  Finish := 0;
  MyCursor := 100;
  ScreenStart := 0;
  ScreenEnd := 0;
  Preroll := 250;
  Postroll := 3000;
  Duration := 0;
  lrTransperent0 := clWhite;
  lrTransperent1 := clWhite;
  lrTransperent2 := clWhite;
  Position := 257;
  ScreenStartFrame := 0;
  ScreenEndFrame := 0;
  ZeroPoint := 0;
  StopPosition := 0;
  EndPoint := Preroll + Duration;
  Scaler := 1;
end;

Destructor TTLParameters.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@ForeGround);
  FreeMem(@MaxFrameSize);
  FreeMem(@FrameSize);
  FreeMem(@Start);
  FreeMem(@Finish);
  FreeMem(@MyCursor);
  FreeMem(@ScreenStart);
  FreeMem(@ScreenEnd);
  FreeMem(@Preroll);
  FreeMem(@Postroll);
  FreeMem(@Duration);
  FreeMem(@lrTransperent0);
  FreeMem(@lrTransperent1);
  FreeMem(@lrTransperent2);
  FreeMem(@Position);
  FreeMem(@Scaler);
  FreeMem(@StopPosition);
  FreeMem(@ScreenStartFrame);
  FreeMem(@ScreenEndFrame);
  FreeMem(@ZeroPoint);
  FreeMem(@EndPoint);
  inherited;
end;

procedure TTLParameters.SetScreenBoanders;
begin
  TLParameters.ScreenStart := TLParameters.Position * TLParameters.FrameSize -
    TLParameters.MyCursor;
  TLParameters.ScreenEnd := TLParameters.ScreenStart + form1.imgTimelines.Width;
  TLParameters.ScreenStartFrame :=
    Round(TLParameters.ScreenStart / TLParameters.FrameSize);
  TLParameters.ScreenEndFrame :=
    Round(TLParameters.ScreenEnd / TLParameters.FrameSize);

end;

procedure TTLParameters.InitParameters;
begin
  try
    BackGround := TLBackGround;;
    ForeGround := SmoothColor(TLZoneNamesColor, 16);
    MaxFrameSize := TLMaxFrameSize;
    // Preroll := TLPreroll;
    // Postroll := TLPostroll;
    ZeroPoint := Preroll;
    EndPoint := Preroll + Duration;
    if Start = 0 then
      Start := ZeroPoint;
    if Finish = 0 then
      Finish := EndPoint;
    Position := Start;
    SetScreenBoanders;
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLParameters.InitParameters');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLParameters.InitParameters | ' +
        E.Message);
  end;
end;

procedure TTLParameters.UpdateParameters;
begin
  try
    BackGround := TLBackGround;;
    ForeGround := SmoothColor(TLZoneNamesColor, 16);
    MaxFrameSize := TLMaxFrameSize;
    // Preroll := TLPreroll;
    // Postroll := TLPostroll;
    EndPoint := Preroll + Duration;
    if Start < Preroll then
      Start := Preroll;
    if ZeroPoint < Preroll then
      ZeroPoint := Preroll;
    SetScreenBoanders;
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLParameters.UpdateParameters');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLParameters.UpdateParameters | ' +
        E.Message);
  end;
end;

Procedure TTLParameters.WriteToStream(F: tStream);
begin
  try
    F.WriteBuffer(BackGround, SizeOf(BackGround));
    F.WriteBuffer(ForeGround, SizeOf(ForeGround));
    F.WriteBuffer(FrameSize, SizeOf(FrameSize));
    F.WriteBuffer(Start, SizeOf(Start));
    F.WriteBuffer(Finish, SizeOf(Finish));
    F.WriteBuffer(ZeroPoint, SizeOf(ZeroPoint));
    F.WriteBuffer(MyCursor, SizeOf(MyCursor));
    F.WriteBuffer(ScreenStart, SizeOf(ScreenStart));
    F.WriteBuffer(ScreenEnd, SizeOf(ScreenEnd));
    F.WriteBuffer(Duration, SizeOf(Duration));
    F.WriteBuffer(EndPoint, SizeOf(EndPoint));
    F.WriteBuffer(Position, SizeOf(Position));
    F.WriteBuffer(ScreenStartFrame, SizeOf(ScreenStartFrame));
    F.WriteBuffer(ScreenEndFrame, SizeOf(ScreenEndFrame));
    F.WriteBuffer(StopPosition, SizeOf(StopPosition));
    F.WriteBuffer(Scaler, SizeOf(Scaler));
    F.WriteBuffer(Preroll, SizeOf(Preroll));
    F.WriteBuffer(Postroll, SizeOf(Postroll));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLParameters.WriteToStream | ' +
        E.Message);
  end;
end;

Procedure TTLParameters.ReadFromStream(F: tStream);
var
  mr: longint;
begin
  try
    F.ReadBuffer(BackGround, SizeOf(BackGround));
    F.ReadBuffer(ForeGround, SizeOf(ForeGround));
    F.ReadBuffer(FrameSize, SizeOf(FrameSize));
    F.ReadBuffer(Start, SizeOf(Start));
    F.ReadBuffer(Finish, SizeOf(Finish));
    F.ReadBuffer(ZeroPoint, SizeOf(ZeroPoint));
    F.ReadBuffer(mr, SizeOf(mr));
    // F.ReadBuffer(MyCursor, SizeOf(MyCursor));
    F.ReadBuffer(ScreenStart, SizeOf(ScreenStart));
    F.ReadBuffer(ScreenEnd, SizeOf(ScreenEnd));
    F.ReadBuffer(Duration, SizeOf(Duration));
    F.ReadBuffer(EndPoint, SizeOf(EndPoint));
    F.ReadBuffer(Position, SizeOf(Position));
    F.ReadBuffer(ScreenStartFrame, SizeOf(ScreenStartFrame));
    F.ReadBuffer(ScreenEndFrame, SizeOf(ScreenEndFrame));
    F.ReadBuffer(StopPosition, SizeOf(StopPosition));
    F.ReadBuffer(Scaler, SizeOf(Scaler));
    F.ReadBuffer(Preroll, SizeOf(Preroll));
    F.ReadBuffer(Postroll, SizeOf(Postroll));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLParameters.ReadFromStream | ' +
        E.Message);
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLTimeline отвечает за отрисовку области шкалы времени
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLTimeline.Create;
begin
  inherited;
  IDTimeline := -1;
  Block := false;
  Status := 4;
  TypeTL := tldevice;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  Count := 0;
end;

Destructor TTLTimeline.Destroy;
begin
  FreeMem(@IDTimeline);
  FreeMem(@Block);
  FreeMem(@Status);
  FreeMem(@TypeTL);
  FreeMem(@Rect);
  FreeMem(@Count);
  FreeMem(@Events);
  inherited;
end;

function TTLTimeline.AddEvent(Position: longint; psgrd, psclr: integer)
  : integer;
begin
  Count := Count + 1;
  setlength(Events, Count);
  Events[Count - 1] := TMyEvent.Create;
  // Events[Count-1].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevColors[psclr];
  // Events[Count-1]:=(Form1.GridTimeLines.Objects[0,psgrid] as TTimelineOptions).DevColors[psclr];
  Events[Count - 1].Start := Position;
  result := Count - 1;
end;

function TTLTimeline.FindEventID(IdEvent: longint): integer;
var
  i: integer;
begin
  try
    result := -1;
    for i := 0 to Count - 1 do
    begin
      if Events[i].IdEvent = IdEvent then
      begin
        result := i;
        exit;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.FindEventID | ' + E.Message);
  end;
end;

function TTLTimeline.FindEvent(Position: longint): integer;
var
  i: integer;
begin
  try
    result := -1;
    for i := 0 to Count - 1 do
    begin
      if (Events[i].Start >= Position) and (Position < Events[i].Finish) then
      begin
        result := i;
        exit;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.FindEvent | ' + E.Message);
  end;
end;

procedure TTLTimeline.DeleteID(IdEvent: longint);
var
  i, ps: integer;
begin
  try
    ps := FindEventID(IdEvent);
    if ps = -1 then
      exit;
    if ps = Count - 1 then
    begin
      Events[ps].FreeInstance;
      Count := Count - 1;
      setlength(Events, Count);
      exit;
    end;
    for i := ps to Count - 2 do
      Events[i].Assign(Events[i + 1]);
    Events[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(Events, Count);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.DeleteID | ' + E.Message);
  end;
end;

procedure TTLTimeline.Delete(Position: longint);
var
  i, ps: integer;
begin
  try
    ps := FindEvent(Position);
    if ps = -1 then
      exit;
    if ps = Count - 1 then
    begin
      Events[ps].FreeInstance;
      Count := Count - 1;
      setlength(Events, Count);
      exit;
    end;
    for i := ps to Count - 2 do
      Events[i].Assign(Events[i + 1]);
    Events[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(Events, Count);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.Delete | ' + E.Message);
  end;
end;

procedure TTLTimeline.Clear;
var
  i: integer;
begin
  try
    For i := Count - 1 downto 0 do
    begin
      Events[i].Clear;
      Events[i].FreeInstance;
    end;
    Count := 0;
    setlength(Events, Count);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.Clear | ' + E.Message);
  end;
end;

procedure TTLTimeline.Assign(ListEvents: TTLTimeline);
var
  i: integer;
begin
  try
    IDTimeline := ListEvents.IDTimeline;
    Block := ListEvents.Block;
    Status := ListEvents.Status;
    TypeTL := ListEvents.TypeTL;
    Clear;
    for i := 0 to ListEvents.Count - 1 do
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      Events[Count - 1].Assign(ListEvents.Events[i]);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.Assign | ' + E.Message);
  end;
end;

Procedure TTLTimeline.DrawDeviceTimeline(cv: tcanvas; EPos: integer);
var
  i, rw, pfr, st, xp, yp, arglen: integer;
  rt, rtfr: TRect;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    for i := EPos to Count - 1 do
    begin
      Events[i].SetRectAreas(tldevice);
      rt.Right := Rect.Left + Events[i].Finish * TLParameters.FrameSize;;
      rt.Top := Rect.Top + 8;
      rt.Bottom := Rect.Bottom - 2;
      rt.Left := Rect.Left + Events[i].Start * TLParameters.FrameSize;

      cv.Brush.Style := bsSolid;
      cv.Brush.Color := Events[i].Color;
      cv.FillRect(rt);

      cv.Brush.Color := SmoothColor(Events[i].Color, 16);
      cv.Pen.Color := SmoothColor(Events[i].Color, 32);

      if Events[i].PhraseIsVisible('Duration') then
      begin
        arglen := Events[i].ReadPhraseData('Duration') * TLParameters.FrameSize;
        if arglen > rt.Right - rt.Left then
          arglen := rt.Right - rt.Left;
        cv.Polygon([Point(rt.Left, rt.Top + 1), Point(rt.Left, rt.Bottom - 1),
          Point(rt.Left + arglen, rt.Bottom - 1)]);
      end;
      cv.Font.Size := Events[i].FontSize - 2;
      cv.Font.Name := Events[i].FontName;
      cv.Font.Color := Events[i].FontColor;

      for pfr := 0 to Events[i].Rows[0].Count - 1 do
      begin
        xp := rt.Left + Events[i].Rows[0].Phrases[pfr].Rect.Left;
        yp := rt.Top + (rt.Bottom - rt.Top - cv.TextHeight('0')) div 2;
        // Events[i].Rows[0].Phrases[pfr].Rect.Top;
        cv.Brush.Style := bsClear;
        rtfr.Left := rt.Left + Events[i].Rows[0].Phrases[pfr].Rect.Left;
        rtfr.Top := rt.Top + Events[i].Rows[0].Phrases[pfr].Rect.Top;
        rtfr.Right := rt.Left + Events[i].Rows[0].Phrases[pfr].Rect.Right;
        if (rw = 0) or (rtfr.Right > rt.Right) then
          rtfr.Right := rt.Right - Events[i].SafeZone;
        rtfr.Bottom := rt.Top + Events[i].Rows[0].Phrases[pfr].Rect.Bottom;
        cv.TextRect(rtfr, xp, yp, Events[i].Rows[0].Phrases[pfr].Text);
      end;
    end;

    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.DrawDeviceTimeline | ' +
        E.Message);
  end;
end;

procedure TTLTimeline.DrawTextTimeline(cv: tcanvas; EPos: integer);
var
  rt, rts: TRect;
  txt: string;
  i, cnt, stp, ps: integer;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    ps := TLZone.FindTimeline(IDTimeline);
    rt.Top := Rect.Top + 3;
    rt.Bottom := Rect.Bottom - 3;
    for i := EPos to Count - 1 do
    begin
      rt.Left := Rect.Left + Events[i].Start * TLParameters.FrameSize;
      rt.Right := Rect.Left + Events[i].Finish * TLParameters.FrameSize;
      cv.Brush.Style := bsClear;
      cv.Brush.Color := (form1.GridTimeLines.Objects[0, ps + 1]
        as TTimelineOptions).TextColor;
      cv.FillRect(rt);

      cv.Font.Color := Events[i].FontColor;
      cv.Font.Size := Events[i].FontSize;

      txt := Events[i].ReadPhraseText('Text');
      rts.Top := rt.Top + 2;
      rts.Bottom := rt.Bottom - 2;
      rts.Left := rt.Left;
      rts.Right := rt.Right;

      MyTextRect(cv, rts, txt);

      cv.Brush.Color := SmoothColor(clBlack, 24);
      cv.Pen.Color := SmoothColor(clBlack, 24);
      rts.Top := rt.Top + 4;
      rts.Bottom := rt.Bottom - 4;
      rts.Left := rt.Left;
      rts.Right := rt.Left + Events[i].SafeZone;
      cv.Pen.Mode := pmMerge;
      cv.Rectangle(rts);

      rts.Right := rt.Right;
      rts.Left := rt.Right - Events[i].SafeZone;
      cv.Rectangle(rts);
    end;

    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.DrawTextTimeline | ' +
        E.Message);
  end;
end;

Procedure TTLTimeline.DrawMediaTimeline(cv: tcanvas; Color: tcolor;
  EPos: integer);
var
  rt, rtfr: TRect;
  txt: string;
  i, rw, pfr, tp, hgh, yp, xp, fsz, psx: integer;
  cfn, cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;
    cfn := cv.Font.Color;

    rt.Right := Rect.Left + TLParameters.EndPoint * TLParameters.FrameSize;;
    rt.Top := Rect.Top + 4;
    rt.Bottom := Rect.Bottom - 3;
    rt.Left := Rect.Left + TLParameters.Preroll * TLParameters.FrameSize;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := Color;
    cv.FillRect(rt);

    cv.Font.Color := TLZoneNamesFontColor;
    cv.Font.Size := TLZoneNamesFontSize - 4;
    txt := extractfilename(form1.lbPlayerFile.Caption);
    cv.TextOut(rt.Left + 5, rt.Top + (rt.Bottom - rt.Top - cv.TextHeight(txt))
      div 2, txt);

    cv.Pen.Width := 2;
    cv.Pen.Color := TLZone.CRStart;
    cv.MoveTo(rt.Left + (TLParameters.ZeroPoint - TLParameters.Preroll) *
      TLParameters.FrameSize, rt.Top);
    cv.LineTo(rt.Left + (TLParameters.ZeroPoint - TLParameters.Preroll) *
      TLParameters.FrameSize, rt.Bottom);

    for i := 0 to Count - 1 do
    begin
      cv.Brush.Style := bsSolid;
      cv.Pen.Color := Events[i].FontColor;
      psx := Events[i].Start * TLParameters.FrameSize;
      cv.MoveTo(psx, rt.Top);
      cv.LineTo(psx, rt.Bottom);
      cv.Brush.Color := Events[i].FontColor;
      cv.Polygon([Point(psx, rt.Top), Point(psx + 5, rt.Top + 10),
        Point(psx, rt.Top + 20)]);
      cv.Font.Color := Events[i].FontColor;
      cv.Font.Name := Events[i].FontName;
      hgh := (rt.Bottom - rt.Top) div Events[i].Count;
      for rw := 0 to Events[i].Count - 1 do
      begin
        tp := rt.Top + rw * hgh;
        yp := tp;
        for pfr := 0 to Events[i].Rows[rw].Count - 1 do
        begin
          xp := psx + Events[i].SafeZone;
          cv.Brush.Style := bsClear;
          rtfr.Left := psx + 10;
          rtfr.Top := tp;
          rtfr.Right := rtfr.Left + Events[i].Rows[rw].Phrases[pfr].Rect.Right;
          rtfr.Bottom := tp + hgh;
          fsz := DefineFontSizeH(cv, rtfr.Bottom - rtfr.Top);
          if fsz < 6 then
            cv.Font.Size := 6
          else
            cv.Font.Size := fsz;
          cv.TextOut(xp, yp, Events[i].Rows[rw].Phrases[pfr].Text);
        end;
        tp := hgh + 1
      end;
    end;

    cv.Font.Color := cfn;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.DrawMediaTimeline | ' +
        E.Message);
  end;
end;

procedure TTLTimeline.DrawTimeline(cv: tcanvas; NomTl: integer; EPos: integer);
var
  i, rw, pfr, st, xp, yp: integer;
  rt: TRect;
  colormedia: tcolor;
begin
  try
    if EPos < 0 then
      EPos := 0;
    if EPos = 0 then
      DrawZoneTimeline(cv, Rect)
    else
      DrawPartZoneTimeline(cv, Rect, Events[EPos].Start);

    case TypeTL of
      tldevice:
        DrawDeviceTimeline(cv, EPos);
      tltext:
        DrawTextTimeline(cv, EPos);
      tlmedia:
        begin
          if fileexists(form1.lbPlayerFile.Caption) then
            colormedia := (form1.GridTimeLines.Objects[0, NomTl + 1]
              as TTimelineOptions).MediaColor
          else
            colormedia := SmoothColor(TLParameters.ForeGround, 64);
          DrawMediaTimeline(cv, colormedia, EPos);
        end;
    end; //
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.DrawTimeline | ' + E.Message);
  end;
end;

Procedure TTLTimeline.WriteToStream(F: tStream);
var
  i: integer;
begin
  try
    F.WriteBuffer(IDTimeline, SizeOf(longint));
    i := ord(TypeTL);
    F.WriteBuffer(i, SizeOf(integer));
    // TypeTL :  TTypeTimeline;
    F.WriteBuffer(Rect.Top, SizeOf(integer));
    F.WriteBuffer(Rect.Bottom, SizeOf(integer));
    F.WriteBuffer(Rect.Left, SizeOf(integer));
    F.WriteBuffer(Rect.Right, SizeOf(integer));
    F.WriteBuffer(Block, SizeOf(Block));
    F.WriteBuffer(Status, SizeOf(Status));
    F.WriteBuffer(Count, SizeOf(integer));
    for i := 0 to Count - 1 do
      Events[i].WriteToStream(F);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.WriteToStream | ' + E.Message);
  end;
end;

Procedure TTLTimeline.ReadFromStream(F: tStream);
var
  i: integer;
begin
  try
    F.ReadBuffer(IDTimeline, SizeOf(longint));
    i := ord(TypeTL);
    F.ReadBuffer(i, SizeOf(integer));
    TypeTL := SetTypeTimeline(i);
    F.ReadBuffer(Rect.Top, SizeOf(integer));
    F.ReadBuffer(Rect.Bottom, SizeOf(integer));
    F.ReadBuffer(Rect.Left, SizeOf(integer));
    F.ReadBuffer(Rect.Right, SizeOf(integer));
    F.ReadBuffer(Block, SizeOf(Block));
    F.ReadBuffer(Status, SizeOf(Status));
    Clear;
    F.ReadBuffer(Count, SizeOf(integer));
    for i := 0 to Count - 1 do
    begin
      setlength(Events, i + 1);
      Events[i] := TMyEvent.Create;
      Events[i].ReadFromStream(F);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLTimeline.ReadFromStream | ' +
        E.Message);
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLEditor отвечает за отрисовку области редактирование тайм-линий
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLEditor.Create;
begin
  inherited;
  Index := 0;
  isZoneEditor := false;
  DoubleClick := false;
  IDTimeline := -1;
  Block := false;
  Status := 4;
  TypeTL := tldevice;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  Count := 0;
end;

Destructor TTLEditor.Destroy;
begin
  FreeMem(@Index);
  FreeMem(@isZoneEditor);
  FreeMem(@DoubleClick);
  FreeMem(@IDTimeline);
  FreeMem(@Block);
  FreeMem(@Status);
  FreeMem(@TypeTL);
  FreeMem(@Rect);
  FreeMem(@Count);
  FreeMem(@Events);
  inherited;
end;

Procedure TTLEditor.Clear;
var
  i: integer;
begin
  try
    For i := Count - 1 downto 0 do
    begin
      Events[i].Clear;
      Events[i].FreeInstance;
    end;
    Count := 0;
    setlength(Events, Count);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.Clear | ' + E.Message);
  end;
end;

Procedure TTLEditor.DeleteEvent(Position: longint);
var
  i: integer;
  Start: longint;
  Finish: longint;
begin
  try
    Start := Events[Position].Start;
    Finish := Events[Position].Finish;
    For i := Position to Count - 2 do
    begin
      Events[i].Assign(Events[i + 1]);
    end;
    Events[Count - 1].Clear;
    Events[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(Events, Count);
    if Count = 0 then
      exit;
    if Position = 0 then
      exit;
    if (TypeTL = tltext) or (TypeTL = tlmedia) then
      exit;
    Events[Position].Start := Start;
    if (Position >= Count - 1) then
    begin
      Events[Count - 1].Finish := TLParameters.Finish;
      exit;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DeleteEvent | ' + E.Message);
  end;
end;

Procedure TTLEditor.Assign(ttl: TTLTimeline; Indx: integer);
var
  i: integer;
begin
  try
    IDTimeline := ttl.IDTimeline;
    Block := ttl.Block;
    Status := ttl.Status;
    TypeTL := ttl.TypeTL;
    Index := Indx;
    Clear;
    for i := 0 to ttl.Count - 1 do
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      Events[Count - 1].Assign(ttl.Events[i]);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.Assign | ' + E.Message);
  end;
end;

procedure TTLEditor.ReturnEvents(ttl: TTLTimeline);
var
  i: integer;
begin
  try
    ttl.Clear;
    for i := 0 to Count - 1 do
    begin
      ttl.Count := ttl.Count + 1;
      setlength(ttl.Events, ttl.Count);
      ttl.Events[ttl.Count - 1] := TMyEvent.Create;
      ttl.Events[ttl.Count - 1].Assign(Events[i]);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.ReturnEvents | ' + E.Message);
  end;
end;

function TTLEditor.InsertDevice(Position: longint): integer;
var
  i, rw: integer;
begin
  try
    if Count = 0 then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      Events[Count - 1].Assign(EventDevice);
      Events[Count - 1].Start := Position;
      Events[Count - 1].Finish := TLParameters.Finish;
      // .Preroll+TLParameters.Duration+TLParameters.Postroll;
      Events[Count - 1].Select := false;
      result := 0;
      exit;
    end;

    if Position < Events[0].Start then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      for i := Count - 1 downto 1 do
        Events[i].Assign(Events[i - 1]);
      // Events[Count-1].Assign(Events[0]);
      Events[0].Assign(EventDevice);
      Events[0].Start := Position;
      Events[0].Finish := Events[1].Start;
      Events[Count - 1].Select := false;
      result := 0;
      exit;
    end;

    for i := 0 to Count - 1 do
    begin
      Events[i].Select := false;
      if Position = Events[i].Start then
      begin
        result := i;
        if i = Count - 1 then
          Events[i].Finish := TLParameters.Finish;
        exit;
      end;
    end;
    rw := -1;
    for i := 0 to Count - 1 do
    begin
      Events[i].Select := false;
      if (Position > Events[i].Start) and (Position < Events[i].Finish) then
      begin
        rw := i;
        break;
      end;
    end;
    if rw = -1 then
      rw := Count - 1;
    Count := Count + 1;
    setlength(Events, Count);
    Events[Count - 1] := TMyEvent.Create;
    for i := Count - 1 downto rw + 1 do
      Events[i].Assign(Events[i - 1]);
    Events[rw].Finish := Position;
    Events[rw + 1].Start := Position;
    Events[Count - 1].Finish := TLParameters.Finish;
    Events[Count - 1].Select := false;
    result := rw + 1;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.InsertDevice | ' + E.Message);
  end;
end;

function TTLEditor.InsertMarker(Position: longint): integer;
var
  i, rw: integer;
begin
  try

    if Count = 0 then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      Events[Count - 1].Assign(EventMedia);
      Events[Count - 1].Start := Position;
      Events[Count - 1].Select := false;
      result := 0;
      exit;
    end;

    if Position < Events[0].Start then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      for i := Count - 1 downto 1 do
        Events[i].Assign(Events[i - 1]);
      Events[0].Assign(EventMedia);
      Events[0].Start := Position;
      Events[Count - 1].Select := false;
      // Events[0].Finish:=Events[1].Start;
      result := 0;
      exit;
    end;

    if (Position >= Events[Count - 1].Start) then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      Events[Count - 1].Assign(EventMedia);
      Events[Count - 1].Start := Position;
      Events[Count - 1].Select := false;
      result := Count - 1;
      exit;
    end;

    rw := -1;
    for i := 0 to Count - 2 do
    begin
      if ((Position >= Events[i].Start) and (Position < Events[i].Finish)) or
        ((Position >= Events[i].Finish) and (Position < Events[i + 1].Start))
      then
      begin
        rw := i + 1;
        break;
      end;
    end;

    Count := Count + 1;
    setlength(Events, Count);
    Events[Count - 1] := TMyEvent.Create;
    if rw = -1 then
      rw := Count - 1;
    for i := Count - 1 downto rw do
      Events[i].Assign(Events[i - 1]);
    Events[rw].Assign(EventMedia);
    Events[rw].Start := Position;
    Events[Count - 1].Select := false;
    result := rw;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.InsertMarker | ' + E.Message);
  end;
end;

function TTLEditor.InsertText(Position: longint): integer;
var
  i, rw: integer;
begin
  try

    if Count = 0 then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      Events[Count - 1].Assign(EventText);
      Events[Count - 1].Start := Position;
      Events[Count - 1].Select := false;
      result := 0;
      exit;
    end;

    if Position < Events[0].Start then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      for i := Count - 1 downto 1 do
        Events[i].Assign(Events[i - 1]);
      Events[0].Assign(EventText);
      Events[0].Start := Position;
      Events[Count - 1].Select := false;
      // Events[0].Finish:=Events[1].Start;
      result := 0;
      exit;
    end;

    if (Position > Events[Count - 1].Start) or
      (Position > Events[Count - 1].Finish) then
    begin
      Count := Count + 1;
      setlength(Events, Count);
      Events[Count - 1] := TMyEvent.Create;
      Events[Count - 1].Assign(EventText);
      Events[Count - 1].Start := Position;
      Events[Count - 1].Select := false;
      result := Count - 1;
      exit;
    end;

    rw := -1;
    for i := 0 to Count - 2 do
    begin
      Events[i].Select := false;
      Events[i + 1].Select := false;
      if ((Position >= Events[i].Start) and (Position < Events[i].Finish)) or
        ((Position >= Events[i].Finish) and (Position < Events[i + 1].Start))
      then
      begin
        rw := i + 1;
        break;
      end;
    end;

    Count := Count + 1;
    setlength(Events, Count);
    Events[Count - 1] := TMyEvent.Create;
    if rw = -1 then
      rw := Count - 1;
    for i := Count - 1 downto rw do
      Events[i].Assign(Events[i - 1]);
    Events[rw].Assign(EventText);
    Events[rw].Start := Position;
    Events[rw].Select := false;
    Events[Count - 1].Select := false;
    result := rw;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.InsertText | ' + E.Message);
  end;
end;

function TTLEditor.AddEvent(Position: longint; psgrd, psclr: integer): integer;
var
  ARow: integer;
  frm: longint;
begin
  try
    // AllSelectFalse;
    case TypeTL of
      tldevice:
        begin
          ARow := InsertDevice(Position);
          Events[ARow].SetEvents((form1.GridTimeLines.Objects[0,
            psgrd] as TTimelineOptions).DevEvents[psclr]);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if trim(Events[ARow].ReadPhraseText('Command'))='' then begin
            Events[ARow].SetPhraseText('Command',DefaultTransition);
            if trim(DefaultTransition)='Cut' then begin
              Events[ARow].SetPhraseData('Duration',0);
              Events[ARow].SetPhraseVisible('Duration',false);
              Events[ARow].SetPhraseData('Set',0);
              Events[ARow].SetPhraseVisible('Set',false);
            end else begin
              Events[ARow].SetPhraseData('Duration',DefTransDuration);
              Events[ARow].SetPhraseData('Set',DefTransSet);
              if trim(DefaultTransition)='Mix' then begin
                Events[ARow].SetPhraseVisible('Duration',true);
                Events[ARow].SetPhraseVisible('Set',false);
              end else begin
                Events[ARow].SetPhraseVisible('Duration',true);
                Events[ARow].SetPhraseVisible('Set',true);
              end;
            end;
          end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          result := ARow;
          AllSelectFalse;
        end;
      tltext:
        begin
          ARow := InsertText(Position);
          Events[ARow].SetEvents((form1.GridTimeLines.Objects[0,
            psgrd] as TTimelineOptions).TextEvent);
          Events[ARow].SetPhraseText('Text', Trim(form1.RichEdit1.Text));
          if Trim(form1.RichEdit1.Text) = '' then
          begin
            Events[ARow].Finish := Events[ARow].Start +
              (form1.GridTimeLines.Objects[0, psgrd] as TTimelineOptions)
              .EventDuration;
          end
          else
          begin
            frm := trunc(length(Trim(form1.RichEdit1.Text)) *
              (form1.GridTimeLines.Objects[0, psgrd] as TTimelineOptions)
              .CharDuration / 40);
            Events[ARow].Finish := Events[ARow].Start + frm;
          end;
          result := ARow;
        end;
      tlmedia:
        begin
          ARow := InsertMarker(Position);
          Events[ARow].Finish := Events[ARow].Start + Events[ARow]
            .SafeZone + 50;
          Events[ARow].SetEvents((form1.GridTimeLines.Objects[0,
            psgrd] as TTimelineOptions).MediaEvent);
          result := ARow;
        end;
    end; // case
    // AllSelectFalse;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.AddEvent | ' + E.Message);
  end;
end;

procedure TTLEditor.MouseClick(cv: tcanvas; X, Y: integer);
var
  i: integer;
  lft, rth: longint;

begin
  for i := 0 to Count - 1 do
  begin
    rth := Rect.Left + Events[i].Finish * TLParameters.FrameSize;
    lft := Rect.Left + Events[i].Start * TLParameters.FrameSize;
    if (X >= lft) and (X <= rth) and (Y <= Rect.Top) and (Y >= Rect.Bottom) then
    begin
      Events[i].Editing := not Events[i].Editing;
    end;
  end;
end;

function TTLEditor.FindEventPos(evframe: longint): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if (evframe >= Events[i].Start) and (evframe <= Events[i].Finish) then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TTLEditor.FirstScreenEvent: integer;
var
  i: integer;
begin

  result := 0;
  if Count <= 0 then
    exit;
  if (TLParameters.ScreenStartFrame <= Events[0].Finish) then
    exit;
  for i := 0 to Count - 2 do
  begin
    if (TLParameters.ScreenStartFrame >= Events[i].Finish) and
      (TLParameters.ScreenStartFrame <= Events[i + 1].Start) then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TTLEditor.LastScreenEvent: integer;
var
  i: integer;
begin
  if Count <= 0 then
  begin
    result := 0;
    exit;
  end;
  result := Count - 1;
  for i := 0 to Count - 2 do
  begin
    if (TLParameters.ScreenEndFrame >= Events[i].Start) and
      (TLParameters.ScreenEndFrame <= Events[i + 1].Start) then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure TTLEditor.AllSelectFalse;
var
  ev, i, j: integer;
begin
  for ev := 0 to Count - 1 do
    for i := 0 to Events[ev].Count - 1 do
      for j := 0 to Events[ev].Rows[i].Count - 1 do
        Events[ev].Rows[i].Phrases[j].Select := false;
end;

procedure TTLEditor.EventsSelectFalse;
var
  ev, i, j: integer;
begin
  for ev := 0 to Count - 1 do
    Events[ev].Select := false;
end;

procedure TTLEditor.MouseMove(cv: tcanvas; X, Y: integer);
var
  i, j, ph: integer;
  lfts, rths, lft, rth, Top, btm, tpp, psx, psf, l1, r1: longint;
  s: string;
  rt: TRect;
  strt, fnsh: longint;
begin
  try
    TLParameters.SetScreenBoanders;
    for i := 0 to Count - 1 do
    begin
      if Events[i].Finish <= TLParameters.ScreenStartFrame then
        continue;
      if Events[i].Start >= TLParameters.ScreenEndFrame then
        exit;
      lft := Events[i].Start * TLParameters.FrameSize -
        TLParameters.ScreenStart;
      lfts := lft;
      if lft < 0 then
        lfts := 0;
      rth := Events[i].Finish * TLParameters.FrameSize -
        TLParameters.ScreenStart;
      rths := rth;
      if rth > TLParameters.ScreenEnd then
        rths := TLParameters.ScreenEnd;
      s := inttostr(psf);
      tpp := TLHeights.Scaler + TLHeights.IntervalEdit;
      if (X >= lfts) and (X <= rths) then
      begin
        Events[i].SetRectAreas(TypeTL);

        for j := 0 to Events[i].Count - 1 do
        begin
          for ph := 0 to Events[i].Rows[j].Count - 1 do
          begin
            Top := tpp + Events[i].Rows[j].Phrases[ph].Rect.Top;
            btm := tpp + Events[i].Rows[j].Phrases[ph].Rect.Bottom;
            l1 := lft + Events[i].Rows[j].Phrases[ph].Rect.Left;
            r1 := lft + Events[i].Rows[j].Phrases[ph].Rect.Right;
            if (X >= l1) and (X <= r1) and (Y >= Top) and (Y <= btm) then
            begin
              Events[i].Rows[j].Phrases[ph].Select := true;
              exit;
            end;
          end;
        end;
        exit;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.MouseMove | ' + E.Message);
  end;
end;

function TTLEditor.CurrentEvents: TEventReplay;
var
  i: integer;
begin
  try
    result.Number := -1;
    result.SafeZone := false;
    result.Image := '';
    for i := 0 to Count - 1 do
    begin
      if Events[i].Start > TLParameters.Position then
        exit;
      if Events[i].Finish < TLParameters.Position then
        continue;
      if (Events[i].Start <= TLParameters.Position) and
        (Events[i].Finish > TLParameters.Position) then
      begin
        result.Number := i;
        if (Events[i].Start <= TLParameters.Position) and
          (Events[i].Start + TLFlashDuration > TLParameters.Position) then
          result.SafeZone := true;
        result.Image := Events[i].ReadPhraseCommand('Text');
        exit;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.CurrentEvents | ' + E.Message);
  end;
end;

procedure TTLEditor.DrawEditorDeviceEvent(evnt: TMyEvent; cv: tcanvas;
  TLRect: TRect; lr: boolean);
var
  rt, rts, rtf, rtfr, rtdur: TRect;
  i, rw, ev, pfr, hh, tp, bt, st, fn: integer;
  // psx, psy : integer;
  xp, yp, arglen: integer;
  txt, tpdt, txt1, flnm: string;
  cbr, cpn, ctm: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    // cv.Font.Size:=evnt.FontSize;
    cv.Font.Name := evnt.FontName;

    rt.Top := TLRect.Top;
    rt.Bottom := TLRect.Bottom;
    cv.Font.Color := evnt.FontColor;
    if lr then
    begin
      // cv.Font.Color:=smoothcolor(evnt.FontColor,4);
      if evnt.FontColor = TLParameters.lrTransperent0 then
        cv.Font.Color := SmoothColor(evnt.FontColor, 4);
      if EditingFinish > EditingStart then
      begin
        rt.Right := TLRect.Left + EditingFinish;
        rt.Left := TLRect.Left + EditingStart;
      end
      else
      begin
        rt.Right := TLRect.Left + EditingStart;
        rt.Left := TLRect.Left + EditingFinish;
      end; // TLParameters.ScreenStart + TLParameters.MyCursor
      txt1 := FramesToShortStr(Round((TLParameters.ScreenStart + rt.Left) /
        TLParameters.FrameSize) - TLParameters.ZeroPoint) + ' (' +
        FramesToShortStr(Round((rt.Right - rt.Left) /
        TLParameters.FrameSize)) + ')';
    end
    else
    begin
      // cv.Font.Color:=evnt.FontColor;
      rt.Right := TLRect.Left + evnt.Finish * TLParameters.FrameSize;
      // Rect.Right;
      rt.Left := TLRect.Left + evnt.Start * TLParameters.FrameSize;
      txt1 := FramesToShortStr(evnt.Start - TLParameters.ZeroPoint) + ' (' +
        FramesToShortStr(evnt.Finish - evnt.Start) + ')';
    end;

    rtdur.Left := rt.Left + 5;
    rtdur.Right := rt.Right - 5;
    // TLRect.Left + (evnt.Finish-TLParameters.ScreenStartFrame) * TLparameters.FrameSize;
    rtdur.Bottom := TLRect.Top;
    rtdur.Top := rtdur.Bottom - TLHeights.IntervalEdit;

    cv.Brush.Style := bsSolid; // Form1.ImgLayer0.Canvas
    cv.Brush.Color := TLBackGround;
    ctm := cv.Font.Color;
    cv.Font.Color := SmoothColor(clWhite, 8);
    // cv.FillRect(rtdur);
    cv.Font.Size := DefineFontSizeH(cv, rtdur.Bottom - rtdur.Top);
    cv.TextRect(rtdur, rt.Left + 5, rtdur.Top + 1, txt1);
    cv.Font.Color := ctm;

    evnt.SetRectAreas(tldevice);

    cv.Brush.Style := bsSolid;
    cv.Brush.Color := evnt.Color;
    cv.FillRect(rt);

    cv.Brush.Color := SmoothColor(evnt.Color, 16);
    cv.Pen.Color := SmoothColor(evnt.Color, 32);
    cv.Pen.Width := 1;

    if evnt.PhraseIsVisible('Duration') then
    begin
      arglen := evnt.ReadPhraseData('Duration') * TLParameters.FrameSize;
      if arglen > rt.Right - rt.Left then
        arglen := rt.Right - rt.Left;
      cv.Polygon([Point(rt.Left, rt.Top + 1), Point(rt.Left, rt.Bottom - 1),
        Point(rt.Left + arglen, rt.Bottom - 1)]);
    end;

    rts.Left := rt.Left;
    rts.Right := rt.Left + evnt.SafeZone;
    rts.Top := rt.Top;
    rts.Bottom := rt.Bottom;
    cv.Brush.Color := SmoothColor(evnt.Color, 32);
    cv.Pen.Color := SmoothColor(evnt.Color, 40);
    cv.Pen.Width := 1;
    cv.Rectangle(rts);

    cv.Brush.Color := evnt.Color;

    for rw := 0 to evnt.Count - 1 do
    begin
      cv.Font.Size := evnt.FontSize - 2;
      cv.Font.Name := evnt.FontName;
      // cv.Font.Color:=evnt.FontColor;
      for pfr := 0 to evnt.Rows[rw].Count - 1 do
      begin
        xp := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
        yp := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        if not(evnt.Rows[rw].Phrases[pfr].visible) then
          continue;
        if (evnt.Rows[rw].Phrases[pfr].Select) and
          (evnt.Rows[rw].Phrases[pfr].visible) then
        begin
          cv.Brush.Color := SmoothColor(evnt.Color, 48);
          rtfr.Left := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
          rtfr.Top := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
          rtfr.Right := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
          if rtfr.Right > rt.Right then
            rtfr.Right := rt.Right;
          rtfr.Bottom := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
          cv.FillRect(rtfr); // Events[i].Rows[rw].Phrases[pfr].Rect);
        end;
        if rw = 0 then
          cv.Font.Size := evnt.FontSize
        else
          cv.Font.Size := evnt.FontSizeSub;
        cv.Brush.Style := bsClear;
        rtfr.Left := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
        rtfr.Top := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        rtfr.Right := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
        if (rw = 0) or (rtfr.Right > rt.Right) then
          rtfr.Right := rt.Right - evnt.SafeZone;
        rtfr.Bottom := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
        tpdt := Trim(lowercase(evnt.Rows[rw].Phrases[pfr].WorkData));
        if (tpdt = 'data') or (tpdt = 'integer') then
          cv.TextRect(rtfr, xp, yp, inttostr(evnt.Rows[rw].Phrases[pfr].Data))
        else if tpdt = 'device' then
        begin
          flnm := evnt.ReadPhraseCommand('Text');
          if Trim(flnm) <> '' then
            cv.TextRect(rtfr, xp, yp, evnt.Rows[rw].Phrases[pfr].Text + '*')
          else
            cv.TextRect(rtfr, xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
        end
        else if (tpdt = 'tag') then
          cv.TextRect(rtfr, xp, yp, inttostr(evnt.Rows[rw].Phrases[pfr].Tag))
        else if (tpdt = 'timecode') or (tpdt = 'shorttimecode') then
          cv.TextRect(rtfr, xp, yp,
            FramesToShortStr(evnt.Rows[rw].Phrases[pfr].Data))
        else if (tpdt = 'command') then
          cv.TextRect(rtfr, xp, yp, evnt.Rows[rw].Phrases[pfr].Command)
        else
          cv.TextRect(rtfr, xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
      end;
    end;
    if evnt.Select then
    begin
      cv.Brush.Style := bsClear;
      cv.Pen.Width := 4;
      if lr then
      begin
        if TLParameters.lrTransperent0 = clWhite then
          cv.Pen.Color := SmoothColor(clWhite, 4);
      end
      else
        cv.Pen.Color := clWhite;

      cv.Rectangle(rt.Left + 2, rt.Top + 2, rt.Right - 2, rt.Bottom - 2);
    end;

    cv.Refresh;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DrawEditorDeviceEvent| ' +
        E.Message);
  end;
end;

procedure TTLEditor.UpdateScreenDevice(cv: tcanvas);
var
  rt, rts, rtf, rtfr, rtdur: TRect;
  i, rw, ev, pfr, hh, tp, bt, st, fn: integer;
  xp, yp, arglen: integer;
  txt: string;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
  evnt: TMyEvent;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    // if EPos<=0 then rtdur.Left:=Rect.Left
    // else rtdur.Left:=Events[EPos].Start * TLParameters.FrameSize;

    rtdur.Left := TLParameters.ScreenStart;
    rtdur.Right := TLParameters.ScreenEnd;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Top - TLHeights.IntervalEdit;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := TLBackGround;
    cv.FillRect(rtdur);

    rtdur.Left := TLParameters.ScreenStart;
    rtdur.Right := TLParameters.ScreenEnd;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Bottom;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := TLParameters.ForeGround;
    cv.FillRect(rtdur);

    if (TLParameters.Preroll + TLParameters.Duration) >= TLParameters.Finish
    then
      rtdur.Left := (TLParameters.Preroll + TLParameters.Duration) *
        TLParameters.FrameSize
    else
      rtdur.Left := TLParameters.Finish * TLParameters.FrameSize;
    rtdur.Right := Rect.Right;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Bottom;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
    cv.FillRect(rtdur);

    if TLParameters.ScreenStartFrame <= TLParameters.Preroll then
    begin
      rtdur.Left := 0;
      rtdur.Right := TLParameters.Preroll * TLParameters.FrameSize;
      rtdur.Bottom := Rect.Top;
      rtdur.Top := Rect.Bottom;
      cv.Brush.Style := bsSolid;
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
      cv.FillRect(rtdur);
    end;

    for i := 0 to Count - 1 do
    begin
      if i = Count - 1 then
      begin
        DrawEditorDevice(cv, Count - 1);
        break;
      end;
      if Events[i].Finish < TLParameters.ScreenStartFrame then
        continue;
      if Events[i].Start > TLParameters.ScreenEndFrame then
        exit;
      if (EditingEvent = i) and (EditingArea = edStart) then
      begin
        if (i > 0) then
        begin
          if (Events[i - 1].Start * TLParameters.FrameSize) -
            TLParameters.ScreenStart < EditingStart then
          begin
            Events[i - 1].Finish := Events[i].Finish;
            // TLParameters.ScreenStartFrame + trunc(EditingStart / TLParameters.FrameSize) +1;
            DrawEditorDeviceEvent(Events[i - 1], cv, Rect, false);
          end;
        end;
        cv.Refresh;
        DrawEditorDeviceEvent(Events[i], form1.imgLayer0.Canvas, Rect, true);
        // InvalidateRect(form1.imgLayer0.Canvas.Handle, NIL, FALSE ) ;
        form1.imgLayer0.Repaint;
      end
      else
        DrawEditorDeviceEvent(Events[i], cv, Rect, false);
    end;
    cv.Refresh;
    // form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.UpdateScreenDevice | ' +
        E.Message);
  end;
end;

procedure TTLEditor.DrawEditorDevice(cv: tcanvas; EPos: integer);
var
  rt, rts, rtf, rtfr, rtdur: TRect;
  i, rw, ev, pfr, hh, tp, bt, st, fn: integer;
  xp, yp, arglen: integer;
  txt: string;
  cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
  evnt: TMyEvent;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;

    if EPos <= 0 then
      rtdur.Left := Rect.Left
    else
      rtdur.Left := Events[EPos].Start * TLParameters.FrameSize;

    // rtdur.Left:=Rect.Left;
    rtdur.Right := Rect.Right;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Top - TLHeights.IntervalEdit;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := TLBackGround;
    cv.FillRect(rtdur);

    for i := EPos to Count - 1 do
    begin
      if (EditingEvent = i) and (EditingArea = edStart) then
      begin
        if (i > 0) then
        begin
          if (Events[i - 1].Start * TLParameters.FrameSize) -
            TLParameters.ScreenStart < EditingStart then
          begin
            Events[i - 1].Finish := Events[i].Finish;
            // TLParameters.ScreenStartFrame + trunc(EditingStart / TLParameters.FrameSize) +1;
            DrawEditorDeviceEvent(Events[i - 1], cv, Rect, false);
          end;
        end;
        cv.Refresh;
        DrawEditorDeviceEvent(Events[i], form1.imgLayer0.Canvas, Rect, true);
        // InvalidateRect(form1.imgLayer0.Canvas.Handle, NIL, FALSE ) ;
        // form1.imgLayer0.Repaint;
      end
      else
        DrawEditorDeviceEvent(Events[i], cv, Rect, false);
    end;
    cv.Refresh;
    // form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DrawEditorDevice | ' +
        E.Message);
  end;
end;

procedure TTLEditor.DrawEditorTextEvent(evnt: TMyEvent; cv: tcanvas;
  TLRect: TRect; lr: boolean);
var
  rt, rts, rtfr, rtdur: TRect;
  txt, txt1: string;
  i, cnt, stp, ps, rw, pfr, xp, yp: integer;
  cfn, cbr, cpn, subcl, ctm: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;
    cfn := cv.Font.Color;

    cv.Font.Size := evnt.FontSize;
    cv.Font.Name := evnt.FontName;
    cv.Font.Color := evnt.FontColor;
    subcl := TLZoneNamesFontColor;

    rt.Top := TLRect.Top;
    rt.Bottom := TLRect.Bottom;
    txt := evnt.ReadPhraseText('Text');
    cnt := length(txt) * (TLParameters.FrameSize + 1);
    if cnt = 0 then
      cnt := evnt.SafeZone * 5;
    if lr then
    begin
      if EditingFinish - EditingStart < cnt then
        EditingFinish := EditingStart + cnt;
      rt.Right := TLRect.Left + EditingFinish;
      rt.Left := TLRect.Left + EditingStart;
      if evnt.FontColor = TLParameters.lrTransperent0 then
        cv.Font.Color := SmoothColor(evnt.FontColor, 4);
      if TLZoneNamesFontColor = TLParameters.lrTransperent0 then
        subcl := SmoothColor(TLZoneNamesFontColor, 4);
      txt1 := FramesToShortStr(Round((TLParameters.ScreenStart + rt.Left) /
        TLParameters.FrameSize) - TLParameters.ZeroPoint) + ' (' +
        FramesToShortStr(Round((rt.Right - rt.Left) /
        TLParameters.FrameSize)) + ')';
    end
    else
    begin
      rt.Left := TLRect.Left + evnt.Start * TLParameters.FrameSize;
      rt.Right := TLRect.Left + evnt.Finish * TLParameters.FrameSize;
      cv.Font.Color := evnt.FontColor;
      subcl := TLZoneNamesFontColor;
      txt1 := FramesToShortStr(evnt.Start - TLParameters.ZeroPoint) + ' (' +
        FramesToShortStr(evnt.Finish - evnt.Start) + ')';
    end;

    rtdur.Left := rt.Left + 5;
    rtdur.Right := rt.Right - 5;
    // TLRect.Left + (evnt.Finish-TLParameters.ScreenStartFrame) * TLparameters.FrameSize;
    rtdur.Bottom := TLRect.Top;
    rtdur.Top := rtdur.Bottom - TLHeights.IntervalEdit;

    cv.Brush.Style := bsSolid; // Form1.ImgLayer0.Canvas
    cv.Brush.Color := TLBackGround;
    ctm := cv.Font.Color;
    cv.Font.Color := SmoothColor(clWhite, 8);
    cv.Font.Size := DefineFontSizeH(cv, rtdur.Bottom - rtdur.Top);
    cv.TextRect(rtdur, rt.Left + 5, rtdur.Top + 1, txt1);
    cv.Font.Color := ctm;

    cv.Brush.Style := bsSolid;
    cv.Brush.Color := (form1.GridTimeLines.Objects[0, Index]
      as TTimelineOptions).TextColor; { evnt.color;// }
    // TLParameters.ForeGround; //Events[i].Color;
    cv.FillRect(rt);

    for rw := 0 to evnt.Count - 1 do
    begin
      for pfr := 0 to evnt.Rows[rw].Count - 1 do
      begin
        xp := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
        yp := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top + 1;
        if (evnt.Rows[rw].Phrases[pfr].Select) and
          (evnt.Rows[rw].Phrases[pfr].visible) then
        begin
          cv.Brush.Color := SmoothColor(evnt.Color, 48);
          rtfr.Left := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
          rtfr.Top := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
          rtfr.Right := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
          if (rw = 0) or (rtfr.Right > rt.Right) then
            rtfr.Right := rt.Right - evnt.SafeZone;
          rtfr.Bottom := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
          cv.Brush.Style := bsSolid;
          cv.FillRect(rtfr);
        end;
        if rw = 0 then
        begin
          rts.Top := rt.Top + evnt.Rows[0].Phrases[0].Rect.Top; // rt.Top+2;
          rts.Bottom := rt.Top + evnt.Rows[0].Phrases[0].Rect.Bottom;
          // rt.Top + (rt.Bottom-rt.Top) div 2 - 2;
          rts.Left := rt.Left;
          rts.Right := rt.Right;
          // cv.Font.Color:=SmoothColor(clWhite,4);
          cv.Brush.Style := bsSolid;
          MyTextRect(cv, rts, txt);
        end
        else
        begin
          cv.Brush.Style := bsClear;
          rtfr.Left := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
          rtfr.Top := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
          rtfr.Right := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
          if (rw = 0) or (rtfr.Right > rt.Right) then
            rtfr.Right := rt.Right - evnt.SafeZone;
          rtfr.Bottom := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
          cv.TextRect(rtfr, xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
        end;
      end;
      cv.Font.Size := evnt.FontSizeSub;
      cv.Font.Color := subcl;
    end;

    cv.Brush.Color := SmoothColor(clBlack, 24);
    cv.Pen.Color := SmoothColor(clBlack, 8);
    rts.Top := rt.Top;
    rts.Bottom := rt.Bottom;
    rts.Left := rt.Left;
    rts.Right := rt.Left + evnt.SafeZone;
    cv.Pen.Mode := pmMerge;
    cv.Rectangle(rts);

    rts.Right := rt.Right;
    rts.Left := rt.Right - evnt.SafeZone;
    cv.Rectangle(rts);

    if evnt.Select then
    begin
      cv.Brush.Style := bsClear;
      cv.Pen.Width := 4;
      cv.Pen.Color := SmoothColor(clBlue, 64);
      cv.Rectangle(rt.Left + 2, rt.Top + 2, rt.Right - 2, rt.Bottom - 2);
    end;

    // if lr then begin
    // if EditingStart < TLParameters.
    // end;
    cv.Font.Color := cfn;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DrawEditorTextEvent | ' +
        E.Message);
  end;
end;

procedure TTLEditor.UpdateScreenText(cv: tcanvas);
var
  rt, rts, rtfr, rtdur: TRect;
  txt: string;
  i, cnt, stp, ps, rw, pfr, xp, yp: integer;
  cfn, cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;
    cfn := cv.Font.Color;

    // if EPos=0 then rtdur.Left:=Rect.Left
    // else rtdur.Left:=Events[EPos].Start * TLParameters.FrameSize;

    // rtdur.Left:=TLParameters.ScreenStart;
    // rtdur.Right:=TLParameters.ScreenEnd;
    // rtdur.Bottom:=Rect.Top;
    // rtdur.Top:=Rect.Top - TLHeights.IntervalEdit;
    // cv.Brush.Style:=bsSolid;
    // cv.Brush.Color:=TLBackGround;
    // cv.FillRect(rtdur);
    //
    // rtdur.Left:=TLParameters.ScreenStart;
    // rtdur.Right:=TLParameters.ScreenEnd;
    // rtdur.Bottom:=Rect.Top;
    // rtdur.Top:=Rect.Bottom;
    // cv.Brush.Style:=bsSolid;
    // cv.Brush.Color:=TLParameters.Foreground;
    // cv.FillRect(rtdur);

    // ______________________________

    rtdur.Left := TLParameters.ScreenStart;
    rtdur.Right := TLParameters.ScreenEnd;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Top - TLHeights.IntervalEdit;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := TLBackGround;
    cv.FillRect(rtdur);

    rtdur.Left := TLParameters.ScreenStart;
    rtdur.Right := TLParameters.ScreenEnd;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Bottom;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := TLParameters.ForeGround;
    cv.FillRect(rtdur);

    rtdur.Left := (TLParameters.Preroll + TLParameters.Duration) *
      TLParameters.FrameSize;
    rtdur.Right := Rect.Right;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Bottom;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
    cv.FillRect(rtdur);

    if TLParameters.ScreenStartFrame <= TLParameters.Preroll then
    begin
      rtdur.Left := 0;
      rtdur.Right := TLParameters.Preroll * TLParameters.FrameSize;
      rtdur.Bottom := Rect.Top;
      rtdur.Top := Rect.Bottom;
      cv.Brush.Style := bsSolid;
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
      cv.FillRect(rtdur);
    end;

    // _____________________________

    if TLParameters.ScreenStartFrame <= TLParameters.Preroll then
    begin
      rtdur.Left := 0;
      rtdur.Right := TLParameters.Preroll * TLParameters.FrameSize;
      rtdur.Bottom := Rect.Top;
      rtdur.Top := Rect.Bottom;
      cv.Brush.Style := bsSolid;
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 32);
      cv.FillRect(rtdur);
    end;

    for i := 0 to Count - 1 do
    begin
      if i = Count - 1 then
      begin
        DrawEditorText(cv, Count - 1);
        break;
      end;
      if Events[i].Finish < TLParameters.ScreenStartFrame then
        continue;
      if Events[i].Start > TLParameters.ScreenEndFrame then
        exit;

      Events[i].SetRectAreas(tltext);
      if (EditingEvent <> -1) and (EditingEvent = i) and
        ((EditingArea = edStart) or (EditingArea = edFinish)) then
        DrawEditorTextEvent(Events[i], form1.imgLayer0.Canvas, Rect, true)
      else
        DrawEditorTextEvent(Events[i], cv, Rect, false);
    end;

    // form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
    cv.Font.Color := cfn;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.UpdateScreenText | ' +
        E.Message);
  end;
end;

procedure TTLEditor.DrawEditorText(cv: tcanvas; EPos: integer);
var
  rt, rts, rtfr, rtdur: TRect;
  txt: string;
  i, cnt, stp, ps, rw, pfr, xp, yp: integer;
  cfn, cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;
    cfn := cv.Font.Color;

    if EPos = 0 then
      rtdur.Left := Rect.Left
    else
      rtdur.Left := Events[EPos].Start * TLParameters.FrameSize;

    // rtdur.Left:=Rect.Left;
    rtdur.Right := Rect.Right;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Top - TLHeights.IntervalEdit;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := TLBackGround;
    cv.FillRect(rtdur);

    for i := EPos to Count - 1 do
    begin
      Events[i].SetRectAreas(tltext);
      if (EditingEvent <> -1) and (EditingEvent = i) and
        ((EditingArea = edStart) or (EditingArea = edFinish)) then
        DrawEditorTextEvent(Events[i], form1.imgLayer0.Canvas, Rect, true)
      else
        DrawEditorTextEvent(Events[i], cv, Rect, false);
    end;

    // form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
    cv.Font.Color := cfn;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DrawEditorText | ' + E.Message);
  end;
end;

procedure TTLEditor.DrawEditorMediaEvent(evnt: TMyEvent; cv: tcanvas;
  TLRect: TRect; lr: boolean);
var
  rt, rtfr, rtdur: TRect;
  txt, txt1: string;
  i, cnt, stp, ps, psx, rw, pfr, xp, yp: integer;
  cfn, cbr, cpn, ctm: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;

begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;
    cfn := cv.Font.Color;

    cv.Font.Size := evnt.FontSizeSub;
    cv.Font.Name := evnt.FontName;
    cv.Font.Color := evnt.FontColor;

    rt.Top := TLRect.Top + 1;
    rt.Bottom := TLRect.Bottom - 1;
    if lr then
    begin
      // if EditingFinish-EditingStart < cnt then EditingFinish:=EditingStart + cnt;
      rt.Left := EditingStart;
      if cv.Font.Color = TLParameters.lrTransperent0 then
        cv.Font.Color := SmoothColor(evnt.FontColor, 4);
      txt1 := FramesToShortStr(Round((TLParameters.ScreenStart + rt.Left) /
        TLParameters.FrameSize) - TLParameters.ZeroPoint);
    end
    else
    begin
      rt.Left := evnt.Start * TLParameters.FrameSize;
      cv.Font.Color := evnt.FontColor;
      txt1 := FramesToShortStr(evnt.Start - TLParameters.ZeroPoint);
    end;
    rt.Right := rt.Left + cv.TextWidth('0000000000000000');

    rtdur.Left := rt.Left + 5;
    rtdur.Right := rt.Right - 5;
    // TLRect.Left + (evnt.Finish-TLParameters.ScreenStartFrame) * TLparameters.FrameSize;
    rtdur.Bottom := TLRect.Top;
    rtdur.Top := rtdur.Bottom - TLHeights.IntervalEdit;

    cv.Brush.Style := bsSolid; // Form1.ImgLayer0.Canvas
    cv.Brush.Color := TLBackGround;
    ctm := cv.Font.Color;
    cv.Font.Color := SmoothColor(clWhite, 8);
    cv.Font.Size := DefineFontSizeH(cv, rtdur.Bottom - rtdur.Top);
    cv.TextRect(rtdur, rt.Left + 5, rtdur.Top + 1, txt1);
    cv.Font.Color := ctm;

    cv.Brush.Style := bsSolid;
    if lr then
    begin
      if evnt.FontColor = TLParameters.lrTransperent0 then
      begin
        cv.Brush.Color := SmoothColor(evnt.FontColor, 8);
        cv.Pen.Color := SmoothColor(evnt.FontColor, 8);
      end
      else
      begin
        cv.Brush.Color := evnt.FontColor;
        cv.Pen.Color := evnt.FontColor;
      end;
    end
    else
    begin;
      cv.Brush.Color := evnt.FontColor;
      cv.Pen.Color := evnt.FontColor;
    end;

    cv.MoveTo(rt.Left, rt.Top);
    cv.LineTo(rt.Left, rt.Bottom);
    cv.Polygon([Point(rt.Left, rt.Top), Point(rt.Left + 5, rt.Top + 10),
      Point(rt.Left, rt.Top + 20)]);
    cv.Brush.Color := cbr;

    for rw := 0 to evnt.Count - 1 do
    begin
      for pfr := 0 to evnt.Rows[rw].Count - 1 do
      begin
        xp := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left -
          (evnt.SafeZone div 2);
        yp := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top + 1;
        if (evnt.Rows[rw].Phrases[pfr].Select) and
          (evnt.Rows[rw].Phrases[pfr].visible) then
        begin
          cv.Brush.Color := SmoothColor(evnt.Color, 48);
          rtfr.Left := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left -
            evnt.SafeZone;
          rtfr.Top := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
          rtfr.Right := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
          rtfr.Bottom := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
          cv.Brush.Style := bsSolid;
          cv.FillRect(rtfr);
          cv.Brush.Color := cbr;
        end;
        cv.Brush.Style := bsClear;
        rtfr.Left := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left -
          evnt.SafeZone;
        rtfr.Top := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        rtfr.Right := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
        rtfr.Bottom := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
        cv.TextRect(rtfr, xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
      end;
      cv.Font.Size := evnt.FontSizeSub;
    end;

    cv.Font.Color := cfn;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DrawEditorMediaEvent | ' +
        E.Message);
  end;
end;

procedure TTLEditor.DrawEditorMedia(cv: tcanvas; EPos: integer);
var
  rt, rts, rtfr, rtdur: TRect;
  txt: string;
  i, cnt, stp, ps, rw, pfr, xp, yp: integer;
  cfn, cbr, cpn: tcolor;
  wpn: integer;
  sbr: tbrushstyle;
  mpn: tpenmode;
begin
  try
    cbr := cv.Brush.Color;
    cpn := cv.Pen.Color;
    wpn := cv.Pen.Width;
    sbr := cv.Brush.Style;
    mpn := cv.Pen.Mode;
    cfn := cv.Font.Color;

    rt.Right := Rect.Left + TLParameters.EndPoint * TLParameters.FrameSize;;
    rt.Top := Rect.Top + 2;
    rt.Bottom := Rect.Bottom - 2;
    rt.Left := { Rect.Left + } TLParameters.Preroll * TLParameters.FrameSize;

    rtdur.Left := Rect.Left;
    rtdur.Right := Rect.Right;
    rtdur.Bottom := Rect.Top;
    rtdur.Top := Rect.Top - TLHeights.IntervalEdit;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := TLBackGround;
    cv.FillRect(rtdur);

    cv.Brush.Style := bsSolid;
    if fileexists(form1.lbPlayerFile.Caption) then
      cv.Brush.Color := (form1.GridTimeLines.Objects[0, Index]
        as TTimelineOptions).MediaColor
    else
      cv.Brush.Color := SmoothColor(TLParameters.ForeGround, 64);
    // cv.Brush.Color:=(Form1.GridTimeLines.Objects[0,Index] as TTimelineOptions).MediaColor;
    cv.FillRect(rt);

    cv.Pen.Width := 1;
    cv.Pen.Color := TLZoneNamesFontColor; // clWhite;//SmoothColor(clWhite,5);
    stp := 25 * TLParameters.FrameSize;
    cnt := (rt.Right - rt.Left) div stp;
    cv.Font.Color := TLZoneNamesFontColor;
    cv.Font.Size := TLZoneNamesFontSize - 3;
    for i := 1 to cnt do
    begin
      ps := rt.Left + i * stp;
      cv.MoveTo(ps, rt.Top);
      cv.LineTo(ps, rt.Bottom);
      if (i mod 5) = 0 then
        cv.TextOut(ps + 3, rt.Bottom - 2 - cv.TextHeight('0'), SecondToStr(i));
    end;
    // cv.Font.Color:=TLZoneNamesFontColor;
    cv.Font.Size := TLZoneNamesFontSize;
    txt := extractfilename(form1.lbPlayerFile.Caption);
    cv.TextOut(rt.Left + 5, rt.Top + (rt.Bottom - rt.Top - cv.TextHeight(txt))
      div 2, txt);
    cv.Pen.Width := 2;
    cv.Pen.Color := TLZone.CRStart;
    cv.MoveTo(rt.Left + (TLParameters.ZeroPoint - TLParameters.Preroll) *
      TLParameters.FrameSize, rt.Top);
    cv.LineTo(rt.Left + (TLParameters.ZeroPoint - TLParameters.Preroll) *
      TLParameters.FrameSize, rt.Bottom);

    for i := 0 to Count - 1 do
    begin
      Events[i].SetRectAreas(tlmedia);
      if (EditingEvent <> -1) and (EditingEvent = i) and (EditingArea = edStart)
      then
        DrawEditorMediaEvent(Events[i], form1.imgLayer0.Canvas, Rect, true)
      else
        DrawEditorMediaEvent(Events[i], cv, Rect, false);
    end;

    // form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
    cv.Font.Color := cfn;
    cv.Brush.Color := cbr;
    cv.Pen.Color := cpn;
    cv.Pen.Width := wpn;
    cv.Brush.Style := sbr;
    cv.Pen.Mode := mpn;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DrawEditorMedia | ' + E.Message);
  end;
end;

procedure TTLEditor.DrawEditor(cv: tcanvas; EPos: integer);
var
  rt, rts, rtf: TRect;
  i, rw, ev, pfr, hh, tp, bt, st, fn: integer;
  xp, yp: integer;
  txt: string;
begin
  try
    if EPos < 0 then
      EPos := 0;
    if EPos <= 0 then
      DrawZoneTimeline(cv, Rect)
    else
    begin
      DrawPartZoneTimeline(cv, Rect, Events[EPos].Start);
    end;

    case TypeTL of
      tldevice:
        DrawEditorDevice(cv, EPos);
      tltext:
        DrawEditorText(cv, EPos);
      tlmedia:
        DrawEditorMedia(cv, EPos);
    end; //
    // if EditingEvent > -1 then DrawLayer0(cv);
    cv.Refresh;
    if form1.PanelAir.visible then
    begin
      MyPanelAir.AirDevices.Init(form1.ImgDevices.Canvas, index);
      MyPanelAir.SetValues;
      MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas, index);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.DrawEditor | ' + E.Message);
  end;
end;

procedure TTLEditor.UpdateScreen(cv: tcanvas);
var
  rt, rts, rtf: TRect;
  i, rw, ev, pfr, hh, tp, bt, st, fn: integer;
  xp, yp: integer;
  txt: string;
begin
  try
    case TypeTL of
      tldevice:
        UpdateScreenDevice(cv);
      tltext:
        UpdateScreenText(cv);
      tlmedia:
        DrawEditorMedia(cv, 0);
    end; //
    // if EditingEvent > -1 then DrawLayer0(cv);
    cv.Refresh;
    // form1.imgLayer1.Repaint;
    // form1.imgLayer2.Repaint;
    if form1.PanelAir.visible then
    begin
      MyPanelAir.AirDevices.Init(form1.ImgDevices.Canvas, index);
      MyPanelAir.SetValues;
      MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas, index);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.UpdateScreen | ' + E.Message);
  end;
end;

procedure TTLEditor.UpdateEventData(ev: TMyEvent);
var
  nm, dt, lsnm, txt: string;
begin
  try
    nm := ev.SelectionPhrase;
    if nm = '' then
      exit;
    dt := ev.ReadPhraseType(nm);
    if Trim(lowercase(dt)) = 'template' then
    begin
      // ev.SetPhraseText(nm, MySetTextTemplate(ev.ReadPhraseText(nm)));
      if Trim(lowercase(nm)) = 'comment' then
        ev.SetPhraseText(nm, MySetTextTemplate(ev.ReadPhraseText(nm), true))
      else
        ev.SetPhraseText(nm, MySetTextTemplate(ev.ReadPhraseText(nm), false));
    end
    else
      SetEventData(ev, nm);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.UpdateEventData | ' + E.Message);
  end;
end;

Procedure TTLEditor.WriteToStream(F: tStream);
var
  i: integer;
begin
  try
    F.WriteBuffer(Index, SizeOf(integer));
    F.WriteBuffer(isZoneEditor, SizeOf(boolean));
    F.WriteBuffer(DoubleClick, SizeOf(boolean));
    F.WriteBuffer(IDTimeline, SizeOf(longint));
    i := ord(TypeTL); // :  TTypeTimeline;
    F.WriteBuffer(i, SizeOf(integer));
    F.WriteBuffer(Rect.Top, SizeOf(integer));
    F.WriteBuffer(Rect.Bottom, SizeOf(integer));
    F.WriteBuffer(Rect.Left, SizeOf(integer));
    F.WriteBuffer(Rect.Right, SizeOf(integer));
    F.WriteBuffer(Block, SizeOf(Block));
    F.WriteBuffer(Status, SizeOf(Status));
    F.WriteBuffer(Count, SizeOf(integer));
    For i := 0 to Count - 1 do
      Events[i].WriteToStream(F);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.WriteToStream | ' + E.Message);
  end;
end;

Procedure TTLEditor.SaveToFile(FileName: string);
var
  Stream: TFileStream;
  renm: string;
  i: integer;
begin
  try
    try
      WriteLog('MAIN', 'UMyFiles.SaveProjectToFile Start FileName=' + FileName);
      if fileexists(FileName) then
      begin
        renm := ExtractFilePath(FileName) + 'Temp.tprj';
        RenameFile(FileName, renm);
        DeleteFile(renm);
      end;
      Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
      i := ord(TypeTL); // :  TTypeTimeline;
      Stream.WriteBuffer(i, SizeOf(integer));
      Stream.WriteBuffer(TLParameters.Finish, SizeOf(longint));
      WriteToStream(Stream);
    finally
      FreeAndNil(Stream);
      MyTextMessage('Сообщение', 'Данные сохранены.', 1);
    end;
  except
    FreeAndNil(Stream);
  end;
end;

Procedure TTLEditor.ReadFromStream(F: tStream);
var
  i: integer;
begin
  try
    F.WriteBuffer(Index, SizeOf(integer));
    F.ReadBuffer(isZoneEditor, SizeOf(boolean));
    F.ReadBuffer(DoubleClick, SizeOf(boolean));
    F.ReadBuffer(IDTimeline, SizeOf(longint));
    F.ReadBuffer(i, SizeOf(integer));
    TypeTL := SetTypeTimeline(i);
    F.ReadBuffer(Rect.Top, SizeOf(integer));
    F.ReadBuffer(Rect.Bottom, SizeOf(integer));
    F.ReadBuffer(Rect.Left, SizeOf(integer));
    F.ReadBuffer(Rect.Right, SizeOf(integer));
    F.ReadBuffer(Block, SizeOf(Block));
    F.ReadBuffer(Status, SizeOf(Status));
    Clear;
    F.ReadBuffer(Count, SizeOf(integer));
    for i := 0 to Count - 1 do
    begin
      setlength(Events, i + 1);
      Events[i] := TMyEvent.Create;
      Events[i].ReadFromStream(F);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLEditor.ReadFromStream | ' + E.Message);
  end;
end;

procedure TTLEditor.LoadFromFile(TLType: TTypeTimeline; FileName: string);
var
  Stream: TFileStream;
  renm: string;
  TLTp: TTypeTimeline;
  i: integer;
  Indx: integer;
  idtl, Finish: longint;

begin
  try
    try
      Stream := TFileStream.Create(FileName, fmOpenReadWrite or
        fmShareDenyNone);
      Stream.ReadBuffer(i, SizeOf(integer));
      TLTp := SetTypeTimeline(i);
      if TLTp = TLType then
      begin
        Stream.ReadBuffer(Finish, SizeOf(longint));
        Indx := Index;
        idtl := IDTimeline;
        if TLParameters.Finish < Finish then
        begin
          TLParameters.Finish := Finish;
          if TLParameters.Finish - TLParameters.EndPoint > 3000 then
            TLParameters.Postroll := TLParameters.Finish -
              TLParameters.EndPoint + 3000;
        end;
        Clear;
        ReadFromStream(Stream);
        Index := Indx;
        IDTimeline := idtl;
        Indx := TLZone.FindTimeline(idtl);
        TLZone.Timelines[Indx].Clear;
        for i := 0 to Count - 1 do
        begin
          TLZone.Timelines[Indx].Count := TLZone.Timelines[Indx].Count + 1;
          setlength(TLZone.Timelines[Indx].Events,
            TLZone.Timelines[Indx].Count);
          TLZone.Timelines[Indx].Events[TLZone.Timelines[Indx].Count - 1] :=
            TMyEvent.Create;
          TLZone.Timelines[Indx].Events[TLZone.Timelines[Indx].Count - 1]
            .Assign(Events[i]);
        end;
        // i:=TLZone.Timelines[indx].IDTimeline;
        // idtl:=i;
        // for i:=0 to Count-1 do begin
        //
        // end;
        // TLZone.Timelines[i].Assign(TLEditor);
        // Timelines[] Assign(ttl : TTLTimeline; Indx : integer);
      end
      else
        MyTextMessage('Предупреждение',
          'Тип текущей тайм-линии не соответсвует загружаемому.' + #13#10 +
          'Процесс загрузки остановлен.', 1);
    finally
      FreeAndNil(Stream);
      MyTextMessage('Сообщение', 'Данные загружены.', 1);
    end;
  except
    FreeAndNil(Stream);
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLScaler отвечает за отрисовку области шкалы времени
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLScaler.Create;
begin
  inherited;
  PenColor := SmoothColor(TLParameters.ForeGround, 64);;
  FontColor := ProgrammFontColor;
  FontSize := 8;
  FontName := ProgrammFontName;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
end;

procedure TTLScaler.UpdateData;
begin
  PenColor := SmoothColor(TLParameters.ForeGround, 64);;
  FontColor := ProgrammFontColor;
  FontSize := 8;
  FontName := ProgrammFontName;
end;

Destructor TTLScaler.Destroy;
begin
  FreeMem(@PenColor);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@Rect);
  inherited;
end;

Procedure TTLScaler.DrawScaler(cv: tcanvas);
var
  i, j, cntb, cntp, dur, step, ps, tp, zero, befor, post: longint;
begin
  try

    with TLParameters do
    begin
      dur := (Preroll + Duration + Postroll) * FrameSize;
      zero := ZeroPoint * FrameSize;
      post := dur - zero;
      step := 25 * FrameSize;

      cntb := zero div FrameSize;
      cntp := post div FrameSize;

      cv.Brush.Color := ForeGround;
      // cv.FillRect(Rect);
      cv.Pen.Color := PenColor;
      cv.Font.Color := FontColor;
      cv.Font.Size := FontSize;
      cv.Font.Name := FontName;
      cv.FillRect(Rect);
      ps := zero;

      cv.MoveTo(ps, 0);
      cv.LineTo(ps, TLHeights.Scaler);
      cv.TextOut(ps + 2, 0, '0:00');
      tp := TLHeights.Scaler div 2;
      ps := ps - FrameSize;
      For i := 1 to cntb do
      begin
        if (i mod 25) = 0 then
        begin
          cv.MoveTo(ps, 0);
          cv.LineTo(ps, TLHeights.Scaler);
          cv.TextOut(ps + 2, 0, '-' + SecondToStr(i div 25));
        end
        else
        begin
          cv.MoveTo(ps, tp);
          cv.LineTo(ps, TLHeights.Scaler);
        end;
        ps := ps - FrameSize;
      End;
      ps := zero + FrameSize;;
      for i := 1 to cntp do
      begin
        if (i mod 25) = 0 then
        begin
          cv.MoveTo(ps, 0);
          cv.LineTo(ps, TLHeights.Scaler);
          cv.TextOut(ps + 2, 0, SecondToStr(i div 25));
        end
        else
        begin
          if FrameSize > 1 then
          begin
            cv.MoveTo(ps, tp);
            cv.LineTo(ps, TLHeights.Scaler);
          end;
        end;
        ps := ps + FrameSize;
      end;
    end; // with
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLScaler.DrawScaler | ' + E.Message);
  end;
end;

Procedure TTLScaler.WriteToStream(F: tStream);
begin
  try
    F.WriteBuffer(PenColor, SizeOf(PenColor));
    F.WriteBuffer(FontColor, SizeOf(FontColor));
    F.WriteBuffer(FontSize, SizeOf(FontSize));
    WriteBufferStr(F, FontName);
    F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
    F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
    F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLScaler.WriteToStream | ' + E.Message);
  end;
end;

Procedure TTLScaler.ReadFromStream(F: tStream);
begin
  try
    F.ReadBuffer(PenColor, SizeOf(PenColor));
    F.ReadBuffer(FontColor, SizeOf(FontColor));
    F.ReadBuffer(FontSize, SizeOf(FontSize));
    ReadBufferStr(F, FontName);
    F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
    F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
    F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
    F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLScaler.ReadFromStream | ' + E.Message);
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLZone отвечает за всю область тайм-линий
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLZone.Create;
begin
  inherited;
  Countbuffer := 0;
  DownViewer := false;
  DownTimeline := false;
  DownEditor := false;
  DownScaler := false;
  XDown := -1;
  XViewer := -1;
  CRStart := StartColorCursor;
  CREnd := EndColorCursor;
  CRStartDown := false;
  CREndDown := false;
  Count := 0;
  TLScaler := TTLScaler.Create;
  TLEditor := TTLEditor.Create;
end;

procedure TTLZone.UpdateCursor;
begin
  CRStart := StartColorCursor;
  CREnd := EndColorCursor;
end;

Destructor TTLZone.Destroy;
begin
  FreeMem(@Countbuffer);
  FreeMem(@TLBuffer);
  FreeMem(@DownViewer);
  FreeMem(@DownTimeline);
  FreeMem(@DownEditor);
  FreeMem(@DownScaler);
  FreeMem(@XDown);
  FreeMem(@XViewer);
  FreeMem(@CRStart);
  FreeMem(@CREnd);
  FreeMem(@CRStartDown);
  FreeMem(@CREndDown);
  FreeMem(@Count);
  TLScaler.Free;
  TLEditor.Free;
  FreeMem(@Timelines);
  inherited;
end;

Procedure TTLZone.ClearBuffer;
var
  i: integer;
begin
  try
    For i := Countbuffer - 1 downto 0 do
    begin
      TLBuffer[i].Clear;
      TLBuffer[i].FreeInstance;
    end;
    Countbuffer := 0;
    setlength(TLBuffer, Countbuffer);
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearBuffer');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearBuffer | ' + E.Message);
  end;
end;

Procedure TTLZone.WriteToBuffer;
var
  i, j: integer;
begin
  try
    ClearBuffer;
    For i := 0 to Count - 1 do
    begin
      Countbuffer := Countbuffer + 1;
      setlength(TLBuffer, Countbuffer);
      TLBuffer[Countbuffer - 1] := TTLTimeline.Create;
      TLBuffer[Countbuffer - 1].Assign(Timelines[i]);
    end;
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.WriteToBuffer');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.WriteToBuffer | ' + E.Message);
  end;
end;

function TTLZone.FindInBuffer(ID: longint): integer;
var
  i: integer;
begin
  try
    result := -1;
    for i := 0 to Countbuffer - 1 do
    begin
      if TLBuffer[i].IDTimeline = ID then
      begin
        result := i;
        if makelogging then
          WriteLog('MAIN', 'UGRTimelines.TTLZone.FindInBuffer IDTimeline=' +
            inttostr(ID) + ' Result=' + inttostr(result));
        exit;
      end;
    end;
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.FindInBuffer IDTimeline=' +
        inttostr(ID) + ' Result=' + inttostr(result));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.FindInBuffer | ' + E.Message);
  end;
end;

Procedure TTLZone.SetEditingEventDevice;
var
  i, sev, fev, cnt: integer;
  Start, Finish, sfzn: longint;
  direction: boolean;
begin
  try
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventDevice');
    if EditingFinish = EditingStart then
    begin
      TLEditor.DeleteEvent(EditingEvent);
      exit;
    end;

    if EditingFinish > EditingStart then
    begin

      Start := Round((TLParameters.ScreenStart + EditingStart) /
        TLParameters.FrameSize);
      Finish := TLEditor.Events[EditingEvent].Finish;

      if EditingEvent = 0 then
      begin
        TLEditor.Events[0].Start := Start;
        exit;
      end;

      sev := TLEditor.FindEventPos(Start);

      if sev = -1 then
      begin
        // TLEditor.Events[EditingEvent].Start:=start;
        For i := EditingEvent - 1 downto 0 do
          TLEditor.DeleteEvent(i);
        TLEditor.Events[0].Start := Start;
        exit;
      end;

      if EditingEvent > 0 then
      begin
        if TLEditor.Events[sev].Finish = TLEditor.Events[EditingEvent].Finish
        then
        begin
          TLEditor.Events[EditingEvent].Start := Start;
          TLEditor.Events[EditingEvent - 1].Finish := Start;
          exit;
        end
        else
        begin
          // sev := TLEditor.FindEventPos(start);
          TLEditor.Events[EditingEvent].Start := Start;
          For i := EditingEvent - 1 downto sev + 1 do
            TLEditor.DeleteEvent(i);
          TLEditor.Events[sev + 1].Start := Start;
          TLEditor.Events[sev].Finish := Start;
          exit;
        end;
      end;

    end;

    if EditingFinish < EditingStart then
    begin
      Finish := Round((TLParameters.ScreenStart + EditingStart) /
        TLParameters.FrameSize);
      Start := TLEditor.Events[EditingEvent].Finish;
      sev := TLEditor.FindEventPos(Finish);
      if sev = -1 then
      begin
        if TLEditor.Count > 1 then
        begin
          For i := TLEditor.Count - 1 downto EditingEvent + 1 do
            TLEditor.DeleteEvent(i);
          TLEditor.Events[EditingEvent].Start := Start;
          TLEditor.Events[EditingEvent].Finish := TLParameters.Finish;
        end
        else
          TLEditor.DeleteEvent(TLEditor.Count - 1);
        exit;
      end;
      if sev = EditingEvent + 1 then
      begin
        TLEditor.Events[EditingEvent].Start := Start;
        TLEditor.Events[EditingEvent].Finish := Finish;
        TLEditor.Events[EditingEvent + 1].Start := Finish;
      end;
      if sev - EditingEvent > 1 then
      begin
        For i := sev - 1 downto EditingEvent + 1 do
          TLEditor.DeleteEvent(i);
        TLEditor.Events[EditingEvent].Start := Start;
        TLEditor.Events[EditingEvent].Finish := Finish;
        TLEditor.Events[EditingEvent + 1].Start := Finish;
      end;
    end;

    EditingEvent := -1;
    EditingArea := edNone;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventDevice | ' +
        E.Message);
  end;
end;

Procedure TTLZone.SetEditingEventText;
var
  evnt: TMyEvent;
  ps: longint;
  nm: integer;
begin
  try
    evnt := TMyEvent.Create;
    try
      ps := Round((TLParameters.ScreenStart + EditingStart) /
        TLParameters.FrameSize);
      TLEditor.Events[EditingEvent].Start := ps;
      TLEditor.Events[EditingEvent].Finish :=
        Round((TLParameters.ScreenStart + EditingFinish) /
        TLParameters.FrameSize);
      evnt.Assign(TLEditor.Events[EditingEvent]);
      TLEditor.DeleteEvent(EditingEvent);
      nm := TLEditor.InsertText(ps);
      TLEditor.Events[nm].Assign(evnt);
      if makelogging then
        WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventText');
    finally
      evnt.FreeInstance;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventText | ' +
        E.Message);
  end;
end;

Procedure TTLZone.SetEditingEventMedia;
var
  evnt: TMyEvent;
  ps: longint;
  nm: integer;
begin
  try
    evnt := TMyEvent.Create;
    try
      ps := Round((TLParameters.ScreenStart + EditingStart) /
        TLParameters.FrameSize);
      TLEditor.Events[EditingEvent].Start := ps;
      TLEditor.Events[EditingEvent].Finish := ps + TLEditor.Events[EditingEvent]
        .SafeZone + 5;
      evnt.Assign(TLEditor.Events[EditingEvent]);
      TLEditor.DeleteEvent(EditingEvent);
      nm := TLEditor.InsertMarker(ps);
      TLEditor.Events[nm].Assign(evnt);
      if makelogging then
        WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventMedia');
    finally
      evnt.FreeInstance;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventMedia | ' +
        E.Message);
  end;
end;

Procedure TTLZone.UPZoneTimeline(cv: tcanvas; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  ps, i, rw, fr, psev, psc: integer;
  txt, flnm: string;
  step: real;
begin
  try
    try
      // frLock.Hide;
      if TLParameters.Duration = 0 then
        exit;
      if DownViewer then
      begin
        DownViewer := false;
        step := trunc((TLParameters.Finish - TLParameters.Start) /
          form1.imgTimelines.Width);
        TLParameters.Position := TLParameters.Position +
          trunc((X - TLZone.XViewer) * step);
          PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
        TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
        SetClipTimeParameters;

        // TLZone.XViewer:=X;
        exit;
      end;
      if DownEditor then
      begin

        ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
        if TLZone.Timelines[ps].Block then
        begin
          TLEditor.DoubleClick := false;
          TLEditor.EventsSelectFalse;
          TLEditor.AllSelectFalse;
          EditingEvent := -1;
          EditingArea := edNone;
          DownTimeline := false;
          DownEditor := false;
          DownScaler := false;
          CRStartDown := false;
          CREndDown := false;
          cv.Refresh;
          exit;
        end;

        if (EditingArea = edNone) and (EditingEvent = -1) and
          (not(ssShift in Shift)) then
        begin
          TLEditor.DoubleClick := false;
          TLEditor.EventsSelectFalse;
        end;
        if (EditingEvent <> -1) then
        begin

          if EditingArea = edStart then
          begin
            Case TLEditor.TypeTL of
              tldevice:
                SetEditingEventDevice;
              tltext:
                SetEditingEventText;
              tlmedia:
                SetEditingEventMedia;
            end; // case
            // end else begin
            EditingEvent := -1;
            EditingArea := edNone;
          end;
          if (EditingArea = edFinish) and (TLEditor.TypeTL = tltext) then
          begin
            SetEditingEventText;
            EditingEvent := -1;
            EditingArea := edNone;
          end;
          if (EditingArea = edCenter) and TLEditor.DoubleClick then
          begin
            TLEditor.DoubleClick := false;
            TLEditor.UpdateEventData(TLEditor.Events[EditingEvent]);
            TLEditor.AllSelectFalse;
          end;
        end;
        EditingEvent := -1;
        EditingArea := edNone;
        // ps:=FindTimeline(TLEditor.IDTimeline);
        TLEditor.ReturnEvents(Timelines[ps]);
        psev := TLEditor.FindEventPos(TLParameters.ScreenStartFrame);
        // TLEditor.DrawEditor(bmptimeline.Canvas,0);
        TLEditor.UpdateScreen(bmptimeline.Canvas);
        Timelines[ps].DrawTimeline(bmptimeline.Canvas, ps, 0);
        form1.imgLayer0.Canvas.Brush.Color := TLParameters.lrTransperent0;
        // Form1.ImgLayer0.Picture.Bitmap.TransparentColor;
        form1.imgLayer0.Canvas.FillRect(form1.imgLayer0.Canvas.ClipRect);
        if TLParameters.vlcmode <> play then
          DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
      end;
      LoadProject(false);
      DownTimeline := false;
      DownEditor := false;
      DownScaler := false;
      CRStartDown := false;
      CREndDown := false;
      if form1.lbActiveClipID.Caption <> '' then
      begin
        psc := FindClipInGrid(form1.GridClips, form1.lbActiveClipID.Caption);
        (form1.GridClips.Objects[0, psc] as TGridRows).MyCells[3].UpdatePhrase
          ('NTK', framestostr(TLParameters.Start - TLParameters.Preroll));
        (form1.GridClips.Objects[0, psc] as TGridRows).MyCells[3].UpdatePhrase
          ('Dur', framestostr(TLParameters.Finish - TLParameters.Start));
      end;
      cv.Refresh;
    finally
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.UPZoneTimeline | ' + E.Message);
  end;
end;

Procedure TTLZone.MoveMouseTimeline(cv: tcanvas; Shift: TShiftState;
  X, Y: integer);
var
  ps, dlt: integer;
  // crpos : teventreplay;
  shft, ln: longint;
  hgh1, hgh2: integer;
  psdbl: double;
begin
  if TLParameters.Duration = 0 then
    exit;
  try
    TLEditor.isZoneEditor := false;
    With TLParameters do
    begin
      if FrameSize = 0 then
        FrameSize := 2;
      // Курсор в зоне скалера
      hgh1 := 0;
      hgh2 := TLHeights.Scaler;

      if (Y >= hgh1) and (Y <= hgh2) then
      begin
        MouseInLayer2 := false;
        if CRStartDown then
        begin
          shft := trunc(X / TLParameters.FrameSize);
          TLParameters.Start := TLParameters.ScreenStartFrame + shft;
          DrawCursorStart(form1.imgLayer1.Canvas);
        end;
        if CREndDown then
        begin
          dlt := X - XDown;
          shft := trunc(X / TLParameters.FrameSize);
          TLParameters.Finish := TLParameters.ScreenStartFrame + shft;
          form1.imgLayer1.Canvas.FillRect(form1.imgLayer1.Canvas.ClipRect);
          DrawCursorEnd(form1.imgLayer1.Canvas);
        end;
        DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
        form1.imgLayer1.Repaint;
        exit;
      end;

      // Курсор в зоне Редактирования

      hgh1 := hgh2 + TLHeights.IntervalEdit;
      hgh2 := hgh1 + TLHeights.Edit;

      if (Y >= hgh1) and (Y <= hgh2) then
      begin
        MouseInLayer2 := true;
        ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
        if form1.GridTimeLines.Objects[0, ps + 1] is TTimelineOptions then
        begin
          if TLZone.Timelines[ps].Block then
          begin
            TLEditor.EventsSelectFalse;
            TLEditor.AllSelectFalse;
            exit;
          end;
        end;
        TLEditor.isZoneEditor := true;
        if DownEditor then
        begin
          if EditingEvent < 0 then
            exit;
          case TLEditor.TypeTL of
            tldevice, tlmedia:
              EditingStart := EditingStart + X - XDown;
            tltext:
              begin
                if EditingArea = edFinish then
                  EditingFinish := EditingFinish + X - XDown;
                if EditingArea = edStart then
                begin
                  EditingStart := EditingStart + X - XDown;
                  EditingFinish := EditingFinish + X - XDown;
                end;
              end;
          end; // case
          form1.imgLayer0.Canvas.Brush.Color := TLParameters.lrTransperent0;
          form1.imgLayer0.Canvas.FillRect(form1.imgLayer0.Canvas.ClipRect);
          XDown := X;
        end
        else
        begin
          if TLParameters.vlcmode = play then
            exit;
          TLEditor.AllSelectFalse;
          TLEditor.MouseMove(cv, X, Y);
          // InvalidateRect(form1.imgLayer0.Canvas.Handle, NIL, FALSE ) ;
        end;

        TLEditor.UpdateScreen(bmptimeline.Canvas);
        if TLParameters.vlcmode <> play then
        begin
          TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
          form1.imgLayer0.Repaint;
        end;
        exit;
      end;

      // Курсор в зоне тайм-линий

      hgh1 := hgh2 + TLHeights.IntervalTL;
      hgh2 := hgh1 + TLHeights.Timelines;

      if (Y >= hgh1) and (Y <= hgh2) then
      begin
        MouseInLayer2 := true;
        if DownTimeline then
        begin
          if TLParameters.vlcmode = play then
            exit;
          shft := trunc((X - XDown) / TLParameters.FrameSize);
          TLParameters.Position := TLParameters.Position - shft;
          PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
          if TLParameters.Position <= TLParameters.Preroll then
            TLParameters.Position := TLParameters.Preroll;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

          ln := TLParameters.Preroll + TLParameters.Duration +
            TLParameters.Postroll -
            (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame) +
            trunc(TLParameters.MyCursor / TLParameters.FrameSize);
          if TLParameters.Position >= ln then
            TLParameters.Position := ln;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
          form1.imgTimelines.Repaint;
          // InvalidateRect(form1.imgTimelines.Canvas.Handle, NIL, FALSE ) ;
          MyPanelAir.SetValues;
          // form1.imgTimelines.Repaint;
          if form1.PanelAir.visible then
          begin
            // pMediaControl.Stop;
            MediaSetPosition(TLParameters.Position, false,
              'TTLZone.MoveMouseTimeline-1'); // 1
            DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
            form1.imgTimelines.Repaint;
            MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
              TLZone.TLEditor.Index);
            form1.ImgEvents.Repaint;
            form1.ImgDevices.Repaint;
            // form1.imgTimelines.Repaint;
            // DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
            // form1.imgTimelines.Repaint;
            // application.ProcessMessages;
          end
          else
          begin
            MediaSetPosition(TLParameters.Position, false,
              'TTLZone.MoveMouseTimeline-2'); // 2
            DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
          end;
          XDown := X;
          exit;
        end;
        exit;
      end;
      if Y > hgh2 then
        MouseInLayer2 := false;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.MoveMouseTimeline | ' + E.Message);
  end;
end;

Procedure TTLZone.DownZoneTimeLines(cv: tcanvas; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i, j, ps, hgh1, hgh2: integer;
  clicktc, sfzn: longint;
  first, last: integer;
  s: string;
  msht: real;
  smsh: longint;
  sz, st, en, psc: longint;
  bl: boolean;
begin
  try
    try
      SaveToUNDO;
      DownTimeline := false;
      DownEditor := false;
      DownScaler := false;
      TLParameters.SetScreenBoanders;
      TLEditor.isZoneEditor := false;
      XDown := X;

      if TLParameters.Duration = 0 then
        exit;

      // Зона скалера
      hgh1 := 0;
      hgh2 := TLHeights.Scaler;

      if (Y >= hgh1) and (Y <= hgh2) then
      begin
        DownScaler := true;
        if MouseInStartCursor(cv, X, Y) then
          CRStartDown := true;
        if MouseInEndCursor(cv, X, Y) then
          CREndDown := true;
        TLEditor.AllSelectFalse;
        TLEditor.EventsSelectFalse;
        // TLEDitor.DrawEditor(bmptimeline.Canvas,TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
        TLEditor.UpdateScreen(bmptimeline.Canvas);
        DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
        form1.imgTimelines.Repaint;
        exit;
      end;

      // Зона редактирования

      hgh1 := hgh2 + TLHeights.IntervalEdit;
      hgh2 := hgh1 + TLHeights.Edit;

      if (Y >= hgh1) and (Y <= hgh2) then
      begin
        ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);

        if form1.GridTimeLines.Objects[0, ps + 1] is TTimelineOptions then
        begin
          if TLZone.Timelines[ps].Block then
          begin
            TLEditor.EventsSelectFalse;
            TLEditor.AllSelectFalse;
            frLock.ShowModal;
            exit;
          end;
        end;

        DownEditor := true;
        TLEditor.isZoneEditor := true;
        clicktc := TLParameters.ScreenStartFrame +
          Round(X / TLParameters.FrameSize);
        s := inttostr(clicktc);
        if TLEditor.TypeTL = tltext then
        begin
          form1.RichEdit1.Text := '';
          TextRichSelect := false;
          if form1.panelprepare.visible then
            form1.ActiveControl := form1.panelprepare;
        end;

        // first := TLEditor.FirstScreenEvent;
        // last := TLEditor.LastScreenEvent;
        first := 0;
        For i := 0 to TLEditor.Count - 1 do
        begin
          if TLEditor.Events[i].Finish <= TLParameters.ScreenStartFrame then
          begin
            first := i;
            continue;
          end;
          if TLEditor.Events[i].Start >= TLParameters.ScreenEndFrame then
            exit;
          sfzn := trunc(TLEditor.Events[i].SafeZone /
            TLParameters.FrameSize) + 1;
          if (clicktc >= TLEditor.Events[i].Start) and
            (clicktc <= TLEditor.Events[i].Finish) then
          begin
            if (ssShift in Shift) and (not(ssCtrl in Shift)) and
              (not(ssAlt in Shift)) then
            begin
              if LastSelection = -1 then
                LastSelection := i
              else
              begin
                if i > LastSelection then
                  for j := LastSelection to i do
                    TLEditor.Events[j].Select := true
                else
                  for j := i to LastSelection do
                    TLEditor.Events[j].Select := true;
              end;
              // TLEditor.Events[i].Select := not TLEditor.Events[i].Select;
              Timelines[FindTimeline(TLEditor.IDTimeline)].Events[i].Select :=
                TLEditor.Events[i].Select;
              break;
            end
            else
            begin
              if (not(ssShift in Shift)) and (ssCtrl in Shift) and
                (not(ssAlt in Shift)) then
              begin
                TLEditor.Events[i].Select := not TLEditor.Events[i].Select;
                if TLEditor.Events[i].Select then
                  LastSelection := i;
                Timelines[FindTimeline(TLEditor.IDTimeline)].Events[i].Select :=
                  TLEditor.Events[i].Select;
                // break;
              end
              else
              begin
                bl := TLEditor.Events[i].Select;
                TLEditor.EventsSelectFalse;
                TLEditor.Events[i].Select := not bl;
                // TLEditor.Events[i].Select;
                if TLEditor.Events[i].Select then
                  LastSelection := i;
                Timelines[FindTimeline(TLEditor.IDTimeline)].Events[i].Select :=
                  TLEditor.Events[i].Select;
              end;
            end;

            EditingArea := edNone;

            // if TLEditor.TypeTL=tltext
            // then if TLEditor.Events[i].Select
            // then form1.RichEdit1.Text:=TLEditor.Events[i].ReadPhraseText('Text')
            // else form1.RichEdit1.Text:='';

            if (clicktc >= TLEditor.Events[i].Start) and
              (clicktc <= TLEditor.Events[i].Start + sfzn) then
            begin
              EditingEvent := i;
              EditingArea := edStart;
              EditingFinish := TLEditor.Events[i].Finish *
                TLParameters.FrameSize - TLParameters.ScreenStart;
              EditingStart := TLEditor.Events[i].Start * TLParameters.FrameSize
                - TLParameters.ScreenStart;
            end;

            if (clicktc >= TLEditor.Events[i].Finish - sfzn) and
              (clicktc <= TLEditor.Events[i].Finish) then
            begin
              EditingEvent := i;
              EditingArea := edFinish;
              EditingFinish := TLEditor.Events[i].Finish *
                TLParameters.FrameSize - TLParameters.ScreenStart;
              EditingStart := TLEditor.Events[i].Start * TLParameters.FrameSize
                - TLParameters.ScreenStart;
            end;

            if (clicktc >= TLEditor.Events[i].Start + sfzn) and
              (clicktc <= TLEditor.Events[i].Finish - sfzn) then
            begin
              EditingEvent := i;
              EditingArea := edCenter;
              EditingFinish := TLEditor.Events[i].Finish *
                TLParameters.FrameSize - TLParameters.ScreenStart;
              EditingStart := TLEditor.Events[i].Start * TLParameters.FrameSize
                - TLParameters.ScreenStart;
            end;

          end;
        end;

        // TLEditor.DrawEditor(bmptimeline.Canvas,first);//TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
        TLEditor.UpdateScreen(bmptimeline.Canvas);
        // InvalidateRect(form1.ImgLayer0.Canvas.Handle, NIL, FALSE ) ;
        DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
        // form1.imgLayer0.repaint;
        // application.ProcessMessages;
        exit;
      end;

      hgh1 := hgh2 + TLHeights.IntervalTL;
      hgh2 := cv.ClipRect.Bottom - cv.ClipRect.Top - TLHeights.Review -
        TLHeights.Interval;

      if (Y >= hgh1) and (Y <= hgh2) then
      begin
        DownTimeline := true;
        TLEditor.AllSelectFalse;
        TLEditor.EventsSelectFalse;
        TLEditor.UpdateScreen(bmptimeline.Canvas);
        // TLEDitor.DrawEditor(bmptimeline.Canvas,0);//TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
        DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
        form1.imgTimelines.Repaint;
        exit;
      end;

      hgh2 := cv.ClipRect.Bottom;
      hgh1 := hgh2 - TLHeights.Review;

      if (Y >= hgh1) and (Y <= hgh2) then
      begin
        sz := (TLParameters.Finish - TLParameters.Start) *
          TLParameters.FrameSize;
        if sz = 0 then
          sz := bmptimeline.Width;
        msht := sz / (TLParameters.ScreenEnd - TLParameters.ScreenStart);
        smsh := trunc(TLParameters.MyCursor / msht);
        st := trunc((TLParameters.ScreenStart - TLParameters.Start *
          TLParameters.FrameSize) / msht);
        en := trunc((TLParameters.ScreenEnd - TLParameters.Start *
          TLParameters.FrameSize) / msht);
        psc := st + smsh;

        if (X > st) and (X < en) then
        begin
          DownViewer := true;
          XViewer := X;
        end;
        TLEditor.AllSelectFalse;
        TLEditor.EventsSelectFalse;
        TLEditor.UpdateScreen(bmptimeline.Canvas);
        // TLEDitor.DrawEditor(bmptimeline.Canvas,0);//TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
        DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
        // Form1.imgtimelines.Repaint;
        exit;
      end;

    finally
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.DownZoneTimeLines | ' + E.Message);
  end;
end;

Procedure TTLZone.AddTimeline(ID: longint);
begin
  try
    Count := Count + 1;
    setlength(Timelines, Count);
    Timelines[Count - 1] := TTLTimeline.Create;
    Timelines[Count - 1].IDTimeline := ID;
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.AddTimeline IDTimeline=' +
        inttostr(ID) + ' Position=' + inttostr(Count - 1));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.AddTimeline | ' + E.Message);
  end;
end;

function TTLZone.FindTimeline(ID: longint): integer;
var
  i: integer;
begin
  try
    result := -1;
    for i := 0 to Count - 1 do
    begin
      If Timelines[i].IDTimeline = ID then
      begin
        result := i;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.FindTimeline IDTimeline=' + inttostr(ID) + ' Result=' + inttostr(Result));
        exit;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.FindTimeline | ' + E.Message);
  end;
end;

procedure TTLZone.ClearTimeline;
var
  i: integer;
begin
  try
    For i := Count - 1 downto 0 do
    begin
      Timelines[i].Clear;
      Timelines[i].FreeInstance;
    end;
    setlength(Timelines, 0);
    Count := 0;
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearTimeline');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearTimeline | ' + E.Message);
  end;
end;

Procedure TTLZone.InitTimelines(bmp: tbitmap);
var
  i, hgh, ps, cnt: integer;

Begin
  try
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.InitTimelines Start');
    TLScaler.Rect.Left := 0;
    TLScaler.Rect.Right := bmp.Width;
    TLScaler.Rect.Top := 0;
    TLScaler.Rect.Bottom := TLHeights.Scaler;

    TLEditor.Rect.Left := 0;
    TLEditor.Rect.Right := bmp.Width;
    TLEditor.Rect.Top := TLHeights.Scaler + TLHeights.IntervalEdit;
    TLEditor.Rect.Bottom := TLHeights.Scaler + TLHeights.IntervalEdit +
      TLHeights.Edit;

    hgh := TLHeights.Scaler + TLHeights.IntervalEdit + TLHeights.Edit +
      TLHeights.IntervalTL;

    WriteToBuffer;
    ClearTimeline;

    For i := 1 to form1.GridTimeLines.RowCount - 1 do
    begin
      if form1.GridTimeLines.Objects[0, i] is TTimelineOptions then
      begin
        // ps:=FindTimeline((Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).IDTimeline);
        AddTimeline((form1.GridTimeLines.Objects[0, i] as TTimelineOptions)
          .IDTimeline);
        Timelines[Count - 1].Rect.Left := 0;
        Timelines[Count - 1].Rect.Right := bmp.Width;
        Timelines[Count - 1].Rect.Top := hgh;
        hgh := hgh + TLHeights.HeightTL;
        Timelines[Count - 1].Rect.Bottom := hgh;
        Timelines[Count - 1].TypeTL :=
          (form1.GridTimeLines.Objects[0, i] as TTimelineOptions).TypeTL;
        hgh := hgh + TLHeights.Interval;
        ps := FindInBuffer(Timelines[Count - 1].IDTimeline);
        if ps <> -1 then
          Timelines[Count - 1].Assign(TLBuffer[ps]);
      end;
    end;
    ClearBuffer;
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.InitTimelines Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.InitTimelines | ' + E.Message);
  end;
End;

Procedure TTLZone.DrawLayer2(cv: tcanvas);
var
  hgh: integer;
begin
  try
    hgh := TLHeights.Height;
    with form1 do
    begin
      cv.Brush.Style := bsSolid;
      cv.Pen.Color := SmoothColor(clWhite, 8);
      cv.MoveTo(TLParameters.MyCursor, 0);
      cv.LineTo(TLParameters.MyCursor, TLHeights.Height - TLHeights.Review);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.DrawLayer2 | ' + E.Message);
  end;
end;

procedure TTLZone.DrawBitmap(bmp: tbitmap);
var
  i: integer;
begin
  try
    bmp.Canvas.Lock;
    try
      bmp.Height := TLHeights.Height - TLHeights.Review - 2 *
        TLHeights.Interval;
      bmp.Width := (TLParameters.Preroll + TLParameters.Duration +
        TLParameters.Postroll) * TLParameters.FrameSize;
      bmp.Canvas.Brush.Color := TLParameters.BackGround;
      bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
      InitTimelines(bmp);
      TLScaler.DrawScaler(bmp.Canvas);
      TLEditor.DrawEditor(bmp.Canvas, 0);
      For i := 0 to Count - 1 do
        Timelines[i].DrawTimeline(bmp.Canvas, i, 0);
      // InvalidateRect( bmp.Canvas.Handle, NIL, FALSE ) ;
    finally
      bmp.Canvas.Unlock;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.DrawBitmap | ' + E.Message);
  end;
end;

Procedure TTLZone.DrawTimelines(cv: tcanvas; bmp: tbitmap);
var
  rect1, rect2, rect3: TRect;
  pn: tpenmode;
  cl: tcolor;
  msht: real;
  smsh: longint;
  sz, st, en: longint;
  DCs: HDC;
  resstr: longbool;
  lt, rt: integer;
begin
  // if mode=play
  // then SetStretchBltMode(Cv.Handle, COLORONCOLOR)
  // else SetStretchBltMode(Cv.Handle, BLACKONWHITE);

  try

    if DrawTimeineInProgress then
      exit;

    try
      DrawTimeineInProgress := true;
      // SetStretchBltMode(Cv.Handle, COLORONCOLOR);
      // if makelogging then WriteLog('TC', '------------> Start');
      // if makelogging then WriteLog('TC', 'DrawTimelines Start=' + MyTimeToStr);
      // if bmptimeline.Canvas.LockCount <>0 then exit;
      rect1.Left := cv.ClipRect.Left;
      rect1.Right := cv.ClipRect.Right;
      rect1.Top := cv.ClipRect.Top;
      rect1.Bottom := cv.ClipRect.Bottom - TLHeights.Review - 2 *
        TLHeights.Interval;

      TLParameters.SetScreenBoanders;

      // WriteLog('TCPlayer', 'DrawTimelines Position=' + inttostr(TLParameters.Position) +
      // ' FrameSize=' + inttostr(TLParameters.FrameSize) +
      // ' MyCursor=' + inttostr(TLParameters.MyCursor) +
      // ' ScreenStart=' + inttostr(TLParameters.ScreenStart) +
      // ' ScreenEnd=' + inttostr(TLParameters.ScreenEnd ) +
      // ' ScreenStartFrame=' + inttostr(TLParameters.ScreenStartFrame) +
      // ' ScreenEndFrame=' + inttostr(TLParameters.ScreenEndFrame));

      rect2.Left := TLParameters.ScreenStart;
      rect2.Right := TLParameters.ScreenEnd;
      rect2.Top := 0;
      rect2.Bottom := bmp.Height;

      sz := (TLParameters.Finish - TLParameters.Start) * TLParameters.FrameSize;
      if sz = 0 then
        sz := bmp.Width;
      msht := sz / (TLParameters.ScreenEnd - TLParameters.ScreenStart);
      smsh := trunc(TLParameters.MyCursor / msht);
      lt := TLParameters.ScreenStart - TLParameters.Start *
        TLParameters.FrameSize;
      rt := TLParameters.ScreenEnd - TLParameters.Start *
        TLParameters.FrameSize;
      rect3.Left := trunc((TLParameters.ScreenStart - TLParameters.Start *
        TLParameters.FrameSize) / msht);
      rect3.Right := trunc((TLParameters.ScreenEnd - TLParameters.Start *
        TLParameters.FrameSize) / msht);

      // Form1.imgTimelines.Canvas.Lock;
      bitblt(cv.Handle, rect1.Left, rect1.Top, rect1.Right - rect1.Left,
        rect1.Bottom - rect1.Top, bmp.Canvas.Handle, rect2.Left,
        rect2.Top, SRCCOPY);
      // WriteLog('TCPlayer', 'DrawTimelines');
      // WriteLog('TCPlayer', 'DrawTimelines Rect2 Start=' + inttostr(rect2.Left) + ' End=' + inttostr(Rect2.Right) +
      // 'rect3 Start' + inttostr(rect3.Left) + ' End=' + inttostr(Rect3.Right));
      // Form1.imgTimelines.Canvas.UnLock;
      // if makelogging then WriteLog('TC', 'DrawTimelines bitblt=' + MyTimeToStr);

      DrawCursorStart(form1.imgLayer1.Canvas);
      // if makelogging then WriteLog('TC', 'DrawTimelines DrawCursorStart=' + MyTimeToStr);

      DrawCursorEnd(form1.imgLayer1.Canvas);
      // if makelogging then WriteLog('TC', 'DrawTimelines DrawCursorEnd=' + MyTimeToStr);
      // Form1.imgLayer1.Canvas.UnLock;

      rect1.Left := cv.ClipRect.Left;
      rect1.Right := cv.ClipRect.Right;
      rect1.Top := cv.ClipRect.Bottom - TLHeights.Review;
      rect1.Bottom := cv.ClipRect.Bottom;

      rect2.Left := TLParameters.Start * TLParameters.FrameSize;
      rect2.Right := TLParameters.Finish * TLParameters.FrameSize;
      rect2.Top := TLHeights.Scaler + TLHeights.IntervalEdit + TLHeights.Edit +
        TLHeights.IntervalTL;
      rect2.Bottom := bmp.Height;
      // Form1.imgTimelines.Canvas.Lock;
      // if makelogging then WriteLog('TC', 'DrawTimelines stretchblt start=' + MyTimeToStr);
      stretchblt(cv.Handle, rect1.Left, rect1.Top, rect1.Right - rect1.Left,
        rect1.Bottom - rect1.Top, bmp.Canvas.Handle, rect2.Left, rect2.Top,
        rect2.Right - rect2.Left, rect2.Bottom - rect2.Top, SRCCOPY);
      // cv.CopyRect(rect1,bmp.Canvas,rect2);
      // Form1.imgTimelines.Canvas.UnLock;
      // if makelogging then WriteLog('TC', 'DrawTimelines stretchblt finish=' + MyTimeToStr);

      // +++++++++++++++++++++++++

      // finally
      // SetStretchBltMode(Cv.Handle, BLACKONWHITE);
      // end;


      // +++++++++++++++++++++++++

      // SetStretchBltMode(Cv.Handle, BLACKONWHITE);

      rect3.Top := rect1.Top;
      rect3.Bottom := rect1.Bottom;

      // stretchblt(cv.Handle, rect3.Left, rect3.Top, rect3.Right-rect3.Left, rect3.Bottom-rect3.Top,
      // bmp.Canvas.Handle, lt, rect2.Top, rt-lt, rect2.Bottom-rect2.Top, SRCCOPY);
      pn := cv.Pen.Mode;
      cl := cv.Pen.Color;
      cv.Brush.Style := bsSolid;
      cv.Pen.Mode := pmMerge;
      cv.Pen.Color := TLZoneNamesColor;
      cv.Rectangle(rect3);
      cv.Pen.Mode := pmCopy;
      cv.Pen.Color := clWhite;
      cv.MoveTo(rect3.Left + smsh, rect3.Top);
      cv.LineTo(rect3.Left + smsh, rect3.Bottom);
      cv.Pen.Color := cl;
      cv.Pen.Mode := pn;

      // if makelogging then WriteLog('TC', 'DrawTimelines Finish=' + MyTimeToStr);
      // dbld1:=dbld2;
      DrawTimeineInProgress := false;
    finally
      // SetStretchBltMode(Cv.Handle, BLACKONWHITE);
    end;
    // SetStretchBltMode(Cv.Handle, COLORONCOLOR)
    // if makelogging then WriteLog('TC', '------------> Start');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.DrawTimelines | ' + E.Message);
  end;
end;

Procedure TTLZone.DrawFlash(nomevent: integer);
var
  rect1, rect2, rect3: TRect;
  pn: tpenmode;
  bs: tbrushstyle;
  cl, bscl: tcolor;
  bsc: tcolor;
  ps: integer;
begin
  try
    form1.imgLayer0.Canvas.FillRect(form1.imgLayer0.Canvas.ClipRect);
    TLParameters.SetScreenBoanders;
    rect1.Left := (TLZone.TLEditor.Events[nomevent].Start -
      TLParameters.ScreenStartFrame) * TLParameters.FrameSize;
    rect1.Right := (TLZone.TLEditor.Events[nomevent].Finish -
      TLParameters.ScreenStartFrame) * TLParameters.FrameSize;
    rect1.Top := TLZone.TLEditor.Rect.Top;
    rect1.Bottom := TLZone.TLEditor.Rect.Bottom;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    rect2.Left := rect1.Left;
    rect2.Right := rect1.Right;
    rect2.Top := TLZone.Timelines[ps].Rect.Top;
    rect2.Bottom := TLZone.Timelines[ps].Rect.Bottom;

    bsc := form1.imgLayer0.Canvas.Brush.Color;
    form1.imgLayer0.Canvas.Brush.Color := SmoothColor(clWhite, 8);
    form1.imgLayer0.Canvas.FillRect(rect1);
    form1.imgLayer0.Canvas.FillRect(rect2);
    form1.imgLayer0.Canvas.Brush.Color := bsc;
    // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.DrawFlash');
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.DrawFlash | ' + E.Message);
  end;
end;

function TTLZone.PlusHoriz: integer;
begin
  try
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.PlusHoriz Start');
    TLParameters.FrameSize := TLParameters.FrameSize + 1;
    if TLParameters.FrameSize > TLParameters.MaxFrameSize then
      TLParameters.FrameSize := TLParameters.MaxFrameSize;
    result := TLParameters.FrameSize;
    DrawBitmap(bmptimeline);
    DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.PlusHoriz Finish FrameSize=' +
        inttostr(TLParameters.FrameSize));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.PlusHoriz | ' + E.Message);
  end;
end;

function TTLZone.MinusHoriz: integer;
begin
  try
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.MinusHoriz Start');
    TLParameters.FrameSize := TLParameters.FrameSize - 1;
    if TLParameters.FrameSize < 1 then
      TLParameters.FrameSize := 1;
    result := TLParameters.FrameSize;
    DrawBitmap(bmptimeline);
    DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
    if makelogging then
      WriteLog('MAIN', 'UGRTimelines.TTLZone.MinusHoriz Finish FrameSize=' +
        inttostr(TLParameters.FrameSize));
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.MinusHoriz | ' + E.Message);
  end;
end;

Procedure TTLZone.WriteToStream(F: tStream);
var
  i: integer;
begin
  try
    F.WriteBuffer(DownTimeline, SizeOf(DownTimeline));
    F.WriteBuffer(DownEditor, SizeOf(DownEditor));
    F.WriteBuffer(DownScaler, SizeOf(DownScaler));
    F.WriteBuffer(XDown, SizeOf(XDown));
    F.WriteBuffer(CRStart, SizeOf(CRStart));
    F.WriteBuffer(CRStartDown, SizeOf(CRStartDown));
    F.WriteBuffer(CREnd, SizeOf(CREnd));
    F.WriteBuffer(CREndDown, SizeOf(CREndDown));
    TLScaler.WriteToStream(F);
    TLEditor.WriteToStream(F);
    F.WriteBuffer(Count, SizeOf(integer));
    for i := 0 to Count - 1 do
      Timelines[i].WriteToStream(F);
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.WriteToStream | ' + E.Message);
  end;
end;

Procedure TTLZone.ReadFromStream(F: tStream);
var
  i: integer;
begin
  try
    F.ReadBuffer(DownTimeline, SizeOf(DownTimeline));
    F.ReadBuffer(DownEditor, SizeOf(DownEditor));
    F.ReadBuffer(DownScaler, SizeOf(DownScaler));
    F.ReadBuffer(XDown, SizeOf(XDown));
    F.ReadBuffer(CRStart, SizeOf(CRStart));
    F.ReadBuffer(CRStartDown, SizeOf(CRStartDown));
    F.ReadBuffer(CREnd, SizeOf(CREnd));
    F.ReadBuffer(CREndDown, SizeOf(CREndDown));
    TLScaler.ReadFromStream(F);
    TLEditor.Clear;
    TLEditor.ReadFromStream(F);
    ClearTimeline;
    F.ReadBuffer(Count, SizeOf(integer));
    for i := 0 to Count - 1 do
    begin
      setlength(Timelines, i + 1);
      Timelines[i] := TTLTimeline.Create;
      Timelines[i].ReadFromStream(F);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UGRTimelines.TTLZone.ReadFromStream | ' + E.Message);
  end;
end;

// ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
// ========================  Helpers для классов. Сохранения в JSON и загрузка ==
// ==============================================================================
{$INCLUDE ..\helpers\ugrtimelines_body.inc}
// ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
// ========================  END Helpers для классов. Сохранения в JSON и загрузка ==
// ==============================================================================

initialization

TLParameters := TTLParameters.Create;
TLZone := TTLZone.Create;

finalization

TLParameters.FreeInstance;
TLParameters := nil;
TLZone.FreeInstance;
TLZone := nil;

end.
